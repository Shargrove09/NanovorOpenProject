#!/usr/bin/env node
'use strict';

// Engine unit tests for battle.js - no server/socket needed. Constructs a
// BattleEngine directly, drives it through its public API (receiveCombatTurnData
// / getRound / getGameOver), and asserts exact outcomes against hand-computed
// expectations from real master-data attacks, cross-checked against the
// decompiled client source (see battle.js's own header for file:line refs).
//
//   node tools/test-battle-engine.js

const path = require('path');
const assert = require('assert');
const { getVirmonMaster } = require('../evolutionData');
const battle = require('../battle');
const { BattleNanovor, BattleEngine } = battle;

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

// A scripted rng: returns values from a fixed queue, then falls back to a
// constant. Lets a test pin exactly which Math.random()-driven branch fires
// (initiative order, dodge/stun rolls) without relying on real randomness.
function scriptedRng(queue, fallback = 0.5) {
    const q = [...queue];
    return () => (q.length ? q.shift() : fallback);
}

function makeNanovor(assetTypeId, instanceOverrides = {}) {
    const master = getVirmonMaster(ROOT, assetTypeId);
    assert.ok(master, `no master data for type ${assetTypeId}`);
    const instance = {
        assetId: String(instanceOverrides.assetId ?? Math.floor(Math.random() * 1e9)),
        name: master.name, nickname: '',
        speed: master.baseSpeed, strength: master.baseStrength, armor: master.baseArmor, health: master.baseHealth,
        ...instanceOverrides,
    };
    return new BattleNanovor(master, instance);
}

function makeEngine(sideA, sideB, rng) {
    return new BattleEngine([
        { userRefId: '1', username: 'alice', swarm: [sideA] },
        { userRefId: '2', username: 'bob', swarm: [sideB] },
    ], rng);
}

// Pass is signalled by AttackId 0 - MyActiveNanovorId must still be a real
// nanovor id (ICombatTurnData always names an active nanovor; it's a turn
// without an attack, not a turn without a combatant).
function passTurn(nanovorId, targetName) {
    return { AttackId: 0, MyActiveNanovorId: nanovorId, MyNextNanovorId: '0', TargetedPlayerName: targetName };
}

function attackTurn(nanovorId, attackId, targetName) {
    return { AttackId: attackId, MyActiveNanovorId: nanovorId, MyNextNanovorId: '0', TargetedPlayerName: targetName };
}

// --- 1. Initiative order (setRoundPosition) -------------------------------------

test('initiative: lower-speed player can still go first via its own roll (speed-curved weighted draw)', () => {
    // speeds 10 vs 30 -> speedCurved (10/40)^2=0.0625, (30/40)^2=0.5625, sum=0.625
    // -> curvePercent 0.1 / 0.9. First player's own roll (0.05) <= its own
    // cumulative (0.1) -> drawn first, confirming this is NOT a simple
    // "higher speed always acts first" rule. Driven through the public API
    // (Pass/Pass) rather than calling the private _setRoundPosition directly,
    // since selectedNanovor - and so speed - is only populated once
    // _applyTurnData has run, same as the real client's setAttackInfo.
    const slow = makeNanovor(1, { assetId: 'slow', speed: 10 });
    const fast = makeNanovor(1, { assetId: 'fast', speed: 30 });
    const engine = makeEngine(slow, fast, scriptedRng([0.05, 0.5]));

    engine.receiveCombatTurnData('1', passTurn('slow', 'bob'));
    engine.receiveCombatTurnData('2', passTurn('fast', 'alice'));

    assert.strictEqual(engine.players[0].userRefId, '1', 'the slower nanovor should have been drawn first with this scripted roll');
    assert.strictEqual(engine.players[1].userRefId, '2');
});

// --- 2. Frost (170) damage, with and without the attacker's RedSpike override ---
// virmon-master-decoded.xml: Hyperblade 1.0 (type 81), base strength 135, base
// armor 10. Statement 14 "60 DAM" fires when RedSpike is set (60*1.35=81,
// rounded, minus 10 armor = 71); statement 184 "FAIL 30 DAM" fires when it
// isn't (30*1.35=40.5 -> round 41, minus 10 = 31). Cross-checked against
// battle.js's own evaluateFormula in tools/check-hyperslash (dev scratch) - 71
// and 31 exactly.

test('Frost (170): without RedSpike deals the FAIL-30 formula result (31)', () => {
    const attacker = makeNanovor(81, { assetId: 'atk', health: 500 });
    const defender = makeNanovor(81, { assetId: 'def', health: 500 });
    const engine = makeEngine(attacker, defender, scriptedRng([0, 0])); // alice always first in turn order

    engine.receiveCombatTurnData('1', attackTurn('atk', 170, 'bob'));
    engine.receiveCombatTurnData('2', passTurn('def', 'alice'));

    assert.strictEqual(defender.hitPoints, 500 - 31, `expected 31 damage, hp is ${defender.hitPoints}`);
});

