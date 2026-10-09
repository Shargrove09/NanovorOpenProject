'use strict';

// ---------------------------------------------------------------------------
// Evolution graph reconstruction
//
// The client loads the evolution graph over HTTP at login:
//   GameEngine.as:163 -> new EvoDataLoader(bankURLRead + "/bankfe/resources/evolution?auth=...")
//
// That data lived ONLY on the original Smith & Tinker server. It is in none of
// the shipped client files - virmon-master.xml (123 records, decrypted) contains
// zero source-type-id / destination-type-id / recipe-slot elements.
//
// Serving an empty <evolution-list/> is not a harmless stub. It cascades:
//   EvoManager.init()                 -> _evolutions = []
//   generateNanovorIdsInEachTree()    -> empty per-tree arrays
//   TreeViewMenu.buildTreeData()      -> createNanovorTypeById(undefined) -> null
//   TreeTile.setTileData()            -> tileData.nanovor.faction  -> TypeError #1009
// and because TreeViewMenu has DEBUG_SHOW_LOGGING = false, it dies silently,
// blanking both the COLLECTION and EVOLVE screens.
//
// So we reconstruct the graph from data we do have:
//   * collector-id is prefixed with the tree id ("14-Hyper Ripper 1.0" -> tree 14).
//     Verified across all 123 records: prefixes are exactly 1-12 and 14-25, which
//     matches evolution-trees.xml's 24 trees including the absent id 13.
//   * the trailing "<major>.<minor>" in the name gives chain order within a family,
//     with multiple entries at one major version forming a branch
//     (e.g. Tank Walker 1.0 -> {2.0, 2.1} -> 3.0).
//   * EM requirements are matched by the destination's faction and wave.
//
// The chain topology is faithful. Node coordinates and the exact EM recipes are
// reasonable reconstructions, not the 2010 originals.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const { RECIPES } = require('./recipes');

const FASTCIPHER_KEY = 'fVBHOulunx9B4kimjhRQ9UEfooDINTyzpn3SJ7FSzmwCodeTWI1';

// Matches a trailing version such as " 2.1" and captures the name stem + major.
const VERSION_RE = /^(.*?)\s*([0-9]+)\.([0-9]+)$/;

function firstTag(block, tag) {
    const m = block.match(new RegExp(`<${tag}>([\\s\\S]*?)</${tag}>`));
    return m ? m[1].trim() : '';
}

function xmlEscape(s) {
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

// virmon-master.xml ships base64 + repeating-key XOR (FastCipher). A pre-decoded
// copy usually sits beside the server; fall back to decoding on the fly.
function loadMasterXml(baseDir) {
    const decoded = path.join(baseDir, 'virmon-master-decoded.xml');
    if (fs.existsSync(decoded)) return fs.readFileSync(decoded, 'utf8');

    const encrypted = path.join(baseDir, 'Manifests', 'Assets', 'Client', 'Characters', 'virmon-master.xml');
    if (!fs.existsSync(encrypted)) {
        throw new Error(`Cannot build evolution data: no virmon master file at ${decoded} or ${encrypted}`);
    }
    const raw = fs.readFileSync(encrypted, 'utf8');
    if (raw.trimStart().startsWith('<')) return raw; // already plaintext

    const bytes = Buffer.from(raw, 'base64');
    const key = Buffer.from(FASTCIPHER_KEY, 'utf8');
    const out = Buffer.alloc(bytes.length);
    for (let i = 0; i < bytes.length; i++) out[i] = bytes[i] ^ key[i % key.length];
    return out.toString('utf8');
}

function parseVirmonMaster(xml) {
    const list = [];
    const re = /<virmon>([\s\S]*?)<\/virmon>/g;
    let m;
    while ((m = re.exec(xml)) !== null) {
        const b = m[1];
        const collectorId = firstTag(b, 'collector-id');
        const assetTypeId = parseInt(firstTag(b, 'asset-type-id'), 10);
        if (!collectorId || !Number.isFinite(assetTypeId)) continue;

        const treeId = parseInt(collectorId.split('-')[0], 10);
        if (!Number.isFinite(treeId)) continue;

        list.push({
            assetTypeId,
            name: firstTag(b, 'name'),
            collectorId,
            treeId,
            faction: firstTag(b, 'faction'),
            wave: firstTag(b, 'wave'),
            rarity: firstTag(b, 'rarity'),
            level: firstTag(b, 'level'),
        });
    }
    return list;
}

function parseEmMaster(xml) {
    const list = [];
    const re = /<em>([\s\S]*?)<\/em>/g;
    let m;
    while ((m = re.exec(xml)) !== null) {
        const b = m[1];
        const id = parseInt(firstTag(b, 'asset-type-id'), 10);
        if (!Number.isFinite(id)) continue;
        list.push({
            assetTypeId: id,
            shortName: firstTag(b, 'short-name'),
            longName: firstTag(b, 'long-name'),
            collectorId: firstTag(b, 'collector-id'),
            faction: firstTag(b, 'faction'),
            wave: firstTag(b, 'wave'),
            rarity: firstTag(b, 'rarity'),
        });
    }
    return list;
}

function parseTreeNames(xml) {
    const names = new Map();
    const re = /<tree\s+id="(\d+)"\s+name="([^"]*)"/g;
    let m;
    while ((m = re.exec(xml)) !== null) names.set(parseInt(m[1], 10), m[2]);
    return names;
}

