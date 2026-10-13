#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// "One entry per nanovor": folding a scope stand-in into the real instance.
//
// Why: every nanovor sent to the scope as a stand-in used to be minted into the collection
// as a SECOND entry (the client resolves the scope's vinfo ids against the asset list, so
// the file's id had to exist). The account ended up with 40 entries for 25 nanovor. Now the
// real instance is renamed to the scope file's id instead.
//
// Self-contained: synthetic users and vaults in a temp dir; no device, no server.
//
//   node tools/test-scope-copies.js
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

function vinfo(assetId, assetTypeId) {
    const b = Buffer.alloc(ns.VINFO_SIZE);
    b.writeUInt16LE(3, 0);
    b.writeBigUInt64LE(BigInt(assetId), 6);
    b.writeUInt32LE(assetTypeId, 14);
    return b;
}

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'scope-copies-'));
const deviceVault = new ns.DeviceVault(path.join(tmp, 'DeviceVault'));
const corpusVault = new ns.CorpusVault(path.join(tmp, 'Corpus'));
const ctx = { deviceVault, corpusVault };
const DEV = '0000000000000999';

// The scope itself supplied 157000001 (type 1). The corpus holds generic files for a few species.
deviceVault.putVinfo(DEV, vinfo(157000001, 1));
deviceVault.putVinfo('0000000000077831', vinfo(4666000, 16));   // a DIFFERENT device's own
corpusVault.ingestVinfo(vinfo(157000063, 63));
corpusVault.ingestVinfo(vinfo(157000041, 41));
corpusVault.ingestVinfo(vinfo(157000001, 1));

const mk = (assetId, assetTypeId, extra = {}) => ({
    id: assetTypeId, name: `Species${assetTypeId}`, type: 'virmon', assetTypeId, assetId: String(assetId),
    speed: 25, strength: 150, armor: 15, health: 145, nickname: '', ...extra,
});
const user = (...inv) => ({ nanovorInventory: inv, nanovorCount: 0, nanovorCountUnique: 0 });

console.log('lookup + counters:');

test('findNanovor matches the current id', () => {
    const u = user(mk(1, 63));
    assert.strictEqual(ns.findNanovor(u, '1').assetTypeId, 63);
    assert.strictEqual(ns.findNanovor(u, 1).assetTypeId, 63, 'numbers work too');
});

test('findNanovor falls back to an id the nanovor used to have', () => {
    const u = user(mk(157000063, 63, { previousAssetIds: ['1515677324'] }));
    assert.strictEqual(ns.findNanovor(u, '1515677324').assetId, '157000063');
});

test('findNanovor returns null for an unknown id', () => {
    assert.strictEqual(ns.findNanovor(user(mk(1, 63)), '999'), null);
});

test('syncNanovorCounts follows the collection: entries and distinct species', () => {
    const u = user(mk(1, 63), mk(2, 63), mk(3, 41));
    ns.syncNanovorCounts(u);
    assert.strictEqual(u.nanovorCount, 3);
    assert.strictEqual(u.nanovorCountUnique, 2);
});

console.log('\nfolding a stand-in into the real instance:');

test('the real instance takes the scope file\'s id and keeps everything else', () => {
    const real = mk(1515677324, 63, { nickname: 'Sparky', strength: 150, birthDate: '2010-01-01' });
    const u = user(real);
    const r = ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV, kind: 'list-standin' });
    assert.ok(r.ok && r.folded);
    assert.strictEqual(u.nanovorInventory.length, 1, 'still ONE entry');
    const n = u.nanovorInventory[0];
    assert.strictEqual(n.assetId, '157000063');
    assert.strictEqual(n.strength, 150, 'earned stats kept');
    assert.strictEqual(n.nickname, 'Sparky');
    assert.strictEqual(n.birthDate, '2010-01-01');
    assert.deepStrictEqual(n.previousAssetIds, ['1515677324']);
    assert.strictEqual(n.pcStats, true, 'import must never overwrite these stats');
    assert.strictEqual(n.scopeCopy.deviceId, '999', 'normalised device id');
});

test('the old id still finds it afterwards (the client keeps using it for the session)', () => {
    const u = user(mk(1515677324, 63));
    ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV });
    assert.strictEqual(ns.findNanovor(u, '1515677324').assetId, '157000063');
    assert.strictEqual(ns.findNanovor(u, '157000063').assetId, '157000063');
});

test('counters are updated by the fold', () => {
    const u = user(mk(1515677324, 63), mk(7, 41));
    ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV });
    assert.strictEqual(u.nanovorCount, 2);
});

test('folding twice is a no-op', () => {
    const u = user(mk(1515677324, 63));
    ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV });
    const again = ns.foldIntoScopeId(u, '157000063', '157000063', { deviceId: DEV });
    assert.ok(again.ok);
    assert.strictEqual(again.folded, false);
    assert.deepStrictEqual(u.nanovorInventory[0].previousAssetIds, ['1515677324']);
});

test('an instance imported from a device is NOT folded (it keeps that device\'s id)', () => {
    const u = user(mk(4666609, 16, { source: 'nanoscope' }));
    const r = ns.foldIntoScopeId(u, '4666609', '157000099', { deviceId: DEV });
    assert.strictEqual(r.ok, false);
    assert.strictEqual(u.nanovorInventory[0].assetId, '4666609');
});

test('refused when the scope file is already another nanovor\'s entry', () => {
    const u = user(mk(11, 63), mk(157000063, 63, { source: 'nanoscope', scopeCopy: { deviceId: '999' } }));
    const r = ns.foldIntoScopeId(u, '11', '157000063', { deviceId: DEV });
    assert.strictEqual(r.ok, false);
    assert.strictEqual(u.nanovorInventory.length, 2, 'nothing was removed');
});

