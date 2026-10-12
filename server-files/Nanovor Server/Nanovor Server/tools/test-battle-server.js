#!/usr/bin/env node
'use strict';

// Live integration test for the quick-battle (vs. AI) flow, against a RUNNING
// server. Per AGENTS.local.md's prescribed method: logs in via /xmlrpc for a
// real token, then drives the raw SmartFox 1.x socket by hand - verChk ->
// login (sys, XML, NUL-terminated) -> JSON xt frames for
// createQuickBattle/setSwarm/setAttackInfo/endRound - and asserts the real
// server sends back well-formed gameStarted/swarmSelected/setRoundInfo/
// performAttack/roundCompleted/gameOver frames and the battle reaches a
// decisive, internally-consistent gameOver.
//
//   node run-server.bat   (separately, first)
//   node tools/test-battle-server.js [--account-name <name>]

const path = require('path');
const net = require('net');
const http = require('http');
const assert = require('assert');
const { getAttacksForType } = require('../evolutionData');

const ROOT = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
const nameIdx = args.indexOf('--account-name');
// Default to the existing seeded account "n" - it already carries real
// nanovor inventory (see UserData/n.json), so no bootstrap grant is needed.
const ACCOUNT_NAME = nameIdx >= 0 ? args[nameIdx + 1] : 'n';

function httpRequest(method, urlPath, { body, type } = {}) {
    return new Promise((resolve, reject) => {
        const headers = {};
        if (body !== undefined) {
            headers['Content-Type'] = type;
            headers['Content-Length'] = Buffer.byteLength(body);
        }
        const req = http.request({ host: '127.0.0.1', port: 8443, method, path: urlPath, headers }, res => {
            const chunks = [];
            res.on('data', c => chunks.push(c));
            res.on('end', () => resolve({ status: res.statusCode, body: Buffer.concat(chunks).toString() }));
        });
        req.on('error', reject);
        req.end(body);
    });
}

async function login(name) {
    const xml = '<?xml version="1.0"?><methodCall><methodName>srb.Connect</methodName><params><param><value><struct>' +
        `<member><name>playername</name><value><string>${name}</string></value></member>` +
        '<member><name>playerpassword</name><value><string>x</string></value></member>' +
        '</struct></value></param></params></methodCall>';
    const res = await httpRequest('POST', '/xmlrpc', { body: xml, type: 'text/xml' });
    const text = res.body;
    const token = (text.match(/Login Token:\s*([^<\s]+)/) || [])[1];
    const accountId = (text.match(/AccountId:\s*([^<\s]+)/) || [])[1];
    assert.ok(token && accountId, `login failed: ${text.slice(0, 300)}`);
    return { token, accountId };
}

async function getNanovorSwarm(accountId, token, count) {
    const res = await httpRequest('GET', `/bankfe/resources/account/${accountId}/asset?auth=${token}`);
    const entries = [];
    // One <asset id="..."> block per nanovor/em; keep only ones tagged virmon.
    const blockRe = /<asset id="(\d+)"[^>]*>([\s\S]*?)<\/asset>/g;
    let m;
    while ((m = blockRe.exec(res.body)) !== null) {
        if (!/<asset-type-category>virmon<\/asset-type-category>/.test(m[2])) continue;
        const assetTypeId = (m[2].match(/<asset-type-id>(\d+)<\/asset-type-id>/) || [])[1];
        if (assetTypeId) entries.push({ assetId: m[1], assetTypeId: Number(assetTypeId) });
    }
    assert.ok(entries.length > 0, `account ${accountId} has no virmon assets to battle with: ${res.body.slice(0, 500)}`);
    return entries.slice(0, count);
}

// Cheapest non-Pass attack for a nanovor, so submitted turns actually deal
// damage instead of idling - drives the battle to a real, timely gameOver
// instead of a 300-round stall that would prove nothing either way.
function cheapestAttack(assetTypeId) {
    const attacks = getAttacksForType(ROOT, assetTypeId);
    assert.ok(attacks.length > 0, `no attacks in master data for asset-type-id ${assetTypeId}`);
    return attacks.reduce((best, a) => (a.cost < best.cost ? a : best), attacks[0]);
}

// --- raw SmartFox 1.x socket client ----------------------------------------

class SfsClient {
    constructor() {
        this.socket = null;
        this.buffer = '';
        this.frameQueue = [];
        this.waiters = [];
    }

    connect() {
        return new Promise((resolve, reject) => {
            this.socket = net.createConnection({ host: '127.0.0.1', port: 9339 }, resolve);
            this.socket.on('error', reject);
            this.socket.on('data', (data) => this._onData(data));
        });
    }

