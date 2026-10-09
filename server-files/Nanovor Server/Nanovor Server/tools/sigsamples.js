#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Signature research, step 1: inventory every signed Nanoscope file we have.
//
//   node tools/sigsamples.js [--out <file>]
//
// Sources (all read-only):
//   <repo>/firmware/update/                        the user's 1.381 update package
//   <repo>/firmware/community/butlerhm/FW/*/*/     community dumps of other units
//   device-backups/<id>/<stamp>/files/             backups of the user's Nanoscope
//   DeviceVault/<id>/uploads/                      device-written files uploaded by the client
//   Manifests/device/s1/                           the client's sensei cartridge
//
// Each "unit" is one folder tree (one device at one point in time). Files are
// grouped by payload so we can see whether the same data carries the same
// signature everywhere (global key / deterministic nonce) or not.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const ns = require('../nanoscope');

const SERVER_ROOT = path.resolve(__dirname, '..');
const REPO_ROOT = path.resolve(SERVER_ROOT, '..', '..', '..');
const FIRMWARE = path.join(REPO_ROOT, 'firmware');

const args = process.argv.slice(2);
const outIdx = args.indexOf('--out');
const OUT = outIdx >= 0 ? args[outIdx + 1] : path.join(FIRMWARE, 'analysis', 'samples.json');

const sha = b => crypto.createHash('sha256').update(b).digest('hex').slice(0, 16);
const hex = (b, s, e) => b.subarray(s, e).toString('hex');

function walk(dir) {
    const out = [];
    if (!fs.existsSync(dir)) return out;
    for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
        const p = path.join(dir, ent.name);
        if (ent.isDirectory()) {
            if (ent.name.toLowerCase() === 'system volume information') continue;
            out.push(...walk(p));
        } else if (ent.isFile() && !ent.name.startsWith('._')) {
            out.push(p);
        }
    }
    return out;
}

// Which device a unit's files belong to: from its deviceid.bbb when present.
function unitDeviceId(root) {
    for (const name of ['deviceid.bbb', 'deviceid.bbb.org']) {
        const f = path.join(root, name);
        if (!fs.existsSync(f)) continue;
        const b = fs.readFileSync(f);
        if (b.length === 62) {
            try { return ns.parseDeviceId(b).deviceId; } catch { /* fall through */ }
        }
        return `unparsed(${name}, ${b.length} bytes)`;
    }
    const pk = path.join(root, 'privkey.bbb');
    if (fs.existsSync(pk)) return `privkey:${fs.readFileSync(pk).subarray(16, 32).toString('latin1')}`;
    return null;
}

function units() {
    const list = [];
    const add = (label, root) => { if (fs.existsSync(root)) list.push({ label, root, deviceId: unitDeviceId(root) }); };

    add('update-1.381 (user)', path.join(FIRMWARE, 'update'));
    const fw = path.join(FIRMWARE, 'community', 'butlerhm', 'FW');
    if (fs.existsSync(fw)) {
        for (const ver of fs.readdirSync(fw)) {
            for (const stamp of fs.readdirSync(path.join(fw, ver))) add(`butlerhm ${ver}/${stamp}`, path.join(fw, ver, stamp));
        }
    }
    const backups = path.join(SERVER_ROOT, 'device-backups');
    if (fs.existsSync(backups)) {
        for (const id of fs.readdirSync(backups)) {
            for (const stamp of fs.readdirSync(path.join(backups, id))) add(`backup ${id}/${stamp}`, path.join(backups, id, stamp, 'files'));
        }
    }
    const vault = path.join(SERVER_ROOT, 'DeviceVault');
    if (fs.existsSync(vault)) {
        for (const id of fs.readdirSync(vault)) {
            const u = path.join(vault, id, 'uploads');
            if (fs.existsSync(u)) list.push({ label: `uploads ${id}`, root: u, deviceId: id });
        }
    }
    add('client s1', path.join(SERVER_ROOT, 'Manifests', 'device'));
    return list;
}

