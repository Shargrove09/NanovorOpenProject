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

class CorpusVault {
    constructor(corpusRoot) {
        this.root = corpusRoot;
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
    buildCharacterManifest,
    harvestCharacterAssets,
    crc32Hex,
};