    _onData(data) {
        this.buffer += data.toString();
        const parts = this.buffer.split('\x00');
        this.buffer = parts.pop();
        for (const raw of parts) {
            const frame = raw.trim();
            if (!frame) continue;
            let parsed = frame;
            if (frame.startsWith('{')) {
                try { parsed = JSON.parse(frame); } catch { /* leave as raw string */ }
            }
            this.frameQueue.push(parsed);
        }
        this._drainWaiters();
    }

    _drainWaiters() {
        while (this.waiters.length && this.frameQueue.length) {
            this.waiters.shift()(this.frameQueue.shift());
        }
    }

    // Resolves with the next frame to arrive (XML string or parsed JSON object).
    nextFrame(timeoutMs = 5000) {
        if (this.frameQueue.length) return Promise.resolve(this.frameQueue.shift());
        return new Promise((resolve, reject) => {
            const timer = setTimeout(() => {
                const idx = this.waiters.indexOf(wrapped);
                if (idx !== -1) this.waiters.splice(idx, 1);
                reject(new Error(`timed out after ${timeoutMs}ms waiting for a frame`));
            }, timeoutMs);
            const wrapped = (frame) => { clearTimeout(timer); resolve(frame); };
            this.waiters.push(wrapped);
        });
    }

    // Waits for the next JSON xt frame whose _cmd matches, ignoring (but
    // logging) anything else that arrives first - mirrors how the real
    // client's dispatcher filters on _cmd and treats the rest as unremarkable.
    async nextXtCmd(expectedCmd, timeoutMs = 5000) {
        const deadline = Date.now() + timeoutMs;
        for (;;) {
            const remaining = deadline - Date.now();
            assert.ok(remaining > 0, `timed out waiting for _cmd "${expectedCmd}"`);
            const frame = await this.nextFrame(remaining);
            const cmd = frame && frame.b && frame.b.o && frame.b.o._cmd;
            if (cmd === expectedCmd) return frame.b.o;
            console.log(`  (skipping frame: ${typeof frame === 'string' ? frame.slice(0, 80) : cmd || JSON.stringify(frame).slice(0, 80)})`);
        }
    }

    sendXml(xml) { this.socket.write(xml + '\x00'); }
    sendXt(extension, command, params) {
        this.socket.write(JSON.stringify({ t: 'xt', b: { x: extension, c: command, p: params } }) + '\x00');
    }

    close() { this.socket.end(); }
}

let passed = 0, failed = 0;
async function test(name, fn) {
    try {
        await fn();
        passed++;
        console.log(`  ok    ${name}`);
    } catch (err) {
        failed++;
        console.log(`  FAIL  ${name}\n        ${(err.stack || err.message).split('\n').join('\n        ')}`);
    }
}