// How many clamps each circuit row has. The client reads this from
// <recipe-slot-count> (EvoGameStateUI: _slots = evoData.getSlotCount()) and gives
// the player NUM_CIRCUITS = 5 attempts at it.
const SLOT_COUNT = 3;

// Deterministic PRNG so a given evolution always has the same solution across
// restarts - otherwise a player's in-progress guesses would be invalidated.
function seededShuffle(items, seed) {
    const out = items.slice();
    let s = (seed * 2654435761) >>> 0;
    for (let i = out.length - 1; i > 0; i--) {
        s = (s * 1664525 + 1013904223) >>> 0;
        const j = s % (i + 1);
        [out[i], out[j]] = [out[j], out[i]];
    }
    return out;
}

// The palette is what the hopper tray offers (EvoGameStateUI.makeHopperTray ->
// setEMs(_hints)), and is also what EvoTreeEvoChecker requires the player to own
// before the Evolve button unlocks. Favour the destination's own faction and wave
// so early evolutions are satisfiable with starter EMs, then pad from the same
// wave to reach SLOT_COUNT distinct types.
function pickPalette(ems, destination) {
    const rank = { common: 0, uncommon: 1, rare: 2 };
    const byRarity = (a, b) => (rank[a.rarity] ?? 9) - (rank[b.rarity] ?? 9) || a.assetTypeId - b.assetTypeId;

    const chosen = [];
    const take = pool => {
        for (const em of pool.sort(byRarity)) {
            if (chosen.length >= SLOT_COUNT) return;
            if (!chosen.some(c => c.assetTypeId === em.assetTypeId)) chosen.push(em);
        }
    };

    take(ems.filter(e => e.faction === destination.faction && e.wave === destination.wave));
    take(ems.filter(e => e.wave === destination.wave));
    take(ems.slice());

    return chosen;
}

