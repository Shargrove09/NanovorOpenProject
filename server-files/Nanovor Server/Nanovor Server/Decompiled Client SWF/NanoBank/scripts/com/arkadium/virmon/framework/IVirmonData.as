package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IVirmonData extends IEventDispatcher
   {
      
      function getCriticalHitCount() : int;
      
      function getBattleCount() : int;
      
      function isSlacker() : Boolean;
      
      function getHexiteKillCount() : int;
      
      function getNickName() : String;
      
      function getMagnamodKillCount() : int;
      
      function areAllAttacksUsed() : Boolean;
      
      function getArmor() : int;
      
      function getSwarmValue() : int;
      
      function getWinCount() : int;
      
      function getSpeed() : int;
      
      function getHealth() : int;
      
      function getAssetID() : String;
      
      function getVirmonMasterData() : IVirmonMasterData;
      
      function setNickName(param1:String) : void;
      
      function getProductionNumber() : int;
      
      function getEvolveDate() : String;
      
      function getLifetimeDeathCount() : int;
      
      function parseXMLStats(param1:XML) : *;
      
      function getMaxDamageHit() : int;
      
      function setStats(param1:int, param2:int, param3:int, param4:int) : void;
      
      function getMaxDamageGame() : int;
      
      function getBadgeById(param1:int) : IBadgeData;
      
      function getFullBirthDate() : Date;
      
      function getTypeName() : String;
      
      function getVelocitronLifetimeKillCount() : int;
      
      function updateStats() : *;
      
      function getVelocitronKillCount() : int;
      
      function isScreenStar() : Boolean;
      
      function getKillCount() : int;
      
      function getBadgeList() : Array;
      
      function isScrapedBy() : Boolean;
      
      function getWhiffCount() : int;
      
      function parseXMLData(param1:XML) : *;
      
      function getAssetTypeID() : int;
      
      function getFullEvolveDate() : Date;
      
      function getDeathCount() : int;
      
      function getLifetimeWinCount() : int;
      
      function setVirmonMasterData(param1:IVirmonMasterData) : *;
      
      function loadBadges() : void;
      
      function getStrength() : int;
      
      function getLifetimeBattleCount() : int;
      
      function getBirthDate() : String;
      
      function getHexiteLifetimeKillCount() : int;
      
      function get isBuffed() : Boolean;
      
      function getMagnamodLifetimeKillCount() : int;
      
      function getMaxRoundCount() : int;
      
      function getLifeKillCount() : int;
   }
}