async function main() {
    const { token, accountId } = await login(ACCOUNT_NAME);
    console.log(`logged in as ${ACCOUNT_NAME} (account ${accountId})`);
    // A single-nanovor swarm sidesteps an unconfirmed mechanic this test isn't
    // trying to probe: a human swapping in a new nanovor after their active
    // one dies mid-battle is driven purely by the next turn's
    // MyActiveNanovorId (confirmed - BattleLogic.as's setAttackInfo trusts it
    // unconditionally, dead or alive), not MyNextNanovorId/the swap flow -
    // real client UI concern, not this wire-shape test's.
    const [mine] = await getNanovorSwarm(accountId, token, 1);
    const myAttack = cheapestAttack(mine.assetTypeId);
    console.log(`fielding asset ${mine.assetId} (type ${mine.assetTypeId}), attack "${myAttack.name}" (id ${myAttack.id}, cost ${myAttack.cost})`);

    const client = new SfsClient();
    await client.connect();

    await test('verChk / login handshake succeeds', async () => {
        client.sendXml(`<msg t="sys"><body action="verChk" r="0"></body></msg>`);
        const verChk = await client.nextFrame();
        assert.ok(/action="verChk"/.test(verChk), `expected verChk response, got: ${verChk}`);
        const apiOk = await client.nextFrame();
        assert.ok(/action="apiOK"/.test(apiOk), `expected apiOK response, got: ${apiOk}`);

        client.sendXml(`<msg t='sys'><body action='login' r='0'><login z='Virmon'><nick><![CDATA[${ACCOUNT_NAME}]]></nick><pword><![CDATA[${token}]]></pword></login></body></msg>`);
        const logOkSys = await client.nextFrame();
        assert.ok(/action="logOK"/.test(logOkSys), `expected sys logOK, got: ${logOkSys}`);
        const logOkXt = await client.nextFrame();
        assert.strictEqual(logOkXt.b.o._cmd, 'logOK', `expected xt logOK, got: ${JSON.stringify(logOkXt)}`);
    });

    let aiUserRefId, aiUsername;
    await test('createQuickBattle creates a battle and joins a Sensei AI opponent', async () => {
        client.sendXt('gameXt', 'createQuickBattle', { gameSwarmValue: 1000, totalPlayers: 2 });
        const created = await client.nextXtCmd('gameCreated');
        assert.ok(created.battleName, 'gameCreated should carry a battleName');

        const joined = await client.nextXtCmd('playerJoinGame');
        assert.ok(joined.userRefId && joined.username, 'playerJoinGame should name the AI opponent');
        aiUserRefId = joined.userRefId;
        aiUsername = joined.username;
        console.log(`  AI opponent: ${aiUsername} (${aiUserRefId})`);

        const started = await client.nextXtCmd('gameStarted');
        assert.ok(Array.isArray(started.players) && started.players.length === 2, 'gameStarted should list 2 players');
    });

    await test('setSwarm builds a real engine and both sides report in', async () => {
        client.sendXt('gameXt', 'setSwarm', { nanovorIds: mine.assetId });
        const mySwarm = await client.nextXtCmd('swarmSelected');
        assert.strictEqual(mySwarm.userRefId, accountId);
        assert.strictEqual(mySwarm.swarmCount, 1);

        const theirs = await client.nextXtCmd('swarmSelected');
        assert.strictEqual(theirs.userRefId, aiUserRefId);
        assert.ok(theirs.swarmCount > 0, 'AI swarm should be non-empty');

        const ready = await client.nextXtCmd('readyForTurn');
        assert.ok('nanovorId' in ready && 'isDead' in ready);
    });

    await test('setAttackInfo resolves a real round with well-formed wire shapes', async () => {
        client.sendXt('gameXt', 'setAttackInfo', {
            enemyUsername: aiUsername, nanovorId: mine.assetId, attackId: myAttack.id, swapNanovorId: '0',
        });

        const roundInfo = await client.nextXtCmd('setRoundInfo');
        assert.ok(Array.isArray(roundInfo.players) && roundInfo.players.length === 2, 'setRoundInfo should snapshot both players');
        for (const p of roundInfo.players) {
            assert.ok(p.selectedNanovor && p.selectedNanovor.instanceId && p.selectedNanovor.assetTypeId != null,
                `selectedNanovor missing required fields: ${JSON.stringify(p.selectedNanovor)}`);
        }

        const attack = await client.nextXtCmd('performAttack');
        assert.ok(Array.isArray(attack.attackResults) && attack.attackResults.length === 2, 'performAttack should carry both attackers\' results');

        const completed = await client.nextXtCmd('roundCompleted');
        assert.ok(Array.isArray(completed.players) && completed.players.length === 2, 'roundCompleted should snapshot both players');
        assert.ok('swapActions' in completed && 'hacks' in completed, 'roundCompleted missing swapActions/hacks');
    });

    await test('endRound acks with readyForTurn mid-battle', async () => {
        client.sendXt('gameXt', 'endRound', {});
        const ready = await client.nextXtCmd('readyForTurn');
        assert.ok('nanovorId' in ready && 'isDead' in ready);
    });

    await test('repeated setAttackInfo drives the battle to a decisive gameOver', async () => {
        // Round resolution happens entirely inside setAttackInfo (both sides'
        // turn data in -> generateRound) - endRound is only the client's own
        // "ready for next input" ack and isn't needed between rounds here.
        let over = null;
        for (let round = 0; round < 100 && !over; round++) {
            client.sendXt('gameXt', 'setAttackInfo', {
                enemyUsername: aiUsername, nanovorId: mine.assetId, attackId: myAttack.id, swapNanovorId: '0',
            });
            await client.nextXtCmd('setRoundInfo');
            await client.nextXtCmd('performAttack');
            await client.nextXtCmd('roundCompleted');

            // gameOver, when this round triggered it, is written in the same
            // synchronous handler right after roundCompleted - a short peek
            // is enough; anything else means the battle continues.
            over = await client.nextXtCmd('gameOver', 150).catch(() => null);
        }
        assert.ok(over, 'battle should reach a decisive gameOver within 100 rounds');
        assert.ok(over.winnerId === accountId || over.winnerId === aiUserRefId, `unexpected winnerId: ${over.winnerId}`);
        assert.ok(Array.isArray(over.results) && over.results.length === 2, 'gameOver results should cover both players');
        console.log(`  battle over - winner: ${over.winnerId === accountId ? ACCOUNT_NAME : aiUsername}`);
    });

    client.close();
    console.log(`\n${passed} passed, ${failed} failed`);
    process.exitCode = failed ? 1 : 0;
}

main().catch(err => {
    console.error('FATAL:', err.stack || err);
    process.exitCode = 1;
});