function buildEvolutions(virmon, ems, treeNames) {
    // tree -> family stem -> major version -> [virmon]
    const trees = new Map();
    for (const v of virmon) {
        const m = VERSION_RE.exec(v.name);
        const family = m ? m[1] : v.name;
        const major = m ? parseInt(m[2], 10) : 1;

        if (!trees.has(v.treeId)) trees.set(v.treeId, new Map());
        const families = trees.get(v.treeId);
        if (!families.has(family)) families.set(family, new Map());
        const majors = families.get(family);
        if (!majors.has(major)) majors.set(major, []);
        majors.get(major).push(v);
    }

    const evolutions = [];
    let nextId = 1;

    for (const treeId of [...trees.keys()].sort((a, b) => a - b)) {
        const families = trees.get(treeId);
        let column = 0;

        for (const [, majors] of families) {
            const versions = [...majors.keys()].sort((a, b) => a - b);

            for (let i = 0; i < versions.length - 1; i++) {
                const sources = majors.get(versions[i]);
                const targets = majors.get(versions[i + 1]);

                // Every member at major N evolves into every member at major N+1;
                // more than one target is a genuine branch in the original game.
                sources.forEach((source, si) => {
                    targets.forEach((destination, di) => {
                        const palette = pickPalette(ems, destination);
                        const id = nextId++;
                        evolutions.push({
                            id,
                            treeId,
                            // The first step of a family is its root. generateNanovorIdsInEachTree
                            // unshifts roots to index 0, and TreeTile reads index 0 - so every
                            // tree must have at least one, or the tile menu throws.
                            isRoot: i === 0,
                            sourceTypeId: source.assetTypeId,
                            sourceX: column + si,
                            sourceY: i,
                            destinationTypeId: destination.assetTypeId,
                            destinationX: column + di,
                            destinationY: i + 1,
                            // Types offered in the hopper, and what the player must own.
                            palette: palette.map(e => e.assetTypeId),
                            slotCount: SLOT_COUNT,
                            // The secret the player is guessing: an ordering of the
                            // palette. Never sent to the client - only graded.
                            solution: seededShuffle(palette.map(e => e.assetTypeId), id),
                        });
                    });
                });
            }
            column += Math.max(1, ...[...majors.values()].map(a => a.length));
        }
    }

    // ---- apply confirmed recipes -------------------------------------------
    // A recipe from recipes.js replaces the guessed edge for that destination -
    // and can create an edge the name-stem rule could never produce, such as
    // Mega Scorpion 1.0 -> Megadoom 1.0 (different family, different faction).
    const byName = new Map(virmon.map(v => [v.name, v]));
    const emByShortName = new Map(ems.map(e => [e.shortName, e]));
    let applied = 0;

    for (const [destName, recipe] of Object.entries(RECIPES)) {
        const destination = byName.get(destName);
        const source = byName.get(recipe.from);
        if (!destination || !source) {
            console.error(`[evolution] recipe skipped - unknown nanovor: ` +
                          `${!source ? recipe.from : ''}${!destination ? ' ' + destName : ''}`.trim());
            continue;
        }

        const solution = recipe.ems.map(code => {
            const em = emByShortName.get(code);
            if (!em) console.error(`[evolution] recipe "${destName}": unknown EM code ${code}`);
            return em ? em.assetTypeId : null;
        });
        if (solution.some(x => x === null)) continue;

        // Palette = the distinct types the hopper offers; solution keeps order + repeats.
        const palette = [...new Set(solution)];

        const existing = evolutions.find(e => e.destinationTypeId === destination.assetTypeId);
        if (existing) {
            existing.sourceTypeId = source.assetTypeId;
            existing.treeId = source.treeId;
            existing.palette = palette;
            existing.slotCount = solution.length;
            existing.solution = solution;
        } else {
            evolutions.push({
                id: nextId++,
                treeId: source.treeId,
                isRoot: false,
                sourceTypeId: source.assetTypeId,
                sourceX: 0, sourceY: 0,
                destinationTypeId: destination.assetTypeId,
                destinationX: 0, destinationY: 1,
                palette,
                slotCount: solution.length,
                solution,
            });
        }
        applied++;
    }
    if (applied) console.log(`[evolution] applied ${applied} confirmed recipe(s) from recipes.js`);

    // A tree present in evolution-trees.xml but absent here would leave
    // _nanovorAssetTypeIdsInTree[treeId] undefined and crash TreeTile.
    const covered = new Set(evolutions.map(e => e.treeId));
    const uncovered = [...treeNames.keys()].filter(t => !covered.has(t));

    // Every tree still needs at least one root at index 0 or TreeTile throws.
    for (const treeId of covered) {
        if (!evolutions.some(e => e.treeId === treeId && e.isRoot)) {
            const first = evolutions.find(e => e.treeId === treeId);
            if (first) first.isRoot = true;
        }
    }

    return { evolutions, uncovered };
}

