'use strict';

// ---------------------------------------------------------------------------
// Nanoscope handheld: on-device file formats, signed-blob vault, import.
//
// The Nanoscope is a plain USB mass-storage drive (FAT32, SCSI vendor NANOVOR,
// product NANOSCOPE_DEVICE). There is no command protocol: the 1.2.0 client
// finds the drive with Utils\ConsoleDeviceInterface.exe and then copies files
// on and off it. The files below ARE the protocol. Everything here is pure (no
// Express) so a future client or a standalone sync tool can reuse it.
//
// Two container shapes exist:
//   device-written  (deviceid.bbb, jolts.bbb)
//       [0]  8 bytes  MAC tag
//       [8]  8 bytes  nonce - changes every USB session, shared by the files
//                     written in that session (fits UMAC-64: tag + nonce)
//       [16] u16      kind
//       [18] u16      USB-session counter (deviceid and jolts on one device agree)
//       [20] u16      0
//       [22] payload
//   server-signed   (vinfo.bbb, plyinfo.bbb)
//       [0]  payload  ...
//       [-16]         16-byte signature trailer
//
// The signature is UMAC (AES) per the firmware's own build paths. We cannot
// produce one yet, so signed files can only be REPLAYED from captures (the
// vault). The sensei s1/swarm vinfos are byte-identical on every device, so at
// least one global key exists; whether a player's vinfo is bound to its device
// is still open.
//
// Offsets are CONFIRMED against the decompiled client (DeviceIDFileParser,
// DeviceNanovorRetriever, DeviceJoltsUploadChainLoadee) and against 8 vinfos
// whose stat blocks match virmon-master exactly. Fields named unknownNNN are
// not understood yet - keep them raw.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const crypto = require('crypto');

const VINFO_SIZE = 4194;
const SIGNATURE_SIZE = 16;
const MAX_DEVICE_NANOVOR = 10; // v1..v10, DeviceSwarmChooser caps the swarm at 10

const FACTIONS = ['Magnamod', 'Velocitron', 'Hexite']; // vinfo u16 @412

// --- primitive readers --------------------------------------------------------

function hex(buf, start, end) {
    return buf.subarray(start, end).toString('hex');
}

// UTF-16LE, stopping at the first NUL code unit.
function readUtf16z(buf, start, byteLength) {
    const s = buf.subarray(start, Math.min(buf.length, start + byteLength)).toString('utf16le');
    const nul = s.indexOf('\0');
    return nul === -1 ? s : s.slice(0, nul);
}

// What the client does for the device id: drop every zero byte, read the rest
// as ASCII (DeviceIDFileParser.as:12-14).
function readAsciiDroppingNuls(buf, start, end) {
    return Array.from(buf.subarray(start, end)).filter(b => b !== 0).map(b => String.fromCharCode(b)).join('');
}

// The client turns the u64 at vinfo+6 into a decimal string with no leading
// zeros and looks the asset up by that exact string (DeviceNanovorRetriever.as:152-178).
function readU64Decimal(buf, offset) {
    return buf.readBigUInt64LE(offset).toString();
}

// "0000000000077831" -> "77831". AssociatedDevices.as compares ids as ints, and
// the sign/* URLs carry the raw zero-padded string, so normalise both sides.
function normalizeDeviceId(id) {
    const digits = String(id || '').replace(/\D/g, '').replace(/^0+/, '');
    return digits || '0';
}

function readDeviceHeader(buf) {
    return {
        tag: hex(buf, 0, 8),
        nonce: hex(buf, 8, 16),
        kind: buf.readUInt16LE(16),
        session: buf.readUInt16LE(18),
    };
}

// --- parsers ---------------------------------------------------------------------

function parseDeviceId(buf) {
    if (buf.length < 62) throw new Error(`deviceid.bbb too short: ${buf.length} bytes`);
    return {
        ...readDeviceHeader(buf),
        firmware: buf.readInt32LE(22), // 1.20 -> 20, this project's unit -> 58, a 1.381 unit -> 59
        unknown26: buf.readInt32LE(26), // 57 on every unit seen so far
        deviceId: readAsciiDroppingNuls(buf, 30, 62),
    };
}

