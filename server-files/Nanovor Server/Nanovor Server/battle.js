'use strict';

// ---------------------------------------------------------------------------
// Combat engine: a faithful port of the decompiled client's BattleLogic
// package to JS, so the server can resolve real battles instead of relaying
// whatever the client sends.
//
// Source of truth throughout (Decompiled Client SWF/SenseiBattleState/scripts/
// com/arkadium/virmon/senseibattle/): battlelogic/BattleLogic.as (1473 lines,
// read in full), battlelogic/nanovor/{BattleLogicNanovor,BattleLogicAttack,
// BattleLogicAttackStatement,BattleLogicConditional,AttackStatementFormula,
// Stat,Faction,AttackActionTypes}.as, battlelogic/player/BattleLogicPlayer.as,
// battlelogic/GameMath.as - all read in full, not summarized. Every function
// below cites the AS3 method it ports. Where the AS3 has a confirmed quirk or
// bug, it is preserved and called out, not "fixed" - the unmodified client
// expects this engine's real behaviour, bugs included.
//
// This same AS3 package runs client-side for offline Sensei battles (never
// serialized) - we have no access to how the original PvP SERVER turned its
// internal Objects into wire JSON. Two fields are reasoned-about, documented
// substitutions for that reason: PlayerRoundInfo.enemy (a raw player object
// reference in the source - emitted here as the opponent's username) and
// gameOver's nmpDiff (never produced by this engine at all - see NMP_DELTA).
// ---------------------------------------------------------------------------

// --- constants (Stat.as / Faction.as / AttackActionTypes.as / BattleLogicAttackStatement.as) ---

const STAT = {
    HEALTH: 'Health', STRENGTH: 'Strength', SPEED: 'Speed', ARMOR: 'Armor',
    ENERGY_GENERATOR: 'Energy Gen', ENERGY: 'Energy',
    SWAP_PERCENTAGE: 'Swap %', DODGE_FAIL_PERCENTAGE: 'Dodge Fail %', STUN_FAIL_PERCENTAGE: 'Stun Fail %',
    OVERRIDE: 'Override', LAST_HACK: 'Last Hack', RANDOM_HACK: 'Random Mod',
    RED_SPIKE: 'RedSpike', BLUE_SPIKE: 'BlueSpike', YELLOW_SPIKE: 'YellowSpike',
};

// 0/1/2 CONFIRMED from Faction.setFaction(int); used by the my/enemy-faction-is conditionals.
const FACTION_BY_CODE = ['Magnamod', 'Velocitron', 'Hexite'];

const STATEMENT_TYPE = { DAMAGE: 'Attack', MOD: 'Mod', HACK: 'Hack', OVERRIDE: 'Override', PASS: 'Pass' };
const TARGET = {
    MY_NANOVOR: 'My active Virmon', ENEMY_NANOVOR: 'Enemy active Virmon',
    MY_TEAM: 'My team', ENEMY_TEAM: 'Enemy team',
    ALL_ACTIVE: 'All active Virmon', ALL_SWARMS: 'All teams',
};

// AttackActionTypes.as: two overlapping code "families" sharing string values by
// design - attackActions entries (NONE..DODGED, 0-8) vs swapActions entries
// (SWAP..FIZZLE, 0-4). Disambiguated by which array a code sits in, not by
// value (e.g. LOW_ENERGY and FIZZLE are both "4"). Preserved as one flat table.
const ACTION = {
    NONE: '0', PASS: '1', DEAD: '2', STUNNED: '3', LOW_ENERGY: '4', TARGET_IS_DEAD: '5',
    NO_ACTIVE_VIRMON: '6', INVALID_ACTION_ID: '7', DODGED: '8',
    SWAP: '0', BLOCK_SWAP: '1', NO_SWAP: '2', NO_ENERGY: '3', FIZZLE: '4',
    ADD_OVERRIDE: '11', REMOVE_OVERRIDE: '12', ADD_HACK: '13', REMOVE_HACK: '14',
    REMOVE_ALL_HACKS: '15', REMOVE_LAST_HACK: '16', SET_ENERGY_LEVEL: '17', MOD_ENERGY_LEVEL: '19',
};

// RECONSTRUCTED: no source anywhere in the decompiled client produces nmpDiff
// (BattleLogic.getPlayerStats/generateGameResults never computes it; neither
// does any other file in this package). A small flat amount, applied at the
// NanoServ.js integration layer, not inside this ported engine.
const NMP_DELTA = { WIN: 10, LOSS: -10, OTHER: 0 };

// --- small helpers (GameMath.as) ------------------------------------------------

const nonNeg = n => (n < 0 ? 0 : n);
const defaultRng = () => Math.random();

// --- formula evaluator (AttackStatementFormula.as) ------------------------------
//
// The AS3 version is a regex-rewrite loop; only the RESULT has to match, so this
// is a real small recursive-descent evaluator over the post-substitution string
// instead (handles the same */+- and parens). Keep the full variable table even
// though an exhaustive grep of all 20,704 lines of decoded master data found
// only $StatementBaseDamage/$MyStrength/$EnemyArmor/$EnemyEnergy are ever used -
// completing the rest is cheap and avoids a rewrite if that ever changes.

// A zeroed stand-in for a missing enemy. AttackStatementFormula.calculateVariable
// does exactly this (`if(_loc6_ == null) { _loc6_ = new BattleLogicNanovor(); }`)
// - a fresh nanovor whose every stat is 0 - so an $Enemy* term against no known
// enemy reads 0 rather than throwing. The AI evaluates formulas with no enemy
// known on round 1, so this path is real, not defensive.
const NULL_NANOVOR = { getModdedStat: () => 0, getStat: () => 0, faction: '', hitPoints: 0, hacks: [] };

function calculateVariable(name, attacker, enemy, statement, rng) {
    if (!enemy) enemy = NULL_NANOVOR;
    const dice = (count, sides) => { let t = 0; for (let i = 0; i < count; i++) t += rng() * sides + 1; return t; };
    switch (name) {
        case '$MyHealth': case '$MyHealthFull': return attacker.getModdedStat(STAT.HEALTH, false);
        case '$MyStrength': return attacker.getModdedStat(STAT.STRENGTH, false);
        case '$MySpeed': return attacker.getModdedStat(STAT.SPEED, false);
        case '$MyArmor': return attacker.getModdedStat(STAT.ARMOR, false);
        case '$MyEnergyGen': return attacker.getModdedStat(STAT.ENERGY_GENERATOR, false);
        case '$MyEnergy': return attacker.getModdedStat(STAT.ENERGY, false);
        case '$MyFactionBonus': return 1; // Faction.calculateFactionBonus - CONFIRMED never referenced by any real attack
        case '$MyCritModifier': return 0;
        case '$MyDamageTakenThisRound': return 0; // no source computes this anywhere in the package
        case '$EnemyHealth': case '$EnemyHealthFull': return enemy.getModdedStat(STAT.HEALTH, false);
        case '$EnemyStrength': return enemy.getModdedStat(STAT.STRENGTH, false);
        case '$EnemySpeed': return enemy.getModdedStat(STAT.SPEED, false);
        case '$EnemyArmor': return enemy.getModdedStat(STAT.ARMOR, false);
        case '$EnemyEnergyGen': return enemy.getModdedStat(STAT.ENERGY_GENERATOR, false);
        case '$EnemyEnergy': return enemy.getModdedStat(STAT.ENERGY, false);
        case '$EnemyFactionBonus': return 1;
        case '$EnemyCritModifier': return 0;
        case '$EnemyDamageTakenThisRound': return 0;
        case '$D4': return dice(1, 4);
        case '$D6': return dice(1, 6);
        case '$D10': return dice(1, 10);
        case '$D20': return dice(1, 20);
        case '$D30': return dice(1, 30);
        case '$D100': return dice(1, 100);
        case '$5D20': return dice(5, 20);
        case '$10D20': return dice(10, 20);
        case '$StatementBaseDamage': return Math.round(evaluateFormula(statement.baseDamageFormula, { attacker, enemy, statement, rng }));
        default: return 0;
    }
}

function substituteVariables(formula, attacker, enemy, statement, rng) {
    return formula.replace(/\$\w+/g, name => String(calculateVariable(name, attacker, enemy, statement, rng)));
}

