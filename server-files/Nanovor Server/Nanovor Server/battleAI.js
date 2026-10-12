'use strict';

// ---------------------------------------------------------------------------
// Sensei AI: a port of the decompiled client's move-selection logic, so the
// server can play a real opponent instead of needing a second human.
//
// Source of truth (Decompiled Client SWF/SenseiBattleState/scripts/com/arkadium/
// virmon/senseibattle/ai/, all read in full): SenseiAICrappy.as (per-turn
// entry point), SenseiAIMoveGenerator.as (expected-damage model, active-nanovor
// and attack selection), SenseiNanovor.as (the per-attack expected-damage
// maths, including the hardcoded named-statement tables), PatienceAttackGenerator.as
// ("save energy for a bigger hit from another nanovor" planning).
//
// Two adaptations, both behaviour-preserving:
//
//  * The AS3 stores a mutable `expectedDamage` ON each IAttack and an
//    `overallExpectedDamage` on each nanovor. Here those live in side tables
//    keyed by nanovor/attack instead, because this server shares one parsed
//    attack object across every nanovor of a type and across concurrent
//    battles - writing scratch values onto it would leak between them.
//
//  * SenseiNanovor is a thin decorator over the client's INanovor (every stat
//    getter just delegates), so this works directly on battle.js's
//    BattleNanovor/BattlePlayer rather than reproducing that wrapper.
//
// Difficulty is CONFIRMED to be roster composition only - there is no
// difficulty branching anywhere in the AI itself. sensei-players.xml holds the
// rosters (Training/-5, two hidden duplicate Easy entries/-1/-2, Easy/-3,
// Medium/-4); there is no Hard tier in any copy of that file.
// ---------------------------------------------------------------------------

const fs = require('fs');
const path = require('path');
const { STAT, STATEMENT_TYPE, TARGET, evaluateFormula, BattleNanovor } = require('./battle');
const { getVirmonMaster } = require('./evolutionData');

// SenseiAIMoveGenerator.as: fixed horizon used by the expected-damage model.
const REMAINING_ROUNDS = 14;
// hasPatience(): `PATIENCE_RATING >= uint(Math.random()*100)` with
// PATIENCE_RATING = 100 and the roll in 0..99 - CONFIRMED always true. Kept as
// the real expression (and it still consumes an rng value) rather than
// hardcoding `true`, so behaviour and rng consumption both stay faithful.
const PATIENCE_RATING = 100;
// PatienceAttackGenerator.as: how many rounds of saving up the AI will consider.
const STRATEGIC_PLANNING = 3;

const nonNeg = n => (n < 0 ? 0 : n);

// --- roster -----------------------------------------------------------------

let rosterCache = null;

