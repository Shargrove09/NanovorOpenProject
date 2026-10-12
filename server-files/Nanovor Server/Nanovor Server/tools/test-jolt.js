#!/usr/bin/env node
'use strict';

// End-to-end check of jolt spending against a RUNNING server.
//
//   node tools/test-jolt.js [--account-name <name>]
//
// Logs in as a throwaway account (new accounts start with Electropod 1.0,
// assetTypeId 1 at base stats), credits it speed jolts via a throwaway
// Nanoscope's jolt-upload route (the same path real jolts arrive by), then
// buffs that nanovor's speed and checks every observable effect: the
// response body, the refreshed asset list, the account balance, and
// persistence across a fresh session. Also checks over-max and
// insufficient-balance are rejected and change nothing.
//
// Defaults to a fresh account name per run (the test isn't re-runnable
// against the same account - it asserts the nanovor starts at base stats).
// Leaves a UserData/<name>.json behind; harmless, delete at will.

const path = require('path');
const http = require('http');
const crypto = require('crypto');
const assert = require('assert');
const { getVirmonMaster } = require('../evolutionData');

const ROOT = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
const nameIdx = args.indexOf('--account-name');
const ACCOUNT_NAME = nameIdx >= 0 ? args[nameIdx + 1] : `jolt-selftest-${Date.now()}`;
const STARTER_TYPE_ID = 1; // Electropod 1.0 - every new account's first nanovor

