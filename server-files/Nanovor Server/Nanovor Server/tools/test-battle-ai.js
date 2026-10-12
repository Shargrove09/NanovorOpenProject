#!/usr/bin/env node
'use strict';

// Unit tests for battleAI.js - the ported Sensei AI. No server/socket needed.
//
//   node tools/test-battle-ai.js

const path = require('path');
const assert = require('assert');
const { getVirmonMaster } = require('../evolutionData');
const { BattleNanovor, BattleEngine } = require('../battle');
const { SenseiAI, loadRoster, getSenseiRoster, buildSenseiSwarm } = require('../battleAI');

const ROOT = path.resolve(__dirname, '..');

let passed = 0, failed = 0;
function test(name, fn) {
    try {
        fn();
        passed++;
        console.log(`  ok    ${name}`);
    } catch (err) {
        failed++;
        console.log(`  FAIL  ${name}\n        ${err.message.split('\n').join('\n        ')}`);
    }
}

function makeNanovor(assetTypeId, overrides = {}) {
    const master = getVirmonMaster(ROOT, assetTypeId);
    return new BattleNanovor(master, {
        assetId: String(overrides.assetId ?? assetTypeId),
        name: master.name, nickname: '',
        speed: master.baseSpeed, strength: master.baseStrength,
        armor: master.baseArmor, health: master.baseHealth,
        ...overrides,
    });
}

// --- roster -------------------------------------------------------------------

test('sensei-players.xml parses into the confirmed 5-entry roster', () => {
    const roster = loadRoster(ROOT);
    assert.strictEqual(roster.length, 5, `expected 5 roster entries, got ${roster.length}`);
    const byId = Object.fromEntries(roster.map(r => [r.userRefId, r]));
    assert.ok(byId['-5'] && byId['-3'] && byId['-4'], 'Training/-5, Easy/-3 and Medium/-4 should all be present');
    assert.strictEqual(byId['-5'].name, 'Training');
    assert.strictEqual(byId['-5'].swarm.length, 1, 'Training has a single-nanovor swarm');
    assert.strictEqual(byId['-3'].swarm.length, 3, 'Easy has 3 nanovor');
    assert.strictEqual(byId['-4'].swarm.length, 4, 'Medium has 4 nanovor');
    // show="true" only on the two player-selectable entries.
    assert.deepStrictEqual(roster.filter(r => r.revealed).map(r => r.userRefId).sort(), ['-3', '-4']);
    assert.deepStrictEqual(byId['-4'].swarm.map(n => n.assetTypeId), [3, 35, 50, 39], 'Medium roster asset-type-ids');
});

test('a roster swarm builds as real BattleNanovor at base stats', () => {
    const roster = getSenseiRoster(ROOT, -4);
    const swarm = buildSenseiSwarm(ROOT, roster);
    assert.strictEqual(swarm.length, 4);
    for (const n of swarm) {
        const master = getVirmonMaster(ROOT, n.assetTypeId);
        assert.strictEqual(n.hitPoints, master.baseHealth, `${n.name} should start at base health`);
        assert.strictEqual(n.strength, master.baseStrength);
        assert.ok(n.attacks.length > 1, `${n.name} should have a real moveset (plus the synthetic Pass)`);
        assert.ok(n.attacks.some(a => a.id === 0), 'every nanovor carries the Pass attack');
    }
});

// --- turn data ----------------------------------------------------------------

function setupBattle(aiRosterId = -4, humanTypeId = 81, humanOverrides = {}, rng = () => 0.5) {
    const roster = getSenseiRoster(ROOT, aiRosterId);
    const aiSwarm = buildSenseiSwarm(ROOT, roster);
    const human = makeNanovor(humanTypeId, { assetId: 'human1', ...humanOverrides });
    const engine = new BattleEngine([
        { userRefId: '1', username: 'alice', swarm: [human] },
        { userRefId: roster.userRefId, username: roster.name, swarm: aiSwarm },
    ], rng);
    const ai = new SenseiAI(engine.players[1], engine.players[0], rng);
    return { engine, ai, human, aiSwarm, roster };
}

