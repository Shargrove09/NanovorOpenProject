'use strict';

// ---------------------------------------------------------------------------
// Item economy: booster packs, drop rolls, nanocodes, starter grant.
//
// Everything tunable lives here so values can be corrected without touching
// route code. Each block is marked CONFIRMED (sourced) or RECONSTRUCTED (my
// best guess, safe to change).
//
// Sources for the CONFIRMED values:
//   - 2009 OnRPG review: three pack types - 1 Nanovor + 4 EMs / 7 EMs /
//     7 Nanovor, each with one guaranteed rare.
//   - 2018 retrospective: roughly 65 / 55 / 275 nanocash for those three.
//   - Nanovor Fandom wiki: the "Hacked" badge granted 1 Wave 2 Nanovor + 3
//     Wave 2 EMs; players started with 400 nanocash; $10 = N400.
//   - Wave 1 = 68 nanovor over trees 1-12, Wave 2 = 54 over trees 14-25.
// ---------------------------------------------------------------------------

const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');
const { getAllEms, getAllVirmon } = require('./evolutionData');

// Starter account. CONFIRMED: the original gave 400, not the 1000 this server
// was handing out.
const STARTER_NANOCASH = 400;

// Relative draw weights. RECONSTRUCTED - the real drop table is not recoverable.
const RARITY_WEIGHT = { common: 60, uncommon: 30, rare: 10 };

// Pack catalogue. The `id` must be one of the 13 that have art on disk
// (Assets/Client/Boosters/<id>/), or the store row renders with blank icons.
//
// `price`  - nanocash. The 65/55/275 trio is CONFIRMED-ish; variants are RECONSTRUCTED.
// `sort`   - display order. Emitted as <image-url>, which despite its name is
//            coerced to Number by the client and used only as a sort key.
// `wave`   - restricts the draw pool. Wave 1 = trees 1-12, Wave 2 = trees 14-25.
// `faction`- optional further restriction (Magnamod | Velocitron | Hexite).
// Pack catalogue. The `id` must be one of the 13 that have art on disk
// (Assets/Client/Boosters/<id>/), or the store row renders with blank icons.
//
// THE ART IS THE SPEC. Each pack's booster_family_icon.png prints its contents
// (dot counts under NANOVOR / EMs, plus a caption). Read those before changing
// anything here - an earlier version of this table guessed, and the store showed
// "1 Nanovor + 3 EMs" on a pack that handed out 7 EMs.
//
// Fields:
//   price   - nanocash
//   sort    - display order; emitted as <image-url>, which the client coerces to
//             Number and uses only as a sort key
//   wave    - restricts the random draw pool (wave 1 = trees 1-12, 2 = trees 14-25)
//   faction - optional further restriction (Magnamod | Velocitron | Hexite)
//   nanovor - how many nanovor to draw at random
//   named   - exact nanovor the pack contains, one of each (overrides `nanovor`).
//             Used by the limited-time packs, whose art lists them by name.
//   ems     - how many EMs to draw at random
const PACKS = [
    // --- Core packs. Counts CONFIRMED by the art AND by the 2018 retrospective
    //     ("one bug plus 3 EMs ~65, 6 EMs ~55, 6 or 7 bugs ~275"). Prices are
    //     the retrospective's recollection. ---
    { id: 3,   sort: 1, wave: '1', name: 'WAVE 1 NANOVOR PACK', price: 275, nanovor: 7, ems: 0 }, // "Get 7 Nanovor ... at least 1 Rare"
    { id: 58,  sort: 2, wave: '1', name: 'WAVE 1 BOOSTER PACK', price: 65,  nanovor: 1, ems: 3 }, // "Build your collection with Nanovor and EMs"
    { id: 59,  sort: 3, wave: '1', name: 'WAVE 1 EM PACK',      price: 55,  nanovor: 0, ems: 6 }, // "More EMs to evolve your Nanovor!"
    { id: 78,  sort: 4, wave: '2', name: 'WAVE 2 BOOSTER PACK', price: 65,  nanovor: 1, ems: 3 },
    { id: 79,  sort: 5, wave: '2', name: 'WAVE 2 EM PACK',      price: 55,  nanovor: 0, ems: 6 },
    { id: 80,  sort: 6, wave: '2', name: 'WAVE 2 NANOVOR PACK', price: 275, nanovor: 7, ems: 0 },

    // --- Limited-time packs. The NANOVOR CONTENTS are CONFIRMED - the art names
    //     them. The EM count and the prices are RECONSTRUCTED: the dot counts on
    //     these icons are too small to read reliably. Check the art and correct. ---
    { id: 109, sort: 7,  wave: '1', faction: 'Magnamod',   name: 'WAVE 1 MAGNAMOD PACK',   price: 200, ems: 3,
      named: ['Tank Walker 1.0', 'Mega Scorpion 1.0', 'Gamma Stalker 1.0', 'Electropod 1.0'] },
    { id: 110, sort: 8,  wave: '1', faction: 'Velocitron', name: 'WAVE 1 VELOCITRON PACK', price: 200, ems: 3,
      named: ['Doom Blade 1.0', 'Plasma Lash 1.0', 'Phase Stormer 1.0', 'Storm Spinner 1.0'] },
    { id: 111, sort: 9,  wave: '1', faction: 'Hexite',     name: 'WAVE 1 HEXITE PACK',     price: 200, ems: 3,
      named: ['Battle Kraken 1.0', 'Spike Spine 1.0', 'Circuit Flyer 1.0', 'Gigastriker 1.0'] },
    { id: 81,  sort: 10, wave: '2', faction: 'Magnamod',   name: 'WAVE 2 MAGNAMOD PACK',   price: 200, ems: 3,
      named: ['Psi Blaster 1.0', 'Rumble Hound 1.0', 'Hyper Ripper 1.0', 'Thunderpoid 1.0'] },
    { id: 82,  sort: 11, wave: '2', faction: 'Velocitron', name: 'WAVE 2 VELOCITRON PACK', price: 200, ems: 3,
      named: ['Turbo Cannon 1.0', 'Scarab Roller 1.0', 'Blaze Dragon 1.0', 'Shock Hornet 1.0'] },
    { id: 83,  sort: 12, wave: '2', faction: 'Hexite',     name: 'WAVE 2 HEXITE PACK',     price: 200, ems: 3,
      named: ['Triton Manta 1.0', 'Shard Slider 1.0', 'Cyber Slicer 1.0', 'War Charger 1.0'] },

    // Radium (".1" variants). Mixed factions, so no faction filter on the EMs.
    { id: 73,  sort: 13, wave: '1', name: 'RADIUM PACK', price: 300, ems: 3,
      named: ['Tank Walker 2.1', 'Storm Spinner 1.1', 'Circuit Flyer 2.1', 'Plasma Lash 2.1', 'Battle Kraken 1.1'] },

    // --- Reward-only, never sold ---
    // `hidden` keeps it out of the SKU list; it needs no art because the store
    // never renders it. CONFIRMED contents: the wiki states the "Hacked" badge
    // granted 1 Wave 2 Nanovor + 3 Wave 2 EMs.
    { id: 9001, sort: 99, wave: '2', hidden: true, name: 'HACKED BADGE REWARD', price: 0, nanovor: 1, ems: 3 },
];

