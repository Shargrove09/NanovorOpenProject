#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Nanoscope command-line tool. Run from the server root:
//
//   node tools/nanoscope-cli.js backup  E:            copy every file off the device
//   node tools/nanoscope-cli.js backup  E: --raw      ...plus a raw disk image (admin)
//   node tools/nanoscope-cli.js inspect E:            decode what's on a device/backup
//   node tools/nanoscope-cli.js verify  <backup> E:   compare a backup with a device
//   node tools/nanoscope-cli.js import  <backup> --account <id>
//                                                     register device + import nanovor
//                                                     (server must be running)
//   node tools/nanoscope-cli.js restore <backup> E: --only v1,v5 [--yes]
//                                                     write files back (dry run without --yes);
//                                                     --only v5 --as v8 restores into another slot
//
// Close the Nanovor client first: it syncs a registered Nanoscope by itself the
// moment it's plugged in. backup warns if the client is running; restore refuses
// (override with --force).
//
// <backup> is a folder made by `backup` (the one holding backup.json). backup,
// inspect and verify never write to the device; restore is the only command
// that does, and only with --yes.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { execFileSync } = require('child_process');
const http = require('http');
const ns = require('../nanoscope');

const SERVER_ROOT = path.resolve(__dirname, '..');
const BACKUPS_ROOT = path.join(SERVER_ROOT, 'device-backups');

// Windows' own per-volume bookkeeping, recreated on every mount. Not device data.
const SKIP_DIRS = new Set(['system volume information']);

function die(msg) {
    console.error(`error: ${msg}`);
    process.exit(1);
}

function driveRoot(arg) {
    if (!arg) die('missing drive (e.g. E:)');
    const m = /^([A-Za-z]):?\\?$/.exec(arg);
    const root = m ? `${m[1].toUpperCase()}:\\` : path.resolve(arg);
    if (!fs.existsSync(root)) die(`${root} not found - is the Nanoscope plugged in (and switched on)?`);
    if (!fs.existsSync(path.join(root, 'deviceid.bbb'))) die(`${root} has no deviceid.bbb - not a Nanoscope`);
    return root;
}

// The client syncs on its own as soon as a registered Nanoscope is plugged in
// (deleting and rewriting s1, jolts, plyinfo...). Reading during that gives a
// half-written backup; writing during it races the client.
function isClientRunning() {
    try {
        const out = execFileSync('tasklist', ['/FI', 'IMAGENAME eq Nanovor.exe', '/NH'], { encoding: 'utf8' });
        return /Nanovor\.exe/i.test(out);
    } catch {
        return false;
    }
}

function guardAgainstClient(args, { writes }) {
    if (!isClientRunning()) return;
    const msg = 'the Nanovor client is running - it syncs the Nanoscope by itself while connected';
    if (writes && !args.includes('--force')) die(`${msg}. Close it first (or pass --force).`);
    console.warn(`warning: ${msg}; results may catch it mid-sync.`);
}

function sha256(buf) {
    return crypto.createHash('sha256').update(buf).digest('hex');
}

function walk(root, rel = '') {
    const out = [];
    for (const ent of fs.readdirSync(path.join(root, rel), { withFileTypes: true })) {
        const r = rel ? path.join(rel, ent.name) : ent.name;
        if (ent.isDirectory()) {
            if (!rel && SKIP_DIRS.has(ent.name.toLowerCase())) continue;
            out.push(...walk(root, r));
        } else if (ent.isFile()) {
            out.push(r);
        }
    }
    return out;
}

// File attributes matter on this device (deviceid.bbb and jolts.bbb are Hidden+System,
// and the client deletes with `del /aa`). Node can't read them, so ask attrib.
function readAttributes(root) {
    const attrs = {};
    let text = '';
    try {
        text = execFileSync('cmd.exe', ['/c', 'attrib', '/s', path.join(root, '*')], { encoding: 'utf8' });
    } catch (err) {
        console.warn(`warning: could not read attributes (${err.message.split('\n')[0]})`);
        return attrs;
    }
    for (const line of text.split(/\r?\n/)) {
        // "A  SH        E:\deviceid.bbb" - flags occupy the first columns, then the path.
        const m = /^(.{1,20}?)\s+([A-Za-z]:\\.*)$/.exec(line);
        if (!m) continue;
        const rel = path.relative(root, m[2]);
        attrs[rel.toLowerCase()] = m[1].replace(/\s+/g, '');
    }
    return attrs;
}