// Real recursive-descent parser over the fully-substituted numeric expression
// (only digits, '.', '()','*','/','+','-' remain at this point).
function evalExpr(s) {
    let i = 0;
    const peek = () => s[i];
    const number = () => {
        const start = i;
        if (s[i] === '-' || s[i] === '+') i++;
        while (i < s.length && /[\d.]/.test(s[i])) i++;
        return parseFloat(s.slice(start, i));
    };
    const factor = () => {
        while (s[i] === ' ') i++;
        if (peek() === '(') {
            i++;
            const v = addSub();
            while (s[i] === ' ') i++;
            if (peek() === ')') i++;
            return v;
        }
        return number();
    };
    const mulDiv = () => {
        let v = factor();
        for (;;) {
            while (s[i] === ' ') i++;
            if (peek() === '*') { i++; v *= factor(); }
            else if (peek() === '/') { i++; const d = factor(); v = d !== 0 ? v / d : 0; }
            else break;
        }
        return v;
    };
    const addSub = () => {
        let v = mulDiv();
        for (;;) {
            while (s[i] === ' ') i++;
            if (peek() === '+') { i++; v += mulDiv(); }
            else if (peek() === '-') { i++; v -= mulDiv(); }
            else break;
        }
        return v;
    };
    const v = addSub();
    return Number.isFinite(v) ? v : 0;
}

function evaluateFormula(formula, { attacker, enemy, statement, rng = defaultRng }) {
    if (!formula) return 0;
    return evalExpr(substituteVariables(formula, attacker, enemy, statement, rng));
}

// performOperation (AttackStatementFormula.as) - the verb dispatcher used
// everywhere a stat gets mutated.
function performOperation(current, verb, amount) {
    switch (verb) {
        case '*': return current * amount;
        case '/': return amount !== 0 ? current / amount : 0;
        case '+': return current + amount;
        case '-': return current - amount;
        case '=': return amount;
        default: return 0;
    }
}

// --- conditional evaluator (BattleLogicConditional.as) --------------------------
//
// ctx = { isFirstInTurn, isSuccess, attacker, enemy, rng }. Mirrors evaluate()'s
// param order exactly: evaluate(isFirstInTurn, attacker, enemy, isSuccess=true)
// -> evaluateConditional(isFirstInTurn, isSuccess, attacker, enemy).
function evaluateModifier(value, mod, variable) {
    const n = parseInt(variable, 10);
    switch (mod) {
        case '<': return value < n;
        case '<=': return value <= n;
        case '>': return value > n;
        case '>=': return value >= n;
        case '==': return value === n;
        case '!=': return value !== n;
        default: return false;
    }
}

function evaluateConditional(cond, ctx) {
    const { isFirstInTurn, isSuccess, attacker, enemy, rng = defaultRng } = ctx;
    const my = attacker.selectedNanovor, en = enemy.selectedNanovor;
    const name = cond.name; // already lowercased at parse time (evolutionData.js), matching the AS3 constructor

    switch (name) {
        case 'no conditions': return false;
        case 'if enemy dies': return en.hitPoints <= 0;
        case "if i'm first in turn": return isFirstInTurn;
        case "if i'm not first in turn": case "if i'm last in turn": return !isFirstInTurn;
        case 'if my energy is': return evaluateModifier(attacker.energyLevel, cond.mod, cond.value);
        case 'if my health is': return evaluateModifier(my.hitPoints, cond.mod, cond.value);
        case 'if my speed is': return evaluateModifier(my.getModdedStat(STAT.SPEED, isFirstInTurn), cond.mod, cond.value);
        case 'if my strength is': return evaluateModifier(my.getModdedStat(STAT.STRENGTH, isFirstInTurn), cond.mod, cond.value);
        case 'if my armor is': return evaluateModifier(my.getModdedStat(STAT.ARMOR, isFirstInTurn), cond.mod, cond.value);
        case 'if my faction is': {
            const wanted = (FACTION_BY_CODE[parseInt(cond.value, 10)] || '').toLowerCase();
            const mine = (my.faction || '').toLowerCase();
            return cond.mod === '!=' ? mine !== wanted : mine === wanted;
        }
        case 'if enemy first in turn': return !isFirstInTurn;
        case 'if enemy not first in turn': case 'if enemy last in turn': return isFirstInTurn;
        case 'if enemy energy is': return evaluateModifier(enemy.energyLevel, cond.mod, cond.value);
        case 'if enemy health is': return evaluateModifier(en.hitPoints, cond.mod, cond.value);
        case 'if enemy speed is': return evaluateModifier(en.getModdedStat(STAT.SPEED, isFirstInTurn), cond.mod, cond.value);
        case 'if enemy strength is': return evaluateModifier(en.getModdedStat(STAT.STRENGTH, isFirstInTurn), cond.mod, cond.value);
        case 'if enemy armor is': return evaluateModifier(en.getModdedStat(STAT.ARMOR, isFirstInTurn), cond.mod, cond.value);
        case 'if enemy faction is':
            // CONFIRMED source bug (BattleLogicConditional.as ENEMY_FACTION_IS, the
            // "!=" branch): `!_loc8_.faction == Faction.setFaction(...)` - AS3 "!"
            // binds tighter than "==", so this is (!enemyFaction) == wantedFaction,
            // and negating a non-empty String always yields `false`, making the
            // whole branch permanently false. Preserved as-shipped, not "fixed" -
            // confirmed only 2 uses in all of master data, so low impact either way.
            if (cond.mod === '!=') return false;
            return (en.faction || '').toLowerCase() === (FACTION_BY_CODE[parseInt(cond.value, 10)] || '').toLowerCase();
        case 'if random 1-100 is': return evaluateModifier(Math.round(rng() * 100), cond.mod, cond.value);
        case 'if attack failed': return !isSuccess;
        case 'if my redspike is set': return evaluateModifier(my.getModdedStat(STAT.RED_SPIKE, isFirstInTurn), '!=', '0');
        case 'if my redspike is not set': return evaluateModifier(my.getModdedStat(STAT.RED_SPIKE, isFirstInTurn), '==', '0');
        case 'if my bluespike is set': return evaluateModifier(my.getModdedStat(STAT.BLUE_SPIKE, isFirstInTurn), '!=', '0');
        case 'if my bluespike is not set': return evaluateModifier(my.getModdedStat(STAT.BLUE_SPIKE, isFirstInTurn), '==', '0');
        case 'if my yellowspike is set': return evaluateModifier(my.getModdedStat(STAT.YELLOW_SPIKE, isFirstInTurn), '!=', '0');
        case 'if my yellowspike is not set': return evaluateModifier(my.getModdedStat(STAT.YELLOW_SPIKE, isFirstInTurn), '==', '0');
        case 'if enemy redspike is set': return evaluateModifier(en.getModdedStat(STAT.RED_SPIKE, isFirstInTurn), '!=', '0');
        case 'if enemy redspike is not set': return evaluateModifier(en.getModdedStat(STAT.RED_SPIKE, isFirstInTurn), '==', '0');
        case 'if enemy bluespike is set': return evaluateModifier(en.getModdedStat(STAT.BLUE_SPIKE, isFirstInTurn), '!=', '0');
        case 'if enemy bluespike is not set': return evaluateModifier(en.getModdedStat(STAT.BLUE_SPIKE, isFirstInTurn), '==', '0');
        case 'if enemy yellowspike is set': return evaluateModifier(en.getModdedStat(STAT.YELLOW_SPIKE, isFirstInTurn), '!=', '0');
        case 'if enemy yellowspike is not set': return evaluateModifier(en.getModdedStat(STAT.YELLOW_SPIKE, isFirstInTurn), '==', '0');
        // "if my/enemy override contains statementid": validated as a known name by
        // the AS3 constructor but CONFIRMED to have no branch in evaluateConditional
        // at all - always falls through to `return false`. Preserved, not completed.
        default: return false;
    }
}

// doesApply (BattleLogicAttackStatement.as): gates whether THIS USE of a
// statement takes effect. Confirmed quirk: with multiple conditionals, the loop
// re-evaluates and overwrites the result each time - only the LAST one is
// actually honoured, they are not ANDed (real data never has >1 per statement,
// so this rarely matters, but it's what's shipped).
function doesApply(statement, isFirstInTurn, isSuccess, attacker, enemy, rng) {
    if (!statement.conditionals.length) return isSuccess;
    let result = isSuccess;
    for (const c of statement.conditionals) {
        result = evaluateConditional(c, { isFirstInTurn, isSuccess, attacker, enemy, rng });
    }
    return result;
}