// Field order is the client's own (DeviceJoltsUploadChainLoadee.as:87-95 builds
// JoltsInfo(health, armor, strength, speed) from the four ints read in order).
// Values are jolt POINTS; master data's buff-formula-* ladders price each +1 stat.
function parseJolts(buf) {
    if (buf.length < 38) throw new Error(`jolts file too short: ${buf.length} bytes`);
    return {
        ...readDeviceHeader(buf),
        speed: buf.readInt32LE(22),
        strength: buf.readInt32LE(26),
        armor: buf.readInt32LE(30),
        health: buf.readInt32LE(34),
    };
}

function parseVinfo(buf) {
    if (buf.length !== VINFO_SIZE) throw new Error(`vinfo.bbb must be ${VINFO_SIZE} bytes, got ${buf.length}`);
    return {
        version: buf.readUInt16LE(0),
        assetId: readU64Decimal(buf, 6),
        assetTypeId: buf.readUInt32LE(14),
        tag: readUtf16z(buf, 18, 128), // e.g. "4-BETA"; meaning unconfirmed
        unknown146: buf.readUInt32LE(146),
        name: readUtf16z(buf, 154, 128), // upper-case handheld name, e.g. "MEGADOOM 1.0"
        sv: buf.readUInt16LE(410),
        faction: FACTIONS[buf.readUInt16LE(412)] || `faction#${buf.readUInt16LE(412)}`,
        speed: buf.readUInt16LE(414),
        strength: buf.readUInt16LE(416),
        armor: buf.readUInt16LE(418),
        health: buf.readUInt16LE(420),
        signature: hex(buf, VINFO_SIZE - SIGNATURE_SIZE, VINFO_SIZE),
    };
}

// Only the header is understood. The rest holds what looks like the avatar as
// palette indices.
function parsePlyinfo(buf) {
    return {
        version: buf.readUInt16LE(0),
        username: readUtf16z(buf, 6, 42),
        beltName: readUtf16z(buf, 48, 42),
        signature: hex(buf, buf.length - SIGNATURE_SIZE, buf.length),
    };
}

// --- reading a device (or a backup of one) ------------------------------------

function readIfExists(file) {
    try {
        return fs.readFileSync(file);
    } catch (err) {
        if (err.code === 'ENOENT') return null;
        throw err;
    }
}

/**
 * Snapshot of everything we understand on a Nanoscope root (a live drive such
 * as "E:\\" or the files/ folder of a backup). Read-only.
 */
function readDeviceRoot(root) {
    const deviceIdBuf = readIfExists(path.join(root, 'deviceid.bbb'));
    if (!deviceIdBuf) throw new Error(`no deviceid.bbb under ${root} - not a Nanoscope root?`);

    const nanovor = [];
    for (let slot = 1; slot <= MAX_DEVICE_NANOVOR; slot++) {
        const dir = path.join(root, `v${slot}`);
        const vinfo = readIfExists(path.join(dir, 'vinfo.bbb'));
        if (!vinfo) continue;
        nanovor.push({
            slot,
            dir,
            vinfo,
            parsed: parseVinfo(vinfo),
            hasSprite: fs.existsSync(path.join(dir, 'spr.v2z')),
            hasSound: fs.existsSync(path.join(dir, 'nano.snd')),
        });
    }

    const joltsFiles = fs.readdirSync(root).filter(f => /^jolts.*\.bbb$/i.test(f));
    const plyinfo = readIfExists(path.join(root, 'plyinfo.bbb'));

    return {
        root,
        device: parseDeviceId(deviceIdBuf),
        nanovor,
        jolts: joltsFiles.map(f => ({ file: f, ...parseJolts(fs.readFileSync(path.join(root, f))) })),
        plyinfo,
        plyinfoParsed: plyinfo ? parsePlyinfo(plyinfo) : null,
    };
}

// --- vault: captured signed blobs ---------------------------------------------
//
// <vaultRoot>/<normalizedDeviceId>/plyinfo.bbb
// <vaultRoot>/<normalizedDeviceId>/vinfo/<assetId>.bbb
//
// The vault is the only signer we have: GET .../sign/vinfo replays the exact
// bytes captured from the device, so a round trip rewrites identical files.

class DeviceVault {
    constructor(vaultRoot) {
        this.root = vaultRoot;
    }

    deviceDir(deviceId) {
        return path.join(this.root, normalizeDeviceId(deviceId));
    }

    putVinfo(deviceId, buf) {
        const { assetId } = parseVinfo(buf); // validates size
        const file = path.join(this.deviceDir(deviceId), 'vinfo', `${assetId}.bbb`);
        fs.mkdirSync(path.dirname(file), { recursive: true });
        fs.writeFileSync(file, buf);
        return assetId;
    }

