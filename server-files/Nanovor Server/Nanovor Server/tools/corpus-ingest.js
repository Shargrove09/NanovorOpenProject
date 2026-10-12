#!/usr/bin/env node
'use strict';

// ---------------------------------------------------------------------------
// Ingest every validly-signed vinfo we hold into the shared corpus, and harvest
// each one's sprite/sound so the device transfer won't 404.
//
//   node tools/corpus-ingest.js [--dry]
//
// Sources (read-only): The List (Project Nanoscope Manager), the 1.381 update
// package, the butlerhm FW dumps, and local device backups. Because the vinfo
// MAC key is global, any of these can later be replayed onto any device.
//
// Writes (unless --dry):
//   Corpus/vinfo/<assetId>.bbb                         (the signed blob)
//   Manifests/device/Characters/<typeId>/{spr.v2z,nano.snd,manifest.xml}
// Neither is ever overwritten once present.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const ns = require('../nanoscope');

const SERVER_ROOT = path.resolve(__dirname, '..');
const REPO_ROOT = path.resolve(SERVER_ROOT, '..', '..', '..');
const CORPUS_ROOT = path.join(SERVER_ROOT, 'Corpus');
const CHARACTERS_DIR = path.join(SERVER_ROOT, 'Manifests', 'device', 'Characters');
const DRY = process.argv.includes('--dry');

const SOURCES = [
    path.join(REPO_ROOT, '_Project Nanoscope Manager', 'Project Nanoscope Manager', 'nanovor'),
    path.join(REPO_ROOT, 'firmware', 'update'),
    path.join(REPO_ROOT, 'firmware', 'community', 'butlerhm', 'FW'),
    path.join(SERVER_ROOT, 'device-backups'),
];

function walkVinfoDirs(dir, out = []) {
    if (!fs.existsSync(dir)) return out;
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
        if (e.name.toLowerCase() === 'system volume information') continue;
        const p = path.join(dir, e.name);
        if (e.isDirectory()) walkVinfoDirs(p, out);
        else if (e.isFile() && /^vinfo\.bbb$/i.test(e.name)) out.push(dir); // the folder holding it
    }
    return out;
}

const corpus = new ns.CorpusVault(CORPUS_ROOT);
const seen = new Set();
let ingested = 0, dupVinfo = 0, bad = 0, sprAdded = 0, sprPresent = 0, sprIncomplete = 0;
const typesCovered = new Set();
const problems = [];

for (const src of SOURCES) {
    for (const dir of walkVinfoDirs(src)) {
        const file = path.join(dir, 'vinfo.bbb');
        let buf;
        try { buf = fs.readFileSync(file); } catch { continue; }
        if (buf.length !== ns.VINFO_SIZE) { bad++; continue; }
        let parsed;
        try { parsed = ns.parseVinfo(buf); } catch (e) { bad++; problems.push(`${path.relative(REPO_ROOT, file)}: ${e.message}`); continue; }
        const type = parsed.assetTypeId;
        typesCovered.add(type);

        // ingest the blob (keyed by embedded assetId)
        if (corpus.has(parsed.assetId)) dupVinfo++;
        else if (!DRY) { corpus.ingestVinfo(buf); ingested++; }
        else ingested++;
        seen.add(parsed.assetId);

        // harvest sprite/sound for this TYPE (shared, never overwritten)
        if (!DRY) {
            const r = ns.harvestCharacterAssets(dir, type, CHARACTERS_DIR);
            if (r === 'added') sprAdded++; else if (r === 'present') sprPresent++; else sprIncomplete++;
        }
    }
}

console.log(`corpus-ingest${DRY ? ' (DRY RUN)' : ''}`);
console.log(`  signed vinfos ingested: ${ingested}  (already present: ${dupVinfo}, bad/other: ${bad})`);
console.log(`  distinct assetIds in corpus now: ${DRY ? seen.size + ' (dry)' : corpus.listAssetIds().length}`);
console.log(`  distinct TYPE ids covered: ${typesCovered.size}`);
if (!DRY) console.log(`  character assets: ${sprAdded} added, ${sprPresent} present, ${sprIncomplete} incomplete`);

// coverage vs 123 master types
try {
    const xml = fs.readFileSync(path.join(SERVER_ROOT, 'virmon-master-decoded.xml'), 'utf8');
    const all = [...new Set([...xml.matchAll(/<asset-type-id>(\d+)<\/asset-type-id>/g)].map(m => +m[1]))];
    const missing = all.filter(t => !typesCovered.has(t)).sort((a, b) => a - b);
    console.log(`  master coverage: ${all.length - missing.length}/${all.length}  (missing: ${missing.join(',')})`);
} catch { /* ignore */ }

if (problems.length) { console.log('\nproblems:'); for (const p of problems.slice(0, 20)) console.log('  ' + p); }