// doesApplyThisRound (BattleLogicAttackStatement.as): gates whether an ALREADY
// ACTIVE hack/override still counts THIS round, via round-conditional-N only
// (a distinct mechanic from doesApply's conditional-N). Real AND (short-circuits
// on the first false), isSuccess always true (AS3 default param).
function doesApplyThisRound(statement, isFirstInTurn, attacker, enemy, rng) {
    for (const c of statement.roundConditionals) {
        if (!evaluateConditional(c, { isFirstInTurn, isSuccess: true, attacker, enemy, rng })) return false;
    }
    return true;
}

// --- BattleNanovor (BattleLogicNanovor.as) --------------------------------------

class BattleNanovor {
    // master: a getVirmonMaster() record (base/max stats, buff ladders, attacks).
    // instance: {assetId, speed, strength, armor, health, name, nickname,
    //            productionNumber} - the live nanovorInventory entry's current
    //           (possibly jolted) stats. receiveSwarm (BattleLogic.as:1262-1296)
    //           clones the master template then overwrites exactly these fields -
    //           health doubles as hitPointsTotal, there is no separate max-HP.
    constructor(master, instance) {
        this.assetId = String(instance.assetId);
        this.assetTypeId = master.assetTypeId;
        this.name = instance.name || master.name;
        this.nickName = instance.nickname || '';
        this.faction = master.faction;

        this.armor = instance.armor;
        this.speed = instance.speed;
        this.strength = instance.strength;
        this.hitPoints = instance.health;
        this.hitPointsTotal = instance.health;

        this.dodgeFailPercent = 1;
        this.stunFailPercent = 1;
        this.redSpike = 0;
        this.blueSpike = 0;
        this.yellowSpike = 0;

        this.moddedArmor = this.armor;
        this.moddedSpeed = this.speed;
        this.moddedStrength = this.strength;
        this.moddedHitPoints = this.hitPoints;
        this.moddedDodgeFailPercent = this.dodgeFailPercent;
        this.moddedStunFailPercent = this.stunFailPercent;
        this.moddedRedSpike = 0;
        this.moddedBlueSpike = 0;
        this.moddedYellowSpike = 0;

        this.hacks = [];
        // createPassAttack (BattleLogicNanovor.as): every nanovor gets a synthetic
        // attackId-0 "Pass" move appended, so getAttackByAttackId(0) resolves
        // without a special case.
        this.attacks = [...master.attacks, {
            id: 0, name: 'Pass', type: STATEMENT_TYPE.PASS, cost: 0, conditional: null,
            statements: [{ id: 0, attackId: 0, name: 'Pass', type: STATEMENT_TYPE.PASS, target: TARGET.MY_NANOVOR, stat: '', verb: '', duration: 0, baseDamageFormula: '0', statementFormula: '0', conditionals: [], roundConditionals: [] }],
        }];
        this.selectedAttack = null;

        this.killCount = 0; this.hexiteKillCount = 0; this.magnamodKillCount = 0; this.velocitronKillCount = 0;
        this.deathCount = 0; this.winCount = 0; this.scrapedBy = false; this.lastManStanding = 0;
        this.totalGameDamage = 0; this.maxDamageHit = 0; this.roundsPlayed = 0;
        this.wasUsedByAttackId = new Set();

        this.owner = null;
    }

    // getStat (BattleLogicNanovor.as): the NATURAL value a modded-stat
    // recompute starts from, before hacks/overrides stack onto it.
    getStat(stat) {
        switch (stat) {
            case STAT.HEALTH: return this.hitPoints;
            case STAT.STRENGTH: return this.strength;
            case STAT.SPEED: return this.speed;
            case STAT.ARMOR: return this.armor;
            case STAT.DODGE_FAIL_PERCENTAGE: return this.dodgeFailPercent;
            case STAT.STUN_FAIL_PERCENTAGE: return this.stunFailPercent;
            case STAT.RED_SPIKE: return this.redSpike;
            case STAT.BLUE_SPIKE: return this.blueSpike;
            case STAT.YELLOW_SPIKE: return this.yellowSpike;
            case STAT.ENERGY_GENERATOR: return this.owner.energyGenerator;
            case STAT.ENERGY: return this.owner.energyLevel;
            default: return 0;
        }
    }

    getModdedStat(stat, isFirstInTurn) {
        switch (stat) {
            case STAT.HEALTH: return this.moddedHitPoints;
            case STAT.STRENGTH: return this.moddedStrength;
            case STAT.SPEED: return this.moddedSpeed;
            case STAT.ARMOR: return this.moddedArmor;
            case STAT.DODGE_FAIL_PERCENTAGE: return this.moddedDodgeFailPercent;
            case STAT.STUN_FAIL_PERCENTAGE: return this.moddedStunFailPercent;
            case STAT.RED_SPIKE: return this.moddedRedSpike;
            case STAT.BLUE_SPIKE: return this.moddedBlueSpike;
            case STAT.YELLOW_SPIKE: return this.moddedYellowSpike;
            default: return this.getStat(stat);
        }
    }

    // setModdedStat (BattleLogicNanovor.as): natural value, then every active
    // hack (nanovor-scoped) then every active override (player-scoped, via the
    // owner) that targets this stat and still passes doesApplyThisRound, applied
    // in array order.
    // attacker/enemy here are PLAYERS (matching doesApplyThisRound's own
    // signature - BattleLogicAttackStatement.doesApplyThisRound(isFirstInTurn,
    // attackerPlayer, enemyPlayer)); evaluateFormula needs the NANOVOR each of
    // those players currently has selected (AttackStatementFormula.solve reads
    // statement.currentAttacker.selectedNanovor - doesApplyThisRound is
    // CONFIRMED to stash exactly these same player refs onto the statement
    // immediately beforehand, so .selectedNanovor here is the identical value).
    _setModdedStat(stat, isFirstInTurn, attacker, enemy, rng) {
        let v = this.getStat(stat);
        const myNanovor = attacker.selectedNanovor, enemyNanovor = enemy.selectedNanovor;
        for (const hack of this.hacks) {
            if (hack.stat === stat && doesApplyThisRound(hack, isFirstInTurn, attacker, enemy, rng)) {
                v = performOperation(v, hack.verb, Math.round(evaluateFormula(hack.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: hack, rng })));
            }
        }
        for (const ov of this.owner.overrides) {
            if (ov.stat === stat && doesApplyThisRound(ov, isFirstInTurn, attacker, enemy, rng)) {
                v = performOperation(v, ov.verb, Math.round(evaluateFormula(ov.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: ov, rng })));
            }
        }
        return v;
    }

    resetModdedStats(isFirstInTurn, attacker, enemy, rng) {
        this.moddedArmor = this._setModdedStat(STAT.ARMOR, isFirstInTurn, attacker, enemy, rng);
        this.moddedSpeed = this._setModdedStat(STAT.SPEED, isFirstInTurn, attacker, enemy, rng);
        this.moddedStrength = this._setModdedStat(STAT.STRENGTH, isFirstInTurn, attacker, enemy, rng);
        this.moddedHitPoints = this._setModdedStat(STAT.HEALTH, isFirstInTurn, attacker, enemy, rng);
        this.moddedDodgeFailPercent = this._setModdedStat(STAT.DODGE_FAIL_PERCENTAGE, isFirstInTurn, attacker, enemy, rng);
        this.moddedStunFailPercent = this._setModdedStat(STAT.STUN_FAIL_PERCENTAGE, isFirstInTurn, attacker, enemy, rng);
        this.moddedRedSpike = this._setModdedStat(STAT.RED_SPIKE, isFirstInTurn, attacker, enemy, rng);
        this.moddedBlueSpike = this._setModdedStat(STAT.BLUE_SPIKE, isFirstInTurn, attacker, enemy, rng);
        this.moddedYellowSpike = this._setModdedStat(STAT.YELLOW_SPIKE, isFirstInTurn, attacker, enemy, rng);
    }

    // isDodged/isStunned (BattleLogicNanovor.as): roll must EXCEED the fail%
    // stat to succeed. Default fail% is 1, so dodge/stun never naturally
    // succeed unless a hack/override has pushed the modded fail% below a
    // reachable roll.
    isDodged(attack, isFirstInTurn, rng) {
        if (!attack.statements.some(s => s.target === TARGET.ENEMY_NANOVOR || s.target === TARGET.ENEMY_TEAM)) return false;
        return rng() > this.getModdedStat(STAT.DODGE_FAIL_PERCENTAGE, isFirstInTurn);
    }

    isStunned(isFirstInTurn, rng) {
        return rng() > this.getModdedStat(STAT.STUN_FAIL_PERCENTAGE, isFirstInTurn);
    }

    // addHack (BattleLogicNanovor.as): capped at 5, oldest dropped first.
    addHack(statement) {
        this.hacks.push({ ...statement, currentDuration: statement.duration });
        while (this.hacks.length > 5) this.hacks.shift();
    }

    removeHack(hack) {
        const i = this.hacks.indexOf(hack);
        if (i !== -1) this.hacks.splice(i, 1);
    }

    // removeRandomHack (BattleLogicNanovor.as): CONFIRMED the AS3 never floors
    // this index before splicing (Math.random()*(length-1), no int cast) - JS
    // splice needs an explicit floor to match AS3's truncating Number->int
    // coercion of the splice argument.
    removeRandomHack(rng) {
        if (!this.hacks.length) return -1;
        const i = Math.floor(rng() * (this.hacks.length - 1));
        this.hacks.splice(i, 1);
        return i;
    }

    removeLastHack() {
        return this.hacks.length ? this.hacks.pop() : null;
    }

    getAttackByAttackId(id) {
        return this.attacks.find(a => a.id === id) || this.attacks.find(a => a.id === 0);
    }

    diedInBattle() { this.deathCount = 1; }
    incKillCount() { this.killCount++; }
    incHexiteKillCount() { this.hexiteKillCount++; }
    incMagnamodKillCount() { this.magnamodKillCount++; }
    incVelocitronKillCount() { this.velocitronKillCount++; }
    incRoundsPlayed() { this.roundsPlayed++; }
    addDamageToTotal(n) { this.totalGameDamage += n; }
    setMaxDamageHit(n) { this.maxDamageHit = Math.max(this.maxDamageHit, n); }
    setWinCount(n) { this.winCount = n; }
    setScrapedBy(b) { this.scrapedBy = b; }
    setWasLastManStanding() { this.lastManStanding = 1; }
    setSelectedAttack(a) { this.selectedAttack = a; }
}