function timestamp() {
    return new Date().toISOString().replace(/:/g, '-').replace(/\.\d+Z$/, '');
}

// --- backup --------------------------------------------------------------------

function cmdBackup(args) {
    const root = driveRoot(args[0]);
    guardAgainstClient(args, { writes: false });
    const raw = args.includes('--raw');
    const snapshot = ns.readDeviceRoot(root);
    const deviceId = snapshot.device.deviceId;

    const dest = path.join(BACKUPS_ROOT, deviceId, timestamp());
    const filesDir = path.join(dest, 'files');
    fs.mkdirSync(filesDir, { recursive: true });

    const attrs = readAttributes(root);
    const files = [];
    for (const rel of walk(root)) {
        const src = path.join(root, rel);
        const buf = fs.readFileSync(src);
        const out = path.join(filesDir, rel);
        fs.mkdirSync(path.dirname(out), { recursive: true });
        fs.writeFileSync(out, buf);
        const st = fs.statSync(src);
        fs.utimesSync(out, st.atime, st.mtime);
        const hash = sha256(buf);
        if (sha256(fs.readFileSync(out)) !== hash) die(`copy of ${rel} does not match the device`);
        files.push({ path: rel, size: buf.length, sha256: hash, mtime: st.mtime.toISOString(), attributes: attrs[rel.toLowerCase()] || '' });
    }

    fs.writeFileSync(path.join(dest, 'SHA256SUMS'), files.map(f => `${f.sha256}  ${f.path.replace(/\\/g, '/')}`).join('\n') + '\n');
    fs.writeFileSync(path.join(dest, 'backup.json'), JSON.stringify({
        createdAt: new Date().toISOString(),
        sourceRoot: root,
        device: snapshot.device,
        nanovor: snapshot.nanovor.map(n => ({ slot: n.slot, ...n.parsed, hasSprite: n.hasSprite, hasSound: n.hasSound })),
        files,
    }, null, 2));

    const total = files.reduce((s, f) => s + f.size, 0);
    console.log(`backed up ${files.length} files (${(total / 1048576).toFixed(1)} MiB) from ${root}`);
    console.log(`device ${deviceId}, firmware field ${snapshot.device.firmware}, ${snapshot.nanovor.length} nanovor`);
    console.log(`-> ${dest}`);

    if (raw) rawImage(dest);
}

// Whole-disk image. Free clusters can still hold files the device consumed and
// deleted (FRM.BBB, manifest.bbb, privkey*.bbb), so this is worth keeping.
// Needs an elevated prompt; reading never writes to the device.
function rawImage(dest) {
    let diskNumber;
    try {
        diskNumber = execFileSync('powershell.exe', ['-NoProfile', '-Command',
            "(Get-Disk | Where-Object { $_.FriendlyName -match 'Nanoscope' } | Select-Object -First 1).Number"],
        { encoding: 'utf8' }).trim();
    } catch (err) {
        return console.warn(`raw image skipped: could not locate the disk (${err.message.split('\n')[0]})`);
    }
    if (!/^\d+$/.test(diskNumber)) return console.warn('raw image skipped: no disk named *Nanoscope* found');

    const device = `\\\\.\\PhysicalDrive${diskNumber}`;
    let fd;
    try {
        fd = fs.openSync(device, 'r');
    } catch (err) {
        return console.warn(`raw image skipped: cannot open ${device} (${err.code}). Re-run from an elevated (Administrator) prompt.`);
    }
    const out = fs.openSync(path.join(dest, 'disk.img'), 'w');
    const hash = crypto.createHash('sha256');
    const chunk = Buffer.alloc(1024 * 1024); // multiple of the 512-byte sector
    let total = 0;
    for (;;) {
        let n;
        try {
            n = fs.readSync(fd, chunk, 0, chunk.length, null);
        } catch (err) {
            if (total > 0) break; // end of device reports as an error on some drivers
            throw err;
        }
        if (n <= 0) break;
        fs.writeSync(out, chunk, 0, n);
        hash.update(chunk.subarray(0, n));
        total += n;
    }
    fs.closeSync(fd);
    fs.closeSync(out);
    fs.writeFileSync(path.join(dest, 'disk.img.sha256'), `${hash.digest('hex')}  disk.img\n`);
    console.log(`raw image: ${total} bytes from ${device} -> disk.img`);
}

// --- inspect -------------------------------------------------------------------