    getVinfo(deviceId, assetId) {
        if (!/^\d+$/.test(String(assetId))) return null;
        return readIfExists(path.join(this.deviceDir(deviceId), 'vinfo', `${assetId}.bbb`));
    }

    // Normalised ids of the devices whose vault holds this assetId, i.e. the devices that
    // supplied it. Used to tell a real device-origin instance from a server-made leftover.
    holders(assetId) {
        if (!/^\d+$/.test(String(assetId))) return [];
        let dirs = [];
        try {
            dirs = fs.readdirSync(this.root, { withFileTypes: true }).filter(d => d.isDirectory()).map(d => d.name);
        } catch (err) {
            if (err.code === 'ENOENT') return [];
            throw err;
        }
        return dirs.filter(d => fs.existsSync(path.join(this.root, d, 'vinfo', `${assetId}.bbb`)));
    }

    // assetIds of every vinfo this device supplied, by species: assetTypeId -> [assetId].
    // These are the only bytes PROVEN to be accepted by this device's firmware.
    listByType(deviceId) {
        const dir = path.join(this.deviceDir(deviceId), 'vinfo');
        const byType = new Map();
        let files = [];
        try { files = fs.readdirSync(dir); } catch (err) { if (err.code !== 'ENOENT') throw err; }
        for (const f of files.filter(x => /^\d+\.bbb$/.test(x))) {
            let p;
            try { p = parseVinfo(fs.readFileSync(path.join(dir, f))); } catch { continue; }
            if (!byType.has(p.assetTypeId)) byType.set(p.assetTypeId, []);
            byType.get(p.assetTypeId).push(p.assetId);
        }
        return byType;
    }

    // One of this device's own vinfos for a species, not in excludeIds, or null.
    // Sorted so repeated calls with the same exclusions are stable.
    pickForType(deviceId, assetTypeId, excludeIds = []) {
        const exclude = new Set(excludeIds.map(String));
        const ids = (this.listByType(deviceId).get(Number(assetTypeId)) || []).slice().sort();
        return ids.find(id => !exclude.has(String(id))) || null;
    }

    putPlyinfo(deviceId, buf) {
        const file = path.join(this.deviceDir(deviceId), 'plyinfo.bbb');
        fs.mkdirSync(path.dirname(file), { recursive: true });
        fs.writeFileSync(file, buf);
    }

    getPlyinfo(deviceId) {
        return readIfExists(path.join(this.deviceDir(deviceId), 'plyinfo.bbb'));
    }

    // Keep every distinct device-written upload (jolts, battle logs): known
    // plaintext with the device's own tag is what the signature research needs.
    // Named by content hash, so a retried upload doesn't make a second copy.
    archiveUpload(deviceId, kind, buf) {
        const dir = path.join(this.deviceDir(deviceId), 'uploads');
        fs.mkdirSync(dir, { recursive: true });
        const digest = crypto.createHash('sha256').update(buf).digest('hex').slice(0, 16);
        const file = path.join(dir, `${kind}-${digest}.bbb`);
        if (!fs.existsSync(file)) fs.writeFileSync(file, buf);
    }
}

// --- corpus: a shared, device-agnostic store of signed vinfos -----------------
//
// The vinfo MAC key is GLOBAL: the same payload carries the same 16-byte
// signature on every device and across firmware 1.20-1.381 (proven by the
// sample corpus - identical sensei vinfos everywhere, and player vinfos whose
// payload matches across different devices share one signature). So a
// validly-signed vinfo captured ANYWHERE can be replayed to ANY device. The
// corpus holds such blobs keyed by assetId only (no device dir):
//
//   <corpusRoot>/vinfo/<assetId>.bbb
//
// This is how the server serves nanovor the current device never physically
// held - the device's firmware validates the signature, not its origin.

//
// NOT every corpus blob is safe to send to every device. Evidence (2026-10-13, the 1.381
// unit): the firmware DELETES a vinfo it will not accept, leaving a slot with a sprite and
// no vinfo (the nanovor just never appears). Of 17 distinct vinfos written, every one with
// a 157xxxxxx id was kept (10: nine the device supplied + The List 157076237) and every
// other one was deleted (7: firmware-dump 147384601, The List 147415019, five 4666xxx from
// the 1.38 unit). So provenance alone is NOT enough - 147415019 is a The List file and was
// deleted. `trusted.json` (written by tools/corpus-ingest.js) lists the assetIds that came
// from The List; resolveVinfo additionally requires the id to be in a series the target
// device already holds. n is small and it is a correlation, so treat it as "the best rule
// so far", not as a fact about the firmware.

