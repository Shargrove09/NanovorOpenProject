#!/usr/bin/env node
'use strict';

// End-to-end check of the Nanoscope routes against a RUNNING server, using a
// device backup instead of the client. Run from the server root:
//
//   node tools/test-nanoscope-server.js [<backupDir>] [--account-name nanoscope-selftest]
//
// Logs in as a throwaway account (created on first login), imports the backup
// into it, then exercises every route the client's Nanoscope screen calls.
// Re-runnable: import is idempotent and repeated jolt uploads are not re-credited.

const fs = require('fs');
const path = require('path');
const http = require('http');
const crypto = require('crypto');
const assert = require('assert');
const ns = require('../nanoscope');

const ROOT = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
const nameIdx = args.indexOf('--account-name');
const ACCOUNT_NAME = nameIdx >= 0 ? args[nameIdx + 1] : 'nanoscope-selftest';

function latestBackup() {
    const base = path.join(ROOT, 'device-backups');
    const all = [];
    for (const id of fs.existsSync(base) ? fs.readdirSync(base) : []) {
        for (const stamp of fs.readdirSync(path.join(base, id))) all.push(path.join(base, id, stamp));
    }
    return all.filter(d => fs.existsSync(path.join(d, 'backup.json'))).sort().pop();
}

const backupDir = args[0] && !args[0].startsWith('--') ? args[0] : latestBackup();
if (!backupDir) {
    console.error('no device backup found - run `node tools/nanoscope-cli.js backup E:` first');
    process.exit(1);
}
const filesDir = path.join(backupDir, 'files');

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
            res.on('end', () => resolve({ status: res.statusCode, headers: res.headers, body: Buffer.concat(chunks) }));
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
    const text = res.body.toString();
    const token = (text.match(/Login Token:\s*([^<\s]+)/) || [])[1];
    const accountId = (text.match(/AccountId:\s*([^<\s]+)/) || [])[1];
    assert.ok(token && accountId, `login failed: ${text.slice(0, 300)}`);
    return { token, accountId };
}

const sha = b => crypto.createHash('sha256').update(b).digest('hex');
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

