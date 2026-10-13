#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// One CLI for running and testing the server. Run from the server root:
//
//   node tools/dev.js up [--no-client] [--no-debuglog] [--reset n]
//   node tools/dev.js down
//   node tools/dev.js status
//   node tools/dev.js account list
//   node tools/dev.js account id      <name>
//   node tools/dev.js account reset   <name> [--fresh | --from <label>] [--force]
//   node tools/dev.js account snapshot <name> [--as <label>]
//   node tools/dev.js account delete  <name> [--force]
//   node tools/dev.js smoke
//
// `up` starts the server detached, waits until port 8443 actually answers, then
// starts the DebugLog viewer BEFORE the client (the client broadcasts its
// narration once; a viewer started later misses it).
//
// While the server runs, its in-memory state is authoritative and UserData/*.json
// is stale until a save - so reset/snapshot/list go through the server's loopback
// /dev/account/* endpoints when it is up, and only touch files when it is down.
//
// Account ids are derived from the username (see accounts.js), so every command
// here takes a NAME - you never need to type 2072745562.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const http = require('http');
const { spawn, spawnSync, execSync } = require('child_process');
const accounts = require('../accounts');

const ROOT = path.resolve(__dirname, '..');
const HOST = '127.0.0.1';
const PORT = 8443;

const die = msg => { console.error(`error: ${msg}`); process.exit(1); };
const flag = (args, k) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : null; };
const has = (args, k) => args.includes(k);

// --- http helpers ---------------------------------------------------------------

function request(method, urlPath, body) {
    return new Promise((resolve, reject) => {
        const payload = body === undefined ? null : JSON.stringify(body);
        const headers = payload ? { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(payload) } : {};
        const req = http.request({ host: HOST, port: PORT, method, path: urlPath, headers, timeout: 5000 }, res => {
            const chunks = [];
            res.on('data', c => chunks.push(c));
            res.on('end', () => {
                const text = Buffer.concat(chunks).toString();
                let json = null;
                try { json = JSON.parse(text); } catch { /* not json */ }
                resolve({ status: res.statusCode, text, json });
            });
        });
        req.on('timeout', () => req.destroy(new Error('timeout')));
        req.on('error', reject);
        req.end(payload);
    });
}

async function serverUp() {
    try {
        const r = await request('GET', '/device/device-manifest.xml');
        return r.status === 200;
    } catch { return false; }
}

// POST a dev endpoint. Returns the parsed body, or null after printing a concise
// reason. A 404 means the running server predates these routes - say so plainly
// instead of dumping Express's HTML error page.
async function dev(urlPath, body, { quiet = false } = {}) {
    const r = await request('POST', urlPath, body || {});
    if (r.status === 200) return r.json;
    if (r.status === 404) {
        if (!quiet) console.error(`the running server has no ${urlPath} - it predates these dev routes.\n` +
            '  restart it:  node tools/dev.js down   (then)   node tools/dev.js up');
        return null;
    }
    if (!quiet) console.error(r.json ? `error: ${r.json.error || JSON.stringify(r.json)}` : `HTTP ${r.status}`);
    process.exitCode = 1;
    return null;
}

// --- process helpers ------------------------------------------------------------

function isRunning(image) {
    try {
        const out = execSync(`tasklist /FI "IMAGENAME eq ${image}" /NH`, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] });
        return out.toLowerCase().includes(image.toLowerCase());
    } catch { return false; }
}

// Detect the scope WITHOUT relying on deviceid.bbb: the client's Associate "+"
// deletes it, so keying off it goes blind exactly when a device is broken and we
// most need to notice. s1/ and g1/ are folders, which that wipe leaves behind.
function nanoscopeDrive() {
    for (const letter of 'DEFGHIJK') {
        const root = `${letter}:\\`;
        try {
            if (!fs.existsSync(root)) continue;
            if (fs.existsSync(path.join(root, 'deviceid.bbb'))) return { root, wiped: false };
            if (fs.existsSync(path.join(root, 's1')) || fs.existsSync(path.join(root, 'g1'))) return { root, wiped: true };
        } catch { /* ignore */ }
    }
    return null;
}

const sleep = ms => new Promise(r => setTimeout(r, ms));

