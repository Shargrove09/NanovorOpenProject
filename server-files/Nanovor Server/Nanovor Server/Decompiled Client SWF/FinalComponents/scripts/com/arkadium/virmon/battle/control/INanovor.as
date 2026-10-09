package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.framework.IVirmonMasterData;
   
   public interface INanovor
   {
      
      function get wave() : int;
      
      function removeAllHacks() : void;
      
      function get assetTypeId() : int;
      
      function get moddedSpeed() : int;
      
      function get previousDodgeFailPercent() : Number;
      
      function get moddedBlueSpike() : int;
      
      function get previousRedSpike() : int;
      
      function set moddedSpeed(param1:int) : void;
      
      function get previousModdedBlueSpike() : int;
      
      function set moddedBlueSpike(param1:int) : void;
      
      function set baseHealth(param1:int) : void;
      
      function get faction() : String;
      
      function get moddedStrength() : int;
      
      function set nickName(param1:String) : void;
      
      function get allAttacksUsed() : Boolean;
      
      function get attacks() : Array;
      
      function get moddedStunFailPercent() : Number;
      
      function get stunFailPercent() : Number;
      
      function get baseStrength() : int;
      
      function get previousHealth() : int;
      
      function get previousStunFailPercent() : Number;
      
      function get battleCount() : int;
      
      function get previousModdedYellowSpike() : int;
      
      function get safeNickName() : String;
      
      function get playerStats() : IPlayerStats;
      
      function addStatHistory() : void;
      
      function get strength() : int;
      
      function get assetId() : String;
      
      function set moddedStrength(param1:int) : void;
      
      function getAttack(param1:int) : IAttack;
      
      function get armor() : int;
      
      function get speed() : int;
      
      function get killCount() : int;
      
      function get bloodType() : String;
      
      function set assetId(param1:String) : void;
      
      function get previousStrength() : int;
      
      function set stunFailPercent(param1:Number) : void;
      
      function get health() : int;
      
      function set moddedStunFailPercent(param1:Number) : void;
      
      function get productionNumber() : int;
      
      function set isDead(param1:Boolean) : void;
      
      function set baseStrength(param1:int) : void;
      
      function set owner(param1:IPlayer) : void;
      
      function checkStatOverride(param1:String) : Boolean;
      
      function addHack(param1:IAttackStatement) : void;
      
      function toString() : String;
      
      function get assetTypeCategory() : String;
      
      function get moddedYellowSpike() : int;
      
      function get hexiteKillCount() : int;
      
      function get previousModdedStunFailPercent() : Number;
      
      function get evolveId() : int;
      
      function get hacks() : Array;
      
      function get previousYellowSpike() : int;
      
      function set playerStats(param1:IPlayerStats) : void;
      
      function set armor(param1:int) : void;
      
      function set strength(param1:int) : void;
      
      function get assetFlag() : int;
      
      function get level() : int;
      
      function get maxDamageGame() : int;
      
      function set selectedAttack(param1:IAttack) : void;
      
      function get previousModdedArmor() : int;
      
      function get previousArmor() : int;
      
      function removeLastHack() : void;
      
      function get name() : String;
      
      function get baseHealth() : int;
      
      function set speed(param1:int) : void;
      
      function get previousModdedSpeed() : int;
      
      function get previousSpeed() : int;
      
      function get winCount() : int;
      
      function get previousBlueSpike() : int;
      
      function set blueSpike(param1:int) : void;
      
      function get virmonMasterData() : IVirmonMasterData;
      
      function get velocitronKillCount() : int;
      
      function get nickName() : String;
      
      function get statHistory() : Array;
      
      function set moddedDodgeFailPercent(param1:Number) : void;
      
      function get maxRoundCount() : int;
      
      function get maxDamageHit() : int;
      
      function get previousModdedDodgeFailPercent() : Number;
      
      function get rarity() : String;
      
      function set moddedRedSpike(param1:int) : void;
      
      function get previousModdedRedSpike() : int;
      
      function get isDead() : Boolean;
      
      function set isFacingRight(param1:Boolean) : void;
      
      function getModdedStat(param1:String, param2:Boolean = false) : Number;
      
      function get owner() : IPlayer;
      
      function get magnamodKillCount() : int;
      
      function set health(param1:int) : void;
      
      function get fullEvolveDate() : Date;
      
      function get previousHacks() : Array;
      
      function set statIndex(param1:int) : void;
      
      function get selectedAttack() : IAttack;
      
      function removeHack(param1:IAttackStatement) : void;
      
      function get blueSpike() : int;
      
      function set assetTypeCategory(param1:String) : void;
      
      function resetStatHistory() : void;
      
      function get moddedRedSpike() : int;
      
      function get version() : int;
      
      function get swarmValue() : int;
      
      function set baseArmor(param1:int) : void;
      
      function get statIndex() : int;
      
      function getAttackByAttackId(param1:int) : IAttack;
      
      function set dodgeFailPercent(param1:Number) : void;
      
      function set moddedYellowSpike(param1:int) : void;
      
      function set yellowSpike(param1:int) : void;
      
      function get isFacingRight() : Boolean;
      
      function get moddedDodgeFailPercent() : Number;
      
      function set redSpike(param1:int) : void;
      
      function set hacks(param1:Array) : void;
      
      function set baseSpeed(param1:int) : void;
      
      function get baseArmor() : int;
      
      function get dodgeFailPercent() : Number;
      
      function get yellowSpike() : int;
      
      function get redSpike() : int;
      
      function get baseSpeed() : int;
      
      function set evolveId(param1:int) : void;
      
      function get previousModdedStrength() : int;
      
      function get deathCount() : int;
      
      function set moddedArmor(param1:int) : void;
      
      function get moddedArmor() : int;
   }
}