// --- BattlePlayer (BattleLogicPlayer.as) ----------------------------------------

class BattlePlayer {
    constructor(userRefId, username, swarm) {
        this.userRefId = String(userRefId);
        this.username = username;
        this.swarm = swarm; // BattleNanovor[]
        for (const n of swarm) n.owner = this;
        this.selectedNanovor = null;
        this.nextNanovor = null;

        this.energyLevel = 2;
        this.energyGenerator = 2;
        this.moddedEnergyGenerator = 2;
        this.swapPercentage = 1;
        this.moddedSwapPercentage = 1;
        this.overrides = [];

        this.enemy = null;
        this.hasQuitGame = false;
        this._isDead = false;
        this.position = 0;
        this.completedGame = false;
        this.hasNewNanovor = false;

        this.killCount = 0; this.totalGameDamage = 0; this.maximumDamage = 0;
        this.hexiteKillCount = 0; this.magnamodKillCount = 0; this.velocitronKillCount = 0;
    }

    setEnergyLevel(n) { this.energyLevel = n < 0 ? 0 : n; }

    setSelectedNanovor(n) {
        this.selectedNanovor = n;
        if (n) { n.setSelectedAttack(null); n.owner = this; }
    }

    setNextNanovor(n) {
        this.nextNanovor = n;
        if (n) n.setSelectedAttack(null);
    }

    // setEnemy(null) (BattleLogicPlayer.as): CONFIRMED sets self, not null -
    // "no target" is represented as enemy === this, not enemy === null.
    // resetEnemy() is the only path that sets a real null.
    setEnemy(player) { this.enemy = player == null ? this : player; }
    resetEnemy() { this.enemy = null; }

    addOverride(statement) { this.overrides.push({ ...statement, currentDuration: statement.duration }); }
    removeOverride() { const removed = this.overrides; this.overrides = []; return removed; }

    get overrideIdsString() { return this.overrides.map(o => o.id).join(','); }

    // resetModdedStats (BattleLogicPlayer.as): energy-generator and swap% are
    // recomputed from the SELECTED NANOVOR's hacks (hacks always live on a
    // nanovor, never the player) plus the player's own overrides, each gated by
    // doesApplyThisRound - additive for energy gen, OVERWRITING (last wins) for
    // swap%, exactly as shipped.
    resetModdedStats(isFirstInTurn, attacker, enemy, rng) {
        // attacker/enemy are PLAYERS; evaluateFormula needs their currently
        // selected NANOVOR - see the matching note on BattleNanovor._setModdedStat.
        const myNanovor = attacker.selectedNanovor, enemyNanovor = enemy.selectedNanovor;
        this.moddedEnergyGenerator = this.energyGenerator;
        const hacks = this.selectedNanovor ? this.selectedNanovor.hacks : [];
        for (const hack of hacks) {
            if (hack.stat === STAT.ENERGY_GENERATOR && doesApplyThisRound(hack, false, attacker, enemy, rng)) {
                this.moddedEnergyGenerator += Math.round(evaluateFormula(hack.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: hack, rng }));
            }
        }
        for (const ov of this.overrides) {
            if (ov.stat === STAT.ENERGY_GENERATOR && doesApplyThisRound(ov, false, attacker, enemy, rng)) {
                this.moddedEnergyGenerator += Math.round(evaluateFormula(ov.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: ov, rng }));
            }
        }

        this.moddedSwapPercentage = this.swapPercentage;
        for (const hack of hacks) {
            if (hack.stat === STAT.SWAP_PERCENTAGE && doesApplyThisRound(hack, false, attacker, enemy, rng)) {
                this.moddedSwapPercentage = Math.round(evaluateFormula(hack.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: hack, rng }));
            }
        }
        for (const ov of this.overrides) {
            if (ov.stat === STAT.SWAP_PERCENTAGE && doesApplyThisRound(ov, false, attacker, enemy, rng)) {
                this.moddedSwapPercentage = Math.round(evaluateFormula(ov.statementFormula, { attacker: myNanovor, enemy: enemyNanovor, statement: ov, rng }));
            }
        }

        if (this.selectedNanovor) this.selectedNanovor.resetModdedStats(isFirstInTurn, attacker, enemy, rng);
    }

    // canSwap (BattleLogicPlayer.as): strictly-less-than roll against modded swap%.
    canSwap(rng) { return rng() < this.moddedSwapPercentage; }

    // isDead (BattleLogicPlayer.as): the WHOLE swarm, not just the active
    // nanovor - a player is only out once every nanovor they own is at 0 HP.
    isDead() {
        if (this.swarm) this._isDead = this.swarm.every(n => n.hitPoints <= 0);
        return this._isDead;
    }

    incKillCount() { this.killCount++; }
    incHexiteKillCount() { this.hexiteKillCount++; }
    incMagnamodKillCount() { this.magnamodKillCount++; }
    incVelocitronKillCount() { this.velocitronKillCount++; }
    addDamageToTotal(n) { this.totalGameDamage += n; }
    setMaximumDamage(n) { this.maximumDamage = Math.max(this.maximumDamage, n); }
    setPosition(n) { if (this.position === 0) this.position = n; }
    setCompletedGame(b) { this.completedGame = b; }
    setHasNewNanovor(b) { this.hasNewNanovor = b; }
}

// --- BattleEngine (BattleLogic.as) ----------------------------------------------

class BattleEngine {
    // sides: [{ userRefId, username, swarm: BattleNanovor[] }, ...]
    constructor(sides, rng = defaultRng) {
        this.rng = rng;
        this.players = sides.map(s => new BattlePlayer(s.userRefId, s.username, s.swarm));
        this.roundCounter = 0;
        this.turnData = new Map(); // userRefId -> ICombatTurnData
        this.roundInfo = null;
        this.attackResults = null;
        this.roundResults = null;
    }

    getPlayerByUserRefId(id) { return this.players.find(p => p.userRefId === String(id)); }
    getPlayerByName(name) { return this.players.find(p => p.username.toLowerCase() === String(name).toLowerCase()); }
    getNanovorByAssetId(id, swarm) { return swarm.find(n => n.assetId === String(id)) || null; }

