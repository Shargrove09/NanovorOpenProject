#!/usr/bin/env node
'use strict';

// Golden tests for nanoscope.js. Run from the server root: node tools/test-nanoscope.js
//
// Always checks the 10 sensei vinfos and 20 character manifests the client ships.
// If a device backup exists (device-backups/<id>/<stamp>/), also checks it.

const fs = require('fs');
const path = require('path');
const assert = require('assert');
const ns = require('../nanoscope');

const ROOT = path.resolve(__dirname, '..');
const DEVICE_ASSETS = path.join(ROOT, 'Manifests', 'device');

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

// Base/max stats straight from the decoded master data.
function loadMaster() {
    const xml = fs.readFileSync(path.join(ROOT, 'virmon-master-decoded.xml'), 'utf8');
    const byId = new Map();
    for (const block of xml.split('<virmon>').slice(1)) {
        const tag = t => (block.match(new RegExp(`<${t}>([^<]*)</${t}>`)) || [])[1];
        const num = t => Number(tag(t));
        byId.set(num('asset-type-id'), {
            name: tag('name'), faction: tag('faction'), pv: num('pv'),
            base: { speed: num('base-speed'), strength: num('base-strength'), armor: num('base-armor'), health: num('base-health') },
            max: { speed: num('max-speed'), strength: num('max-strength'), armor: num('max-armor'), health: num('max-health') },
        });
    }
    return byId;
}
const master = loadMaster();
const STATS = ['speed', 'strength', 'armor', 'health'];

function checkVinfoAgainstMaster(v, { exactBase }) {
    const m = master.get(v.assetTypeId);
    assert.ok(m, `type ${v.assetTypeId} not in master data`);
    assert.strictEqual(v.name, m.name.toUpperCase(), 'name');
    assert.strictEqual(v.faction, m.faction, 'faction');
    assert.strictEqual(v.sv, m.pv, 'SV');
    for (const s of STATS) {
        if (exactBase) {
            assert.strictEqual(v[s], m.base[s], `${s} should be the base value`);
        } else {
            // Device nanovor carry jolted stats: somewhere from base up to max.
            assert.ok(v[s] >= m.base[s] && v[s] <= m.max[s], `${s} ${v[s]} outside base..max ${m.base[s]}..${m.max[s]}`);
        }
    }
}

console.log('sensei vinfos shipped with the client');
const swarm = path.join(DEVICE_ASSETS, 's1', 'swarm');
for (const dir of fs.readdirSync(swarm).filter(d => /^\d+$/.test(d))) {
    test(`s1/swarm/${dir}/vinfo.bbb`, () => {
        const v = ns.parseVinfo(fs.readFileSync(path.join(swarm, dir, 'vinfo.bbb')));
        assert.strictEqual(v.assetTypeId, Number(dir), 'asset-type-id matches its folder');
        assert.match(v.assetId, /^[1-9]\d*$/, 'asset id is a plain decimal');
        checkVinfoAgainstMaster(v, { exactBase: true });
    });
}

console.log('character manifests');
test('buildCharacterManifest reproduces every shipped manifest.xml byte for byte', () => {
    const chars = path.join(DEVICE_ASSETS, 'Characters');
    for (const t of fs.readdirSync(chars)) {
        const d = path.join(chars, t);
        const want = fs.readFileSync(path.join(d, 'manifest.xml'), 'utf8');
        const got = ns.buildCharacterManifest(fs.readFileSync(path.join(d, 'spr.v2z')), fs.readFileSync(path.join(d, 'nano.snd')));
        assert.strictEqual(got, want, `type ${t}`);
    }
});

console.log('helpers');
test('normalizeDeviceId', () => {
    assert.strictEqual(ns.normalizeDeviceId('0000000000077831'), '77831');
    assert.strictEqual(ns.normalizeDeviceId(77831), '77831');
    assert.strictEqual(ns.normalizeDeviceId('0000000000000000'), '0');
});
test('parseVinfo rejects a wrong-sized buffer', () => {
    assert.throws(() => ns.parseVinfo(Buffer.alloc(100)), /must be 4194 bytes/);
});

// Latest backup, if any.
function latestBackup() {
    const base = path.join(ROOT, 'device-backups');
    if (!fs.existsSync(base)) return null;
    const all = [];
    for (const id of fs.readdirSync(base)) {
        for (const stamp of fs.readdirSync(path.join(base, id))) {
            const dir = path.join(base, id, stamp);
            if (fs.existsSync(path.join(dir, 'backup.json'))) all.push(dir);
        }
    }
    return all.sort().pop() || null;
}

const backup = latestBackup();
if (backup) {
    console.log(`device backup ${path.relative(ROOT, backup)}`);
    const files = path.join(backup, 'files');
    const snap = ns.readDeviceRoot(files);
    test('deviceid.bbb parses', () => {
        assert.match(snap.device.deviceId, /^\d{16}$/, '16-digit device id');
        assert.ok(snap.device.firmware > 0, 'firmware field set');
    });
    for (const j of snap.jolts) {
        test(`${j.file} shares the session nonce and counter with deviceid.bbb`, () => {
            assert.strictEqual(j.nonce, snap.device.nonce);
            assert.strictEqual(j.session, snap.device.session);
            for (const s of STATS) assert.ok(j[s] >= 0, `${s} is negative`);
        });
    }
    for (const n of snap.nanovor) {
        test(`v${n.slot} ${n.parsed.name}: stats within master base..max`, () => checkVinfoAgainstMaster(n.parsed, { exactBase: false }));
    }
    test('device nanovor have unique asset ids', () => {
        const ids = snap.nanovor.map(n => n.parsed.assetId);
        assert.strictEqual(new Set(ids).size, ids.length);
    });
    test('sensei vinfos on the device are byte-identical to the client copies', () => {
        for (const dir of fs.readdirSync(swarm).filter(d => /^\d+$/.test(d))) {
            const onDevice = path.join(files, 's1', 'swarm', dir, 'vinfo.bbb');
            if (!fs.existsSync(onDevice)) continue;
            assert.ok(fs.readFileSync(onDevice).equals(fs.readFileSync(path.join(swarm, dir, 'vinfo.bbb'))), `s1/swarm/${dir}`);
        }
    });
} else {
    console.log('(no device backup found - run `node tools/nanoscope-cli.js backup E:` to add device checks)');
}

console.log(`\n${passed} passed, ${failed} failed`);
process.exitCode = failed ? 1 : 0;