function classify(file, buf) {
    const name = path.basename(file).toLowerCase();
    const rel = file.split(path.sep).join('/');
    if (/vinfo\.bbb$/.test(name) && buf.length === ns.VINFO_SIZE) {
        const v = ns.parseVinfo(buf);
        return {
            kind: /\/s1\/swarm\//.test(rel) ? 'vinfo-sensei' : 'vinfo',
            payload: sha(buf.subarray(0, buf.length - 16)),
            trailer: hex(buf, buf.length - 16, buf.length),
            assetId: v.assetId, assetTypeId: v.assetTypeId, name: v.name,
        };
    }
    if (/^plyinfo\.bbb$/.test(name)) {
        return { kind: 'plyinfo', size: buf.length, payload: sha(buf.subarray(0, buf.length - 16)), trailer: hex(buf, buf.length - 16, buf.length),
            user: ns.parsePlyinfo(buf).username };
    }
    // Device-written: [tag 8][nonce 8][kind u16][session u16] ...
    if (/^(deviceid\.bbb(\.org)?|jolts.*\.bbb)$/.test(name) || /^jolts-[0-9a-f]+\.bbb$/.test(name)) {
        return { kind: name.startsWith('jolts') ? 'jolts' : 'deviceid', size: buf.length,
            tag: hex(buf, 0, 8), nonce: hex(buf, 8, 16), fileKind: buf.length >= 18 ? buf.readUInt16LE(16) : null,
            session: buf.length >= 20 ? buf.readUInt16LE(18) : null, payload: sha(buf.subarray(16)) };
    }
    if (/^(clog\.bbb|clog-[0-9a-f]+\.bbb)$/.test(name)) return { kind: 'clog', size: buf.length, head: hex(buf, 0, 16), payload: sha(buf) };
    if (name === 'manifest.bbb') return { kind: 'manifest', size: buf.length, head: hex(buf, 0, 16), payload: sha(buf.subarray(16)) };
    if (name === 'privkey.bbb') return { kind: 'privkey', size: buf.length, head: hex(buf, 0, 16), id: buf.subarray(16, 32).toString('latin1'), payload: sha(buf.subarray(16)) };
    if (name === 'frm.bbb') return { kind: 'firmware', size: buf.length, head: hex(buf, 0, 16), payload: sha(buf.subarray(16)) };
    return null;
}

const samples = [];
for (const u of units()) {
    for (const file of walk(u.root)) {
        if (!/\.bbb(\.org)?$/i.test(file)) continue;
        const buf = fs.readFileSync(file);
        const c = classify(file, buf);
        if (!c) continue;
        samples.push({ unit: u.label, deviceId: u.deviceId, file: path.relative(REPO_ROOT, file).split(path.sep).join('/'), ...c });
    }
}

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, JSON.stringify(samples, null, 1));

// --- summary -------------------------------------------------------------------
const byKind = {};
for (const s of samples) (byKind[s.kind] = byKind[s.kind] || []).push(s);
console.log(`${samples.length} signed samples from ${new Set(samples.map(s => s.unit)).size} units -> ${path.relative(REPO_ROOT, OUT)}`);
for (const [k, list] of Object.entries(byKind)) console.log(`  ${k.padEnd(13)} ${list.length}`);

console.log('\nunits:');
for (const u of [...new Set(samples.map(s => `${s.unit}  [device ${s.deviceId}]`))]) console.log(`  ${u}`);

// Same payload, different signature? (vinfo + sensei + plyinfo)
console.log('\npayloads seen in more than one unit:');
const groups = new Map();
for (const s of samples.filter(x => /^(vinfo|plyinfo)/.test(x.kind))) {
    const key = `${s.kind}:${s.payload}`;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(s);
}
let shown = 0;
for (const [key, list] of groups) {
    const unitsSeen = new Set(list.map(s => s.unit));
    if (unitsSeen.size < 2) continue;
    const trailers = new Set(list.map(s => s.trailer));
    const devices = new Set(list.map(s => s.deviceId));
    shown++;
    console.log(`  ${key.padEnd(30)} ${(list[0].name || list[0].user || '').padEnd(18)} units ${unitsSeen.size}  devices ${devices.size}  distinct signatures ${trailers.size}`);
    if (trailers.size > 1) {
        for (const t of trailers) console.log(`      ${t}  <- ${[...new Set(list.filter(s => s.trailer === t).map(s => `${s.unit}[${s.deviceId}]`))].join(', ')}`);
    }
}
if (!shown) console.log('  (none)');

// Same asset on different devices with different data?
console.log('\nassets appearing with different payloads:');
const byAsset = new Map();
for (const s of samples.filter(x => x.kind === 'vinfo')) {
    if (!byAsset.has(s.assetId)) byAsset.set(s.assetId, []);
    byAsset.get(s.assetId).push(s);
}
let diff = 0;
for (const [asset, list] of byAsset) {
    const payloads = new Set(list.map(s => s.payload));
    if (payloads.size < 2) continue;
    diff++;
    console.log(`  asset ${asset} ${list[0].name}: ${payloads.size} payloads over ${new Set(list.map(s => s.deviceId)).size} device(s)`);
}
if (!diff) console.log('  (none)');

console.log('\ndevice-written headers:');
for (const s of samples.filter(x => x.kind === 'deviceid' || x.kind === 'jolts')) {
    console.log(`  ${s.kind.padEnd(8)} ${String(s.deviceId).padEnd(18)} session ${String(s.session).padStart(3)}  tag ${s.tag}  nonce ${s.nonce}  ${s.unit}`);
}