class CorpusVault {
    constructor(corpusRoot) {
        this.root = corpusRoot;
        this._trusted = null;
    }

    trustedFile() {
        return path.join(this.root, 'trusted.json');
    }

    // Set of assetIds known to be device-agnostic (The List). Missing file = none
    // trusted, which fails SAFE.
    trustedIds() {
        if (!this._trusted) {
            let list = [];
            try { list = JSON.parse(fs.readFileSync(this.trustedFile(), 'utf8')); } catch { /* none */ }
            this._trusted = new Set(list.map(String));
        }
        return this._trusted;
    }

    setTrusted(ids) {
        fs.mkdirSync(this.root, { recursive: true });
        const sorted = [...new Set([...ids].map(String))].sort(); // any iterable (Set or array)
        fs.writeFileSync(this.trustedFile(), JSON.stringify(sorted, null, 1));
        this._trusted = new Set(sorted);
    }

    isTrusted(assetId) {
        return this.trustedIds().has(String(assetId));
    }

    vinfoPath(assetId) {
        return path.join(this.root, 'vinfo', `${assetId}.bbb`);
    }

    // Validates size (via parseVinfo) and stores by the vinfo's embedded assetId.
    // Never re-ids: the assetId is inside the signed payload. Returns the assetId.
    ingestVinfo(buf) {
        const { assetId } = parseVinfo(buf);
        const file = this.vinfoPath(assetId);
        fs.mkdirSync(path.dirname(file), { recursive: true });
        fs.writeFileSync(file, buf);
        return assetId;
    }

    getVinfo(assetId) {
        if (!/^\d+$/.test(String(assetId))) return null;
        return readIfExists(this.vinfoPath(assetId));
    }

    has(assetId) {
        return /^\d+$/.test(String(assetId)) && fs.existsSync(this.vinfoPath(assetId));
    }

    // Decimal assetIds currently held.
    listAssetIds() {
        try {
            return fs.readdirSync(path.join(this.root, 'vinfo'))
                .filter(f => /^\d+\.bbb$/.test(f))
                .map(f => f.replace(/\.bbb$/, ''));
        } catch (err) {
            if (err.code === 'ENOENT') return [];
            throw err;
        }
    }

    // Map of assetTypeId -> [assetId, ...] for every corpus copy. Used by the
    // transfer guard to find a same-species stand-in and to count how many
    // distinct signed copies of a species exist.
    listByType() {
        const byType = new Map();
        for (const id of this.listAssetIds()) {
            const buf = this.getVinfo(id);
            if (!buf) continue;
            let type;
            try { type = parseVinfo(buf).assetTypeId; } catch { continue; }
            if (!byType.has(type)) byType.set(type, []);
            byType.get(type).push(id);
        }
        return byType;
    }

    // A corpus copy of assetTypeId whose id is not in excludeIds, or null.
    // Deterministic (sorted) so repeated calls with the same exclude set are stable.
    //
    // `trustedOnly` (default true) restricts the choice to The List files; pass false
    // only for an explicit, backed-up experiment.
    pickCopyForType(assetTypeId, excludeIds = [], { trustedOnly = true } = {}) {
        const exclude = new Set(excludeIds.map(String));
        const ids = (this.listByType().get(Number(assetTypeId)) || []).slice().sort();
        return ids.find(id => !exclude.has(String(id)) && (!trustedOnly || this.isTrusted(id))) || null;
    }
}