function request(method, urlPath, { body, type } = {}) {
    return new Promise((resolve, reject) => {
        const headers = {};
        if (body !== undefined) {
            headers['Content-Type'] = type;
            headers['Content-Length'] = Buffer.byteLength(body);
        }
        const req = http.request({ host: '127.0.0.1', port: 8443, method, path: urlPath, headers }, res => {
            const chunks = [];
            res.on('data', c => chunks.push(c));
            res.on('end', () => resolve({ status: res.statusCode, headers: res.headers, body: Buffer.concat(chunks).toString() }));
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
    const res = await request('POST', '/xmlrpc', { body: xml, type: 'text/xml' });
    const text = res.body;
    const token = (text.match(/Login Token:\s*([^<\s]+)/) || [])[1];
    const accountId = (text.match(/AccountId:\s*([^<\s]+)/) || [])[1];
    assert.ok(token && accountId, `login failed: ${text.slice(0, 300)}`);
    return { token, accountId };
}

let passed = 0, failed = 0;
async function test(name, fn) {
    try {
        await fn();
        passed++;
        console.log(`  ok    ${name}`);
    } catch (err) {
        failed++;
        console.log(`  FAIL  ${name}\n        ${err.message.split('\n').join('\n        ')}`);
    }
}

async function getAsset(accountId, auth, assetId) {
    const res = await request('GET', `/bankfe/resources/account/${accountId}/asset?auth=${encodeURIComponent(auth)}&killcache=${Date.now()}`);
    const block = (res.body.match(new RegExp(`<asset id="${assetId}"[\\s\\S]*?</asset>`)) || [])[0];
    assert.ok(block, `asset ${assetId} not found in asset list`);
    const stat = tag => Number((block.match(new RegExp(`<ns3:${tag}>(-?\\d+)</ns3:${tag}>`)) || [])[1]);
    return { speed: stat('speed'), strength: stat('strength'), armor: stat('armor'), health: stat('health') };
}

async function getAccount(accountId, auth) {
    const res = await request('GET', `/bankfe/resources/account/${accountId}?auth=${encodeURIComponent(auth)}&killcache=${Date.now()}`);
    const v = tag => Number((res.body.match(new RegExp(`<jolt_${tag}_balance>(-?\\d+)</jolt_${tag}_balance>`)) || [])[1]);
    return { health: v('health'), armor: v('armor'), strength: v('strength'), speed: v('speed') };
}

async function main() {
    const { token, accountId } = await login(ACCOUNT_NAME);
    console.log(`logged in as ${ACCOUNT_NAME} (${accountId})`);
    const q = `?auth=${encodeURIComponent(token)}`;

    // Find the starter Electropod 1.0 instance id.
    const assetsRes = await request('GET', `/bankfe/resources/account/${accountId}/asset${q}&killcache=${Date.now()}`);
    const m = assetsRes.body.match(/<asset id="([^"]+)"[^>]*>\s*<asset-type-category>virmon<\/asset-type-category>\s*<asset-type-id>1<\/asset-type-id>/);
    assert.ok(m, 'could not find starter Electropod 1.0 in asset list');
    const assetId = m[1];
    console.log(`target nanovor: Electropod 1.0, asset ${assetId}`);

    const master = getVirmonMaster(ROOT, STARTER_TYPE_ID);
    assert.ok(master, 'no master data for Electropod 1.0');
    console.log(`master: base speed ${master.baseSpeed}, max ${master.maxSpeed}, ladder [${master.buffSpeed.join(',')}]`);

    const before = await getAsset(accountId, token, assetId);
    assert.strictEqual(before.speed, master.baseSpeed, `expected fresh account to start at base speed ${master.baseSpeed}, got ${before.speed}`);

    // Give the account enough speed jolts for +2, via the dev grant-style path isn't
    // available for jolts, so credit directly through the device jolt-upload route
    // using a throwaway device (mirrors how real jolts arrive).
    const twoStepCost = master.buffSpeed[0] + master.buffSpeed[1];
    const oneStepCost = master.buffSpeed[0];
    console.log(`cost for +1 speed: ${oneStepCost}, for +2: ${twoStepCost}`);

    await test('insufficient balance is rejected and changes nothing', async () => {
        const res = await request('POST', `/bankfe/resources/asset/${assetId}/jolt${q}`, {
            body: '<jolt-spend><speed-delta>1</speed-delta></jolt-spend>', type: 'application/xml',
        });
        assert.notStrictEqual(res.status, 200, `expected non-2xx, got ${res.status}: ${res.body}`);
        const after = await getAsset(accountId, token, assetId);
        assert.strictEqual(after.speed, before.speed, 'speed changed despite rejection');
    });

    // No dev endpoint grants stat jolts directly, so associate a throwaway
    // Nanoscope and upload a crafted jolts file through the real route - the
    // same path real jolts arrive by.
    const deviceId = String(100000000 + Math.floor(Math.random() * 800000000));
    const deviceIdBuf = Buffer.alloc(62);
    crypto.randomFillSync(deviceIdBuf, 0, 22);
    deviceIdBuf.writeInt32LE(1, 22); // firmware field, arbitrary non-negative
    deviceIdBuf.writeInt32LE(0, 26);
    Buffer.from(deviceId, 'ascii').copy(deviceIdBuf, 30);

    await test('associate throwaway device', async () => {
        const res = await request('POST', `/device/associate${q}`, { body: deviceIdBuf, type: 'application/octet-stream' });
        assert.strictEqual(res.status, 200, res.body);
    });

    const joltsBuf = Buffer.alloc(38);
    crypto.randomFillSync(joltsBuf, 0, 16);
    joltsBuf.writeUInt16LE(3, 16);
    joltsBuf.writeUInt16LE(Math.floor(Math.random() * 60000), 18);
    joltsBuf.writeInt32LE(twoStepCost + 5, 22); // speed points (a little slack)
    joltsBuf.writeInt32LE(0, 26); // strength
    joltsBuf.writeInt32LE(0, 30); // armor
    joltsBuf.writeInt32LE(0, 34); // health

    await test('credit speed jolts via device upload', async () => {
        const res = await request('POST', `/device/${deviceId}/jolt${q}`, { body: joltsBuf, type: 'application/octet-stream' });
        assert.strictEqual(res.status, 200, res.body);
        const bal = await getAccount(accountId, token);
        assert.ok(bal.speed >= twoStepCost, `expected at least ${twoStepCost} speed jolts, got ${bal.speed}`);
    });

    let balanceBeforeSpend;
    await test('buff +2 speed: response has matching ids and correct new value', async () => {
        balanceBeforeSpend = await getAccount(accountId, token);
        const res = await request('POST', `/bankfe/resources/asset/${assetId}/jolt${q}`, {
            body: '<jolt-spend><speed-delta>2</speed-delta></jolt-spend>', type: 'application/xml',
        });
        assert.strictEqual(res.status, 200, res.body);
        assert.doesNotMatch(res.body, /^<error/, `root must not be <error>: ${res.body}`);
        assert.match(res.body, new RegExp(`<asset-stat id="${assetId}">`), 'asset-stat id must match posted asset id');
        assert.match(res.body, new RegExp(`<account id="${accountId}">`), 'account id must match session account id');
        assert.match(res.body, new RegExp(`<speed>${before.speed + 2}</speed>`), 'response speed should be base+2');
    });

    await test('asset list reflects the buff', async () => {
        const after = await getAsset(accountId, token, assetId);
        assert.strictEqual(after.speed, before.speed + 2, `expected speed ${before.speed + 2}, got ${after.speed}`);
        assert.strictEqual(after.strength, before.strength, 'strength should be untouched');
    });

    await test('speed jolt pool was debited exactly the ladder cost', async () => {
        const after = await getAccount(accountId, token);
        assert.strictEqual(balanceBeforeSpend.speed - after.speed, twoStepCost,
            `expected debit of ${twoStepCost}, got ${balanceBeforeSpend.speed - after.speed}`);
    });

    await test('over-max delta is rejected and changes nothing', async () => {
        const current = await getAsset(accountId, token, assetId);
        const balBefore = await getAccount(accountId, token);
        const overDelta = master.maxSpeed - current.speed + 1;
        const res = await request('POST', `/bankfe/resources/asset/${assetId}/jolt${q}`, {
            body: `<jolt-spend><speed-delta>${overDelta}</speed-delta></jolt-spend>`, type: 'application/xml',
        });
        assert.notStrictEqual(res.status, 200, `expected non-2xx, got ${res.status}: ${res.body}`);
        const after = await getAsset(accountId, token, assetId);
        const balAfter = await getAccount(accountId, token);
        assert.strictEqual(after.speed, current.speed, 'speed changed despite over-max rejection');
        assert.strictEqual(balAfter.speed, balBefore.speed, 'jolt pool changed despite over-max rejection');
    });

    await test('buff persists across a fresh login', async () => {
        const second = await login(ACCOUNT_NAME);
        const after = await getAsset(accountId, second.token, assetId);
        assert.strictEqual(after.speed, before.speed + 2, 'buffed speed did not persist');
    });

    console.log(`\n${passed} passed, ${failed} failed`);
    process.exitCode = failed ? 1 : 0;
}

main().catch(err => {
    console.error(err);
    process.exit(1);
});