test('Frost (170): with an active RedSpike override deals the 60-DAM formula result (71) and then clears the override', () => {
    const attacker = makeNanovor(81, { assetId: 'atk', health: 500 });
    const defender = makeNanovor(81, { assetId: 'def', health: 500 });
    const engine = makeEngine(attacker, defender, scriptedRng([0, 0]));
    // Arrange: pre-condition the attacker as if attack 144 "Red Spike" had
    // already been used on a prior round (BattleLogicPlayer.addOverride -
    // overrides are player-scoped, confirmed via direct source read).
    engine.players[0].addOverride({ id: 135, type: 'Override', stat: 'RedSpike', verb: '=', statementFormula: '1', duration: 10000, roundConditionals: [] });

    engine.receiveCombatTurnData('1', attackTurn('atk', 170, 'bob'));
    engine.receiveCombatTurnData('2', passTurn('def', 'alice'));

    assert.strictEqual(defender.hitPoints, 500 - 71, `expected 71 damage, hp is ${defender.hitPoints}`);
    assert.strictEqual(engine.players[0].overrides.length, 0, 'statement 157 "Red: Clear Red Spike" should have removed the override');
});

// --- 3. A stun hack actually skips a later turn ---------------------------------
// Hyperslash (171) on Hyperblade 1.0: statement 216 "70 DAM AP" (no armor
// term, 70*1.35=94.5 -> round 95) plus statement 132 "Stun Me (2R)", a
// self-targeting Hack on Stun Fail % (verb "=", formula "0", duration 3 ->
// active 2 rounds per the confirmed off-by-one). Default Stun Fail % is 1, so
// isStunned() never naturally succeeds (roll > 1 can't happen) - only a hack
// pushing it to 0 can ever trigger a stun, so an actual stunned turn with no
// damage dealt is strong confirmation the hack/duration system works.

test('Hyperslash (171): the self-stun hack prevents the very next attack from landing', () => {
    const attacker = makeNanovor(81, { assetId: 'atk', health: 500 });
    const defender = makeNanovor(81, { assetId: 'def', health: 500 });
    const engine = makeEngine(attacker, defender, scriptedRng([], 0.5));
    // Hyperslash costs 3; a fresh player only starts with 2 energy (confirmed
    // default, BattleLogicPlayer.as) and would FIZZLE instead of connecting.
    engine.players[0].setEnergyLevel(3);

    // Round 1: Hyperslash connects (95 AP damage) and self-hacks.
    engine.receiveCombatTurnData('1', attackTurn('atk', 171, 'bob'));
    engine.receiveCombatTurnData('2', passTurn('def', 'alice'));
    assert.strictEqual(defender.hitPoints, 500 - 95, `round 1: expected 95 damage, hp is ${defender.hitPoints}`);
    assert.strictEqual(attacker.hacks.length, 1, 'the self-stun hack should be on the attacker after round 1');

    // Round 2: same attacker tries Frost - should be stunned, not resolved.
    engine.receiveCombatTurnData('1', attackTurn('atk', 170, 'bob'));
    engine.receiveCombatTurnData('2', passTurn('def', 'alice'));
    assert.strictEqual(defender.hitPoints, 500 - 95, 'round 2: no further damage should have landed while stunned');
    const round2Attack = engine.getRound().attackResults.find(r => r.attackerId === '1');
    assert.ok(round2Attack, 'round 2 should have an attack-result entry for the attacker');
    assert.ok(round2Attack.attackActions.some(a => a.type === battle.ACTION.STUNNED),
        `expected a STUNNED action, got ${JSON.stringify(round2Attack.attackActions.map(a => a.type))}`);
});

// --- 4. A kill increments the right faction counter and ends the game ----------

test('a lethal hit increments kill/faction counters and generateGameResults reports the winner', () => {
    const attacker = makeNanovor(81, { assetId: 'atk', health: 500 }); // Hyperblade 1.0 = Magnamod
    const defender = makeNanovor(81, { assetId: 'def', health: 10 }); // low HP - one Frost kills it
    const engine = makeEngine(attacker, defender, scriptedRng([0, 0]));
    engine.players[0].addOverride({ id: 135, type: 'Override', stat: 'RedSpike', verb: '=', statementFormula: '1', duration: 10000, roundConditionals: [] });

    engine.receiveCombatTurnData('1', attackTurn('atk', 170, 'bob')); // 71 damage, lethal
    engine.receiveCombatTurnData('2', passTurn('def', 'alice'));

    assert.strictEqual(defender.hitPoints, 0, 'defender should be at 0 hp (damage clamps, does not go negative)');
    assert.strictEqual(engine.players[0].killCount, 1, 'attacker player killCount should be 1');
    assert.strictEqual(attacker.killCount, 1, 'attacker nanovor killCount should be 1');
    assert.strictEqual(attacker.magnamodKillCount, 1, 'victim is Magnamod - attacker nanovor magnamodKillCount should be 1');
    assert.strictEqual(engine.players[0].magnamodKillCount, 1, 'attacker player magnamodKillCount should be 1');

    const over = engine.getGameOver();
    assert.ok(over, 'game should be over - only one active player remains');
    assert.strictEqual(over.winnerId, '1');
    assert.strictEqual(over.results.length, 2, 'results should cover both players');
    for (const r of over.results) {
        assert.ok('userRefId' in r && 'totalDamage' in r && 'maxDamage' in r && 'totalNanovorKilled' in r && 'position' in r,
            `result entry missing a confirmed field: ${JSON.stringify(r)}`);
        assert.strictEqual(typeof r.totalDamage, 'string', 'getPlayerStats stringifies every field');
    }
    const winnerStats = over.results.find(r => r.userRefId === '1');
    assert.strictEqual(winnerStats.totalNanovorKilled, '1');
    assert.strictEqual(winnerStats.position, '1');
});

console.log(`\n${passed} passed, ${failed} failed`);
process.exitCode = failed ? 1 : 0;