    // receiveCombatTurnData (BattleLogic.as): stash; once every player has
    // submitted, resolve the round synchronously.
    receiveCombatTurnData(userRefId, data) {
        this.turnData.set(String(userRefId), data);
        if (this.players.every(p => this.turnData.has(p.userRefId))) {
            this.generateRound();
            return true;
        }
        return false;
    }

    // setAttackInfo (BattleLogic.as, internal - not the gameXt command of the
    // same name): resolves each player's selectedNanovor/selectedAttack/
    // nextNanovor/enemy from this round's stashed turn data.
    _applyTurnData() {
        for (const p of this.players) {
            const data = this.turnData.get(p.userRefId);
            const n = this.getNanovorByAssetId(data.MyActiveNanovorId, p.swarm);
            p.setSelectedNanovor(n);
            n.setSelectedAttack(n.getAttackByAttackId(data.AttackId));
            p.setNextNanovor(data.MyNextNanovorId && data.MyNextNanovorId !== '0' ? this.getNanovorByAssetId(data.MyNextNanovorId, p.swarm) : null);
            p.setEnemy(this.getPlayerByName(data.TargetedPlayerName));
        }
    }

    // setRoundPosition (BattleLogic.as:253-319): speed-curved weighted draw,
    // ported verbatim. Confirmed dead candidate-tracking var dropped (never
    // affected the outcome).
    _setRoundPosition() {
        const pool = [...this.players];
        const order = [];
        let totalSpeed = 0;
        for (const p of pool) {
            p.speed = 1;
            if (p.selectedNanovor) {
                p.speed = Math.max(1, p.selectedNanovor.getModdedStat(STAT.SPEED, false));
                p.curvePercent = 0;
                p.speedCurved = 0;
                totalSpeed += p.speed;
            }
        }
        for (const p of pool) {
            p.initiativeRoll = this.rng();
            p.speedCurved = Math.pow(p.speed / totalSpeed, 2);
        }
        while (pool.length > 0) {
            const sumCurved = pool.reduce((s, p) => s + p.speedCurved, 0);
            let cumulative = 0;
            for (const p of pool) {
                p.curvePercent = p.speedCurved / sumCurved;
                cumulative += p.curvePercent;
                if (p.initiativeRoll <= cumulative || pool.length < 2) {
                    order.push(p);
                    pool.splice(pool.indexOf(p), 1);
                    break;
                }
            }
        }
        return order;
    }

    // resetPlayerAndNanovorStats (BattleLogic.as): recompute every living
    // player's modded stats, each using THEIR OWN first-in-turn-ness (not the
    // attacker's - this runs for all players, repeatedly, through a round).
    _resetAllModdedStats() {
        for (const p of this.players) {
            if (p.isDead() || p.hasQuitGame) continue;
            const isFirstInTurn = this.players.indexOf(p) === 0;
            const enemyOrSelf = p.enemy || p;
            p.resetModdedStats(isFirstInTurn, p, enemyOrSelf, this.rng);
        }
    }

    // isOverrideAttack (BattleLogic.as)
    _isOverrideAttack(attack) { return attack.statements.some(s => s.type === STATEMENT_TYPE.OVERRIDE); }

    // addHack / addOverride (BattleLogic.as): route a statement to whichever
    // nanovor/player its <target> names.
    _addHack(attacker, enemy, attack, statement) {
        const result = { attackerHacks: null, enemyHacks: null };
        if (statement.type !== STATEMENT_TYPE.HACK) return result;
        let hitEnemy = false, hitMine = false;
        if (statement.target === TARGET.ENEMY_NANOVOR || statement.target === TARGET.ENEMY_TEAM) {
            enemy.selectedNanovor.addHack(statement); hitEnemy = true;
        } else if (statement.target === TARGET.MY_NANOVOR || statement.target === TARGET.MY_TEAM) {
            attacker.selectedNanovor.addHack(statement); hitMine = true;
        } else { // ALL_ACTIVE / ALL_SWARMS
            enemy.selectedNanovor.addHack(statement); hitEnemy = true;
            attacker.selectedNanovor.addHack(statement); hitMine = true;
        }
        if (hitMine) result.attackerHacks = getHacksObject(attacker.selectedNanovor);
        if (hitEnemy) result.enemyHacks = getHacksObject(enemy.selectedNanovor);
        return result;
    }

    _addOverride(attacker, enemy, statement) {
        if (statement.type !== STATEMENT_TYPE.OVERRIDE) return;
        if (statement.target === TARGET.ENEMY_NANOVOR || statement.target === TARGET.ENEMY_TEAM) {
            enemy.addOverride(statement);
        } else if (statement.target === TARGET.MY_NANOVOR || statement.target === TARGET.MY_TEAM) {
            attacker.addOverride(statement);
        } else {
            enemy.addOverride(statement);
            attacker.addOverride(statement);
        }
    }

    // setPlayerStats (BattleLogic.as:1425-1455): damage/kill bookkeeping, only
    // called from the HEALTH branch of calculateAttack.
    _setPlayerStats(attacker, targetNanovor, damage) {
        attacker.addDamageToTotal(damage);
        attacker.setMaximumDamage(damage);
        attacker.selectedNanovor.addDamageToTotal(damage);
        attacker.selectedNanovor.setMaxDamageHit(damage);
        if (targetNanovor.hitPoints <= 0) {
            targetNanovor.diedInBattle();
            if (targetNanovor.owner.userRefId !== attacker.userRefId) {
                attacker.incKillCount();
                attacker.selectedNanovor.incKillCount();
                if (targetNanovor.faction === 'Hexite') { attacker.incHexiteKillCount(); attacker.selectedNanovor.incHexiteKillCount(); }
                else if (targetNanovor.faction === 'Magnamod') { attacker.incMagnamodKillCount(); attacker.selectedNanovor.incMagnamodKillCount(); }
                else if (targetNanovor.faction === 'Velocitron') { attacker.incVelocitronKillCount(); attacker.selectedNanovor.incVelocitronKillCount(); }
            }
        }
    }

    // setPlayerPosition (BattleLogic.as:564-593): assigns a finishing position
    // the instant a player's last nanovor dies, filling from the pool size down.
    _setPlayerPosition(player) {
        if (player.position > 0) return;
        let pos = this.players.length;
        for (const p of this.players) {
            if (p.position > 0) pos = Math.min(pos, p.position - 1);
        }
        player.setPosition(pos);
    }

    getActivePlayers() { return this.players.filter(p => !p.isDead() && !p.hasQuitGame); }