test('a leftover holding the scope file is replaced, not duplicated', () => {
    const leftover = mk(157000063, 63, { source: 'nanoscope', strength: 100 });
    const u = user(mk(1515677324, 63), leftover);
    const r = ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV, canReplace: e => ns.isLeftover(e, ctx) });
    assert.ok(r.ok && r.folded);
    assert.strictEqual(u.nanovorInventory.length, 1, 'the leftover is gone');
    assert.strictEqual(u.nanovorInventory[0].strength, 150, 'and the real instance\'s stats won');
});

test('an unfoldable unknown nanovor is reported, not crashed on', () => {
    assert.strictEqual(ns.foldIntoScopeId(user(), '1', '2', {}).ok, false);
});

console.log('\nwhat counts as a leftover:');

test('a generic corpus copy nothing depends on is a leftover', () => {
    assert.strictEqual(ns.isLeftover(mk(157000063, 63, { source: 'nanoscope' }), ctx), true);
});

test('one a device supplied is NOT a leftover (it is that device\'s real nanovor)', () => {
    assert.strictEqual(ns.isLeftover(mk(157000001, 1, { source: 'nanoscope' }), ctx), false);
});

test('one bound to a scope slot is NOT a leftover', () => {
    assert.strictEqual(ns.isLeftover(mk(157000063, 63, { source: 'nanoscope', scopeCopy: { deviceId: '999' } }), ctx), false);
});

test('a bought/evolved nanovor is NOT a leftover', () => {
    assert.strictEqual(ns.isLeftover(mk(157000063, 63), ctx), false);
});

test('an id that is not in the corpus is NOT a leftover', () => {
    assert.strictEqual(ns.isLeftover(mk(555, 63, { source: 'nanoscope' }), ctx), false);
});

console.log('\nstand-ins we minted earlier (the vault cannot tell them apart once imported):');

test('a The List stand-in recorded in the ledger is replaceable, even though the vault holds it', () => {
    deviceVault.putVinfo(DEV, vinfo(157000041, 41));           // an import vaulted what was on the scope
    const entry = mk(157000041, 41, { source: 'nanoscope' });
    const ledger = { scopeAssetId: '157000041', kind: 'list-standin' };
    assert.strictEqual(ns.isLeftover(entry, ctx), false, 'the vault alone says: device-supplied');
    assert.strictEqual(ns.isReplaceableStandIn(entry, ledger, ctx), true, 'the ledger says: we made it');
});

test('the device\'s OWN copy used as a stand-in (ledger kind own-standin) is NOT replaceable', () => {
    const entry = mk(157000001, 1, { source: 'nanoscope' });
    assert.strictEqual(ns.isReplaceableStandIn(entry, { scopeAssetId: '157000001', kind: 'own-standin' }, ctx), false);
});

test('a ledger entry for a different scope id does not make an entry replaceable', () => {
    const entry = mk(157000063, 63, { source: 'nanoscope' });
    assert.strictEqual(ns.isReplaceableStandIn(entry, { scopeAssetId: '157000099', kind: 'list-standin' }, ctx), false);
});

test('no ledger entry -> not replaceable', () => {
    assert.strictEqual(ns.isReplaceableStandIn(mk(157000063, 63, { source: 'nanoscope' }), undefined, ctx), false);
});

test('a bound (folded) or non-scope entry is never replaceable', () => {
    const ledger = { scopeAssetId: '157000063', kind: 'list-standin' };
    assert.strictEqual(ns.isReplaceableStandIn(mk(157000063, 63, { source: 'nanoscope', scopeCopy: { deviceId: '999' } }), ledger, ctx), false);
    assert.strictEqual(ns.isReplaceableStandIn(mk(157000063, 63), ledger, ctx), false);
});

test('isFoldable: only instances the PC owns outright', () => {
    assert.strictEqual(ns.isFoldable(mk(1, 63)), true);
    assert.strictEqual(ns.isFoldable(mk(1, 63, { source: 'nanoscope' })), false);
});

console.log('\nwhat a device import may do to stats:');

test('a device import overwrites a device-origin instance\'s stats (the device is the truth)', () => {
    const inst = mk(4666609, 16, { source: 'nanoscope', strength: 100 });
    assert.strictEqual(ns.applyDeviceStats(inst, { speed: 55, strength: 116, armor: 8, health: 152 }), true);
    assert.strictEqual(inst.strength, 116);
});

test('a folded nanovor keeps its PC-earned stats through an import (the scope shows the generic file)', () => {
    const u = user(mk(1515677324, 63, { strength: 180 }));
    ns.foldIntoScopeId(u, '1515677324', '157000063', { deviceId: DEV });
    const inst = u.nanovorInventory[0];
    assert.strictEqual(ns.applyDeviceStats(inst, { speed: 25, strength: 150, armor: 15, health: 145 }), false);
    assert.strictEqual(inst.strength, 180, 'the earned 180 survives, not the generic 150');
});

console.log('\nwhich devices supplied an id:');

test('holders lists the devices whose vault holds the id', () => {
    assert.deepStrictEqual(deviceVault.holders('157000001'), ['999']);
    assert.deepStrictEqual(deviceVault.holders('4666000'), ['77831']);
    assert.deepStrictEqual(deviceVault.holders('157000063'), []);
    assert.deepStrictEqual(deviceVault.holders('../x'), []);
});

fs.rmSync(tmp, { recursive: true, force: true });
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
