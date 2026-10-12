#!/usr/bin/env node
'use strict';
// Phase 0 battery: try obvious MAC schemes x obvious keys against the KAT corpus.
// Any scheme/key that reproduces even one real 16-byte signature is a hit worth chasing.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const kat = require('./sig-kat');

const SERVER_ROOT = path.resolve(__dirname, '..');
const REPO_ROOT = path.resolve(SERVER_ROOT, '..', '..', '..');
const rd = p => { try { return fs.readFileSync(p); } catch { return null; } };

const privkey = rd(path.join(REPO_ROOT, 'firmware', 'update', 'privkey.bbb')) || Buffer.alloc(0);
const frm = rd(path.join(REPO_ROOT, 'firmware', 'update', 'FRM.BBB')) || Buffer.alloc(0);

// ---- candidate keys -------------------------------------------------------
const keys = {};
keys['zero16'] = Buffer.alloc(16);
keys['zero32'] = Buffer.alloc(32);
keys['ff16'] = Buffer.alloc(16, 0xff);
if (privkey.length >= 160) {
    keys['privkey[0:16]'] = privkey.subarray(0, 16);
    keys['privkey[16:32]id'] = privkey.subarray(16, 32);
    keys['privkey[32:48]'] = privkey.subarray(32, 48);
    keys['privkey[32:64]'] = privkey.subarray(32, 64);
    keys['privkey[0:32]'] = privkey.subarray(0, 32);
    keys['privkey[144:160]'] = privkey.subarray(144, 160);
}
if (frm.length >= 32) {
    keys['frm[0:16]'] = frm.subarray(0, 16);
    keys['frm[0:32]'] = frm.subarray(0, 32);
}
for (const s of ['NANOVOR', 'NANOSCOPE', 'nanovor', 'nanoscope', 'Smith&Tinker', 'virmon', 'VIRMON', 'SmithTinker']) {
    const b = Buffer.alloc(16); Buffer.from(s).copy(b); keys['ascii:' + s + '/16'] = b;
    keys['ascii:' + s] = Buffer.from(s);
}
keys['deviceid999'] = Buffer.from('0000000000000999');

// ---- AES-CMAC (RFC 4493, 128-bit) ----------------------------------------
function leftShift(buf) {
    const out = Buffer.alloc(buf.length); let carry = 0;
    for (let i = buf.length - 1; i >= 0; i--) { const b = buf[i]; out[i] = ((b << 1) | carry) & 0xff; carry = (b >> 7) & 1; }
    return out;
}
function cmacSubkeys(key) {
    const Rb = Buffer.alloc(16); Rb[15] = 0x87;
    const c = crypto.createCipheriv('aes-128-ecb', key, Buffer.alloc(0)); c.setAutoPadding(false);
    const L = Buffer.concat([c.update(Buffer.alloc(16)), c.final()]);
    let K1 = leftShift(L); if (L[0] & 0x80) for (let i = 0; i < 16; i++) K1[i] ^= Rb[i];
    let K2 = leftShift(K1); if (K1[0] & 0x80) for (let i = 0; i < 16; i++) K2[i] ^= Rb[i];
    return { K1, K2 };
}
function aesCmac(key, msg) {
    if (key.length !== 16) return null;
    const { K1, K2 } = cmacSubkeys(key);
    const n = Math.ceil(msg.length / 16) || 1;
    let last;
    if (msg.length && msg.length % 16 === 0) { last = Buffer.from(msg.subarray((n - 1) * 16)); for (let i = 0; i < 16; i++) last[i] ^= K1[i]; }
    else { const rem = msg.subarray((n - 1) * 16); const p = Buffer.alloc(16); rem.copy(p); p[rem.length] = 0x80; last = p; for (let i = 0; i < 16; i++) last[i] ^= K2[i]; }
    let X = Buffer.alloc(16);
    const c = crypto.createCipheriv('aes-128-ecb', key, Buffer.alloc(0)); c.setAutoPadding(false);
    for (let i = 0; i < n - 1; i++) { const blk = msg.subarray(i * 16, i * 16 + 16); const y = Buffer.alloc(16); for (let j = 0; j < 16; j++) y[j] = X[j] ^ blk[j]; X = c.update(y); }
    const y = Buffer.alloc(16); for (let j = 0; j < 16; j++) y[j] = X[j] ^ last[j];
    return Buffer.concat([c.update(y), c.final()]).subarray(0, 16);
}
function aesCbcMac(key, msg) {
    if (key.length !== 16) return null;
    const pad = (16 - (msg.length % 16)) % 16; const m = pad ? Buffer.concat([msg, Buffer.alloc(pad)]) : msg;
    const c = crypto.createCipheriv('aes-128-cbc', key, Buffer.alloc(16)); c.setAutoPadding(false);
    const out = Buffer.concat([c.update(m), c.final()]); return out.subarray(out.length - 16);
}

// ---- scheme families ------------------------------------------------------
function schemes(key) {
    const s = {};
    // unkeyed (only add once, under a null key)
    s['md5(p)'] = p => crypto.createHash('md5').update(p).digest();
    s['sha1(p)[:16]'] = p => crypto.createHash('sha1').update(p).digest().subarray(0, 16);
    s['sha256(p)[:16]'] = p => crypto.createHash('sha256').update(p).digest().subarray(0, 16);
    // keyed prefix/suffix MD5
    s['md5(k|p)'] = p => crypto.createHash('md5').update(key).update(p).digest();
    s['md5(p|k)'] = p => crypto.createHash('md5').update(p).update(key).digest();
    s['md5(k|p|k)'] = p => crypto.createHash('md5').update(key).update(p).update(key).digest();
    s['sha1(k|p)[:16]'] = p => crypto.createHash('sha1').update(key).update(p).digest().subarray(0, 16);
    s['sha1(p|k)[:16]'] = p => crypto.createHash('sha1').update(p).update(key).digest().subarray(0, 16);
    s['sha256(k|p)[:16]'] = p => crypto.createHash('sha256').update(key).update(p).digest().subarray(0, 16);
    // HMAC
    s['hmac-md5'] = p => crypto.createHmac('md5', key).update(p).digest();
    s['hmac-sha1[:16]'] = p => crypto.createHmac('sha1', key).update(p).digest().subarray(0, 16);
    s['hmac-sha256[:16]'] = p => crypto.createHmac('sha256', key).update(p).digest().subarray(0, 16);
    // AES
    s['aes-cmac'] = p => aesCmac(key, p);
    s['aes-cbcmac'] = p => aesCbcMac(key, p);
    return s;
}

const vecs = kat.loadVectors();
const vinfo = vecs.filter(v => v.kind.startsWith('vinfo'));
console.log(`battery over ${vinfo.length} vinfo vectors`);

const results = [];
// unkeyed first
for (const [name, fn] of Object.entries(schemes(Buffer.alloc(16)))) {
    if (!/\(p\)/.test(name)) continue;
    const r = kat.check(fn, vinfo); if (r.matched) results.push([`${name}`, r.matched]);
}
for (const [kn, key] of Object.entries(keys)) {
    for (const [name, fn] of Object.entries(schemes(key))) {
        if (/\(p\)/.test(name)) continue; // unkeyed already done
        const r = kat.check(fn, vinfo);
        if (r.matched) results.push([`${name}  key=${kn}`, r.matched]);
    }
}
if (results.length) {
    console.log('\n*** HITS ***');
    for (const [n, m] of results.sort((a, b) => b[1] - a[1])) console.log(`  ${m}/${vinfo.length}  ${n}`);
} else {
    console.log('\nno hits: none of the obvious scheme/key combos reproduced any signature.');
}
