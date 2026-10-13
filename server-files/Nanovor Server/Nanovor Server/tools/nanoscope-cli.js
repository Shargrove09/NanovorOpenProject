#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Nanoscope command-line tool. Run from the server root:
//
//   node tools/nanoscope-cli.js backup  E:            copy every file off the device
//   node tools/nanoscope-cli.js backup  E: --raw      ...plus a raw disk image (admin)
//   node tools/nanoscope-cli.js inspect E:            decode what's on a device/backup
//   node tools/nanoscope-cli.js preflight E: --account <id|name>
//                                                     IS THIS DEVICE SAFE FOR THE CLIENT?
//   node tools/nanoscope-cli.js verify  <backup> E:   compare a backup with a device
//   node tools/nanoscope-cli.js import  <backup> --account <id>
//                                                     register device + import nanovor
//                                                     (server must be running)
//   node tools/nanoscope-cli.js adopt   --account <id> (--all | --types a,b | --assets id,id)
//                                                     mint corpus nanovor into the account
//   node tools/nanoscope-cli.js transferable --account <id> [--device <deviceId>]
//                                                     which nanovor can go on a scope
//   node tools/nanoscope-cli.js standins --account <id>   dump the stand-in ledger
//   node tools/nanoscope-cli.js consolidate --account <id> [--remove id,id] [--root E:] [--yes]
//                                                     one entry per nanovor (dry run unless --yes)
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