// --- which vinfo may we send this device for this nanovor? -------------------------
//
// Writing a vinfo the firmware rejects does not fail politely: it DELETES the file after
// the write and leaves the slot with a sprite and no vinfo, so the nanovor silently never
// appears on the handheld (it still boots - a rejected vinfo is not what crashed the
// 1.381 unit; that was the s1/ cartridge, see tools/nanoscope-cli.js preflight). A 409
// leaves the same nanovor missing but is honest about it, and writes nothing.
//
// What the evidence supports (2026-10-13, 1.381 unit, 17 distinct vinfos written):
//
//     id series 157xxxxxx   10 files  (9 the device supplied + The List 157076237)  ALL KEPT
//     id series 147xxxxxx    2 files  (firmware dump, The List 147415019)           BOTH DELETED
//     id series 4666xxx      5 files  (captured from the 1.38 unit)                 ALL DELETED
//
// "Came from The List" does NOT separate keepers from rejects (147415019 is a List file
// and was deleted). The id series does, perfectly - so a corpus file is only eligible when
// its id falls in a series this device already holds. We do not know WHY (an id block
// allotted per device? a field in plyinfo?), only that it predicts all 17 outcomes; n is
// small and it is a correlation. A wrong "no" costs a 409, a wrong "yes" costs a missing
// nanovor, so the rule errs towards refusing.
//
//   device-origin   this device supplied exactly this vinfo        -> proven
//   corpus-exact    the requested id is a trusted (The List) blob in
//                   a series this device holds, and is unmodified  -> 157 series: kept
//   own-standin     another vinfo of the SAME SPECIES this device
//                   supplied (the real instance's id is never
//                   written, so a round-trip cannot clobber it)    -> proven
//   list-standin    a trusted (The List) copy of the species, in a
//                   series this device holds                       -> 157 series: kept
//   none            everything else -> the caller answers 409
//
// `allowUntrusted` lifts BOTH restrictions (provenance and series) for a deliberate,
// backed-up experiment. `excludeIds` are ids already promised to other requests on this
// device (so several same-species nanovor in one transfer get distinct copies).
// `preferId` is the stand-in the ledger used last time, kept if it is still servable so
// the mapping stays stable.
//
// Coarse "series" of an asset id: the leading digits of the long ids (157xxxxxx,
// 147xxxxxx, ...), or 'short' for the 7-digit/3-digit ones.
const idSeries = id => (String(id).length >= 9 ? String(id).slice(0, 3) : 'short');

// Series a device is known to hold: the ids it supplied itself. An empty vault has none,
// so such a device is sent nothing from the corpus.
function deviceSeries(deviceVault, deviceId) {
    return new Set([...deviceVault.listByType(deviceId).values()].flat().map(idSeries));
}

function resolveVinfo({ deviceVault, corpusVault, deviceId, inst, excludeIds = [], preferId = null, allowUntrusted = false }) {
    const R = String(inst.assetId);
    const type = Number(inst.assetTypeId);
    const exclude = new Set([...excludeIds.map(String), R]);
    const ownSeries = deviceSeries(deviceVault, deviceId);
    const corpusOk = id => Boolean(corpusVault.getVinfo(id)) &&
        (allowUntrusted || (corpusVault.isTrusted(id) && ownSeries.has(idSeries(id))));

    // 1) exactly what this device supplied
    const captured = deviceVault.getVinfo(deviceId, R);
    if (captured) return { kind: 'device-origin', assetId: R, blob: captured };

    // 2) the instance's own id is itself an eligible corpus file OF THE SAME SPECIES: serve
    //    it as itself, whatever the instance's stats. This is what a "folded" nanovor is
    //    (see foldIntoScopeId): the real instance was renamed to the scope file's id, so
    //    the scope keeps carrying the same generic file while the PC keeps the earned stats
    //    (import never overwrites those - see the pcStats flag). The species check stops an
    //    EVOLVED nanovor being sent its old species' file.
    if (corpusOk(R)) {
        const blob = corpusVault.getVinfo(R);
        let cp = null; try { cp = parseVinfo(blob); } catch { /* fall through */ }
        if (cp && cp.assetTypeId === type) return { kind: 'corpus-exact', assetId: R, blob };
    }

    // 3) stand-in, last time's choice first, then the device's own copy of the species
    if (preferId && !exclude.has(String(preferId))) {
        const id = String(preferId);
        const own = deviceVault.getVinfo(deviceId, id);
        if (own) return { kind: 'own-standin', assetId: id, blob: own };
        if (corpusOk(id)) {
            let t = null; try { t = parseVinfo(corpusVault.getVinfo(id)).assetTypeId; } catch { /* ignore */ }
            if (t === type) return { kind: 'list-standin', assetId: id, blob: corpusVault.getVinfo(id) };
        }
    }
    const ownId = deviceVault.pickForType(deviceId, type, [...exclude]);
    if (ownId) return { kind: 'own-standin', assetId: ownId, blob: deviceVault.getVinfo(deviceId, ownId) };

    // 4) a trusted corpus copy of the species, from a series this device holds (corpusOk).
    //    Sorted so the choice is stable; with the override on, copies from a held series
    //    still come first.
    const candidates = (corpusVault.listByType().get(type) || [])
        .filter(id => !exclude.has(String(id)) && corpusOk(id))
        .sort((a, b) => (ownSeries.has(idSeries(b)) - ownSeries.has(idSeries(a))) || (a < b ? -1 : a > b ? 1 : 0));
    if (candidates.length) {
        const listId = candidates[0];
        const normal = corpusVault.isTrusted(listId) && ownSeries.has(idSeries(listId));
        return {
            kind: normal ? 'list-standin' : 'untrusted-standin',
            assetId: listId, blob: corpusVault.getVinfo(listId),
            // kept so callers/logs can say when the override sent something unproven
            seriesProven: ownSeries.has(idSeries(listId)),
        };
    }
    return { kind: 'none' };
}