const PACK_BY_ID = new Map(PACKS.map(p => [p.id, p]));

// Nanocodes. Originally printed on toys, cards and the tie-in books.
// `grants` may mix nanovor (asset-type-ids), ems (asset-type-ids) and nanocash.
// RECONSTRUCTED except HACKED, whose contents the wiki documents.
const CODES = [
    {
        code: 'HACKEDHACKEDHACK',
        note: 'Tie-in novel "Hacked!" - CONFIRMED contents: 1 Wave 2 Nanovor + 3 Wave 2 EMs',
        grants: { pack: 9001 },
        maxUses: 1,
    },
    { code: 'TESTTESTTESTTEST', note: 'dev: a wave 1 booster', grants: { pack: 3 }, maxUses: 99 },
    { code: 'NANOCASH00000400', note: 'dev: the retail $10 card', grants: { nanocash: 400 }, maxUses: 99 },
    { code: 'STARTERSWARM0001', note: 'dev: specific EMs for testing evolution',
      grants: { ems: [1007, 1008, 1009, 1012] }, maxUses: 99 },
];

const CODE_BY_VALUE = new Map(CODES.map(c => [c.code.toUpperCase(), c]));

// Gift cards credit nanocash only.
const GIFT_CARDS = [
    { code: 'GIFT000000000010', nanocash: 400,  zip: null, maxUses: 99 },
    { code: 'GIFT000000000025', nanocash: 1000, zip: null, maxUses: 99 },
];
const GIFT_BY_VALUE = new Map(GIFT_CARDS.map(c => [c.code.toUpperCase(), c]));

// ---------------------------------------------------------------------------

function weightedPick(pool) {
    const total = pool.reduce((s, x) => s + (RARITY_WEIGHT[x.rarity] || 1), 0);
    let r = Math.random() * total;
    for (const x of pool) {
        r -= RARITY_WEIGHT[x.rarity] || 1;
        if (r <= 0) return x;
    }
    return pool[pool.length - 1];
}

function drawFrom(pool, count, guaranteeRare) {
    if (!pool.length || count <= 0) return [];
    const out = [];
    for (let i = 0; i < count; i++) out.push(weightedPick(pool));

    // One guaranteed rare per pack, per the 2009 review.
    if (guaranteeRare && !out.some(x => x.rarity === 'rare')) {
        const rares = pool.filter(x => x.rarity === 'rare');
        if (rares.length) out[out.length - 1] = rares[Math.floor(Math.random() * rares.length)];
    }
    return out;
}

/**
 * Roll a pack's contents. Returns master-data records, not inventory entries -
 * the caller mints them so instance ids and dates stay in one place.
 */