    // calculateAttack (BattleLogic.as:922-1196): resolves one statement's
    // effect against its target list, pushing one or more action-response
    // objects. Ported branch-for-branch, including the confirmed fallthrough:
    // RedSpike/BlueSpike/YellowSpike statements hit no Stat.* branch at all, so
    // they fall to the final "type==Override && !handled" catch-all, which
    // pushes a generic ADD_OVERRIDE response (not a stat-specific one, and not
    // nothing - this corrects an earlier, less careful reading).
    _calculateAttack(statement, actions, isFirstInTurn, attacker, enemy) {
        const stat = statement.stat, verb = statement.verb;
        let targets = [], targetingEnemy = true, allPlayers = false;
        if (statement.target === TARGET.MY_NANOVOR) { targets = [attacker.selectedNanovor]; targetingEnemy = false; }
        else if (statement.target === TARGET.ENEMY_NANOVOR) { targets = [enemy.selectedNanovor]; }
        else if (statement.target === TARGET.MY_TEAM) { targets = [attacker.selectedNanovor]; targetingEnemy = false; }
        else if (statement.target === TARGET.ENEMY_TEAM) { targets = [enemy.selectedNanovor]; }
        else if (statement.target === TARGET.ALL_ACTIVE) { targets = [enemy.selectedNanovor, attacker.selectedNanovor]; allPlayers = true; }
        else if (statement.target === TARGET.ALL_SWARMS) { targets = [attacker.selectedNanovor, enemy.selectedNanovor]; allPlayers = true; }

        for (const targetNanovor of targets) {
            // Two distinct numbers travel through the rest of this loop body,
            // exactly as in calculateAttack's _loc9_/_loc10_: `resultValue`
            // (the stat's new/modded value, becomes the response's .value) and
            // `amount` (the rounded formula result/delta, becomes .totalDamage).
            // They are NOT the same number except for plain Mod/Attack
            // STRENGTH/ARMOR/SPEED, where a fresh stat happens to equal its own
            // delta only coincidentally never - keep them separate.
            // evaluateFormula needs nanovor, not players - performAttack sets
            // statement.currentAttacker/currentEnemy to these same two players
            // right before calculateAttack runs, and solve() reads
            // .selectedNanovor off of exactly those; .selectedNanovor here is
            // the identical value without the stateful indirection.
            let amount = statement.statementFormula != null
                ? Math.round(evaluateFormula(statement.statementFormula, { attacker: attacker.selectedNanovor, enemy: enemy.selectedNanovor, statement, rng: this.rng }))
                : 0;
            let resultValue = amount;
            let handled = false;
            const isHackOrOverride = statement.type === STATEMENT_TYPE.HACK || statement.type === STATEMENT_TYPE.OVERRIDE;

            if (stat === STAT.HEALTH) {
                if (amount < 0) amount = 0;
                const hp = nonNeg(performOperation(targetNanovor.hitPoints, verb, amount));
                targetNanovor.hitPoints = hp;
                resultValue = hp;
                handled = true;
                this._setPlayerStats(attacker, targetNanovor, amount);
                if (targetNanovor.owner.isDead() && !targetNanovor.owner.hasQuitGame) {
                    this._setPlayerPosition(targetNanovor.owner);
                    targetNanovor.owner.setCompletedGame(true);
                }
            } else if (stat === STAT.STRENGTH) {
                if (isHackOrOverride) resultValue = targetNanovor.getModdedStat(STAT.STRENGTH, isFirstInTurn);
                else { targetNanovor.strength = nonNeg(performOperation(targetNanovor.strength, verb, amount)); resultValue = targetNanovor.strength; }
                handled = true;
            } else if (stat === STAT.ARMOR) {
                if (isHackOrOverride) resultValue = targetNanovor.getModdedStat(STAT.ARMOR, isFirstInTurn);
                else { targetNanovor.armor = nonNeg(performOperation(targetNanovor.armor, verb, amount)); resultValue = targetNanovor.armor; }
                handled = true;
            } else if (stat === STAT.SPEED) {
                if (isHackOrOverride) resultValue = targetNanovor.getModdedStat(STAT.SPEED, isFirstInTurn);
                else { targetNanovor.speed = nonNeg(performOperation(targetNanovor.speed, verb, amount)); resultValue = targetNanovor.speed; }
                handled = true;
            } else if (stat === STAT.SWAP_PERCENTAGE || stat === STAT.DODGE_FAIL_PERCENTAGE || stat === STAT.STUN_FAIL_PERCENTAGE) {
                // CONFIRMED: no setter is ever called for these even when the
                // statement is plain Mod/Attack type - the natural value never
                // changes, only the modded one (via the hack/override itself,
                // already recorded by _addHack/_addOverride). Real data only
                // ever uses Hack/Override for these three stats anyway.
                if (isHackOrOverride) resultValue = 0;
                handled = true;
            }

            amount = Math.round(amount);
            if (handled) {
                const responseTarget = targetingEnemy ? targetNanovor.owner : attacker;
                actions.push(prepareClientDescription(
                    setAttackResponseObject(responseTarget, statement.id, statement.type, stat, verb, resultValue, amount), statement, amount));
            }

            if (stat === STAT.ENERGY) {
                if (allPlayers) {
                    for (const p of this.players) {
                        p.setEnergyLevel(nonNeg(performOperation(p.energyLevel, verb, amount)));
                        actions.push(prepareClientDescription(setAttackResponseObject(p, statement.id, ACTION.MOD_ENERGY_LEVEL, stat, verb, p.energyLevel, amount), statement, amount));
                    }
                } else {
                    const p = targetingEnemy ? targetNanovor.owner : attacker;
                    p.setEnergyLevel(nonNeg(performOperation(p.energyLevel, verb, amount)));
                    actions.push(prepareClientDescription(setAttackResponseObject(p, statement.id, ACTION.MOD_ENERGY_LEVEL, stat, verb, p.energyLevel, amount), statement, amount));
                }
            }

            if (stat === STAT.OVERRIDE) {
                const pushRemoveOverride = (p) => {
                    p.removeOverride();
                    const resp = setActionResponseObject(p, ACTION.REMOVE_OVERRIDE);
                    resp.attackStatementId = String(statement.id);
                    actions.push(prepareClientDescription(resp, statement, amount));
                };
                if (allPlayers) this.players.forEach(pushRemoveOverride);
                else pushRemoveOverride(targetingEnemy ? targetNanovor.owner : attacker);
            }

            if (stat === STAT.RANDOM_HACK) {
                const pushRemoveHack = (p, idx) => {
                    const resp = setActionResponseObject(p, ACTION.REMOVE_HACK, null, idx);
                    resp.attackStatementId = String(statement.id);
                    actions.push(prepareClientDescription(resp, statement, amount));
                };
                const idx = targetNanovor.removeRandomHack(this.rng);
                if (allPlayers) this.players.forEach(p => pushRemoveHack(p, idx));
                else pushRemoveHack(targetingEnemy ? targetNanovor.owner : attacker, idx);
            }

            if (stat === STAT.LAST_HACK) {
                targetNanovor.removeLastHack();
                const pushRemoveLastHack = (p) => {
                    const resp = setActionResponseObject(p, ACTION.REMOVE_LAST_HACK);
                    resp.attackStatementId = String(statement.id);
                    actions.push(prepareClientDescription(resp, statement, amount));
                };
                if (allPlayers) this.players.forEach(pushRemoveLastHack);
                else pushRemoveLastHack(targetingEnemy ? targetNanovor.owner : attacker);
            }

            // Spike flags and anything else Override-typed that hit none of the
            // branches above (handled stays false): generic ADD_OVERRIDE.
            if (statement.type === STATEMENT_TYPE.OVERRIDE && !handled) {
                const p = targetingEnemy ? targetNanovor.owner : attacker;
                const resp = setActionResponseObject(p, ACTION.ADD_OVERRIDE);
                resp.attackStatementId = String(statement.id);
                actions.push(resp);
            }
        }
        return actions;
    }