function cmdInspect(args) {
    const root = resolveRoot(args[0]);
    const s = ns.readDeviceRoot(root);
    const d = s.device;
    console.log(`device ${d.deviceId}  firmware field ${d.firmware}  session ${d.session}  nonce ${d.nonce}`);
    for (const j of s.jolts) {
        console.log(`${j.file}: speed ${j.speed}  strength ${j.strength}  armor ${j.armor}  health ${j.health}  (session ${j.session})`);
    }
    if (s.plyinfoParsed) console.log(`plyinfo: user "${s.plyinfoParsed.username}"  belt "${s.plyinfoParsed.beltName}"`);
    const vault = new ns.DeviceVault(path.join(SERVER_ROOT, 'DeviceVault'));
    for (const n of s.nanovor) {
        const p = n.parsed;
        const missing = [!n.hasSprite && 'spr.v2z', !n.hasSound && 'nano.snd'].filter(Boolean);
        console.log(`v${n.slot}: ${p.name.padEnd(18)} type ${String(p.assetTypeId).padStart(3)}  asset ${p.assetId}  ${p.faction.padEnd(10)} ` +
            `SV ${p.sv}  spd ${p.speed} str ${p.strength} arm ${p.armor} hp ${p.health}  tag ${p.tag}` +
            (missing.length ? `  MISSING ${missing.join(', ')}` : ''));
        console.log(`      ${slotHealth(n, vault, d.deviceId)}`);
    }
}

// Is a slot exactly what the server would write? vinfo vs the vault, sprite and
// sound vs the served Characters/<type>/ files.
function slotHealth(n, vault, deviceId) {
    const notes = [];
    const vaulted = vault.getVinfo(deviceId, n.parsed.assetId);
    notes.push(!vaulted ? 'vinfo: not in vault' : vaulted.equals(n.vinfo) ? 'vinfo: matches vault' : 'vinfo: DIFFERS from vault');
    const chars = path.join(SERVER_ROOT, 'Manifests', 'device', 'Characters', String(n.parsed.assetTypeId));
    for (const f of ['spr.v2z', 'nano.snd']) {
        const onDevice = path.join(n.dir, f);
        const served = path.join(chars, f);
        if (!fs.existsSync(onDevice)) continue;
        if (!fs.existsSync(served)) notes.push(`${f}: server has none`);
        else notes.push(`${f}: ${sha256(fs.readFileSync(onDevice)) === sha256(fs.readFileSync(served)) ? 'matches server' : 'DIFFERS from server'}`);
    }
    return notes.join(' | ');
}

// A backup folder (holding backup.json) or a drive/root folder.
function resolveRoot(arg) {
    if (arg && fs.existsSync(path.join(arg, 'backup.json'))) return path.join(arg, 'files');
    if (arg && fs.existsSync(path.join(arg, 'deviceid.bbb'))) return path.resolve(arg);
    return driveRoot(arg);
}

// --- verify --------------------------------------------------------------------

function cmdVerify(args) {
    const backupDir = args[0];
    const manifestFile = path.join(backupDir || '', 'backup.json');
    if (!fs.existsSync(manifestFile)) die(`${manifestFile} not found`);
    const root = driveRoot(args[1]);
    const { files } = JSON.parse(fs.readFileSync(manifestFile, 'utf8'));

    const onDevice = new Set(walk(root).map(r => r.toLowerCase()));
    let same = 0;
    const changed = [], missing = [];
    for (const f of files) {
        const p = path.join(root, f.path);
        onDevice.delete(f.path.toLowerCase());
        if (!fs.existsSync(p)) { missing.push(f.path); continue; }
        if (sha256(fs.readFileSync(p)) === f.sha256) same++; else changed.push(f.path);
    }
    const extra = [...onDevice];
    console.log(`identical ${same}, changed ${changed.length}, missing ${missing.length}, new ${extra.length}`);
    for (const p of changed) console.log(`  changed  ${p}`);
    for (const p of missing) console.log(`  missing  ${p}`);
    for (const p of extra) console.log(`  new      ${p}`);
    process.exitCode = changed.length || missing.length || extra.length ? 2 : 0;
}

// --- import (via the running server) ---------------------------------------------