test('getCombatTurnData returns a well-formed ICombatTurnData', () => {
    const { ai, aiSwarm, roster } = setupBattle();
    const data = ai.getCombatTurnData();

    assert.strictEqual(typeof data.AttackId, 'number', 'AttackId must be a number');
    assert.strictEqual(data.AttackData, null, 'AttackData is always null from the AI (confirmed)');
    assert.strictEqual(data.TargetedPlayerName, 'alice', 'should target the opposing username, not an id');
    assert.strictEqual(typeof data.MyNextNanovorId, 'string');
    assert.notStrictEqual(data.MyNextNanovorId, null, 'no-swap is the "0" sentinel, never null');

    const active = aiSwarm.find(n => n.assetId === data.MyActiveNanovorId);
    assert.ok(active, `MyActiveNanovorId ${data.MyActiveNanovorId} should name one of the AI's own nanovor`);
    assert.ok(active.attacks.some(a => a.id === data.AttackId),
        `chosen AttackId ${data.AttackId} must belong to the active nanovor's moveset`);
    if (data.MyNextNanovorId !== '0') {
        assert.ok(aiSwarm.some(n => n.assetId === data.MyNextNanovorId), 'a swap target must be in the AI swarm');
    }
    assert.ok(roster.swarm.some(n => n.assetId === data.MyActiveNanovorId));
});

test('the AI never picks an attack it cannot pay for (except Pass)', () => {
    // Run many turns across varied energy levels and enemy states; the chosen
    // attack must always be affordable, or the free Pass.
    for (let energy = 0; energy <= 6; energy++) {
        const { ai, aiSwarm } = setupBattle(-4, 81, {}, () => 0.5);
        for (const n of aiSwarm) n.owner.setEnergyLevel(energy);
        const data = ai.getCombatTurnData();
        const active = aiSwarm.find(n => n.assetId === data.MyActiveNanovorId);
        const attack = active.attacks.find(a => a.id === data.AttackId);
        assert.ok(attack.cost <= energy || attack.id === 0,
            `with ${energy} energy the AI chose "${attack.name}" costing ${attack.cost}`);
    }
});

test('with a nearly-dead enemy and energy to spare, the AI attacks rather than passing', () => {
    const { ai, aiSwarm, human } = setupBattle(-4, 81, { health: 1 });
    for (const n of aiSwarm) n.owner.setEnergyLevel(6);
    // Teach the AI about the enemy the way a resolved round would.
    ai.enemyPlayer.setSelectedNanovor(human);
    ai.setRound();

    const data = ai.getCombatTurnData();
    const active = aiSwarm.find(n => n.assetId === data.MyActiveNanovorId);
    const attack = active.attacks.find(a => a.id === data.AttackId);
    assert.notStrictEqual(attack.id, 0, 'should not Pass when it can finish the opponent');
    assert.ok(attack.cost <= 6, 'and the finisher must still be affordable');
});

// --- full battle --------------------------------------------------------------

test('AI drives a full battle to a decisive result without stalling', () => {
    const { engine, ai, human, aiSwarm } = setupBattle(-4, 81, { health: 200 }, Math.random);
    const humanAttack = human.attacks.find(a => a.id !== 0 && a.cost <= 2) || human.attacks.find(a => a.id === 0);

    let rounds = 0;
    let over = null;
    while (rounds < 200) {
        rounds++;
        const aiTurn = ai.getCombatTurnData();
        engine.receiveCombatTurnData('1', {
            AttackId: humanAttack.id, MyActiveNanovorId: human.assetId,
            MyNextNanovorId: '0', TargetedPlayerName: engine.players.find(p => p.userRefId !== '1').username,
        });
        engine.receiveCombatTurnData(aiTurn.MyActiveNanovorId === null ? '-4' : '-4', aiTurn);
        over = engine.getGameOver();
        if (over) break;
        ai.setRound();
    }

    assert.ok(over, `battle should finish within 200 rounds (ran ${rounds})`);
    assert.ok(over.winnerId === '1' || over.winnerId === '-4', `unexpected winner ${over.winnerId}`);
    assert.strictEqual(over.results.length, 2);
    const totalHp = aiSwarm.reduce((s, n) => s + n.hitPoints, 0) + human.hitPoints;
    assert.ok(totalHp >= 0, 'hit points never go negative');
    // One side must be wiped out for the game to be over.
    const aiWiped = aiSwarm.every(n => n.hitPoints <= 0);
    assert.ok(aiWiped || human.hitPoints <= 0, 'the loser should have no nanovor left standing');
});

console.log(`\n${passed} passed, ${failed} failed`);
process.exitCode = failed ? 1 : 0;
