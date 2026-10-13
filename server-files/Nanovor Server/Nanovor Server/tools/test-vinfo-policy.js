#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Regression test for WHICH vinfo the server may send to a device (resolveVinfo).
//
// Why it exists: on 2026-10-13 a transfer wrote 9 vinfos to the 1.381 Nanoscope. The
// firmware DELETED the 6 that came from other devices' dumps (the 3 from Project
// Nanoscope's "The List" were kept) and the handheld then failed SEC_VerifySystem on
// every boot. The picker had also ignored vinfos the device had itself supplied.
//
// Self-contained: builds synthetic vinfos in a temp dir, so it needs no device, no
// server and none of the gitignored data.
//
//   node tools/test-vinfo-policy.js
// ---------------------------------------------------------------------------

const fs = require('fs');
const os = require('os');
const path = require('path');
const assert = require('assert');
const ns = require('../nanoscope');

let passed = 0, failed = 0;
function test(name, fn) {
    try { fn(); passed++; console.log(`  ok    ${name}`); }
    catch (err) { failed++; console.log(`  FAIL  ${name}\n        ${err.message}`); }
}

// A minimal but valid-looking 4194-byte vinfo: only the fields the server reads.
function vinfo(assetId, assetTypeId, { speed = 10, strength = 100, armor = 5, health = 100 } = {}) {
    const b = Buffer.alloc(ns.VINFO_SIZE);
    b.writeUInt16LE(3, 0);
    b.writeBigUInt64LE(BigInt(assetId), 6);
    b.writeUInt32LE(assetTypeId, 14);
    b.writeUInt16LE(150, 410);
    b.writeUInt16LE(0, 412);
    b.writeUInt16LE(speed, 414);
    b.writeUInt16LE(strength, 416);
    b.writeUInt16LE(armor, 418);
    b.writeUInt16LE(health, 420);
    return b;
}

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'vinfo-policy-'));
const deviceVault = new ns.DeviceVault(path.join(tmp, 'DeviceVault'));
const corpusVault = new ns.CorpusVault(path.join(tmp, 'Corpus'));
const DEV = '0000000000000999';

// What this device itself supplied (proven accepted): a type-1 and a type-6 nanovor.
// 500 sorts AFTER 201, so a picker that just sorts the corpus would wrongly prefer 201.
deviceVault.putVinfo(DEV, vinfo(500, 1));
deviceVault.putVinfo(DEV, vinfo(501, 6));
// The corpus: a mix of The List files (trusted) and other devices' captures (not).
corpusVault.ingestVinfo(vinfo(200, 1));                  // type 1, NOT from The List
corpusVault.ingestVinfo(vinfo(201, 1));                  // type 1, The List
corpusVault.ingestVinfo(vinfo(300, 14));                 // type 14, The List
corpusVault.ingestVinfo(vinfo(301, 14, { speed: 12 }));  // type 14, The List (a 2nd copy)
corpusVault.ingestVinfo(vinfo(400, 16));                 // type 16, ONLY a foreign capture
corpusVault.setTrusted([201, 300, 301]);

const inst = (assetId, assetTypeId, stats) => ({ assetId: String(assetId), assetTypeId, speed: 10, strength: 100, armor: 5, health: 100, ...stats });
const resolve = (i, extra = {}) => ns.resolveVinfo({ deviceVault, corpusVault, deviceId: DEV, inst: i, ...extra });
const idOf = r => r.assetId;

console.log('which vinfo may be sent to a device:');

test('a vinfo the device supplied is served exactly (device-origin)', () => {
    const r = resolve(inst(500, 1));
    assert.strictEqual(r.kind, 'device-origin');
    assert.strictEqual(r.assetId, '500');
});

test('a progression instance gets the device\'s OWN copy of the species, not the first corpus id', () => {
    const r = resolve(inst(900001, 1, { strength: 140 }));
    assert.strictEqual(r.kind, 'own-standin');
    assert.strictEqual(r.assetId, '500', 'the 2026-10-13 bug: it picked the first corpus id instead');
});

