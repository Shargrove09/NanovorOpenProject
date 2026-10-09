'use strict';

// ---------------------------------------------------------------------------
// Evolution recipes
//
// The real recipes lived only on Smith & Tinker's server - virmon-master.xml
// contains no evolution data at all. But the Nanovor Fandom wiki documented them,
// and its EM notation maps exactly onto em-master.xml's <short-name> values, so
// confirmed recipes can be transcribed here verbatim.
//
//   https://nanovor.fandom.com/wiki/<Nanovor_Name>   e.g. /wiki/Electropod_2.0
//
// HOW TO ADD ONE
//   Look up the nanovor on the wiki. Its page states what it evolves FROM and the
//   ordered EM list. Add an entry keyed by the RESULT's exact name as it appears
//   in virmon-master.xml:
//
//     'Electropod 2.0': { from: 'Electropod 1.0', ems: ['1M1','1M6','1M3','1M2'] },
//
//   Order matters - it IS the puzzle solution. Repeats are allowed and real
//   (e.g. Gamma Stalker 3.0 uses 1M2 and 1M3 twice each).
//
// WHY THIS OVERRIDES THE DERIVED CHAINS
//   evolutionData.js falls back to guessing chains from name stems ("Electropod
//   1.0" -> "Electropod 2.0"). That guess is wrong in ways only real data fixes:
//     * branching    - Mega Scorpion 1.0 evolves into BOTH Mega Scorpion 2.0 and
//                      Megadoom 1.0
//     * faction hops - Megadoom crosses Magnamod -> Velocitron
//     * length       - real recipes run 3-5 EMs, not a fixed 3
//   Anything listed here replaces the guess, including creating edges between
//   different name families. Anything absent keeps the derived fallback so every
//   tree stays populated (an empty tree crashes the client's TreeTile).
// ---------------------------------------------------------------------------

// CONFIRMED from the wiki. Verified: every EM code below resolves against
// em-master.xml short-names.
const RECIPES = {
    'Electropod 2.0':    { from: 'Electropod 1.0',    ems: ['1M1', '1M6', '1M3', '1M2'] },
    'Electrobull 2.0':   { from: 'Electrobull 1.0',   ems: ['1M2', '1M3', '1M1', '1M4'] },
    'Mega Scorpion 2.0': { from: 'Mega Scorpion 1.0', ems: ['1M3', '1M2', '1M1'] },
    'Megadoom 1.0':      { from: 'Mega Scorpion 1.0', ems: ['1M2', '1V4', '1M3', '1M1', '1V6'] },
    'Gamma Stalker 3.0': { from: 'Gamma Stalker 2.0', ems: ['1M3', '1M2', '1M2', '1M3'] },
    'Triton Manta 2.0':  { from: 'Triton Manta 1.0',  ems: ['2H1', '2H2', '2H2'] },
};

module.exports = { RECIPES };