function cmdImport(args) {
    const root = resolveRoot(args[0]);
    const i = args.indexOf('--account');
    const account = i >= 0 ? args[i + 1] : null;
    if (!account) die('--account <accountId> is required');

    const body = JSON.stringify({ account, root });
    const req = http.request({
        host: '127.0.0.1', port: 8443, method: 'POST', path: '/dev/nanoscope/import',
        headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(body) },
    }, res => {
        let text = '';
        res.on('data', c => { text += c; });
        res.on('end', () => {
            console.log(`HTTP ${res.statusCode}`);
            try { console.log(JSON.stringify(JSON.parse(text), null, 2)); } catch { console.log(text); }
            if (res.statusCode !== 200) process.exitCode = 1;
        });
    });
    req.on('error', err => die(`could not reach the server on 127.0.0.1:8443 (${err.code}) - is run-server.bat running?`));
    req.end(body);
}

// --- restore -------------------------------------------------------------------

function cmdRestore(args) {
    const backupDir = args[0];
    const manifestFile = path.join(backupDir || '', 'backup.json');
    if (!fs.existsSync(manifestFile)) die(`${manifestFile} not found`);
    const root = driveRoot(args[1]);
    const i = args.indexOf('--only');
    const only = i >= 0 ? new Set(String(args[i + 1] || '').toLowerCase().split(',').filter(Boolean)) : null;
    const commit = args.includes('--yes');

    // --as puts a single slot back under another name, e.g. --only v5 --as v8 when a
    // transfer has since reused v5.
    const j = args.indexOf('--as');
    const renameTo = j >= 0 ? String(args[j + 1] || '') : null;
    if (renameTo !== null && (!only || only.size !== 1 || !/^v([1-9]|10)$/i.test(renameTo))) {
        die('--as needs exactly one --only slot and a target v1..v10');
    }

    if (commit) guardAgainstClient(args, { writes: true });

    const backup = JSON.parse(fs.readFileSync(manifestFile, 'utf8'));
    const live = ns.readDeviceRoot(root).device.deviceId;
    if (live !== backup.device.deviceId) die(`backup is of device ${backup.device.deviceId} but ${root} is device ${live}`);

    // --only matches the first path component: v1, s1, g3, plyinfo.bbb ...
    const picked = backup.files.filter(f => !only || only.has(f.path.split(/[\\/]/)[0].toLowerCase()));
    if (!picked.length) die('nothing selected');

    console.log(`${commit ? 'restoring' : 'would restore'} ${picked.length} file(s) to ${root}:`);
    for (const f of picked) {
        const target = renameTo ? f.path.replace(/^[^\\/]+/, renameTo.toLowerCase()) : f.path;
        const dst = path.join(root, target);
        const cur = fs.existsSync(dst) ? sha256(fs.readFileSync(dst)) : null;
        const status = cur === f.sha256 ? 'same' : cur ? 'differs' : 'missing';
        console.log(`  ${status.padEnd(8)} ${target}${target !== f.path ? `  (from ${f.path})` : ''}${f.attributes ? `  [${f.attributes}]` : ''}`);
        if (!commit || status === 'same') continue;

        // Clear H/S/R first so the write isn't refused, then put the original attributes back.
        if (cur) execFileSync('cmd.exe', ['/c', 'attrib', '-h', '-s', '-r', dst]);
        fs.mkdirSync(path.dirname(dst), { recursive: true });
        fs.writeFileSync(dst, fs.readFileSync(path.join(backupDir, 'files', f.path)));
        fs.utimesSync(dst, new Date(f.mtime), new Date(f.mtime));
        const flags = f.attributes.replace(/[^HSR]/gi, '').toLowerCase().split('').map(c => `+${c}`);
        if (flags.length) execFileSync('cmd.exe', ['/c', 'attrib', ...flags, dst]);
        if (sha256(fs.readFileSync(dst)) !== f.sha256) die(`write verification failed for ${f.path}`);
    }
    if (!commit) console.log('dry run - add --yes to write to the device');
}

// --- main ------------------------------------------------------------------------

const [cmd, ...rest] = process.argv.slice(2);
const commands = { backup: cmdBackup, inspect: cmdInspect, verify: cmdVerify, import: cmdImport, restore: cmdRestore };
if (!commands[cmd]) {
    // Usage = the header comment between the first two // ---- rules.
    const lines = fs.readFileSync(__filename, 'utf8').split(/\r?\n/);
    const rules = lines.reduce((acc, l, i) => (/^\/\/ -{10,}/.test(l) ? acc.concat(i) : acc), []);
    console.log(lines.slice(rules[0] + 1, rules[1]).map(l => l.replace(/^\/\/ ?/, '')).join('\n'));
    process.exit(cmd ? 1 : 0);
}
commands[cmd](rest);
