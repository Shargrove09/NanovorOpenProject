#!/usr/bin/env node
'use strict';
// Phase 1 automated attack: if the MAC is a standard scheme with a static key
// baked into FRM.BBB, slide a key window across the whole image and test each
// position against real signatures. Hit => key + scheme recovered, no disasm.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const kat = require('./sig-kat');

const SERVER_ROOT = path.resolve(__dirname, '..');
const REPO_ROOT = path.resolve(SERVER_ROOT, '..', '..', '..');
const rd = p => fs.readFileSync(p);
const frm = rd(path.join(REPO_ROOT, 'firmware', 'update', 'FRM.BBB'));
const haystacks = {
    'FRM.BBB': frm,
    'privkey.bbb': rd(path.join(REPO_ROOT, 'firmware', 'update', 'privkey.bbb')),
};

// pick a few probe vectors (fast filter) + full set for confirmation
const vecs = kat.loadVectors().filter(v => v.kind.startsWith('vinfo'));
const probes = vecs.slice(0, 3);
console.log(`key-search over ${Object.keys(haystacks).join(', ')} ; probes=${probes.length} ; full=${vecs.length}`);

// --- AES-CMAC (reused, compact) ---
function ls(b){const o=Buffer.alloc(b.length);let c=0;for(let i=b.length-1;i>=0;i--){const x=b[i];o[i]=((x<<1)|c)&0xff;c=(x>>7)&1;}return o;}
function cmac(key,msg){if(key.length!==16)return null;const Rb=Buffer.alloc(16);Rb[15]=0x87;
 const e=k=>{const c=crypto.createCipheriv('aes-128-ecb',key,Buffer.alloc(0));c.setAutoPadding(false);return Buffer.concat([c.update(k),c.final()]);};
 const L=e(Buffer.alloc(16));let K1=ls(L);if(L[0]&0x80)for(let i=0;i<16;i++)K1[i]^=Rb[i];let K2=ls(K1);if(K1[0]&0x80)for(let i=0;i<16;i++)K2[i]^=Rb[i];
 const n=Math.ceil(msg.length/16)||1;let last;if(msg.length%16===0){last=Buffer.from(msg.subarray((n-1)*16));for(let i=0;i<16;i++)last[i]^=K1[i];}else{const r=msg.subarray((n-1)*16);const p=Buffer.alloc(16);r.copy(p);p[r.length]=0x80;last=p;for(let i=0;i<16;i++)last[i]^=K2[i];}
 let X=Buffer.alloc(16);const c=crypto.createCipheriv('aes-128-ecb',key,Buffer.alloc(0));c.setAutoPadding(false);
 for(let i=0;i<n-1;i++){const y=Buffer.alloc(16);for(let j=0;j<16;j++)y[j]=X[j]^msg[i*16+j];X=c.update(y);}
 const y=Buffer.alloc(16);for(let j=0;j<16;j++)y[j]=X[j]^last[j];return Buffer.concat([c.update(y),c.final()]).subarray(0,16);}
function cbcmac(key,msg){if(key.length!==16)return null;const pad=(16-(msg.length%16))%16;const m=pad?Buffer.concat([msg,Buffer.alloc(pad)]):msg;const c=crypto.createCipheriv('aes-128-cbc',key,Buffer.alloc(16));c.setAutoPadding(false);const o=Buffer.concat([c.update(m),c.final()]);return o.subarray(o.length-16);}

// schemes: [name, keyLen, fn(key,payload)->16B]
const schemes = [
    ['md5(k|p)', 16, (k, p) => crypto.createHash('md5').update(k).update(p).digest()],
    ['md5(p|k)', 16, (k, p) => crypto.createHash('md5').update(p).update(k).digest()],
    ['hmac-md5', 16, (k, p) => crypto.createHmac('md5', k).update(p).digest()],
    ['hmac-sha1[:16]', 16, (k, p) => crypto.createHmac('sha1', k).update(p).digest().subarray(0, 16)],
    ['hmac-sha256[:16]', 16, (k, p) => crypto.createHmac('sha256', k).update(p).digest().subarray(0, 16)],
    ['aes-cmac', 16, cmac],
    ['aes-cbcmac', 16, cbcmac],
    ['md5(k32|p)', 32, (k, p) => crypto.createHash('md5').update(k).update(p).digest()],
    ['hmac-sha1-k32[:16]', 32, (k, p) => crypto.createHmac('sha1', k).update(p).digest().subarray(0, 16)],
];

let found = null;
outer:
for (const [name, klen, fn] of schemes) {
    for (const [hn, hay] of Object.entries(haystacks)) {
        const end = hay.length - klen;
        for (let off = 0; off <= end; off++) {
            const key = hay.subarray(off, off + klen);
            let ok = true;
            for (const v of probes) { const o = fn(key, v.payload); if (!o || !o.equals(v.sig)) { ok = false; break; } }
            if (ok) {
                // confirm full
                const r = kat.check(p => fn(key, p), vecs);
                console.log(`\n*** HIT *** ${name} key@${hn}+0x${off.toString(16)} (${klen}B)  full ${r.matched}/${r.total}`);
                console.log('key hex:', key.toString('hex'));
                found = { name, hn, off, klen };
                if (r.matched === r.total) break outer;
            }
        }
        process.stderr.write(`  scanned ${name} / ${hn}\n`);
    }
}
if (!found) console.log('\nno static-key hit for any tested scheme across FRM.BBB/privkey.bbb.');