// sensei-players.xml: <player name userRefId show><swarm><nanovor assetTypeId assetId/>...
function loadRoster(baseDir) {
    if (rosterCache) return rosterCache;
    const file = path.join(baseDir, 'Manifests', 'Assets', 'Client', 'sensei-players.xml');
    const xml = fs.readFileSync(file, 'utf8');
    const out = [];
    const re = /<player\s+name="([^"]*)"\s+userRefId="(-?\d+)"\s+show="([^"]*)"\s*>([\s\S]*?)<\/player>/g;
    let m;
    while ((m = re.exec(xml)) !== null) {
        const swarm = [...m[4].matchAll(/<nanovor\s+assetTypeId="(\d+)"\s+assetId="([^"]*)"\s*\/>/g)]
            .map(s => ({ assetTypeId: parseInt(s[1], 10), assetId: s[2] }));
        out.push({ name: m[1].trim(), userRefId: m[2], revealed: m[3] === 'true', swarm });
    }
    rosterCache = out;
    return out;
}

function getSenseiRoster(baseDir, userRefId) {
    return loadRoster(baseDir).find(p => p.userRefId === String(userRefId)) || null;
}

// Build a roster entry's swarm as real BattleNanovor at their type's base
// stats. A sensei's nanovor aren't owned by any account, so unlike a player's
// swarm there is no instance row to read current/jolted stats from.
function buildSenseiSwarm(baseDir, roster) {
    return roster.swarm.map(entry => {
        const master = getVirmonMaster(baseDir, entry.assetTypeId);
        if (!master) throw new Error(`sensei roster references unknown asset-type-id ${entry.assetTypeId}`);
        return new BattleNanovor(master, {
            assetId: entry.assetId, name: master.name, nickname: '',
            speed: master.baseSpeed, strength: master.baseStrength,
            armor: master.baseArmor, health: master.baseHealth,
        });
    });
}

// --- expected-damage model (SenseiNanovor.as) --------------------------------

function isDamageAttack(statement) {
    return statement.type === STATEMENT_TYPE.DAMAGE
        && statement.stat === STAT.HEALTH
        && (statement.target === TARGET.ENEMY_NANOVOR || statement.target === TARGET.ENEMY_TEAM);
}

// isArmorPiercingAttackStatement: a pure name check in the source ("70 DAM AP").
const isArmorPiercing = statement => statement.name.indexOf('AP') !== -1;

// Magnamod > Velocitron > Hexite > Magnamod
function isFactionAdvantage(myFaction, enemyFaction) {
    return (myFaction === 'Magnamod' && enemyFaction === 'Velocitron')
        || (myFaction === 'Velocitron' && enemyFaction === 'Hexite')
        || (myFaction === 'Hexite' && enemyFaction === 'Magnamod');
}

class SenseiAI {
    // player / enemyPlayer are battle.js BattlePlayer instances.
    constructor(player, enemyPlayer, rng = Math.random) {
        this.player = player;
        this.enemyPlayer = enemyPlayer;
        this.rng = rng;
        this.senseiSwarm = player.swarm;
        this.enemySwarm = [];
        this.enemyNanovor = null;
        this.selectedNanovor = null;
        this.osoed = NaN;
        // side tables standing in for IAttack.expectedDamage /
        // ISenseiNanovor.overallExpectedDamage (see header).
        this._ed = new Map();        // nanovor -> Map<attackId, number>
        this._overallEd = new Map(); // nanovor -> number
    }

    _edTable(nanovor) {
        if (!this._ed.has(nanovor)) this._ed.set(nanovor, new Map());
        return this._ed.get(nanovor);
    }

    ed(nanovor, attack) { return this._edTable(nanovor).get(attack.id) ?? 0; }
    _edSet(nanovor, attack, v) { this._edTable(nanovor).set(attack.id, v); }
    _edAdd(nanovor, attack, v) { this._edSet(nanovor, attack, this.ed(nanovor, attack) + v); }
    overallEd(nanovor) { return this._overallEd.get(nanovor) ?? 0; }

    _formula(which, statement, me, enemy) {
        return Math.round(evaluateFormula(statement[which], { attacker: me, enemy, statement, rng: this.rng }));
    }

    // calculateDamageAttackExpectedDamage: the base hit, weighted by the
    // faction match-up. The three blends read as expected values over a
    // hit/crit/graze spread; they are reproduced exactly, not simplified.
    _damageAttackED(me, enemy, attack, statement) {
        if (enemy == null) {
            this._edAdd(me, attack, this._formula('baseDamageFormula', statement, me, null));
            return true;
        }
        const d = this._formula('baseDamageFormula', statement, me, enemy);
        if (me.faction === enemy.faction) this._edAdd(me, attack, d * 0.85 + d * 2 * 0.1 + d * 0.25 * 0.5);
        else if (isFactionAdvantage(me.faction, enemy.faction)) this._edAdd(me, attack, d * 0.75 + d * 2 * 0.24);
        else this._edAdd(me, attack, d * 0.84 + d * 2 * 0.01 + d * 0.25 * 0.15);
        if (isArmorPiercing(statement)) this._edAdd(me, attack, -enemy.getModdedStat(STAT.ARMOR, false));
        return true;
    }

    // calculateHackED / calculateModED / calculateOverrideED: hardcoded tables
    // keyed on the exact attack-statement name. Only the names listed here get
    // a non-damage valuation at all; everything else is worth 0 to the AI.
    // `dmg` is NaN unless the statement is of the matching type - that NaN
    // deliberately propagates into the sums below, exactly as it does in AS3.
    _hackED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd) {
        const dmg = statement.type === STATEMENT_TYPE.HACK ? this._formula('statementFormula', statement, me, enemy) : NaN;
        const en = me.owner.energyLevel, gen = me.owner.energyGenerator;
        const enemyArmor = enemy.getModdedStat(STAT.ARMOR, false);
        const add = v => this._edAdd(me, attack, v);
        switch (statement.name) {
            case 'Chance ARM -15 50% (3R)':
                if (enemyArmor >= 15) { add(remainingRounds * 15 < 45 ? (dmg + remainingRounds * 15) / 2 : (dmg + 45) / 2); return true; }
                add(remainingRounds < 3 ? (dmg + (15 - enemyArmor) * remainingRounds) / 2 : (dmg + (15 - enemyArmor) * 3) / 2);
                return true;
            case 'Opp ARM -5 (2R)':
                add(enemyArmor >= 5 ? dmg + 10 : dmg + (5 - enemyArmor) * 2);
                return true;
            case 'Opp ARM -10 (5R)':
                if (enemyArmor >= 10) add(remainingRounds * 10 < 50 ? dmg + remainingRounds * 10 : dmg + 50);
                else add(remainingRounds < 5 ? dmg + (10 - enemyArmor) * remainingRounds : dmg + (10 - enemyArmor) * 5);
                return true;
            case 'STR +5 (10R)':
                add(dmg + 10 * (remainingRounds - 1) / enemyLiving);
                return true;
            case 'If Opp Mag, STR +25 (3R)':
                if (!Number.isNaN(swarmEd)) {
                    add(attack.cost > en
                        ? swarmEd * 1.25 * (remainingRounds - (attack.cost - en) / gen + 1)
                        : swarmEd * 1.25 * ((remainingRounds - 1) / 3 * 2));
                    return true;
                }
                break;
            case 'If first, STR +15 (2R)':
                if (!Number.isNaN(swarmEd)) {
                    const ratio = me.hitPoints / enemySwarmEd;
                    add(ratio < 2
                        ? dmg + this.overallEd(me) * 1.15 * ratio / 2
                        : dmg + this.overallEd(me) * 1.15 * 2 / 2);
                    return true;
                }
                break;
        }
        return false;
    }

    _modED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd) {
        const dmg = statement.type === STATEMENT_TYPE.MOD ? this._formula('statementFormula', statement, me, enemy) : NaN;
        const add = v => this._edAdd(me, attack, v);
        switch (statement.name) {
            case 'Opp ARM -5 (Mod)': add(dmg + 5 * (remainingRounds - 1) / enemyLiving); return true;
            case 'Opp ARM -10 (Mod)': add(dmg + 10 * (remainingRounds - 1) / enemyLiving); return true;
            case 'If not first, Me +25 STR (Mod)':
                if (!Number.isNaN(swarmEd)) {
                    const ratio = me.hitPoints / enemySwarmEd;
                    add(ratio < remainingRounds / 4
                        ? dmg + this.overallEd(me) * 1.25 * ratio / 2
                        : dmg + this.overallEd(me) * 1.15 * (remainingRounds / 2) / 2);
                    return true;
                }
                break;
            case 'Me STR +10 (Mod)':
                if (!Number.isNaN(enemySwarmEd)) {
                    const ratio = me.hitPoints / enemySwarmEd;
                    add(remainingRounds < ratio
                        ? dmg + this.overallEd(me) * 1.1 * remainingRounds
                        : dmg + this.overallEd(me) * 1.1 * ratio);
                    return true;
                }
                break;
        }
        return false;
    }

    _overrideED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd) {
        const en = me.owner.energyLevel, gen = me.owner.energyGenerator;
        const add = v => this._edAdd(me, attack, v);
        // Every "STR +N (OR)" case shares this shape: the override's value is
        // amortised over how many rounds it will be up for, and costs more
        // rounds to reach if it isn't affordable yet.
        const amortised = (multiplier, divisor = 1, scale = 1) => {
            const rounds = attack.cost > en
                ? (remainingRounds - (attack.cost - en) / gen + 1)
                : (remainingRounds - 1);
            return swarmEd * multiplier * (rounds / divisor) * scale;
        };
        switch (statement.name) {
            case 'STR +10 (OR)': if (!Number.isNaN(swarmEd)) { add(amortised(1.1)); return true; } break;
            case 'STR +15 (OR)': if (!Number.isNaN(swarmEd)) { add(amortised(1.15)); return true; } break;
            case 'STR +20 (OR)': if (!Number.isNaN(swarmEd)) { add(amortised(1.2)); return true; } break;
            case 'If Opp is Hex, +25 STR (OR)': if (!Number.isNaN(swarmEd)) { add(amortised(1.25, 3)); return true; } break;
            case 'If Opp is not Mag, STR +25 (OR)': if (!Number.isNaN(swarmEd)) { add(amortised(1.25, 3, 2)); return true; } break;
            case 'If HTH<40, STR +50 (OR)':
                if (!Number.isNaN(swarmEd)) { add(swarmEd * 1.5 * (enemyLiving * (40 / enemySwarmEd))); return true; }
                break;
            case 'If HTH<80, STR +25 (OR)':
                if (!Number.isNaN(swarmEd)) { add(swarmEd * 1.25 * (enemyLiving * (80 / enemySwarmEd))); return true; }
                break;
            case 'If Mag and last, STR +25 (OR)':
                if (!Number.isNaN(swarmEd)) { add(swarmEd * 1.25 * (remainingRounds / 3 * 0.5)); return true; }
                break;
        }
        return false;
    }

    // calculateOverallExpectedDamage: reset every attack's ED, score each
    // statement, then average across the attacks that scored anything.
    // CONFIRMED quirk: the "did anything score" flag is function-scoped and
    // never reset per attack, so once one attack scores, every later attack is
    // counted in the average too. Preserved.
    _calculateOverall(me, enemy, remainingRounds, enemyLiving, swarmEd, enemySwarmEd) {
        if (me.hitPoints <= 0) { this._overallEd.set(me, 0); return; }
        for (const attack of me.attacks) this._edSet(me, attack, 0);

        let scoredAny = false;
        const scored = [];
        for (const attack of me.attacks) {
            for (const statement of attack.statements) {
                if (isDamageAttack(statement)) {
                    scoredAny = this._damageAttackED(me, enemy, attack, statement);
                } else if (enemy != null) {
                    const h = this._hackED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd);
                    const m = this._modED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd);
                    scoredAny = scoredAny || h;
                    scoredAny = scoredAny || m;
                }
            }
            if (scoredAny) scored.push(attack);
        }

        let total = 0;
        for (const attack of scored) total += this.ed(me, attack);
        const avg = total / scored.length;
        this._overallEd.set(me, nonNeg(Number.isNaN(avg) ? 0 : avg));
    }

    // calculateRemainingExpectedDamage: layers override (and a second pass of
    // mod) valuations on top. Its own local accumulators are dead in the
    // source - the real effect is the ED mutations these calls perform.
    _calculateRemaining(me, enemy, remainingRounds, enemyLiving, swarmEd, enemySwarmEd) {
        if (me.hitPoints <= 0 || me.attacks.length === 0) return;
        for (const attack of me.attacks) {
            for (const statement of attack.statements) {
                this._overrideED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd);
                if (enemy != null) this._modED(me, enemy, attack, statement, remainingRounds, enemyLiving, swarmEd, enemySwarmEd);
            }
        }
    }

    // calculateExpectedDamages: score my swarm, then (if an enemy is known)
    // re-score theirs to get the opposing swarm's total, then layer the
    // override/mod valuations on mine.
    _calculateExpectedDamages() {
        let senseiLiving = 0, enemyLiving = 0;
        for (const n of this.senseiSwarm) if (n.hitPoints > 0) senseiLiving++;
        for (const n of this.enemySwarm) if (n.hitPoints > 0) enemyLiving++;

        // CONFIRMED: the running total starts as NaN and is only normalised
        // AFTER the first nanovor is scored, so the first call genuinely sees NaN.
        let swarmEd = NaN;
        for (const n of this.senseiSwarm) {
            this._calculateOverall(n, this.enemyNanovor, REMAINING_ROUNDS, enemyLiving, swarmEd, this.osoed);
            swarmEd = Number.isNaN(swarmEd) ? 0 : swarmEd;
            swarmEd += this.overallEd(n);
        }
        this.osoed = swarmEd;

        if (this.enemyNanovor != null) {
            this.osoed = 0;
            for (const n of this.enemySwarm) {
                // NaN for both trailing args here is faithful - the source passes
                // an unassigned local, so the enemy pass has no swarm totals.
                this._calculateOverall(n, this.selectedNanovor, REMAINING_ROUNDS, senseiLiving, NaN, NaN);
                this.osoed += this.overallEd(n);
            }
        }

        for (const n of this.senseiSwarm) {
            this._calculateRemaining(n, this.enemyNanovor, REMAINING_ROUNDS, enemyLiving, swarmEd, this.osoed);
        }
    }

    // --- patience planning (PatienceAttackGenerator.as) ----------------------

    // Attacks the swarm cannot currently afford, with how much more energy each needs.
    _selectHEDAttacks() {
        const out = [];
        for (const n of this.senseiSwarm) {
            if (n.hitPoints <= 0) continue;
            for (const attack of n.attacks) {
                if (attack.cost > n.owner.energyLevel) {
                    out.push({ attack, needEnergy: attack.cost - n.owner.energyLevel, nanovor: n });
                }
            }
        }
        return out;
    }

    // findAED: how good a plan "use this affordable attack now, save toward
    // that expensive one" is, averaged over the rounds it takes to get there.
    // The named-statement cases adjust the energy maths for moves that
    // generate energy themselves.
    _findAED(nanovor, attack, activeNanovor, hed, enemy) {
        let needEnergy = hed.needEnergy;
        const hedAttack = hed.attack;
        let surplus = activeNanovor.owner.energyLevel - attack.cost;
        let needRounds = 0;
        let noOverride = true;

        // CONFIRMED: the "die" cases compare the ENEMY's health against this
        // attack's expected damage - i.e. "will this finish them" - despite
        // "If Me die" reading the other way round. Preserved as shipped.
        const finishesEnemy = () => enemy != null && enemy.hitPoints < this.ed(nanovor, attack);
        for (const st of attack.statements) {
            if (st.type !== STATEMENT_TYPE.MOD) continue;
            switch (st.name) {
                case 'EN +2 (Mod)': needEnergy -= 2; break;
                case 'EN +3 (Mod)': needEnergy -= 3; break;
                case 'EN x2 (Mod)': {
                    // "am I likely to die this round" - my HP vs how hard they hit.
                    const threat = enemy != null ? this.overallEd(enemy) : this.osoed;
                    if (nanovor.hitPoints < threat) needEnergy -= 2 * activeNanovor.owner.energyLevel;
                    break;
                }
                case 'If Me die, EN +10 (Mod)': if (finishesEnemy()) needEnergy -= 10; break;
                case 'If Opp die, EN +2 (Mod)': if (finishesEnemy()) needEnergy -= 2; break;
                case 'If Opp die, EN +3 (Mod)': if (finishesEnemy()) needEnergy -= 3; break;
                case 'If Opp die, EN +4 (Mod)': if (finishesEnemy()) needEnergy -= 4; break;
                case 'If Opp die, EN +5 (Mod)': if (finishesEnemy()) needEnergy -= 5; break;
            }
        }

        const hedFaction = hed.nanovor.faction;
        for (const st of attack.statements) {
            if (st.type !== STATEMENT_TYPE.OVERRIDE) continue;
            switch (st.name) {
                case 'EN GEN +1 (OR)': surplus += 1; break;
                case 'If Hex +1 EN Gen (OR)':
                    if (nanovor.faction === 'Hexite' && hedFaction === 'Hexite') surplus += 1;
                    else if (nanovor.faction === 'Hexite') surplus += 0.75;
                    else if (hedFaction === 'Hexite') surplus += 0.25;
                    break;
                case 'If Mag +1 EN Gen (OR)':
                    if (nanovor.faction === 'Magnamod' && hedFaction === 'Magnamod') surplus += 1;
                    else if (nanovor.faction === 'Magnamod') surplus += 0.75;
                    else if (hedFaction === 'Magnamod') surplus += 0.25;
                    break;
                case 'If Mag +2 EN Gen (OR)':
                    if (nanovor.faction === 'Magnamod' && hedFaction === 'Magnamod') surplus += 2;
                    else if (nanovor.faction === 'Magnamod') surplus += 1.5;
                    else if (hedFaction === 'Magnamod') surplus += 0.5;
                    break;
            }
            needRounds = surplus === 0 ? 0 : Math.ceil(needEnergy / surplus + 1);
            noOverride = false;
        }

        hed.needEnergy = needEnergy;
        if (noOverride) needRounds = surplus === 0 ? 0 : Math.ceil(needEnergy / surplus);
        if (nanovor.assetId !== activeNanovor.assetId) needRounds += 1;

        let averageED = 0;
        if (needRounds <= STRATEGIC_PLANNING) {
            averageED = (this.ed(hed.nanovor, hedAttack) + this.ed(nanovor, attack) * needRounds) / (needRounds + 1);
            averageED = averageED < 0 || Number.isNaN(averageED) ? 0 : Math.round(averageED);
        }
        return { nanovor, attack, needEnergy, needRounds, surplusEnergy: surplus, averageED };
    }

    // selectPatienceAttack: pick the highest-ED unaffordable target (HED), then
    // the best affordable move to make while saving for it (LED).
    _selectPatienceAttack(activeNanovor) {
        const hedList = this._selectHEDAttacks();
        hedList.sort((a, b) => {
            const ea = this.ed(a.nanovor, a.attack), eb = this.ed(b.nanovor, b.attack);
            if (ea > eb) return -1;
            if (ea < eb) return 1;
            if (a.needEnergy > b.needEnergy) return 1;
            if (a.needEnergy < b.needEnergy) return -1;
            return 0;
        });

        let best = null;
        for (let i = 0; i < hedList.length; i++) {
            const hed = hedList[i];
            const consider = (candidate) => {
                if (best == null) { if (candidate.averageED > 0) best = candidate; }
                else if (best.averageED < candidate.averageED) best = candidate;
            };
            for (const attack of activeNanovor.attacks) {
                if (attack.cost <= activeNanovor.owner.energyLevel) consider(this._findAED(activeNanovor, attack, activeNanovor, hed, this.enemyNanovor));
            }
            // The source also evaluates a blank Attack here - "do nothing this
            // round and just bank the energy" as an explicit option.
            consider(this._findAED(activeNanovor, { id: 0, cost: 0, statements: [] }, activeNanovor, hed, this.enemyNanovor));

            for (const attack of hed.nanovor.attacks) {
                if (attack.cost <= activeNanovor.owner.energyLevel) consider(this._findAED(hed.nanovor, attack, activeNanovor, hed, this.enemyNanovor));
            }
            if (best != null) return { led: best, hed };
        }
        return { led: best, hed: hedList[hedList.length] };
    }

    // --- selection (SenseiAIMoveGenerator.as) --------------------------------

    _hasPatience() { return PATIENCE_RATING >= Math.trunc(this.rng() * 100); }

    // selectActiveNanovor: keep the current nanovor while it lives; otherwise
    // take whichever living swarm member holds the single best affordable
    // attack, falling back to whichever holds the cheapest attack at all.
    selectActiveNanovor(current) {
        if (current != null) {
            for (let i = 0; i < this.senseiSwarm.length; i++) {
                if (this.senseiSwarm[i].assetId === current.assetId) {
                    this.senseiSwarm[i] = current;
                    this.selectedNanovor = current;
                    break;
                }
            }
            if (this.selectedNanovor && this.selectedNanovor.hitPoints > 0) return;
        }
        this._calculateExpectedDamages();

        let bestNanovor = null, bestAttack = null;
        if (this.senseiSwarm.length === 1 && this.senseiSwarm[0].hitPoints > 0) {
            bestNanovor = this.senseiSwarm[0];
        } else {
            for (const n of this.senseiSwarm) {
                if (n.hitPoints <= 0) continue;
                for (const attack of n.attacks) {
                    const affordable = attack.cost <= n.owner.energyLevel;
                    if (bestAttack == null) {
                        if (affordable) { bestNanovor = n; bestAttack = attack; }
                    } else if (this.ed(n, attack) > this.ed(bestNanovor, bestAttack) && affordable) {
                        bestNanovor = n; bestAttack = attack;
                    }
                }
            }
        }

        if (bestNanovor == null) {
            for (const n of this.senseiSwarm) {
                if (n.hitPoints <= 0) continue;
                for (const attack of n.attacks) {
                    if (bestAttack == null) { bestNanovor = n; bestAttack = attack; }
                    else if (attack.cost < bestAttack.cost) { bestNanovor = n; bestAttack = attack; }
                }
            }
        }
        this.selectedNanovor = bestNanovor;
    }

    // selectAttack: a lethal finisher if one is affordable, otherwise the
    // swarm's best move - and if that best move lives on a different nanovor
    // or can't be paid for, consider being patient instead.
    selectAttack() {
        this._calculateExpectedDamages();
        const active = this.selectedNanovor;
        const energy = active.owner.energyLevel;
        let chosen = null;
        let swapAssetId = null;

        if (this.enemyNanovor != null) {
            for (const attack of active.attacks) {
                if (chosen == null) {
                    if (attack.cost <= energy && this.ed(active, attack) >= this.enemyNanovor.hitPoints * 1.2) chosen = attack;
                } else if (attack.cost < chosen.cost && this.ed(active, attack) >= this.ed(active, chosen)) {
                    // CONFIRMED: this replacement checks neither affordability
                    // nor the lethal threshold again - preserved as shipped.
                    chosen = attack;
                }
            }
        }

        let activeHoldsBest = true;
        if (chosen == null) {
            // Best attack on the active nanovor, ignoring cost entirely here.
            for (const attack of active.attacks) {
                if (chosen == null) chosen = attack;
                else if (this.ed(active, chosen) < this.ed(active, attack)) chosen = attack;
            }
            // ...then: does anyone else in the swarm hold something better?
            for (const n of this.senseiSwarm) {
                if (n.hitPoints <= 0) continue;
                let broke = false;
                for (const attack of n.attacks) {
                    if (this.ed(n, attack) > this.ed(active, chosen)) { activeHoldsBest = false; chosen = null; broke = true; break; }
                }
                if (broke) break;
            }
        }

        if (activeHoldsBest === false || chosen.cost > energy) {
            chosen = null;
            if (this._hasPatience()) {
                const { led, hed } = this._selectPatienceAttack(active);
                if (led != null) {
                    for (const attack of active.attacks) {
                        if (chosen == null) { if (attack.cost <= energy) chosen = attack; }
                        else if (this.ed(active, chosen) < this.ed(active, attack) && attack.cost <= energy) chosen = attack;
                    }
                    if (chosen != null) {
                        const bestNow = this.ed(active, chosen);
                        if (led.averageED > bestNow) {
                            if (led.nanovor.assetId === active.assetId) {
                                chosen = led.attack;
                                if (hed && hed.nanovor.assetId !== active.assetId) {
                                    const projected = active.owner.energyLevel + active.owner.energyGenerator - led.attack.cost;
                                    if (projected >= hed.needEnergy) swapAssetId = hed.nanovor.assetId;
                                }
                            } else {
                                for (const attack of active.attacks) {
                                    if (chosen == null) { if (attack.cost < energy) chosen = attack; }
                                    else if (this.ed(active, chosen) < this.ed(active, attack) && attack.cost < energy) chosen = attack;
                                    else if (this.ed(active, chosen) === this.ed(active, attack) && attack.cost < chosen.cost) chosen = attack;
                                }
                                swapAssetId = led.nanovor.assetId;
                            }
                        }
                    }
                }
            }
        }

        if (chosen == null) {
            for (const attack of active.attacks) {
                if (chosen == null) { if (attack.cost <= energy) chosen = attack; }
                else if (this.ed(active, chosen) < this.ed(active, attack) && attack.cost <= energy) chosen = attack;
            }
            // Blank Attack fallback in the source - nothing affordable at all,
            // so Pass (attack id 0, which every nanovor carries).
            if (chosen == null) chosen = active.getAttackByAttackId(0);
        }

        return { attackId: chosen.id, swapAssetId };
    }

    // setRound (SenseiAICrappy.as): refresh what the AI knows about the
    // opposing side after a round resolves - its current nanovor, and the
    // running list of everything it has seen. Deliberately NOT fed from the
    // human's submitted turn data: the real AI only ever learns from resolved
    // rounds, and seeding it earlier would hand it information the original
    // never had.
    setRound() {
        const enemyActive = this.enemyPlayer.hasNewNanovor && this.enemyPlayer.nextNanovor
            ? this.enemyPlayer.nextNanovor
            : this.enemyPlayer.selectedNanovor;
        if (!enemyActive) return;
        if (!this.enemySwarm.some(n => n.assetId === enemyActive.assetId)) this.enemySwarm.push(enemyActive);
        this.enemyNanovor = enemyActive;
    }

    // getCombatTurnData: the ICombatTurnData the engine expects, with the "0"
    // sentinel for "not swapping" (never null/absent - confirmed contract).
    getCombatTurnData() {
        this.selectActiveNanovor(this.player.selectedNanovor);
        const { attackId, swapAssetId } = this.selectAttack();
        return {
            AttackId: attackId,
            AttackData: null,
            MyActiveNanovorId: this.selectedNanovor.assetId,
            MyNextNanovorId: swapAssetId != null ? swapAssetId : '0',
            TargetedPlayerName: this.enemyPlayer.username,
        };
    }
}

module.exports = { SenseiAI, loadRoster, getSenseiRoster, buildSenseiSwarm, REMAINING_ROUNDS };