    // performAttack (BattleLogic.as:63-230): one player's turn this round.
    _performAttack(attacker, enemy) {
        const isFirstInTurn = this.players.indexOf(attacker) === 0;
        const myNanovor = attacker.selectedNanovor, enemyNanovor = enemy ? enemy.selectedNanovor : null;
        const response = {
            attacker: attacker.username, attackerId: attacker.userRefId,
            attackerNanovorId: myNanovor.assetId, attackerNanovorAssetId: myNanovor.assetTypeId,
            attackId: myNanovor.selectedAttack.id,
        };
        let actions = [];
        const attack = myNanovor.selectedAttack;
        myNanovor.wasUsedByAttackId.add(attack.id);
        this._resetAllModdedStats();
        // _loc10_ (BattleLogic.as): true by default, false ONLY for Pass and
        // target-already-dead - FIZZLE/stunned/dodged all still leave it true,
        // so the final resetPlayerAndNanovorStats() below still runs for them.
        let resolved = true;

        if (attack.id === 0) {
            actions.push(setActionResponseObject(null, ACTION.PASS));
            resolved = false;
        } else if (!enemyNanovor || enemyNanovor.hitPoints <= 0) {
            actions.push(setActionResponseObject(attacker, ACTION.TARGET_IS_DEAD));
            resolved = false;
        } else if (attacker.energyLevel < attack.cost) {
            actions.push(setActionResponseObject(attacker, ACTION.FIZZLE));
        } else if (!enemyNanovor.isDodged(attack, isFirstInTurn, this.rng) && !myNanovor.isStunned(isFirstInTurn, this.rng)) {
            let isSuccess = true;
            if (attack.conditional) isSuccess = evaluateConditional(attack.conditional, { isFirstInTurn, isSuccess: true, attacker, enemy, rng: this.rng });
            let costCharged = false;
            if (this._isOverrideAttack(attack) && isSuccess) attacker.removeOverride();

            for (const statement of attack.statements) {
                this._resetAllModdedStats();
                // The AS3 has what reads as an outer gate here
                // (`_loc11_ || !_loc11_ && _loc14_.conditionals != null`), but
                // `conditionals` is a `new Array()` in the constructor - never
                // literally null, even when empty - so that condition is a
                // tautology (always true). The real filter is this one: a
                // statement is only considered when the attack-level conditional
                // passed, OR the statement specifically has an "if attack failed"
                // conditional of its own (the fallback-on-failure pattern, e.g.
                // attack 170 Frost's "FAIL 30 DAM").
                const hasAttackFailedConditional = statement.conditionals.some(c => c.name === 'if attack failed');
                if (!(isSuccess || hasAttackFailedConditional)) continue;

                const hasDeathConditional = statement.conditionals.some(c => c.name === 'if enemy dies' || c.name === 'if i die');
                const applies = hasDeathConditional ? true : doesApply(statement, isFirstInTurn, isSuccess, attacker, enemy, this.rng);
                const hacksInfo = this._addHack(attacker, enemy, attack, statement);
                if (hacksInfo.attackerHacks || hacksInfo.enemyHacks) response.hacksInfo = hacksInfo;
                this._addOverride(attacker, enemy, statement);

                if (applies) {
                    let shouldResolve = hasDeathConditional ? enemyNanovor.hitPoints === 0 : true;
                    if (myNanovor.selectedAttack.cost > attacker.energyLevel) shouldResolve = false;
                    if (shouldResolve) {
                        costCharged = true;
                        actions = this._calculateAttack(statement, actions, isFirstInTurn, attacker, enemy);
                    }
                }
            }

            if (costCharged) {
                response.attackId = String(myNanovor.selectedAttack.id);
                response.attackCost = String(myNanovor.selectedAttack.cost);
                attacker.setEnergyLevel(nonNeg(attacker.energyLevel - myNanovor.selectedAttack.cost));
                response.energyLevel = String(attacker.energyLevel);
            }
        } else if (myNanovor.isStunned(isFirstInTurn, this.rng)) {
            actions.push(setActionResponseObject(attacker, ACTION.STUNNED));
        } else {
            actions.push(setActionResponseObject(enemy, ACTION.DODGED));
            response.attackCost = String(myNanovor.selectedAttack.cost);
            attacker.setEnergyLevel(nonNeg(attacker.energyLevel - myNanovor.selectedAttack.cost));
            response.energyLevel = String(attacker.energyLevel);
        }

        if (actions.length === 0) actions.push(setActionResponseObject(attacker, ACTION.FIZZLE));
        response.attackActions = actions;
        if (resolved) this._resetAllModdedStats();
        return response;
    }

    // checkHacks (BattleLogic.as:812-898): per living player, tick duration on
    // their active nanovor's hacks, expire any that hit 0, and report both the
    // remaining hacks and (for the player, not the expiring nanovor) the plain
    // stat the expiry restored to - plus the next-round nanovor's own hacks.
    _checkHacks(player) {
        const remaining = [], statChanges = [], expired = [];
        const nextNanovor = player.nextNanovor, current = player.selectedNanovor;
        for (const hack of current.hacks) {
            if (hack.type !== STATEMENT_TYPE.HACK) continue;
            hack.currentDuration -= 1;
            if (hack.currentDuration <= 0) { hack.currentDuration = 0; expired.push(hack); }
            else remaining.push(prepareHackInfo(hack, current));
        }
        for (const hack of expired) {
            current.removeHack(hack);
            if (!nextNanovor && [STAT.STRENGTH, STAT.ARMOR, STAT.SPEED, STAT.HEALTH].includes(hack.stat)) {
                statChanges.push(`${hack.stat}|${current.getModdedStat(hack.stat, false)}`);
            }
        }
        if (nextNanovor) {
            for (const hack of nextNanovor.hacks) {
                if (hack.type === STATEMENT_TYPE.HACK) remaining.push(prepareHackInfo(hack, nextNanovor));
            }
        }
        return { userRefId: player.userRefId, remainingHacks: remaining, statChanges };
    }

    // finishRound (BattleLogic.as:673-731): swap resolution (canSwap() rolled
    // BEFORE the energy check - a blocked roll never even looks at energy),
    // then the per-round energy-generator tick.
    _finishRound() {
        const swapActions = [];
        for (const p of this.players) {
            if (!p.selectedNanovor) continue;
            p.selectedNanovor.incRoundsPlayed();
            if (p.isDead()) continue;

            if (p.nextNanovor && p.selectedNanovor.hitPoints > 0) {
                const hasEnergy = p.energyLevel - 0 >= 0; // SWAP_COST is hardcoded 0 in the shipped client
                if (p.canSwap(this.rng)) {
                    if (hasEnergy) {
                        p.setSelectedNanovor(p.nextNanovor);
                        swapActions.push(setSwapResponseObject(p, ACTION.SWAP));
                    } else {
                        swapActions.push(setSwapResponseObject(p, ACTION.NO_ENERGY));
                    }
                } else {
                    swapActions.push(setSwapResponseObject(p, ACTION.BLOCK_SWAP));
                }
            } else {
                swapActions.push(setSwapResponseObject(p, ACTION.NO_SWAP));
            }
            p.resetEnemy();
            p.setNextNanovor(null);
            p.setEnergyLevel(p.energyLevel + p.moddedEnergyGenerator);
        }
        return swapActions;
    }

    // setRoundInfo (BattleLogic.as:450-529): one PlayerRoundInfo per living,
    // non-quit player. oldNanovor is CONFIRMED always null - its source lookup
    // dictionary is freshly (re-)created empty on every call to this same
    // function, so the lookup can never find anything; this isn't a missing
    // feature, it's a structural guarantee in the decompiled build.
    _buildRoundInfo() {
        const out = [];
        for (const p of this.players) {
            if (p.isDead() || p.hasQuitGame) continue;
            const info = {
                hasNewNanovor: p.hasNewNanovor,
                username: p.username,
                userRefId: p.userRefId,
                energyLevel: p.energyLevel,
                // Confirmed required by the *consumer* of this same players[]
                // array in its roundResults role (BattleController.
                // handleRoundCompleted, PlayerStats fields) even though
                // RoundInfoPlayer itself never reads them - PlayerRoundInfo is
                // reused verbatim for both roundInfo.players and
                // roundResults.players (generateRound), so both readers' field
                // needs apply here.
                energyGenerator: p.energyGenerator,
                moddedEnergyGenerator: p.moddedEnergyGenerator,
                swapPercentage: p.swapPercentage,
                moddedSwapPercentage: p.moddedSwapPercentage,
            };
            p.setHasNewNanovor(false);
            // enemy (DOCUMENTED SUBSTITUTION): the AS3 assigns the raw opposing
            // BattleLogicPlayer object here, which only makes sense for an
            // in-process (never-serialized) consumer - this package's only other
            // user is the offline Sensei battle, which never goes over the wire.
            // The original PvP server's actual JSON encoding of this field isn't
            // in any decompiled client file. Emitting the opponent's username
            // matches the convention used everywhere else in this same codebase
            // (ICombatTurnData.TargetedPlayerName, getPlayerByName) for naming a
            // player over the wire.
            if (p.enemy) info.enemy = p.enemy.username;
            if (p.overrides.length > 0) { info.overrideId = p.overrides[0].id; info.overrideIds = p.overrideIdsString; }

            const n = p.selectedNanovor;
            this._resetAllModdedStats();
            info.selectedNanovor = {
                name: n.name, nickname: n.nickName, instanceId: n.assetId, assetTypeId: n.assetTypeId,
                swapChance: p.moddedSwapPercentage,
                stunFailChance: n.getModdedStat(STAT.STUN_FAIL_PERCENTAGE, false),
                dodgeChance: n.getModdedStat(STAT.DODGE_FAIL_PERCENTAGE, false),
                armor: n.getModdedStat(STAT.ARMOR, false),
                speed: n.getModdedStat(STAT.SPEED, false),
                strength: n.getModdedStat(STAT.STRENGTH, false),
                health: n.getModdedStat(STAT.HEALTH, false),
                hacks: getHacksObject(n),
            };
            info.oldNanovor = null;
            info.swarmSize = p.swarm.length;
            out.push(info);
        }
        return out;
    }