// Start a long-lived process that must outlive this CLI WITHOUT inheriting our handles.
//
// child_process.spawn() on Windows enables handle inheritance, so even with the
// child's stdio sent to a file it still receives a copy of OUR stdout pipe. When that
// pipe feeds `| tail`, `| cat` or a tool capturing output, the reader waits for EOF
// until the child exits - so `dev up | tail` hung for as long as the server ran.
// Start-Process goes through ShellExecute, which does not inherit handles.
// Measured 2026-10-13 with a 12s detached child: `| cat` took 13s with spawn() (and
// with `cmd /c start`), 1s with this.
//
// `args` is ONE pre-quoted command-line string. Returns true when launched through
// PowerShell; on failure it falls back to a plain detached spawn (which works, but
// leaks the pipe, so piped output will not return until the child exits).
function launchDetached({ file, args = '', cwd, hidden = false }) {
    const ps = [
        '$a = @{ FilePath = $env:DEV_FILE; WorkingDirectory = $env:DEV_CWD }',
        "if ($env:DEV_ARGS) { $a.ArgumentList = $env:DEV_ARGS }",
        "if ($env:DEV_HIDDEN -eq '1') { $a.WindowStyle = 'Hidden' }",
        'Start-Process @a',
    ].join('; ');
    const r = spawnSync('powershell.exe', ['-NoProfile', '-NonInteractive', '-Command', ps], {
        env: { ...process.env, DEV_FILE: file, DEV_ARGS: args, DEV_CWD: cwd, DEV_HIDDEN: hidden ? '1' : '0' },
        stdio: 'ignore', windowsHide: true,
    });
    if (!r.error && r.status === 0) return true;
    spawn(file, args ? [args] : [], { cwd, detached: true, stdio: 'ignore', windowsVerbatimArguments: true }).unref();
    console.warn('(PowerShell launch failed - fell back to spawn; piped output will not return until the server stops)');
    return false;
}

// --- up / down / status ----------------------------------------------------------

async function cmdUp(args) {
    if (await serverUp()) {
        console.log('server already running on ' + PORT);
    } else {
        const log = path.join(ROOT, 'server.log');
        fs.writeFileSync(log, ''); // fresh log each run, like run-server.bat
        // cmd does the redirect so stdout AND stderr land in one file, like run-server.bat.
        // (Not a spawn() with a file fd - see launchDetached for why.)
        const cmdline = `/d /s /c ""${process.execPath}" NanoServ.js >> "${log}" 2>&1"`;
        launchDetached({ file: process.env.ComSpec || 'cmd.exe', args: cmdline, cwd: ROOT, hidden: true });
        process.stdout.write('starting server');
        const deadline = Date.now() + 30000;
        let ready = false;
        while (Date.now() < deadline) {
            await sleep(400);
            process.stdout.write('.');
            if (await serverUp()) { ready = true; break; }
        }
        console.log(ready ? ' ready' : ' TIMED OUT');
        if (!ready) die(`server did not answer on ${PORT} within 30s - check server.log`);
    }

    const resetName = flag(args, '--reset');
    if (resetName) await cmdAccount(['reset', resetName, ...(has(args, '--force') ? ['--force'] : [])]);

    if (!has(args, '--no-debuglog')) {
        if (isRunning('flashplayer_32_sa.exe')) console.log('debuglog viewer already open');
        else {
            launchDetached({ file: path.join(ROOT, 'flashplayer_32_sa.exe'),
                args: `"${path.join(ROOT, 'DebugLog.swf')}"`, cwd: ROOT });
            console.log('debuglog viewer started');
            await sleep(1200); // it must be listening before the client narrates
        }
    }
    if (!has(args, '--no-client')) {
        if (isRunning('Nanovor.exe')) console.log('client already running');
        else {
            const dir = path.join(ROOT, 'Nanovor');
            launchDetached({ file: path.join(dir, 'Nanovor.exe'), cwd: dir });
            console.log('client started');
        }
    }
    console.log(`\nlog: ${path.join(ROOT, 'server.log')}`);
    console.log(`test account: 'n' (any password)   stop with: node tools/dev.js down`);
    // Backstop: nothing here should keep the CLI alive, but never let a stray handle do it.
    process.exit(process.exitCode || 0);
}

