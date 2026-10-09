package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IPlayerStats;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   
   public class AbstractSenseiNanovor implements ISenseiNanovor
   {
      
      protected var _overallEnergyDamage:Number;
      
      protected var _nanovor:INanovor;
      
      public function AbstractSenseiNanovor(param1:INanovor)
      {
         super();
         _nanovor = param1;
      }
      
      public function get previousDodgeFailPercent() : Number
      {
         return _nanovor.previousDodgeFailPercent;
      }
      
      public function get previousRedSpike() : int
      {
         return _nanovor.previousRedSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         _nanovor.moddedBlueSpike = param1;
      }
      
      public function set moddedSpeed(param1:int) : void
      {
         _nanovor.moddedSpeed = param1;
      }
      
      public function get faction() : String
      {
         return _nanovor.faction;
      }
      
      public function get assetId() : String
      {
         return _nanovor.assetId;
      }
      
      public function get moddedStunFailPercent() : Number
      {
         return _nanovor.moddedStunFailPercent;
      }
      
      public function get stunFailPercent() : Number
      {
         return _nanovor.stunFailPercent;
      }
      
      public function get baseStrength() : int
      {
         return _nanovor.baseStrength;
      }
      
      public function get previousHealth() : int
      {
         return _nanovor.previousHealth;
      }
      
      public function calculateOverallExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void
      {
         throw new Error("AbstractSenseiNanovor::calculateNOED() must be implemented in subclasses.");
      }
      
      public function get previousStunFailPercent() : Number
      {
         return _nanovor.previousStunFailPercent;
      }
      
      public function get playerStats() : IPlayerStats
      {
         return _nanovor.playerStats;
      }
      
      public function addStatHistory() : void
      {
         _nanovor.addStatHistory();
      }
      
      public function get strength() : int
      {
         return _nanovor.strength;
      }
      
      public function set moddedStrength(param1:int) : void
      {
         _nanovor.moddedStrength = param1;
      }
      
      public function get speed() : int
      {
         return _nanovor.speed;
      }
      
      public function get killCount() : int
      {
         return _nanovor.killCount;
      }
      
      public function get bloodType() : String
      {
         return _nanovor.bloodType;
      }
      
      public function set assetId(param1:String) : void
      {
         _nanovor.assetId = param1;
      }
      
      public function get previousStrength() : int
      {
         return _nanovor.previousStrength;
      }
      
      public function set stunFailPercent(param1:Number) : void
      {
         _nanovor.stunFailPercent = param1;
      }
      
      public function get health() : int
      {
         return _nanovor.health;
      }
      
      public function set baseStrength(param1:int) : void
      {
         _nanovor.baseStrength = param1;
      }
      
      public function set moddedStunFailPercent(param1:Number) : void
      {
         _nanovor.moddedStunFailPercent = param1;
      }
      
      public function toString() : String
      {
         return _nanovor.toString();
      }
      
      public function get previousYellowSpike() : int
      {
         return _nanovor.previousYellowSpike;
      }
      
      public function set playerStats(param1:IPlayerStats) : void
      {
         _nanovor.playerStats = param1;
      }
      
      public function set armor(param1:int) : void
      {
         _nanovor.armor = param1;
      }
      
      public function set strength(param1:int) : void
      {
         _nanovor.strength = param1;
      }
      
      public function get previousModdedArmor() : int
      {
         return _nanovor.previousModdedArmor;
      }
      
      public function get previousArmor() : int
      {
         return _nanovor.previousArmor;
      }
      
      public function get name() : String
      {
         return _nanovor.name;
      }
      
      public function get maxDamageGame() : int
      {
         return _nanovor.maxDamageGame;
      }
      
      public function get baseHealth() : int
      {
         return _nanovor.baseHealth;
      }
      
      public function set speed(param1:int) : void
      {
         _nanovor.speed = param1;
      }
      
      public function get assetFlag() : int
      {
         return _nanovor.assetFlag;
      }
      
      public function get previousBlueSpike() : int
      {
         return _nanovor.previousBlueSpike;
      }
      
      public function get winCount() : int
      {
         return _nanovor.winCount;
      }
      
      public function get velocitronKillCount() : int
      {
         return _nanovor.velocitronKillCount;
      }
      
      public function get maxRoundCount() : int
      {
         return _nanovor.maxRoundCount;
      }
      
      public function get maxDamageHit() : int
      {
         return _nanovor.maxDamageHit;
      }
      
      public function get isDead() : Boolean
      {
         return _nanovor.isDead;
      }
      
      public function get nickName() : String
      {
         return _nanovor.nickName;
      }
      
      public function get owner() : IPlayer
      {
         return _nanovor.owner;
      }
      
      public function get previousModdedDodgeFailPercent() : Number
      {
         return _nanovor.previousModdedDodgeFailPercent;
      }
      
      public function set health(param1:int) : void
      {
         _nanovor.health = param1;
      }
      
      public function get fullEvolveDate() : Date
      {
         return _nanovor.fullEvolveDate;
      }
      
      public function get previousHacks() : Array
      {
         return _nanovor.previousHacks;
      }
      
      public function get magnamodKillCount() : int
      {
         return _nanovor.magnamodKillCount;
      }
      
      public function get selectedAttack() : IAttack
      {
         return _nanovor.selectedAttack;
      }
      
      public function set assetTypeCategory(param1:String) : void
      {
         _nanovor.assetTypeCategory = param1;
      }
      
      public function resetStatHistory() : void
      {
         _nanovor.resetStatHistory();
      }
      
      public function get moddedRedSpike() : int
      {
         return _nanovor.moddedRedSpike;
      }
      
      public function get swarmValue() : int
      {
         return _nanovor.swarmValue;
      }
      
      public function get statIndex() : int
      {
         return _nanovor.statIndex;
      }
      
      public function get version() : int
      {
         return _nanovor.version;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         _nanovor.moddedYellowSpike = param1;
      }
      
      public function getAttackByAttackId(param1:int) : IAttack
      {
         return _nanovor.getAttackByAttackId(param1);
      }
      
      public function get moddedDodgeFailPercent() : Number
      {
         return _nanovor.moddedDodgeFailPercent;
      }
      
      public function set hacks(param1:Array) : void
      {
         _nanovor.hacks = param1;
      }
      
      public function get baseArmor() : int
      {
         return _nanovor.baseArmor;
      }
      
      public function get dodgeFailPercent() : Number
      {
         return _nanovor.dodgeFailPercent;
      }
      
      public function get wave() : int
      {
         return _nanovor.wave;
      }
      
      public function get deathCount() : int
      {
         return _nanovor.deathCount;
      }
      
      public function removeAllHacks() : void
      {
         _nanovor.removeAllHacks();
      }
      
      public function set evolveId(param1:int) : void
      {
         _nanovor.evolveId = param1;
      }
      
      public function get assetTypeId() : int
      {
         return _nanovor.assetTypeId;
      }
      
      public function get moddedSpeed() : int
      {
         return _nanovor.moddedSpeed;
      }
      
      public function get moddedBlueSpike() : int
      {
         return _nanovor.moddedBlueSpike;
      }
      
      public function get isFacingRight() : Boolean
      {
         return _nanovor.isFacingRight;
      }
      
      public function get previousModdedBlueSpike() : int
      {
         return _nanovor.previousModdedBlueSpike;
      }
      
      public function set baseHealth(param1:int) : void
      {
         _nanovor.baseHealth = param1;
      }
      
      public function set nickName(param1:String) : void
      {
         _nanovor.nickName = param1;
      }
      
      public function get moddedStrength() : int
      {
         return _nanovor.moddedStrength;
      }
      
      public function get allAttacksUsed() : Boolean
      {
         return _nanovor.allAttacksUsed;
      }
      
      public function get attacks() : Array
      {
         return _nanovor.attacks;
      }
      
      public function get battleCount() : int
      {
         return _nanovor.battleCount;
      }
      
      public function get previousModdedYellowSpike() : int
      {
         return _nanovor.previousModdedYellowSpike;
      }
      
      public function get safeNickName() : String
      {
         return _nanovor.safeNickName;
      }
      
      public function get armor() : int
      {
         return _nanovor.armor;
      }
      
      public function getAttack(param1:int) : IAttack
      {
         return _nanovor.getAttack(param1);
      }
      
      public function set isDead(param1:Boolean) : void
      {
         _nanovor.isDead = param1;
      }
      
      public function get productionNumber() : int
      {
         return _nanovor.productionNumber;
      }
      
      public function set owner(param1:IPlayer) : void
      {
         _nanovor.owner = param1;
      }
      
      public function checkStatOverride(param1:String) : Boolean
      {
         return _nanovor.checkStatOverride(param1);
      }
      
      public function get moddedYellowSpike() : int
      {
         return _nanovor.moddedYellowSpike;
      }
      
      public function get hacks() : Array
      {
         return _nanovor.hacks;
      }
      
      public function get previousModdedStunFailPercent() : Number
      {
         return _nanovor.previousModdedStunFailPercent;
      }
      
      public function get assetTypeCategory() : String
      {
         return _nanovor.assetTypeCategory;
      }
      
      public function addHack(param1:IAttackStatement) : void
      {
         _nanovor.addHack(param1);
      }
      
      public function removeLastHack() : void
      {
         _nanovor.removeLastHack();
      }
      
      public function get evolveId() : int
      {
         return _nanovor.evolveId;
      }
      
      public function get hexiteKillCount() : int
      {
         return _nanovor.hexiteKillCount;
      }
      
      public function get level() : int
      {
         return _nanovor.level;
      }
      
      public function set selectedAttack(param1:IAttack) : void
      {
         _nanovor.selectedAttack = param1;
      }
      
      public function get previousSpeed() : int
      {
         return _nanovor.previousSpeed;
      }
      
      public function get previousModdedSpeed() : int
      {
         return _nanovor.previousModdedSpeed;
      }
      
      public function calculateRemainingExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void
      {
         throw new Error("AbstractSenseiNanovor::calculateRemainingED() must be implemented in subclasses.");
      }
      
      public function set blueSpike(param1:int) : void
      {
         _nanovor.blueSpike = param1;
      }
      
      public function get virmonMasterData() : IVirmonMasterData
      {
         return _nanovor.virmonMasterData;
      }
      
      public function get statHistory() : Array
      {
         return _nanovor.statHistory;
      }
      
      public function set moddedDodgeFailPercent(param1:Number) : void
      {
         _nanovor.moddedDodgeFailPercent = param1;
      }
      
      public function get rarity() : String
      {
         return _nanovor.rarity;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         _nanovor.moddedRedSpike = param1;
      }
      
      public function get previousModdedRedSpike() : int
      {
         return _nanovor.previousModdedRedSpike;
      }
      
      public function set isFacingRight(param1:Boolean) : void
      {
         _nanovor.isFacingRight = param1;
      }
      
      public function getModdedStat(param1:String, param2:Boolean = false) : Number
      {
         return _nanovor.getModdedStat(param1,param2);
      }
      
      public function set statIndex(param1:int) : void
      {
         _nanovor.statIndex = param1;
      }
      
      public function removeHack(param1:IAttackStatement) : void
      {
         _nanovor.removeHack(param1);
      }
      
      public function get blueSpike() : int
      {
         return _nanovor.blueSpike;
      }
      
      public function set baseArmor(param1:int) : void
      {
         _nanovor.baseArmor = param1;
      }
      
      public function set dodgeFailPercent(param1:Number) : void
      {
         _nanovor.dodgeFailPercent = param1;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         _nanovor.yellowSpike = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         _nanovor.redSpike = param1;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         _nanovor.baseSpeed = param1;
      }
      
      public function get yellowSpike() : int
      {
         return _nanovor.yellowSpike;
      }
      
      public function get redSpike() : int
      {
         return _nanovor.redSpike;
      }
      
      public function get previousModdedStrength() : int
      {
         return _nanovor.previousModdedStrength;
      }
      
      public function get overallExpectedDamage() : Number
      {
         return _overallEnergyDamage;
      }
      
      public function set moddedArmor(param1:int) : void
      {
         _nanovor.moddedArmor = param1;
      }
      
      public function get baseSpeed() : int
      {
         return _nanovor.baseSpeed;
      }
      
      public function get moddedArmor() : int
      {
         return _nanovor.moddedArmor;
      }
   }
}