    // generateRound (BattleLogic.as:382-448): the per-round orchestration.
    generateRound() {
        this._applyTurnData();
        this._resetAllModdedStats();
        this.players = this._setRoundPosition();

        this.roundInfo = { players: this._buildRoundInfo(), roundCounter: ++this.roundCounter };

        this.attackResults = [];
        for (const p of this.players) {
            if (p.hasQuitGame || p.isDead() || p.selectedNanovor.hitPoints <= 0) continue;
            this.attackResults.push(this._performAttack(p, p.enemy));
        }

        const hacks = [];
        for (const p of this.players) {
            if (p.isDead() || p.hasQuitGame) continue;
            hacks.push(this._checkHacks(p));
        }

        const swapActions = this._finishRound();
        this._resetAllModdedStats();
        this.roundResults = { swapActions, players: this._buildRoundInfo(), hacks };

        this.turnData.clear();
    }

    getRound() { return { roundInfo: this.roundInfo, attackResults: this.attackResults, roundResults: this.roundResults }; }

    // calculateNanovorResults (BattleLogic.as:330-362): per-nanovor win/scrape/
    // last-man-standing flags, for the single player at position 1 (the winner).
    _calculateNanovorResults() {
        const winner = this.players.find(p => p.position === 1 && !p.hasQuitGame && p.swarm);
        if (!winner) return;
        const survivors = [];
        for (const n of winner.swarm) {
            n.setWinCount(1);
            if (n.hitPoints > 0 && n.hitPoints < Math.round(n.hitPointsTotal * 0.1)) n.setScrapedBy(true);
            if (n.hitPoints > 0) survivors.push(n);
        }
        if (survivors.length === 1) survivors[0].setWasLastManStanding();
    }

    getPlayerStats(player) {
        return {
            userRefId: player.userRefId,
            totalDamage: String(player.totalGameDamage),
            maxDamage: String(player.maximumDamage),
            totalNanovorKilled: String(player.killCount),
            position: String(player.position),
        };
    }

    // generateGameResults / getGameOver (BattleLogic.as:1198-1413): game-over
    // condition is "fewer than 2 active players remain" (last swarm standing;
    // works for N>2). Returns null until then.
    generateGameResults() {
        const result = {};
        const results = [];
        let finishedCount = 0;
        for (const p of this.players) {
            const active = this.getActivePlayers();
            if ((p.completedGame || !p.hasQuitGame) && active.length < 2) {
                if (p.position === 0) { p.setPosition(1); result.winnerId = p.userRefId; }
                finishedCount++;
            }
        }
        for (const p of this.players) {
            const active = this.getActivePlayers();
            if ((p.completedGame || !p.hasQuitGame) && active.length < 2) results.push(this.getPlayerStats(p));
        }
        this._calculateNanovorResults();
        if (!results.length) return null;
        result.results = results;
        return result;
    }

    getGameOver() { return this.generateGameResults(); }
}

// --- wire response builders (BattleLogic.as) ------------------------------------

function setActionResponseObject(player, type, verb = null, value = -1) {
    const obj = {
        targetUsername: player ? player.username : '0',
        targetUserRefId: player ? player.userRefId : '0',
        targetNanovorId: player ? player.selectedNanovor.assetId : '0',
        targetNanovorAssetTypeId: player ? String(player.selectedNanovor.assetTypeId) : '0',
        type,
    };
    if (verb != null) obj.verb = verb;
    if (value !== -1) obj.value = String(value);
    obj.targetUpdates = getTargetUpdates(player);
    return obj;
}

// setAttackResponseObject (BattleLogic.as:900-920)
function setAttackResponseObject(player, statementId, statementType, statName, verb, value, damage) {
    let type;
    if (statementType === STATEMENT_TYPE.OVERRIDE) type = ACTION.ADD_OVERRIDE;
    else if (statementType === STATEMENT_TYPE.DAMAGE || statementType === STATEMENT_TYPE.MOD) type = ACTION.NONE;
    else if (statementType === STATEMENT_TYPE.HACK) type = ACTION.ADD_HACK;
    const obj = setActionResponseObject(player, type, verb, value);
    obj.attackStatementId = String(statementId);
    obj.statName = statName;
    obj.totalDamage = String(damage);
    return obj;
}

function setSwapResponseObject(player, type = null) {
    const obj = {};
    if (player.nextNanovor) { obj.newInstanceId = player.nextNanovor.assetId; obj.newAssetTypeId = player.nextNanovor.assetTypeId; }
    if (type != null) {
        obj.type = type; obj.userRefId = player.userRefId;
        obj.instanceId = player.selectedNanovor.assetId; obj.assetTypeId = player.selectedNanovor.assetTypeId;
    }
    return obj;
}

// getTargetUpdates (BattleLogic.as:751-805): natural AND modded values, unlike
// PlayerRoundInfo (modded only).
function getTargetUpdates(player) {
    if (!player) return { noTarget: 'true' };
    const out = {
        username: player.username, userRefId: player.userRefId,
        energyLevel: player.energyLevel, energyGenerator: player.energyGenerator,
        swapChance: player.swapPercentage,
        moddedEnergyGenerator: player.moddedEnergyGenerator, moddedSwapChance: player.moddedSwapPercentage,
    };
    if (player.overrides.length > 0) { out.overrideId = player.overrides[0].id; out.overrideIds = player.overrideIdsString; }
    out.hasNewNanovor = player.hasNewNanovor;
    if (player.hasNewNanovor) { out.newNanoAssetId = player.nextNanovor.assetId; out.newNanoAssetTypeId = player.nextNanovor.assetTypeId; }

    const n = player.selectedNanovor;
    out.selectedNanovor = {
        name: n.nickName, instanceId: n.assetId, assetTypeId: n.assetTypeId,
        health: n.hitPoints, stunFailChance: n.stunFailPercent, dodgeChance: n.dodgeFailPercent,
        armor: n.armor, speed: n.speed, strength: n.strength,
        moddedStunFailChance: n.getModdedStat(STAT.STUN_FAIL_PERCENTAGE, false),
        moddedDodgeChance: n.getModdedStat(STAT.DODGE_FAIL_PERCENTAGE, false),
        moddedArmor: n.getModdedStat(STAT.ARMOR, false),
        moddedSpeed: n.getModdedStat(STAT.SPEED, false),
        moddedStrength: n.getModdedStat(STAT.STRENGTH, false),
        yellowSpike: n.yellowSpike, redSpike: n.redSpike, blueSpike: n.blueSpike,
        moddedYellowSpike: n.getModdedStat(STAT.YELLOW_SPIKE, false),
        moddedRedSpike: n.getModdedStat(STAT.RED_SPIKE, false),
        moddedBlueSpike: n.getModdedStat(STAT.BLUE_SPIKE, false),
        hacks: getHacksObject(n),
    };
    return out;
}

function getHacksObject(nanovor) {
    return (nanovor.hacks || []).map(h => ({ statementId: String(h.id), currentDuration: String(h.currentDuration), totalDuration: String(h.duration) }));
}

function prepareHackInfo(statement, nanovor) {
    return { attackId: statement.attackId, statementId: statement.id, nanovorInstanceId: nanovor.assetId };
}

// prepareClientDescription (BattleLogicAttackStatement.as:277-309): only
// Armor/Energy/Health/Speed/Strength (plus the Remove-verb case) get a short
// description; everything else (spikes, swap%, dodge/stun fail%) is "".
function prepareClientDescription(responseObj, statement, value) {
    let desc = '';
    if (statement.verb && statement.stat) {
        if (statement.verb === 'Remove') desc = `${statement.verb} ${statement.stat}`;
        else if (statement.stat === STAT.ARMOR) desc = `${statement.verb}${value} ARM`;
        else if (statement.stat === STAT.ENERGY || statement.stat === STAT.ENERGY_GENERATOR) desc = `${statement.verb}${value} EN`;
        else if (statement.stat === STAT.HEALTH) desc = `${statement.verb}${value} DAM`;
        else if (statement.stat === STAT.SPEED) desc = `${statement.verb}${value} SPD`;
        else if (statement.stat === STAT.STRENGTH) desc = `${statement.verb}${value} STR`;
    }
    responseObj.statementClientDescription = desc;
    return responseObj;
}

module.exports = {
    STAT, FACTION_BY_CODE, STATEMENT_TYPE, TARGET, ACTION, NMP_DELTA,
    evaluateFormula, evaluateConditional, performOperation, doesApply, doesApplyThisRound,
    BattleNanovor, BattlePlayer, BattleEngine,
};