async function cmdDown() {
    if (!(await serverUp())) return console.log('server is not running');
    const r = await dev('/dev/shutdown');
    if (r) console.log(`stopping - saved ${r.accountsSaved} account(s)`);
    for (let i = 0; i < 20; i++) { await sleep(250); if (!(await serverUp())) return console.log('server stopped'); }
    console.log('server still answering - check server.log');
}

async function cmdStatus() {
    const up = await serverUp();
    console.log(`server    : ${up ? `UP on ${PORT}` : 'down'}`);
    console.log(`client    : ${isRunning('Nanovor.exe') ? 'running' : 'not running'}`);
    console.log(`debuglog  : ${isRunning('flashplayer_32_sa.exe') ? 'open' : 'closed'}`);
    const drive = nanoscopeDrive();
    if (!drive) console.log('nanoscope : not connected');
    else if (drive.wiped) console.log(`nanoscope : ${drive.root} connected but NO deviceid.bbb - looks WIPED. ` +
        `run: node tools/nanoscope-cli.js preflight ${drive.root.slice(0, 2)}`);
    else {
        const elog = fs.existsSync(path.join(drive.root, 'elog.txt'));
        console.log(`nanoscope : connected at ${drive.root}${elog ? '  *** elog.txt PRESENT - the client would wipe it; delete first ***' : ''}`);
        console.log(`            check before opening the client: node tools/nanoscope-cli.js preflight ${drive.root.slice(0, 2)}`);
    }
    console.log('');
    await cmdAccount(['list']);
}

// --- accounts ---------------------------------------------------------------------

function listAccountsFromDisk() {
    const dir = accounts.userDataDir(ROOT);
    if (!fs.existsSync(dir)) return [];
    return fs.readdirSync(dir).filter(f => f.endsWith('.json')).map(f => f.replace(/\.json$/, ''));
}

async function cmdAccount(args) {
    const [sub, name, ...rest] = args;
    const up = await serverUp();

    if (sub === 'id') {
        if (!name) die('usage: account id <name>');
        return console.log(accounts.generateAccountId(name));
    }

    if (sub === 'list' || !sub) {
        const r = up ? await dev('/dev/account/list') : null;
        if (r) {
            for (const a of r.accounts) {
                const tag = a.protected ? 'protected' : 'test';
                const loaded = a.loaded ? `nanovor ${a.nanovor}  nanocash ${a.nanocash}  jolts s${a.jolts.speed}/t${a.jolts.strength}/a${a.jolts.armor}/h${a.jolts.health}` : '(not loaded)';
                console.log(`  ${a.username.padEnd(26)} ${a.accountId.padEnd(11)} ${tag.padEnd(10)} ${loaded}`);
            }
            return;
        }
        console.log(up ? '  (falling back to UserData/ - may be stale while the server runs)'
            : '  (server down - reading UserData/)');
        for (const n of listAccountsFromDisk()) {
            console.log(`  ${n.padEnd(26)} ${accounts.generateAccountId(n).padEnd(11)} ${accounts.isTestAccount(n) ? 'test' : 'protected'}`);
        }
        return;
    }

    if (!name) die(`usage: account ${sub} <name>`);
    const guarded = !accounts.isTestAccount(name) && !has(rest, '--force');

    if (sub === 'snapshot') {
        const label = flag(rest, '--as') || new Date().toISOString().replace(/[:.]/g, '-');
        if (up) {
            const r = await dev('/dev/account/snapshot', { username: name, label });
            if (r) console.log(`snapshot '${r.label}' -> ${r.path}${r.flushed ? ' (flushed live state)' : ''}`);
            return;
        }
        const src = accounts.userFile(ROOT, name);
        if (!fs.existsSync(src)) die(`no save file for '${name}'`);
        const dest = accounts.snapshotFile(ROOT, name, label);
        fs.mkdirSync(path.dirname(dest), { recursive: true });
        fs.copyFileSync(src, dest);
        return console.log(`snapshot '${label}' -> ${path.relative(ROOT, dest)}`);
    }

    if (sub === 'reset') {
        if (guarded) die(`'${name}' is a protected account - pass --force to reset it (test accounts: ${accounts.TEST_ACCOUNTS.join(', ')})`);
        const mode = has(rest, '--fresh') ? 'fresh' : (flag(rest, '--from') ? 'snapshot' : 'baseline');
        const label = flag(rest, '--from');
        if (up) {
            const r = await dev('/dev/account/reset', { username: name, mode, label, force: has(rest, '--force') });
            if (r) console.log(`reset '${name}' from ${r.reset}${r.label ? ` '${r.label}'` : ''} - re-login in the client to see it`);
            return;
        }
        const src = mode === 'fresh'
            ? die('--fresh needs the server running (it reuses the new-user path)')
            : mode === 'snapshot' ? accounts.snapshotFile(ROOT, name, label) : accounts.baselineFile(ROOT, name);
        if (!fs.existsSync(src)) die(`not found: ${path.relative(ROOT, src)}`);
        fs.mkdirSync(accounts.userDataDir(ROOT), { recursive: true });
        fs.copyFileSync(src, accounts.userFile(ROOT, name));
        return console.log(`reset '${name}' from ${path.relative(ROOT, src)} (server was down)`);
    }

    if (sub === 'delete') {
        if (guarded) die(`'${name}' is a protected account - pass --force to delete it`);
        if (up) die('stop the server first (it would re-save this account on shutdown): node tools/dev.js down');
        const f = accounts.userFile(ROOT, name);
        if (!fs.existsSync(f)) die(`no save file for '${name}'`);
        fs.unlinkSync(f);
        return console.log(`deleted ${path.relative(ROOT, f)}`);
    }

    die(`unknown account command '${sub}'`);
}

