package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.VirmonEvoNode;
   
   public interface IVirmon
   {
      
      function getCollectorNumber() : String;
      
      function getName() : String;
      
      function getEvolutionTree() : VirmonEvoNode;
      
      function getNickName() : String;
      
      function setSpeed(param1:int) : void;
      
      function getYellowSpikeSet() : Boolean;
      
      function getBattleCount() : uint;
      
      function getArmor() : int;
      
      function create(param1:String, param2:IVirmonData) : IVirmon;
      
      function setID(param1:String) : void;
      
      function setName(param1:String) : void;
      
      function getCurrentState() : int;
      
      function setAttackList(param1:Array) : void;
      
      function setNickName(param1:String) : void;
      
      function getSpeed() : int;
      
      function getHDAttackExpected() : int;
      
      function getMasterId() : int;
      
      function setKillCount(param1:uint) : void;
      
      function setEvolutionTree(param1:VirmonEvoNode) : void;
      
      function setCurrentState(param1:int) : void;
      
      function getKillCount() : uint;
      
      function setHDAttackExpected(param1:int) : void;
      
      function setMasterId(param1:int) : void;
      
      function getRarity() : String;
      
      function getAssetTypeVersion() : Number;
      
      function getEvolutionReadiness() : int;
      
      function setYellowSpikeSet(param1:Boolean) : void;
      
      function clearHacks() : void;
      
      function setRarity(param1:String) : void;
      
      function setAssetTypeVersion(param1:Number) : void;
      
      function setEvolutionReadiness(param1:int) : void;
      
      function getStrength() : int;
      
      function getSV() : int;
      
      function getHacks() : Array;
      
      function setBuffedScore(param1:int) : void;
      
      function getNumber() : String;
      
      function getEvolveDate() : String;
      
      function setLevel(param1:int) : void;
      
      function setStrength(param1:int) : void;
      
      function setSpike(param1:String) : void;
      
      function setSV(param1:int) : void;
      
      function setAccountID(param1:int) : void;
      
      function setHacks(param1:Array) : void;
      
      function getBuffedScore() : int;
      
      function setBirthDate(param1:String) : void;
      
      function setEvolveDate(param1:String) : void;
      
      function getLevel() : int;
      
      function getHealth() : int;
      
      function setMarketValue(param1:int) : void;
      
      function getBirthDate() : String;
      
      function getProductionNumber() : int;
      
      function getAccountID() : int;
      
      function setNumber(param1:String) : void;
      
      function getPV() : int;
      
      function getDeltaArmor() : String;
      
      function setHealth(param1:int) : void;
      
      function getMarketValue() : int;
      
      function setFaction(param1:String) : void;
      
      function addHack(param1:*) : void;
      
      function getDeltaStrength() : String;
      
      function getBadgesList() : Array;
      
      function getDeltaSpeed() : String;
      
      function getFaction() : String;
      
      function setPV(param1:int) : void;
      
      function setProductionNumber(param1:int) : void;
      
      function getBlueSpikeSet() : Boolean;
      
      function setBadgesList(param1:Array) : void;
      
      function getID() : String;
      
      function setAmpTokenPrice(param1:int) : void;
      
      function setCurrentHealth(param1:int) : void;
      
      function setCollectorNumber(param1:String) : void;
      
      function setBattleCount(param1:uint) : void;
      
      function getRedSpikeSet() : Boolean;
      
      function setBlueSpikeSet(param1:Boolean) : void;
      
      function setRedSpikeSet(param1:Boolean) : void;
      
      function getAttackList() : Array;
      
      function setArmor(param1:int) : void;
      
      function getAmpTokenPrice() : int;
      
      function getCurrentHealth() : int;
   }
}