function rollPack(baseDir, packId) {
    const pack = PACK_BY_ID.get(Number(packId));
    if (!pack) return null;

    const matches = x =>
        (!pack.wave || x.wave === pack.wave) &&
        (!pack.faction || x.faction === pack.faction);

    let virmonPool = getAllVirmon(baseDir).filter(matches);
    let emPool = getAllEms(baseDir).filter(matches);

    // Never hand back an empty pack just because a filter was too narrow.
    if (!virmonPool.length) virmonPool = getAllVirmon(baseDir);
    if (!emPool.length) emPool = getAllEms(baseDir);

    // Limited packs list their exact nanovor on the art: one of each.
    let nanovor;
    if (pack.named) {
        const byName = new Map(getAllVirmon(baseDir).map(v => [v.name, v]));
        nanovor = pack.named.map(n => byName.get(n)).filter(Boolean);
        const missing = pack.named.filter(n => !byName.has(n));
        if (missing.length) console.error(`[economy] pack ${pack.id} names unknown nanovor: ${missing.join(', ')}`);
    } else {
        nanovor = drawFrom(virmonPool, pack.nanovor || 0, (pack.nanovor || 0) > 0);
    }

    return {
        pack,
        nanovor,
        // The guaranteed rare goes to the EMs only in EM-only packs.
        ems: drawFrom(emPool, pack.ems || 0, (pack.ems || 0) > 0 && nanovor.length === 0),
    };
}

// --- minting -----------------------------------------------------------------
// `now` must already be in the client's required bank-date format
// (YYYY-MM-DDTHH:MM:SS.mmm+HH:MM). MakeDate.dateFromBankTime returns null for
// anything else and the client dereferences it without a guard.

// Nanovor asset ids must be plain decimal. On a Nanoscope the id is a u64 inside
// vinfo.bbb, which the client turns back into a decimal string and looks up
// verbatim (DeviceNanovorRetriever). Original ids were ~4.6M; these start at 1e9
// so they never collide, and stay under 2^31 in case anything casts to int.
function newNanovorAssetId() {
    return String(crypto.randomInt(1e9, 2 ** 31 - 1));
}

function mintNanovor(master, now) {
    return {
        id: master.assetTypeId,
        name: master.name,
        type: 'virmon',
        assetTypeId: master.assetTypeId,
        assetId: newNanovorAssetId(), // unique per instance
        faction: master.faction,
        rarity: master.rarity,
        wave: master.wave,
        productionNumber: 1,
        birthDate: now,
        lastEvolutionDate: now,
        nickname: '',
    };
}

function mintEm(master, now) {
    return {
        id: `em_${master.assetTypeId}_${uuidv4().substring(0, 4)}`,
        name: master.shortName || master.longName || `EM ${master.assetTypeId}`,
        type: 'em',
        assetTypeId: master.assetTypeId,
        assetId: uuidv4().substring(0, 8),
        faction: master.faction,
        rarity: master.rarity,
        wave: master.wave,
        productionNumber: 1,
        birthDate: now,
        lastEvolutionDate: now,
        nickname: '',
    };
}

/** Grant rolled contents to a user object. Returns the minted entries. */
function grantToUser(user, rolled, now) {
    if (!user.nanovorInventory) user.nanovorInventory = [];
    if (!user.emInventory) user.emInventory = [];

    const minted = { nanovor: [], ems: [] };
    for (const m of rolled.nanovor || []) {
        const inst = mintNanovor(m, now);
        user.nanovorInventory.push(inst);
        minted.nanovor.push(inst);
    }
    for (const m of rolled.ems || []) {
        const inst = mintEm(m, now);
        user.emInventory.push(inst);
        minted.ems.push(inst);
    }

    user.ems = user.emInventory.length;
    user.nanovorCount = user.nanovorInventory.length;
    user.nanovorCountUnique = new Set(user.nanovorInventory.map(n => n.assetTypeId)).size;
    return minted;
}

// --- SKU list XML ------------------------------------------------------------
// Contract (WaveList.as:101-126): <sku> elements must be DIRECT children of the
// root - any wrapper makes child("sku") return 0 and the store renders empty.
// Fields read are the `id` ATTRIBUTE plus <name>, <price>, <image-url>.
// No colon may appear inside a start tag: Utils.StripXmlNamespace runs
// /<(\/*)[^>]+:/gi over the raw string and would mangle the document.
function buildSkuListXml() {
    const rows = PACKS.filter(p => !p.hidden).sort((a, b) => a.sort - b.sort).map(p =>
        `  <sku id="${p.id}"><name>${p.name}</name><price>${p.price}</price>` +
        `<image-url>${p.sort}</image-url></sku>`);
    return `<?xml version="1.0" encoding="UTF-8"?>\n<sku-list>\n${rows.join('\n')}\n</sku-list>`;
}

module.exports = {
    STARTER_NANOCASH,
    PACKS,
    PACK_BY_ID,
    CODE_BY_VALUE,
    GIFT_BY_VALUE,
    rollPack,
    grantToUser,
    newNanovorAssetId,
    mintNanovor,
    mintEm,
    buildSkuListXml,
};