test('with no own copy of the species, a The List copy is used', () => {
    const r = resolve(inst(900002, 14));
    assert.strictEqual(r.kind, 'list-standin');
    assert.ok(['300', '301'].includes(r.assetId));
});

test('a species with ONLY a foreign (non-List) capture is refused', () => {
    assert.strictEqual(resolve(inst(900003, 16)).kind, 'none');
});

test('the foreign capture is only reachable through the explicit danger override', () => {
    const r = resolve(inst(900003, 16), { allowUntrusted: true });
    assert.strictEqual(r.kind, 'untrusted-standin');
    assert.strictEqual(r.assetId, '400');
});

test('a species nobody has is refused', () => {
    assert.strictEqual(resolve(inst(900004, 99)).kind, 'none');
});

test('an untrusted corpus id requested directly is NOT served as corpus-exact', () => {
    // 200 is in the corpus but not from The List; the account owns it unmodified.
    const r = resolve(inst(200, 1));
    assert.notStrictEqual(r.kind, 'corpus-exact');
    assert.notStrictEqual(r.assetId, '200');
});

test('an unmodified trusted corpus instance is served as itself', () => {
    const r = resolve(inst(300, 14));
    assert.strictEqual(r.kind, 'corpus-exact');
    assert.strictEqual(r.assetId, '300');
});

test('a leveled instance whose id IS a scope file is served as itself (stats stay PC-side)', () => {
    // A "folded" nanovor: the real instance was renamed to the scope file's id. The scope
    // keeps carrying the generic file; import must not overwrite the earned stats (pcStats).
    const r = resolve(inst(300, 14, { strength: 999 }));
    assert.strictEqual(r.kind, 'corpus-exact');
    assert.strictEqual(r.assetId, '300');
});

test('an EVOLVED instance (species changed) is not sent its old species\' file', () => {
    // id 300 is a type-14 file; the instance is now type 1, so it must get a type-1 copy.
    const r = resolve(inst(300, 1, { strength: 140 }));
    assert.notStrictEqual(r.assetId, '300');
    assert.strictEqual(r.kind, 'own-standin');
});

test('two same-species requests in one transfer get DISTINCT ids', () => {
    const a = resolve(inst(900010, 14));
    const b = resolve(inst(900011, 14), { excludeIds: [idOf(a)] });
    assert.strictEqual(b.kind, 'list-standin');
    assert.notStrictEqual(a.assetId, b.assetId);
});

test('a third same-species request has nothing left and is refused, not duplicated', () => {
    const a = resolve(inst(900010, 14));
    const b = resolve(inst(900011, 14), { excludeIds: [idOf(a)] });
    const c = resolve(inst(900012, 14), { excludeIds: [idOf(a), idOf(b)] });
    assert.strictEqual(c.kind, 'none');
});

test('last time\'s stand-in is kept when still servable (stable mapping)', () => {
    const r = resolve(inst(900013, 14), { preferId: '301' });
    assert.strictEqual(r.assetId, '301');
});

test('a remembered stand-in that is not safe any more is ignored', () => {
    const r = resolve(inst(900014, 1), { preferId: '200' }); // 200 = foreign capture
    assert.notStrictEqual(r.assetId, '200');
});

test('a remembered stand-in of the wrong species is ignored', () => {
    const r = resolve(inst(900015, 14), { preferId: '201' }); // 201 is type 1
    assert.notStrictEqual(r.assetId, '201');
});

test('NOTHING sent to the device is ever unproven (property check over many requests)', () => {
    const allowed = id => Boolean(deviceVault.getVinfo(DEV, id)) || corpusVault.isTrusted(id);
    for (const type of [1, 6, 14, 16, 99]) {
        for (let n = 0; n < 4; n++) {
            const r = resolve(inst(910000 + n, type, { strength: 111 + n }));
            if (r.kind !== 'none') assert.ok(allowed(r.assetId), `type ${type}: sent ${r.assetId}, which is unproven`);
        }
    }
});

test('with no trusted.json at all, nothing from the corpus is trusted (fails safe)', () => {
    const empty = new ns.CorpusVault(path.join(tmp, 'EmptyCorpus'));
    empty.ingestVinfo(vinfo(700, 14));
    const r = ns.resolveVinfo({ deviceVault, corpusVault: empty, deviceId: DEV, inst: inst(900020, 14) });
    assert.strictEqual(r.kind, 'none');
});