async function main() {
    const snap = ns.readDeviceRoot(filesDir);
    const rawId = snap.device.deviceId; // zero-padded, as the client sends it
    console.log(`backup ${path.relative(ROOT, backupDir)} (device ${rawId}, ${snap.nanovor.length} nanovor)`);

    try {
        await request('GET', '/device/device-manifest.xml');
    } catch (err) {
        console.error(`server not reachable on 127.0.0.1:8443 (${err.code}) - start run-server.bat first`);
        process.exit(1);
    }

    const { token, accountId } = await login(ACCOUNT_NAME);
    console.log(`logged in as ${ACCOUNT_NAME} (${accountId})`);
    const q = `?auth=${encodeURIComponent(token)}&killcache=${Date.now()}`;

    await test('device-manifest.xml: firmware -1, no files, no minigames', async () => {
        const res = await request('GET', `/device/device-manifest.xml?killcache=${Date.now()}`);
        assert.strictEqual(res.status, 200);
        const text = res.body.toString();
        assert.match(text, /<firmware-version>-1<\/firmware-version>/);
        assert.doesNotMatch(text, /<file>|<minigame-file>/);
    });

    await test('sign/vinfo before import is refused (device not associated)', async () => {
        const fresh = await login(`${ACCOUNT_NAME}-unassociated`);
        const a = snap.nanovor[0].parsed.assetId;
        const res = await request('GET', `/device/${rawId}/asset/${a}/sign/vinfo?auth=${encodeURIComponent(fresh.token)}`);
        assert.strictEqual(res.status, 403);
    });

    await test('import via /dev/nanoscope/import', async () => {
        const res = await request('POST', '/dev/nanoscope/import', {
            body: JSON.stringify({ account: accountId, root: filesDir }), type: 'application/json',
        });
        assert.strictEqual(res.status, 200, res.body.toString());
        const report = JSON.parse(res.body);
        assert.strictEqual(report.nanovor.length, snap.nanovor.length);
        for (const n of report.nanovor) {
            console.log(`        ${n.slot} ${n.name.padEnd(18)} asset ${n.assetId}  sprites: ${n.characterAssets.padEnd(10)} device-ready: ${n.deviceReady}`);
        }
    });

    await test('device list contains the device, id without leading zeros', async () => {
        const res = await request('GET', `/bankfe/resources/account/${accountId}/device${q}`);
        assert.strictEqual(res.status, 200);
        assert.match(res.body.toString(), new RegExp(`<device id="${ns.normalizeDeviceId(rawId)}"/>`));
    });

    await test('asset list carries the imported nanovor with their jolted stats', async () => {
        const res = await request('GET', `/bankfe/resources/account/${accountId}/asset${q}`);
        const text = res.body.toString();
        for (const n of snap.nanovor) {
            const p = n.parsed;
            const block = (text.match(new RegExp(`<asset id="${p.assetId}"[\\s\\S]*?</asset>`)) || [])[0];
            assert.ok(block, `asset ${p.assetId} missing`);
            for (const s of ['speed', 'strength', 'armor', 'health']) {
                assert.match(block, new RegExp(`<ns3:${s}>${p[s]}</ns3:${s}>`), `${p.name} ${s}`);
            }
        }
    });

    for (const n of snap.nanovor) {
        await test(`sign/vinfo replays v${n.slot} byte-for-byte`, async () => {
            const res = await request('GET', `/device/${rawId}/asset/${n.parsed.assetId}/sign/vinfo${q}`);
            assert.strictEqual(res.status, 200);
            assert.strictEqual(sha(res.body), sha(n.vinfo));
        });
    }

    await test('sign/vinfo for an asset with no captured copy -> 409', async () => {
        const res = await request('GET', `/bankfe/resources/account/${accountId}/asset${q}`);
        const ids = [...res.body.toString().matchAll(/<asset id="([^"]+)"[^>]*>\s*<asset-type-category>virmon/g)].map(m => m[1]);
        const deviceIds = new Set(snap.nanovor.map(n => n.parsed.assetId));
        const other = ids.find(id => !deviceIds.has(id));
        assert.ok(other, 'account has no non-device nanovor to try');
        const r = await request('GET', `/device/${rawId}/asset/${other}/sign/vinfo${q}`);
        assert.strictEqual(r.status, 409);
    });

    await test('sign/plyinfo replays the captured file', async () => {
        const res = await request('GET', `/device/${rawId}/account/${accountId}/sign/plyinfo${q}`);
        assert.strictEqual(res.status, 200);
        assert.strictEqual(sha(res.body), sha(snap.plyinfo));
    });

    await test('character assets served for every device-ready type', async () => {
        for (const n of snap.nanovor.filter(x => x.hasSprite && x.hasSound)) {
            const t = n.parsed.assetTypeId;
            const res = await request('GET', `/device/characters/${t}/spr.v2z?killcache=1`);
            assert.strictEqual(res.status, 200, `type ${t}`);
        }
    });

    await test('firmware, manifest.bbb and recovery are refused', async () => {
        for (const p of [`/device/${rawId}/firmware/signature${q}`, `/device/${rawId}/manifest${q}`, '/device/reset/privkey.bbb', '/device/reset/frm.bbb']) {
            const res = await request('GET', p);
            assert.strictEqual(res.status, 404, p);
        }
    });

    for (const j of snap.jolts) {
        await test(`jolt upload of ${j.file} credits once`, async () => {
            const balance = async () => {
                const t = (await request('GET', `/bankfe/resources/account/${accountId}${q}`)).body.toString();
                const v = k => Number((t.match(new RegExp(`<jolt_${k}_balance>(\\d+)</jolt_${k}_balance>`)) || [])[1]);
                return { speed: v('speed'), strength: v('strength'), armor: v('armor'), health: v('health') };
            };
            const body = fs.readFileSync(path.join(filesDir, j.file));
            const before = await balance();
            const r1 = await request('POST', `/device/${rawId}/jolt${q}`, { body, type: 'application/octet-stream' });
            assert.strictEqual(r1.status, 200);
            const mid = await balance();
            const r2 = await request('POST', `/device/${rawId}/jolt${q}`, { body, type: 'application/octet-stream' });
            assert.strictEqual(r2.status, 200);
            const after = await balance();
            for (const s of ['speed', 'strength', 'armor', 'health']) {
                const firstGain = mid[s] - before[s];
                assert.ok(firstGain === j[s] || firstGain === 0, `${s}: first upload added ${firstGain}, expected ${j[s]} (or 0 if credited on an earlier run)`);
                assert.strictEqual(after[s], mid[s], `${s}: second upload must not credit again`);
            }
        });
    }

    await test('associate with a raw deviceid.bbb', async () => {
        const fresh = await login(`${ACCOUNT_NAME}-associate`);
        const body = fs.readFileSync(path.join(filesDir, 'deviceid.bbb'));
        const r = await request('POST', `/device/associate?auth=${encodeURIComponent(fresh.token)}`, { body, type: 'application/octet-stream' });
        assert.strictEqual(r.status, 200);
        const list = await request('GET', `/bankfe/resources/account/${fresh.accountId}/device?auth=${encodeURIComponent(fresh.token)}`);
        assert.match(list.body.toString(), new RegExp(`<device id="${ns.normalizeDeviceId(rawId)}"/>`));
    });

    console.log(`\n${passed} passed, ${failed} failed`);
    process.exitCode = failed ? 1 : 0;
}

main().catch(err => {
    console.error(err);
    process.exit(1);
});