// --- smoke ------------------------------------------------------------------------

async function cmdSmoke() {
    const offline = ['test-nanoscope.js', 'test-vinfo-policy.js', 'test-scope-copies.js', 'test-battle-engine.js', 'sig-kat.js'];
    const online = ['test-nanoscope-server.js', 'test-battle-server.js', 'test-jolt.js'];
    const up = await serverUp();
    const results = [];

    const run = (script, extra = []) => {
        const file = path.join(__dirname, script);
        if (!fs.existsSync(file)) return results.push([script, 'MISSING']);
        process.stdout.write(`  ${script.padEnd(28)} `);
        try {
            execSync(`"${process.execPath}" "${file}" ${extra.join(' ')}`, { cwd: ROOT, stdio: ['ignore', 'pipe', 'pipe'] });
            console.log('pass'); results.push([script, 'pass']);
        } catch (e) {
            console.log('FAIL'); results.push([script, 'FAIL']);
            const tail = String(e.stdout || '').trim().split('\n').slice(-6).join('\n');
            if (tail) console.log(tail.split('\n').map(l => '      ' + l).join('\n'));
        }
    };

    console.log('offline:');
    for (const s of offline) run(s);
    console.log(up ? 'server-dependent:' : 'server-dependent: SKIPPED (server down)');
    if (up) for (const s of online) run(s, s === 'test-nanoscope-server.js' ? ['--account-name', 'smoke-selftest'] : []);

    const failed = results.filter(r => r[1] === 'FAIL').length;
    console.log(`\n${results.filter(r => r[1] === 'pass').length} passed, ${failed} failed` +
        (up ? '' : `, ${online.length} skipped`));
    if (failed) process.exitCode = 1;
}

// --- main -------------------------------------------------------------------------

(async () => {
    const [cmd, ...rest] = process.argv.slice(2);
    const commands = {
        up: cmdUp, down: cmdDown, status: cmdStatus,
        account: cmdAccount, smoke: cmdSmoke,
    };
    if (!commands[cmd]) {
        const lines = fs.readFileSync(__filename, 'utf8').split(/\r?\n/);
        const rules = lines.reduce((acc, l, i) => (/^\/\/ -{10,}/.test(l) ? acc.concat(i) : acc), []);
        console.log(lines.slice(rules[0] + 1, rules[1]).map(l => l.replace(/^\/\/ ?/, '')).join('\n'));
        process.exit(cmd ? 1 : 0);
    }
    try { await commands[cmd](rest); } catch (err) { die(err.message); }
})();