// --- one entry per nanovor: fold a stand-in into the real instance -------------------
//
// In the original game the scope's vinfo carried the REAL instance's id, so the client's
// readback resolved straight to it. We cannot sign, so the scope carries a generic file's
// id X while the player's instance has id Y; the client only ever matches X against the
// asset list. Minting X as a second entry duplicated every such nanovor in the collection.
// Instead we give the real instance the scope's id: rename Y -> X, keep everything else.
// The client then finds exactly one nanovor for the scope's vinfo.
//
//   previousAssetIds  ids the instance used to have. The client keeps asking for the old id
//                     for the rest of that session, so findNanovor() honours them.
//   scopeCopy         { deviceId, since, kind } - this instance's id is a file on that scope.
//   pcStats           the instance's stats were earned on the PC; a device import must never
//                     overwrite them (the scope only ever shows the generic file's stats).
//
// Only instances the PC owns outright are folded. An instance imported FROM a scope carries
// that scope's own signed id (vaulted under that device); renaming it would make the next
// import of that scope recreate it as a second entry.

// Look a nanovor up by its current id, then by any id it used to have.
function findNanovor(user, id) {
    const inv = (user && user.nanovorInventory) || [];
    const key = String(id);
    return inv.find(n => String(n.assetId) === key) ||
        inv.find(n => (n.previousAssetIds || []).some(p => String(p) === key)) || null;
}

// The profile's counters follow the collection, not whatever last touched them.
function syncNanovorCounts(user) {
    const inv = user.nanovorInventory || [];
    user.nanovorCount = inv.length;
    user.nanovorCountUnique = new Set(inv.map(n => n.assetTypeId)).size;
}

// Bought/evolved instances have no `source`; imports and adoptions are 'nanoscope'.
const isFoldable = inst => inst.source !== 'nanoscope';

// A server-made generic copy nothing depends on: minted from a corpus file, never supplied
// by any device, not bound to a scope slot. Safe to remove or to replace by a fold.
function isLeftover(entry, { deviceVault, corpusVault }) {
    return entry.source === 'nanoscope' && !entry.scopeCopy &&
        corpusVault.has(entry.assetId) && deviceVault.holders(entry.assetId).length === 0;
}

// What a device import may do to an instance's stats. The device's copy carries the stats as
// jolted on the handheld, so for a device-origin instance it wins - EXCEPT when the instance's
// id is a generic scope file (folded or minted, pcStats): the scope only ever shows the
// file's stats, so the PC's earned stats must not be overwritten. Returns true if applied.
function applyDeviceStats(inst, parsed) {
    if (inst.pcStats) return false;
    Object.assign(inst, { speed: parsed.speed, strength: parsed.strength, armor: parsed.armor, health: parsed.health });
    return true;
}

// A stand-in WE minted as a separate entry earlier (before folding existed) and recorded in
// the ledger as a The List copy. It looks "device-supplied" once an import has vaulted what
// is on the scope, so the vault cannot tell it apart; the ledger can. A stand-in that was
// the device's OWN copy (ledger kind 'own-standin') is a real device nanovor and is not
// replaceable.
function isReplaceableStandIn(entry, ledgerEntry, { corpusVault }) {
    return Boolean(ledgerEntry) && entry.source === 'nanoscope' && !entry.scopeCopy &&
        corpusVault.has(entry.assetId) &&
        String(ledgerEntry.scopeAssetId) === String(entry.assetId) &&
        (ledgerEntry.kind === 'list-standin' || ledgerEntry.kind === 'untrusted-standin');
}