// ---------------------------------------------------------------------------
// Series rule. 2026-10-13: Plasma Lash's stand-in 147415019 WAS a The List file, was
// sent to a device holding only 157xxxxxx ids, and the firmware deleted it. Every kept
// vinfo (10 of 10) had a 157 id; every deleted one (7 of 7) did not.
// ---------------------------------------------------------------------------
console.log('\nid series (the Plasma Lash case):');
const dev2 = '0000000000000777';
const vault2 = new ns.DeviceVault(path.join(tmp, 'DeviceVault2'));
const corpus2 = new ns.CorpusVault(path.join(tmp, 'Corpus2'));
vault2.putVinfo(dev2, vinfo(157000001, 1));        // the device holds the 157 series
corpus2.ingestVinfo(vinfo(157000300, 14));         // type 14, The List, 157 series
corpus2.ingestVinfo(vinfo(147000301, 14));         // type 14, The List, 147 series
corpus2.ingestVinfo(vinfo(147000400, 25));         // type 25, The List, ONLY in the 147 series
corpus2.ingestVinfo(vinfo(1318669, 26));           // type 26, The List, short-id series
corpus2.setTrusted([157000300, 147000301, 147000400, 1318669]);
const resolve2 = (i, extra = {}) => ns.resolveVinfo({ deviceVault: vault2, corpusVault: corpus2, deviceId: dev2, inst: i, ...extra });

test('a The List file in the device\'s own series is sent', () => {
    const r = resolve2(inst(900100, 14));
    assert.strictEqual(r.kind, 'list-standin');
    assert.strictEqual(r.assetId, '157000300');
});

test('a The List file in a series the device does not hold is REFUSED (Plasma Lash)', () => {
    assert.strictEqual(resolve2(inst(900101, 25)).kind, 'none', '147... must not go to a 157-series device');
});

test('the short-id series is refused for a 157-series device too (Doom Blade 2.0)', () => {
    assert.strictEqual(resolve2(inst(900102, 26)).kind, 'none');
});

test('when both series exist for a species, only the held one is ever chosen', () => {
    for (let n = 0; n < 3; n++) {
        const r = resolve2(inst(900110 + n, 14), { excludeIds: n ? ['157000300'] : [] });
        if (r.kind !== 'none') assert.strictEqual(ns.idSeries(r.assetId), '157', `sent ${r.assetId}`);
    }
});

test('a held-series file asked for directly and unmodified is served as itself', () => {
    const r = resolve2(inst(157000300, 14));
    assert.strictEqual(r.kind, 'corpus-exact');
});

test('a not-held-series file asked for directly is NOT served as itself', () => {
    const r = resolve2(inst(147000400, 25));
    assert.strictEqual(r.kind, 'none');
});

test('a remembered stand-in from a series the device does not hold is ignored', () => {
    const r = resolve2(inst(900103, 14), { preferId: '147000301' });
    assert.notStrictEqual(r.assetId, '147000301');
});

test('the explicit override lifts the series restriction', () => {
    const r = resolve2(inst(900104, 25), { allowUntrusted: true });
    assert.strictEqual(r.assetId, '147000400');
    assert.strictEqual(r.kind, 'untrusted-standin', 'and it is labelled as unproven');
});

test('a device that supplied nothing is sent nothing from the corpus (no series to match)', () => {
    const r = ns.resolveVinfo({ deviceVault: vault2, corpusVault: corpus2, deviceId: '0000000000000888', inst: inst(900105, 14) });
    assert.strictEqual(r.kind, 'none');
});

test('idSeries buckets long ids by prefix and short ids together', () => {
    assert.strictEqual(ns.idSeries('157138677'), '157');
    assert.strictEqual(ns.idSeries('147415019'), '147');
    assert.strictEqual(ns.idSeries('4666632'), 'short');
    assert.strictEqual(ns.idSeries('1318669'), 'short');
});

fs.rmSync(tmp, { recursive: true, force: true });
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
