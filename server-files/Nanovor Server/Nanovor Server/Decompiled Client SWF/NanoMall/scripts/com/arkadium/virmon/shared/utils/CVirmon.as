package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.arkadium.virmon.framework.VirmonEvoNode;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.getQualifiedClassName;
   
   public class CVirmon implements IVirmon
   {
      
      public static const UNLIKELY_NUMBER:Number = -9367892;
      
      private var _cVirmonEvoNode:VirmonEvoNode;
      
      private var _iBeginStrength:Number;
      
      private var _bRedSpikeSet:Boolean;
      
      private var _iStrength:int;
      
      private var _iMarketValue:int;
      
      private var _sNumber:String;
      
      private var _hacks:Array;
      
      private var _bBlueSpikeSet:Boolean;
      
      private var _iSpeed:int;
      
      private var _aAttackList:Array;
      
      private var _sName:String;
      
      private var _sNickName:String;
      
      private var _iBeginSpeed:Number;
      
      private var _iEvolutionReadiness:int;
      
      private var _sRarity:String;
      
      private var _iHealth:int;
      
      private var _iBattleCount:*;
      
      private var _iHDAttackExpected:int;
      
      private var _iMasterId:int;
      
      private var _iBuffedScore:int;
      
      private var _nAssetTypeVersion:Number;
      
      private var _iAccountID:int;
      
      private var _iCurrentHealth:int;
      
      private var _iPV:int;
      
      private var _iArmor:int;
      
      private var _aBadgesList:Array = new Array();
      
      private var _sBirthDate:String;
      
      private var _iKillCount:*;
      
      private var _sFaction:String;
      
      private var _iBeginArmor:Number;
      
      private var _iCurrentState:int;
      
      private var _sCollectorNumber:String;
      
      private var _iLevel:int;
      
      private var _nProdNum:int;
      
      private var _id:String;
      
      private var _bYellowSpikeSet:Boolean;
      
      private var _sEvolveDate:String;
      
      private var _iAmpTokenPrice:int;
      
      public function CVirmon()
      {
         super();
         _bRedSpikeSet = false;
         _bYellowSpikeSet = false;
         _bBlueSpikeSet = false;
         _hacks = new Array();
         _iBeginSpeed = UNLIKELY_NUMBER;
         _iBeginStrength = UNLIKELY_NUMBER;
         _iBeginArmor = UNLIKELY_NUMBER;
      }
      
      public function getCollectorNumber() : String
      {
         return _sCollectorNumber;
      }
      
      public function getBattleCount() : uint
      {
         return _iBattleCount;
      }
      
      public function getEvolutionTree() : VirmonEvoNode
      {
         return _cVirmonEvoNode;
      }
      
      public function getNickName() : String
      {
         return _sNickName;
      }
      
      public function getYellowSpikeSet() : Boolean
      {
         return _bYellowSpikeSet;
      }
      
      public function setName(param1:String) : void
      {
         _sName = param1;
      }
      
      public function setKillCount(param1:uint) : void
      {
         _iKillCount = param1;
      }
      
      public function setProductionNumber(param1:int) : void
      {
         _nProdNum = param1;
      }
      
      public function setYellowSpikeSet(param1:Boolean) : void
      {
         _bYellowSpikeSet = param1;
      }
      
      public function setCurrentState(param1:int) : void
      {
         _iCurrentState = param1;
      }
      
      public function setHacks(param1:Array) : void
      {
         _hacks = param1;
      }
      
      public function getSV() : int
      {
         return _iPV;
      }
      
      public function getNumber() : String
      {
         return _sNumber;
      }
      
      public function setLevel(param1:int) : void
      {
         _iLevel = param1;
      }
      
      public function setSV(param1:int) : void
      {
         _iPV = param1;
      }
      
      public function getBuffedScore() : int
      {
         return _iBuffedScore;
      }
      
      public function getBirthDate() : String
      {
         return _sBirthDate;
      }
      
      public function setNumber(param1:String) : void
      {
         _sNumber = param1;
      }
      
      public function getDeltaStrength() : String
      {
         var _loc1_:String = String(_iStrength - _iBeginStrength);
         if(int(_loc1_) > 0)
         {
            _loc1_ = "+" + _loc1_;
         }
         return _loc1_;
      }
      
      public function getDeltaArmor() : String
      {
         var _loc1_:String = String(_iArmor - _iBeginArmor);
         if(int(_loc1_) > 0)
         {
            _loc1_ = "+" + _loc1_;
         }
         return _loc1_;
      }
      
      public function setRedSpikeSet(param1:Boolean) : void
      {
         _bRedSpikeSet = param1;
      }
      
      public function setAmpTokenPrice(param1:int) : void
      {
         _iAmpTokenPrice = param1;
      }
      
      public function setEvolutionTree(param1:VirmonEvoNode) : void
      {
         _cVirmonEvoNode = param1;
      }
      
      public function setBlueSpikeSet(param1:Boolean) : void
      {
         _bBlueSpikeSet = param1;
      }
      
      public function getSpeed() : int
      {
         return _iSpeed;
      }
      
      public function getHDAttackExpected() : int
      {
         return _iHDAttackExpected;
      }
      
      public function getMasterId() : int
      {
         return _iMasterId;
      }
      
      public function getRarity() : String
      {
         return _sRarity;
      }
      
      public function getAssetTypeVersion() : Number
      {
         return _nAssetTypeVersion;
      }
      
      public function setRarity(param1:String) : void
      {
         _sRarity = param1;
      }
      
      public function getEvolveDate() : String
      {
         return _sEvolveDate;
      }
      
      public function setStrength(param1:int) : void
      {
         _iStrength = param1;
         if(_iBeginStrength == UNLIKELY_NUMBER)
         {
            _iBeginStrength = _iStrength;
         }
      }
      
      public function setSpike(param1:String) : void
      {
         var _loc2_:String = param1.toLowerCase();
         _bRedSpikeSet = false;
         _bYellowSpikeSet = false;
         _bBlueSpikeSet = false;
         switch(_loc2_)
         {
            case "blue":
               _bBlueSpikeSet = true;
               break;
            case "yellow":
               _bYellowSpikeSet = true;
               break;
            case "red":
               _bRedSpikeSet = true;
         }
      }
      
      public function setBirthDate(param1:String) : void
      {
         _sBirthDate = param1;
      }
      
      public function setEvolveDate(param1:String) : void
      {
         _sEvolveDate = param1;
      }
      
      public function setMarketValue(param1:int) : void
      {
         _iMarketValue = param1;
      }
      
      public function getProductionNumber() : int
      {
         return _nProdNum;
      }
      
      public function getID() : String
      {
         return _id;
      }
      
      public function getRedSpikeSet() : Boolean
      {
         return _bRedSpikeSet;
      }
      
      public function getName() : String
      {
         return _sName;
      }
      
      public function getAttackList() : Array
      {
         return _aAttackList;
      }
      
      public function setID(param1:String) : void
      {
         _id = param1;
      }
      
      public function setSpeed(param1:int) : void
      {
         _iSpeed = param1;
         if(_iBeginSpeed == UNLIKELY_NUMBER)
         {
            _iBeginSpeed = _iSpeed;
         }
      }
      
      public function create(param1:String, param2:IVirmonData) : IVirmon
      {
         var _loc3_:IVirmonData = param2;
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc4_:IVirmonMasterData = _loc3_.getVirmonMasterData();
         if(_loc4_ == null)
         {
            return null;
         }
         setID(param1);
         setMasterId(_loc3_.getVirmonMasterData().getAssetTypeID());
         setName(String(_loc4_.getName()));
         setNickName(String(_loc3_.getNickName()));
         setSV(_loc4_.getPointValue());
         setHealth(_loc4_.getBaseHealth());
         setCurrentHealth(_loc3_.getHealth());
         setStrength(_loc3_.getStrength());
         setSpeed(_loc3_.getSpeed());
         setArmor(_loc3_.getArmor());
         setFaction(_loc4_.getFaction());
         setAttackList(_loc4_.getAttackList());
         setNumber(String(_loc3_.getProductionNumber()));
         setLevel(_loc4_.getLevel());
         setBadgesList(_loc3_.getBadgeList());
         setBattleCount(_loc3_.getBattleCount());
         setKillCount(_loc3_.getKillCount());
         return this;
      }
      
      public function setAttackList(param1:Array) : void
      {
         _aAttackList = param1;
      }
      
      public function getCurrentState() : int
      {
         return _iCurrentState;
      }
      
      public function setNickName(param1:String) : void
      {
         _sNickName = param1;
      }
      
      public function getEvolutionReadiness() : int
      {
         return _iEvolutionReadiness;
      }
      
      public function setEvolutionReadiness(param1:int) : void
      {
         _iEvolutionReadiness = param1;
      }
      
      public function clearHacks() : void
      {
         _hacks = new Array();
      }
      
      public function getHealth() : int
      {
         return _iHealth;
      }
      
      public function setFaction(param1:String) : void
      {
         _sFaction = param1;
      }
      
      public function setHealth(param1:int) : void
      {
         _iHealth = param1;
      }
      
      public function getMarketValue() : int
      {
         return _iMarketValue;
      }
      
      public function getAccountID() : int
      {
         return _iAccountID;
      }
      
      public function addHack(param1:*) : void
      {
         _hacks.push(param1);
      }
      
      public function getDeltaSpeed() : String
      {
         var _loc1_:String = String(_iSpeed - _iBeginSpeed);
         if(int(_loc1_) > 0)
         {
            _loc1_ = "+" + _loc1_;
         }
         return _loc1_;
      }
      
      public function getBlueSpikeSet() : Boolean
      {
         return _bBlueSpikeSet;
      }
      
      public function setBattleCount(param1:uint) : void
      {
         _iBattleCount = param1;
      }
      
      public function setCollectorNumber(param1:String) : void
      {
         _sCollectorNumber = param1;
      }
      
      public function getCurrentHealth() : int
      {
         return _iCurrentHealth;
      }
      
      public function getArmor() : int
      {
         return _iArmor;
      }
      
      public function getKillCount() : uint
      {
         return _iKillCount;
      }
      
      public function setHDAttackExpected(param1:int) : void
      {
         _iHDAttackExpected = param1;
      }
      
      public function setMasterId(param1:int) : void
      {
         _iMasterId = param1;
      }
      
      public function setAssetTypeVersion(param1:Number) : void
      {
         _nAssetTypeVersion = param1;
      }
      
      public function getStrength() : int
      {
         return _iStrength;
      }
      
      public function getHacks() : Array
      {
         return _hacks;
      }
      
      public function setBuffedScore(param1:int) : void
      {
         _iBuffedScore = param1;
      }
      
      public function getLevel() : int
      {
         return _iLevel;
      }
      
      public function setAccountID(param1:int) : void
      {
         _iAccountID = param1;
      }
      
      public function getPV() : int
      {
         return _iPV;
      }
      
      public function getFaction() : String
      {
         return _sFaction;
      }
      
      public function setPV(param1:int) : void
      {
         _iPV = param1;
      }
      
      public function getBadgesList() : Array
      {
         return _aBadgesList;
      }
      
      public function setCurrentHealth(param1:int) : void
      {
         _iCurrentHealth = param1;
      }
      
      public function setBadgesList(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(getQualifiedClassName(param1[_loc2_]) == "null")
               {
                  DebugLog.instance.error("** CVirmon: setBadgesList: asset _id=" + _id + ", aBadgesList[" + _loc2_ + "] is NULL! ");
               }
               _loc2_++;
            }
         }
         _aBadgesList = param1;
      }
      
      public function setArmor(param1:int) : void
      {
         _iArmor = param1;
         if(_iBeginArmor == UNLIKELY_NUMBER)
         {
            _iBeginArmor = _iArmor;
         }
      }
      
      public function getAmpTokenPrice() : int
      {
         return _iAmpTokenPrice;
      }
   }
}