/**
 * Rename the real instance `realId` to the scope file's id `scopeId`.
 * Returns { ok, folded, inst, formerAssetId, removed } or { ok:false, reason }.
 *   - already has that id            -> ok, folded:false
 *   - not foldable (imported)        -> refused
 *   - `scopeId` held by another entry -> refused, unless `canReplace(entry)` says that entry
 *                                        is a leftover, in which case it is removed first
 */
function foldIntoScopeId(user, realId, scopeId, { deviceId = null, kind = null, canReplace = () => false } = {}) {
    const real = findNanovor(user, realId);
    if (!real) return { ok: false, reason: `no nanovor ${realId}` };
    if (String(real.assetId) === String(scopeId)) return { ok: true, folded: false, inst: real };
    if (!isFoldable(real)) return { ok: false, reason: `${real.name} ${real.assetId} was imported from a device and keeps that device's id` };

    const inv = user.nanovorInventory;
    const clash = inv.find(n => n !== real && String(n.assetId) === String(scopeId));
    let removed = null;
    if (clash) {
        if (!canReplace(clash)) return { ok: false, reason: `id ${scopeId} is already held by another nanovor (${clash.name})` };
        inv.splice(inv.indexOf(clash), 1);
        removed = clash;
    }

    const former = String(real.assetId);
    real.previousAssetIds = [...new Set([...(real.previousAssetIds || []).map(String), former])];
    real.assetId = String(scopeId);
    real.scopeCopy = { deviceId: normalizeDeviceId(deviceId), since: new Date().toISOString(), kind };
    real.pcStats = true;
    syncNanovorCounts(user);
    return { ok: true, folded: true, inst: real, formerAssetId: former, removed };
}

// --- device character assets ----------------------------------------------------
//
// /device/characters/<typeId>/{manifest.xml,spr.v2z,nano.snd} are per TYPE. The
// client compares its local manifest.xml with the server's as plain text and
// re-downloads all three files when they differ.

function crc32Hex(buf) {
    return (zlib.crc32(buf) >>> 0).toString(16).padStart(8, '0');
}

// Same shape (and CRLF line endings) as the shipped Characters/<id>/manifest.xml.
function buildCharacterManifest(spriteBuf, soundBuf) {
    return [
        '<Manifest>',
        '  <Assets>',
        '    <Group name="deviceFiles" redundant="false">',
        `      <Asset Id="Animation" Type="V2Z" Filename="spr.v2z" CRC="${crc32Hex(spriteBuf)}" />`,
        `      <Asset Id="Sound" Type="SND" Filename="nano.snd" CRC="${crc32Hex(soundBuf)}" />`,
        '    </Group>',
        '  </Assets>',
        '</Manifest>',
    ].join('\r\n');
}

/**
 * Copy a type's sprite and sound from a device slot into the served
 * Characters tree, but only when that type has none yet. Never overwrites.
 * Returns 'added' | 'present' | 'incomplete' (slot lacks spr.v2z or nano.snd).
 */
function harvestCharacterAssets(slotDir, typeId, charactersRoot) {
    const dest = path.join(charactersRoot, String(typeId));
    if (fs.existsSync(path.join(dest, 'manifest.xml'))) return 'present';

    const sprite = readIfExists(path.join(slotDir, 'spr.v2z'));
    const sound = readIfExists(path.join(slotDir, 'nano.snd'));
    if (!sprite || !sound) return 'incomplete';

    fs.mkdirSync(dest, { recursive: true });
    fs.writeFileSync(path.join(dest, 'spr.v2z'), sprite);
    fs.writeFileSync(path.join(dest, 'nano.snd'), sound);
    fs.writeFileSync(path.join(dest, 'manifest.xml'), buildCharacterManifest(sprite, sound));
    return 'added';
}

module.exports = {
    VINFO_SIZE,
    MAX_DEVICE_NANOVOR,
    normalizeDeviceId,
    parseDeviceId,
    parseJolts,
    parseVinfo,
    parsePlyinfo,
    readDeviceRoot,
    DeviceVault,
    CorpusVault,
    resolveVinfo,
    idSeries,
    deviceSeries,
    findNanovor,
    syncNanovorCounts,
    isFoldable,
    isLeftover,
    isReplaceableStandIn,
    applyDeviceStats,
    foldIntoScopeId,
    buildCharacterManifest,
    harvestCharacterAssets,
    crc32Hex,
};