// `bootstrap` is for recovering a WIPED device: the client's Associate "+" deletes
// every root file including deviceid.bbb, so the usual "is this a Nanoscope?" check
// would refuse exactly when restore is needed most. With bootstrap we accept a drive
// that has no deviceid.bbb, as long as it still looks like a Nanoscope volume.
function driveRoot(arg, { bootstrap = false } = {}) {
    if (!arg) die('missing drive (e.g. E:)');
    const m = /^([A-Za-z]):?\\?$/.exec(arg);
    const root = m ? `${m[1].toUpperCase()}:\\` : path.resolve(arg);
    if (!fs.existsSync(root)) die(`${root} not found - is the Nanoscope plugged in (and switched on)?`);
    if (!fs.existsSync(path.join(root, 'deviceid.bbb'))) {
        if (!bootstrap) die(`${root} has no deviceid.bbb - not a Nanoscope (if it was wiped, use: restore <backup> ${arg} --bootstrap)`);
        // Refuse anything that is obviously not the scope - restoring onto the wrong
        // drive would scatter 85 MiB of game files across it.
        const looksLikeScope = ['s1', 'g1'].some(d => fs.existsSync(path.join(root, d)));
        if (!looksLikeScope) die(`${root} has no deviceid.bbb and no s1/ or g1/ - refusing to treat it as a wiped Nanoscope`);
        console.log(`WARNING: ${root} has no deviceid.bbb - treating it as a WIPED Nanoscope (--bootstrap)`);
    }
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

// --- preflight -------------------------------------------------------------------
//
// Run this BEFORE letting the client near a device. On 2026-10-13 the 1.381 unit
// was associated via the client's "+" while it had never been imported: the "+"
// wipes v1..v10 and every root file first, then the sync asks the server for a
// signed plyinfo it does not have (404) and the device is left unbootable.
//
// A device is only safe for the client once we hold a signed plyinfo AND its
// vinfos - that is what `import` captures.
// Backups usable as "the latest good state". A backup taken AFTER a bad transfer (kept
// as evidence) is excluded by putting a DO-NOT-RESTORE.txt inside it.
function goodBackups(backupDir) {
    if (!fs.existsSync(backupDir)) return [];
    return fs.readdirSync(backupDir).filter(d =>
        fs.existsSync(path.join(backupDir, d, 'backup.json')) &&
        !fs.existsSync(path.join(backupDir, d, 'DO-NOT-RESTORE.txt')));
}

// v-slots holding a sprite or sound but no vinfo.bbb. `root` is a drive or a backup's files/.
function orphanedSlots(root) {
    const out = [];
    for (let slot = 1; slot <= ns.MAX_DEVICE_NANOVOR; slot++) {
        const dir = path.join(root, `v${slot}`);
        if (!fs.existsSync(dir)) continue;
        const hasVinfo = fs.existsSync(path.join(dir, 'vinfo.bbb'));
        const hasMedia = fs.existsSync(path.join(dir, 'spr.v2z')) || fs.existsSync(path.join(dir, 'nano.snd'));
        if (!hasVinfo && hasMedia) out.push(`v${slot}`);
    }
    return out;
}

// Look an account up by accountId OR username. Reading UserData/ is reliable for
// this even while the server runs, because device registration is persisted the
// moment it changes (both /dev/nanoscope/import and /device/associate save).
function findAccount(idOrName) {
    const dir = path.join(SERVER_ROOT, 'UserData');
    if (!fs.existsSync(dir)) return null;
    for (const f of fs.readdirSync(dir).filter(x => x.endsWith('.json'))) {
        let u;
        try { u = JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8')); } catch { continue; }
        if (String(u.id) === String(idOrName) || String(u.username) === String(idOrName)) return u;
    }
    return null;
}

function cmdPreflight(args) {
    // A wiped device has no deviceid.bbb, which is exactly when we most need to
    // look at it - so resolve the drive leniently here.
    const raw = args[0];
    if (!raw) die('usage: preflight E:');
    const m = /^([A-Za-z]):?\\?$/.exec(raw);
    const root = m ? `${m[1].toUpperCase()}:\\` : path.resolve(raw);
    if (!fs.existsSync(root)) die(`${root} not found - is the Nanoscope plugged in?`);

    const problems = [], warnings = [];
    const hasDeviceId = fs.existsSync(path.join(root, 'deviceid.bbb'));
    console.log(`drive        : ${root}`);

    if (!hasDeviceId) {
        console.log('deviceid.bbb : MISSING - this device looks WIPED');
        problems.push(`restore it first:  node tools/nanoscope-cli.js restore <backup> ${raw} --bootstrap --yes`);
    }

    // The firmware writes elog.txt when it fails to boot. If the client sees it,
    // DeviceErrorLogCheckChainLoadee deletes EVERY file on the device and forces
    // a firmware push - far worse than the original fault.
    if (fs.existsSync(path.join(root, 'elog.txt'))) {
        let lastError = '';
        try {
            lastError = fs.readFileSync(path.join(root, 'elog.txt'), 'utf8')
                .split(/\r?\n/).filter(l => l.startsWith('#')).slice(-1)[0] || '';
        } catch { /* unreadable */ }
        console.log(`elog.txt     : PRESENT${lastError ? `  (last error: ${lastError.replace(/^#\s*/, '')})` : ''}`);
        problems.push('the device wrote an error log - read it, then delete E:\\elog.txt BEFORE opening the client ' +
            '(it makes the client wipe the whole device and push firmware).' +
            (/SEC_Verify/.test(lastError) ? ' SEC_Verify* means the firmware rejected a signed file - check for slots with no vinfo.' : ''));
    }

    let deviceId = null;
    if (hasDeviceId) {
        const snap = ns.readDeviceRoot(root);
        deviceId = snap.device.deviceId;
        console.log(`device       : ${deviceId}  firmware field ${snap.device.firmware}`);
        console.log(`nanovor      : ${snap.nanovor.length} slot(s)`);

        const vault = new ns.DeviceVault(path.join(SERVER_ROOT, 'DeviceVault'));
        const hasPly = Boolean(vault.getPlyinfo(deviceId));
        // "Covered" = the device supplied it (vault) OR it is a The List file, which the
        // server may also send, so it can go back on without being in this device's vault.
        const corpusVault = new ns.CorpusVault(path.join(SERVER_ROOT, 'Corpus'));
        const vaulted = snap.nanovor.filter(n =>
            vault.getVinfo(deviceId, n.parsed.assetId) || corpusVault.isTrusted(n.parsed.assetId)).length;
        console.log(`imported     : plyinfo ${hasPly ? 'YES' : 'NO'}, vinfos ${vaulted}/${snap.nanovor.length}`);
        if (!hasPly) problems.push(`device ${deviceId} is NOT imported - run:  node tools/nanoscope-cli.js import ${raw} --account <id>`);
        else if (vaulted < snap.nanovor.length) warnings.push(`${snap.nanovor.length - vaulted} nanovor have no vaulted vinfo - re-run import or they cannot go back on`);

        const backupDir = path.join(BACKUPS_ROOT, deviceId);
        const stamps = goodBackups(backupDir);
        console.log(`backups      : ${stamps.length}${stamps.length ? ` (latest ${stamps.sort().pop()})` : ''}`);
        if (!stamps.length) problems.push(`no backup for ${deviceId} - run:  node tools/nanoscope-cli.js backup ${raw}`);

        // The client byte-compares ITS Sensei cartridge (Nanovor/Assets/device/s1/game.bin)
        // with the device's s1/game.bin on every sync. If they differ it deletes the device's
        // s1/ and writes its own - and the firmware rejects a cartridge it doesn't own: it
        // deletes game.bin, logs SEC_VerifySystem: FAILED, and solo training greys out
        // (2026-10-13; the client held bbe576d1..., the 1.381 unit's own is e7e134c5...).
        // So the two must match BEFORE the client is allowed near the device.
        const clientGame = path.join(SERVER_ROOT, 'Nanovor', 'Assets', 'device', 's1', 'game.bin');
        const deviceGame = path.join(root, 's1', 'game.bin');
        if (fs.existsSync(clientGame)) {
            if (!fs.existsSync(deviceGame)) {
                problems.push('the device has no s1/game.bin (the firmware deletes a cartridge it rejects). Restore s1/ from a good backup:  node tools/nanoscope-cli.js restore <backup> ' + raw + ' --only s1 --yes');
            } else if (!fs.readFileSync(clientGame).equals(fs.readFileSync(deviceGame))) {
                const h = f => require('crypto').createHash('sha256').update(fs.readFileSync(f)).digest('hex').slice(0, 8);
                console.log(`sensei card  : client ${h(clientGame)} != device ${h(deviceGame)}`);
                problems.push(`the client's Sensei cartridge (${clientGame}) differs from the device's. On its next sync the client will wipe the device's s1/ and write its own, which the firmware rejects (SEC_VerifySystem, solo training greyed out). Make the client's Nanovor/Assets/device/s1 match the device's first`);
            } else {
                console.log('sensei card  : client and device cartridges match');
            }
        }

        // A slot with a sprite/sound but NO vinfo.bbb is the fingerprint of the firmware
        // rejecting a vinfo: it deletes the file it won't accept and leaves the rest, then
        // fails SEC_VerifySystem and the handheld stops booting (2026-10-13). Compare with
        // the latest good backup, because a slot that was already like that is a quirk of
        // this unit (v7 on the 1.381 unit has always been), not new damage.
        const orphaned = orphanedSlots(root);
        if (orphaned.length) {
            const latest = stamps.length ? path.join(backupDir, [...stamps].sort().pop(), 'files') : null;
            const before = latest ? new Set(orphanedSlots(latest)) : new Set();
            const fresh = orphaned.filter(x => !before.has(x));
            const old = orphaned.filter(x => before.has(x));
            if (old.length) console.log(`note         : ${old.join(', ')} hold a sprite but no vinfo.bbb - already so in the latest good backup, a quirk of this unit rather than new damage`);
            if (fresh.length) problems.push(`${fresh.join(', ')} hold a sprite but NO vinfo.bbb, and the latest good backup had them intact - the firmware deletes a vinfo it rejects. Restore from that backup before the handheld next boots`);
        }

        // Registration is PER ACCOUNT while the vault is per device. A device can be
        // fully imported (vault populated) and still be unregistered for the account
        // you are about to log in as - and then the client shows the Associate "+"
        // prompt, which wipes the device. So this must be checked per account.
        const i = args.indexOf('--account');
        const account = i >= 0 ? args[i + 1] : null;
        if (!account) {
            warnings.push('no --account given, so per-account registration was NOT checked. ' +
                `If the account you log in as has not registered this device, the client will show the "+" prompt and WIPE it. ` +
                `Re-run as:  node tools/nanoscope-cli.js preflight ${raw} --account <id|name>`);
        } else {
            const acct = findAccount(account);
            if (!acct) {
                console.log(`account      : '${account}' NOT FOUND in UserData/`);
                problems.push(`no account '${account}' - log in once as that user, then:  node tools/nanoscope-cli.js import ${raw} --account <id>`);
            } else {
                const registered = (acct.devices || []).some(d => ns.normalizeDeviceId(d.deviceId) === ns.normalizeDeviceId(deviceId));
                console.log(`account      : ${acct.username} (${acct.id}) - device ${registered ? 'REGISTERED' : 'NOT registered'}`);
                if (!registered) {
                    problems.push(`account '${acct.username}' has NOT registered device ${deviceId} - the client will show the Associate "+" prompt and WIPE the device.\n` +
                        `      run first:  node tools/nanoscope-cli.js import ${raw} --account ${acct.id}`);
                }
            }
        }
    }

    console.log('');
    for (const w of warnings) console.log(`WARNING: ${w}`);
    if (problems.length) {
        console.log('NOT SAFE for the client:');
        for (const p of problems) console.log(`  - ${p}`);
        process.exitCode = 2;
    } else if (warnings.length) {
        // Never claim a clean bill of health for a check we did not actually run.
        console.log('PARTIALLY SAFE: device-level checks pass, but see the warning above before opening the client.');
        process.exitCode = 1;
    } else {
        console.log('SAFE: backed up, imported, and registered to that account - the client can sync this device.');
    }
}

// --- adopt ---------------------------------------------------------------------
//
// Mint corpus nanovor into an account (server must be running). Pick one:
//   adopt --account <id> --all
//   adopt --account <id> --types 24,27          (all tiers of those types)
//   adopt --account <id> --assets 157091847,... (specific corpus assetIds)
function cmdAdopt(args) {
    const flag = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
    const account = flag('--account');
    if (!account) die('--account <accountId> is required');
    const payload = { account };
    if (args.includes('--all')) payload.all = true;
    else if (flag('--types')) payload.types = flag('--types').split(',').map(s => Number(s.trim()));
    else if (flag('--assets')) payload.assetIds = flag('--assets').split(',').map(s => s.trim());
    else die('specify one of --all | --types a,b | --assets id,id');

    const body = JSON.stringify(payload);
    const req = http.request({
        host: '127.0.0.1', port: 8443, method: 'POST', path: '/dev/nanoscope/adopt',
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

// --- transferable / standins ---------------------------------------------------
//
// transferable --account <id> [--device <deviceId>]   which nanovor can go on a scope
// standins     --account <id>                          dump the stand-in ledger
function postDev(path, payload) {
    const body = JSON.stringify(payload);
    const req = http.request({
        host: '127.0.0.1', port: 8443, method: 'POST', path,
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

function cmdTransferable(args) {
    const flag = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
    const account = flag('--account');
    if (!account) die('--account <accountId> is required');
    postDev('/dev/nanoscope/transferable', { account, deviceId: flag('--device') || undefined });
}

// consolidate --account <id> [--remove id,id] [--root E:] [--yes]
// Collapse the duplicate entries the scope tooling made into one entry per nanovor. A DRY RUN
// unless --yes. --root E: lets the server refuse to remove anything that is on the scope now.
function cmdConsolidate(args) {
    const flag = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
    const account = flag('--account');
    if (!account) die('--account <accountId> is required');
    const rootArg = flag('--root');
    postDev('/dev/nanoscope/consolidate', {
        account,
        remove: (flag('--remove') || '').split(',').map(s => s.trim()).filter(Boolean),
        root: rootArg ? driveRoot(rootArg) : undefined,
        apply: args.includes('--yes'),
    });
    if (!args.includes('--yes')) console.error('(dry run - add --yes to apply)');
}

function cmdStandins(args) {
    const flag = k => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
    const account = flag('--account');
    if (!account) die('--account <accountId> is required');
    postDev('/dev/nanoscope/standins', { account });
}

// --- restore -------------------------------------------------------------------

function cmdRestore(args) {
    const backupDir = args[0];
    const manifestFile = path.join(backupDir || '', 'backup.json');
    if (!fs.existsSync(manifestFile)) die(`${manifestFile} not found`);
    const marker = path.join(backupDir, 'DO-NOT-RESTORE.txt');
    if (fs.existsSync(marker) && !args.includes('--force')) {
        die(`${backupDir} is marked DO-NOT-RESTORE:\n${fs.readFileSync(marker, 'utf8')}\n(pass --force only if you really mean it)`);
    }
    const bootstrap = args.includes('--bootstrap');
    const root = driveRoot(args[1], { bootstrap });
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
    // A wiped device has no deviceid.bbb to compare against - the restore is what
    // puts its identity back. Skip the check, having already confirmed in driveRoot
    // that the drive still looks like a Nanoscope.
    if (bootstrap) {
        console.log(`--bootstrap: skipping device-id check; restoring identity of device ${backup.device.deviceId}`);
    } else {
        const live = ns.readDeviceRoot(root).device.deviceId;
        if (live !== backup.device.deviceId) die(`backup is of device ${backup.device.deviceId} but ${root} is device ${live}`);
    }

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
        // Only create the folder when it is actually missing: mkdirSync on a drive
        // root ("E:\") throws EPERM on Windows even with recursive, which is exactly
        // what a root-level file like deviceid.bbb needs.
        const dstDir = path.dirname(dst);
        if (!fs.existsSync(dstDir)) fs.mkdirSync(dstDir, { recursive: true });
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
const commands = { backup: cmdBackup, inspect: cmdInspect, preflight: cmdPreflight, verify: cmdVerify, import: cmdImport, adopt: cmdAdopt, transferable: cmdTransferable, consolidate: cmdConsolidate, standins: cmdStandins, restore: cmdRestore };
if (!commands[cmd]) {
    // Usage = the header comment between the first two // ---- rules.
    const lines = fs.readFileSync(__filename, 'utf8').split(/\r?\n/);
    const rules = lines.reduce((acc, l, i) => (/^\/\/ -{10,}/.test(l) ? acc.concat(i) : acc), []);
    console.log(lines.slice(rules[0] + 1, rules[1]).map(l => l.replace(/^\/\/ ?/, '')).join('\n'));
    process.exit(cmd ? 1 : 0);
}
commands[cmd](rest);