function toXml(evolutions) {
    const parts = ['<?xml version="1.0" encoding="UTF-8"?>', '<evolution-list>'];

    for (const e of evolutions) {
        parts.push(`  <evolution id="${e.id}">`);
        parts.push(`    <tree>${e.treeId}</tree>`);
        parts.push(`    <root>${e.isRoot ? 'true' : 'false'}</root>`);
        parts.push(`    <source-type-id>${e.sourceTypeId}</source-type-id>`);
        parts.push(`    <source-xpos>${e.sourceX}</source-xpos>`);
        parts.push(`    <source-ypos>${e.sourceY}</source-ypos>`);
        parts.push(`    <destination-type-id>${e.destinationTypeId}</destination-type-id>`);
        parts.push(`    <destination-xpos>${e.destinationX}</destination-xpos>`);
        parts.push(`    <destination-ypos>${e.destinationY}</destination-ypos>`);
        // <recipe-slot-count> becomes EvoData.slotCount, which EvoGameStateUI uses
        // as the number of clamps per circuit row. A present <recipe-slot> also
        // marks the step "discovered"
        // (EvoManager: isDiscovered = root || recipe-slot.length > 0).
        parts.push(`    <recipe-slot-count>${e.slotCount}</recipe-slot-count>`);
        for (const emId of e.palette) {
            parts.push(`    <recipe-slot>${emId}</recipe-slot>`);
        }
        // <hint> entries become EvoData.palette (distinct) and .reqEMIds (all).
        // These are the EM types the hopper offers and that the player must own -
        // deliberately NOT the solution ordering, which stays server-side.
        for (const emId of e.palette) {
            parts.push(`    <hint>${emId}</hint>`);
        }
        parts.push(`    <solution-visible-at>0</solution-visible-at>`);
        parts.push(`    <hint-text></hint-text>`);
        parts.push(`  </evolution>`);
    }

    parts.push('</evolution-list>');
    return parts.join('\n');
}

let cached = null;

function build(baseDir) {
    if (cached) return cached;

    const masterXml = loadMasterXml(baseDir);
    const emXml = fs.readFileSync(
        path.join(baseDir, 'Manifests', 'Assets', 'Client', 'Ems', 'em-master.xml'), 'utf8');
    const treeXml = fs.readFileSync(
        path.join(baseDir, 'Manifests', 'Assets', 'Client', 'evolution-trees.xml'), 'utf8');

    const virmon = parseVirmonMaster(masterXml);
    const ems = parseEmMaster(emXml);
    const treeNames = parseTreeNames(treeXml);

    const { evolutions, uncovered } = buildEvolutions(virmon, ems, treeNames);

    console.log(`[evolution] built ${evolutions.length} evolutions across ` +
                `${new Set(evolutions.map(e => e.treeId)).size} trees ` +
                `from ${virmon.length} nanovor and ${ems.length} EMs`);
    if (uncovered.length) {
        console.error(`[evolution] WARNING: trees with no evolutions (TreeTile will throw): ${uncovered.join(', ')}`);
    }

    cached = {
        xml: toXml(evolutions),
        evolutions,
        byId: new Map(evolutions.map(e => [e.id, e])),
        virmonById: new Map(virmon.map(v => [v.assetTypeId, v])),
        emById: new Map(ems.map(e => [e.assetTypeId, e])),
        emByShortName: new Map(ems.map(e => [e.shortName, e])),
        ems,
        virmon,
    };
    return cached;
}

const getEvolutionListXml = baseDir => build(baseDir).xml;

// Evolution record by the id the client posts back, e.g. /bankfe/resources/evolution/7
const getEvolutionById = (baseDir, id) => build(baseDir).byId.get(Number(id)) || null;

// Master-data lookups shared with the EM-granting and evolution endpoints
const getVirmonMaster = (baseDir, assetTypeId) => build(baseDir).virmonById.get(Number(assetTypeId)) || null;
const getEmMaster = (baseDir, assetTypeId) => build(baseDir).emById.get(Number(assetTypeId)) || null;
const getAllEms = baseDir => build(baseDir).ems.slice();
const getAllVirmon = baseDir => build(baseDir).virmon.slice();

// Wiki/recipe notation ("1M1", "2H2") -> the EM master record
const getEmByShortName = (baseDir, shortName) => build(baseDir).emByShortName.get(shortName) || null;

module.exports = {
    getEvolutionListXml,
    getEvolutionById,
    getVirmonMaster,
    getEmMaster,
    getEmByShortName,
    getAllEms,
    getAllVirmon,
    xmlEscape,
};
