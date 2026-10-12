#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Signature research, step 2: a known-answer-test (KAT) corpus + oracle.
//
// Loads every REAL signed vinfo/plyinfo file we hold (samples.json only keeps
// payload *hashes*, so we read the files themselves) and exposes:
//   loadVectors()        -> [{src,kind,name,payload:Buffer,sig:Buffer,file}]
//   check(signFn [,vecs])-> {total, matched, firstFail}
// A candidate signFn(payloadBuffer) is correct iff it reproduces sig for a vector.
//
// Run directly for a corpus summary:  node tools/sig-kat.js
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const ns = require('../nanoscope');

const SERVER_ROOT = path.resolve(__dirname, '..');
const REPO_ROOT = path.resolve(SERVER_ROOT, '..', '..', '..');
const SIG = ns.VINFO_SIZE - 16; // 4178 payload split point for vinfo

function walk(dir, out = []) {
    if (!fs.existsSync(dir)) return out;
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
        if (e.name.toLowerCase() === 'system volume information') continue;
        const p = path.join(dir, e.name);
        if (e.isDirectory()) walk(p, out);
        else if (e.isFile() && !e.name.startsWith('._')) out.push(p);
    }
    return out;
}

// Directories that may contain real vinfo.bbb / plyinfo.bbb files.
const SOURCES = [
    ['the-list', path.join(REPO_ROOT, '_Project Nanoscope Manager', 'Project Nanoscope Manager', 'nanovor')],
    ['fw-update', path.join(REPO_ROOT, 'firmware', 'update')],
    ['butlerhm', path.join(REPO_ROOT, 'firmware', 'community', 'butlerhm', 'FW')],
    ['backups', path.join(SERVER_ROOT, 'device-backups')],
    ['vault', path.join(SERVER_ROOT, 'DeviceVault')],
    ['client-s1', path.join(SERVER_ROOT, 'Manifests', 'device', 's1')],
];

function loadVectors() {
    const seen = new Set();
    const vecs = [];
    for (const [src, root] of SOURCES) {
        for (const f of walk(root)) {
            const base = path.basename(f).toLowerCase();
            const buf = fs.readFileSync(f);
            let kind, payload, sig, name = '';
            if (/vinfo\.bbb$/.test(base) && buf.length === ns.VINFO_SIZE) {
                kind = /[\/]s1[\/]swarm[\/]/.test(f) ? 'vinfo-sensei' : 'vinfo';
                payload = buf.subarray(0, SIG);
                sig = buf.subarray(SIG);
                try { name = ns.parseVinfo(buf).name; } catch {}
            } else if (/^plyinfo\.bbb$/.test(base) && buf.length > 16) {
                kind = 'plyinfo';
                payload = buf.subarray(0, buf.length - 16);
                sig = buf.subarray(buf.length - 16);
                try { name = ns.parsePlyinfo(buf).username; } catch {}
            } else continue;
            const digest = crypto.createHash('sha256').update(buf).digest('hex');
            if (seen.has(digest)) continue;
            seen.add(digest);
            vecs.push({ src, kind, name, payload, sig, file: path.relative(REPO_ROOT, f) });
        }
    }
    return vecs;
}

// signFn(payloadBuffer) -> Buffer|string(hex). Returns how many vectors match.
function check(signFn, vectors) {
    const vecs = vectors || loadVectors();
    let matched = 0, firstFail = null;
    for (const v of vecs) {
        let out;
        try { out = signFn(v.payload, v); } catch (e) { out = null; }
        if (!out) { if (!firstFail) firstFail = v; continue; }
        const got = Buffer.isBuffer(out) ? out : Buffer.from(out, 'hex');
        if (got.length === 16 && got.equals(v.sig)) matched++;
        else if (!firstFail) firstFail = v;
    }
    return { total: vecs.length, matched, firstFail };
}

module.exports = { loadVectors, check, SIG };

if (require.main === module) {
    const vecs = loadVectors();
    const byKind = {};
    for (const v of vecs) (byKind[v.kind] = byKind[v.kind] || []).push(v);
    console.log(`KAT corpus: ${vecs.length} unique signed files`);
    for (const [k, l] of Object.entries(byKind)) {
        const bySrc = {};
        for (const v of l) bySrc[v.src] = (bySrc[v.src] || 0) + 1;
        console.log(`  ${k.padEnd(13)} ${String(l.length).padStart(3)}   ${Object.entries(bySrc).map(([s, n]) => s + ':' + n).join(' ')}`);
    }
    // Deterministic? same payload -> same sig anywhere
    const byPay = new Map();
    for (const v of vecs.filter(x => x.kind.startsWith('vinfo'))) {
        const k = v.payload.toString('hex');
        if (!byPay.has(k)) byPay.set(k, new Set());
        byPay.get(k).add(v.sig.toString('hex'));
    }
    const nondet = [...byPay.values()].filter(s => s.size > 1).length;
    console.log(`\nvinfo payloads with >1 signature (non-deterministic): ${nondet}`);
}
