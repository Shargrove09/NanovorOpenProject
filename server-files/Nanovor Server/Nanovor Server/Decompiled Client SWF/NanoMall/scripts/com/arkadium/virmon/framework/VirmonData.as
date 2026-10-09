package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.smithandtinker.nanovor.common.utils.MakeDate;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class VirmonData extends EventDispatcher implements IVirmonData
   {
      
      private var _nHexKillCount:int;
      
      private var _nLifeKillCount:int;
      
      private var _bScrapedBy:Boolean;
      
      private var _nAssetID:String;
      
      private var _bScreenStar:Boolean;
      
      private var _nKillCount:int;
      
      private var _aBadgeList:Array;
      
      private var _nVelLifeKillCount:int;
      
      private var _nSwarmValue:int;
      
      private var _nHealth:int;
      
      private var _nMagLifeKillCount:int;
      
      private var _nMaxDamageHit:int;
      
      private var _nDeathCount:int;
      
      private var _nStrength:int;
      
      private var _nHexLifeKillCount:int;
      
      private var _nAssetTypeID:int;
      
      private var _sBirthDate:String;
      
      private var _sNickname:String;
      
      private var _nLifetimeWinCount:int;
      
      private var _nArmor:int;
      
      private var _nSpeed:int;
      
      private var _dEvolveDate:Date;
      
      private var _nWinCount:int;
      
      private var _dBirthDate:Date;
      
      private var _oVirmonMasterData:IVirmonMasterData;
      
      private var _nLifeBattleCount:int;
      
      private var _nProdNum:int;
      
      private var _nVelKillCount:int;
      
      private var _nCritHitCount:int;
      
      private var _nWhiffCount:int;
      
      private var _nBattleCount:int;
      
      private var _nMagKillCount:int;
      
      private var _nMaxDamageGame:int;
      
      private var _bSlacker:Boolean;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _sEvolveDate:String;
      
      private var _bAllAttacksUsed:Boolean;
      
      private var _nLifetimeDeathCount:int;
      
      private var _nMaxRoundCount:int;
      
      private var _sTypeName:String;
      
      public function VirmonData(param1:IServiceRequestBrokerManager)
      {
         super();
         _serviceRequestBrokerManager = param1;
         _oVirmonMasterData = null;
         _nStrength = -1;
      }
      
      public function get isBuffed() : Boolean
      {
         var _loc1_:IVirmonMasterData = getVirmonMasterData();
         return getHealth() > _loc1_.getBaseHealth() || getArmor() > _loc1_.getBaseArmor() || getStrength() > _loc1_.getBaseStrength() || getSpeed() > _loc1_.getBaseSpeed();
      }
      
      public function getWinCount() : int
      {
         return _nWinCount;
      }
      
      public function getVirmonMasterData() : IVirmonMasterData
      {
         return _oVirmonMasterData;
      }
      
      public function setNickName(param1:String) : void
      {
         _sNickname = param1;
      }
      
      public function getNickName() : String
      {
         return _sNickname;
      }
      
      public function getLifetimeWinCount() : int
      {
         return _nLifetimeWinCount;
      }
      
      public function getBattleCount() : int
      {
         return _nBattleCount;
      }
      
      public function setVirmonMasterData(param1:IVirmonMasterData) : *
      {
         _oVirmonMasterData = param1;
         if(_nStrength > 0)
         {
         }
         _nSwarmValue = int(_oVirmonMasterData.getPointValue());
         _sTypeName = _oVirmonMasterData.getName();
         if(!_sNickname)
         {
            _sNickname = "";
         }
      }
      
      public function getMaxDamageHit() : int
      {
         return _nMaxDamageHit;
      }
      
      private function badgesReturned(param1:Event) : *
      {
         var _loc5_:IBadgeData = null;
         var _loc6_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,badgesLoadError);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = Utils.StripXmlNamespace(XML(_loc2_));
         var _loc4_:XMLList = _loc3_.child("badge");
         _aBadgeList = new Array(_loc4_.length());
         while(_loc6_ < _aBadgeList.length)
         {
            _loc5_ = new BadgeData();
            _loc5_.sType = BadgeData.TYPE_ASSET;
            _loc5_.parseXMLData(_loc4_[_loc6_]);
            _aBadgeList[_loc6_] = _loc5_;
            _loc6_++;
         }
         dispatchEvent(new Event(VirmonDataEvent.ASSET_BADGES_LOADED));
      }
      
      public function getMagnamodKillCount() : int
      {
         return _nMagKillCount;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:Namespace = param1.namespace();
         _nAssetID = String(param1.attribute(new QName(_loc2_.uri,"id")));
         _nProdNum = int(param1.child(new QName(_loc2_.uri,"production-number")));
         _sBirthDate = String(param1.child(new QName(_loc2_.uri,"birth-date")));
         _dBirthDate = MakeDate.dateFromBankTime(_sBirthDate);
         _sBirthDate = _sBirthDate.slice(0,10);
         _sEvolveDate = String(param1.child(new QName(_loc2_.uri,"last-evolution-date")));
         _dEvolveDate = MakeDate.dateFromBankTime(_sEvolveDate);
         _sEvolveDate = _sEvolveDate.slice(0,10);
         _nSwarmValue = 0;
         var _loc3_:Namespace = param1.namespace("ns2");
         var _loc4_:XML = param1.child(new QName(_loc3_.uri,"asset-miscellany"))[0];
         if(Boolean(_loc4_))
         {
            _sNickname = String(_loc4_.child(new QName(_loc3_.uri,"nickname")));
         }
         var _loc5_:Namespace = param1.namespace("ns3");
         var _loc6_:XML = param1.child(new QName(_loc5_.uri,"asset-stat"))[0];
         if(Boolean(_loc6_))
         {
            _nAssetTypeID = int(_loc6_.child(new QName(_loc5_.uri,"asset-type-id")));
            _nSpeed = int(_loc6_.child(new QName(_loc5_.uri,"speed")));
            _nStrength = int(_loc6_.child(new QName(_loc5_.uri,"strength")));
            _nArmor = int(_loc6_.child(new QName(_loc5_.uri,"armor")));
            _nHealth = int(_loc6_.child(new QName(_loc5_.uri,"health")));
            _nKillCount = int(_loc6_.child(new QName(_loc5_.uri,"kill-count")));
            _nLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"kill-count-lifetime")));
            _nBattleCount = int(_loc6_.child(new QName(_loc5_.uri,"battle-count")));
            _nLifeBattleCount = int(_loc6_.child(new QName(_loc5_.uri,"battle-count-lifetime")));
            _nDeathCount = int(_loc6_.child(new QName(_loc5_.uri,"death-count")));
            _nLifetimeDeathCount = int(_loc6_.child(new QName(_loc5_.uri,"death-count-lifetime")));
            _nMagKillCount = int(_loc6_.child(new QName(_loc5_.uri,"magnamod-kill-count")));
            _nMagLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"magnamod-kill-count-lifetime")));
            _nHexKillCount = int(_loc6_.child(new QName(_loc5_.uri,"hexite-kill-count")));
            _nHexLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"hexite-kill-count-lifetime")));
            _nVelKillCount = int(_loc6_.child(new QName(_loc5_.uri,"velocitron-kill-count")));
            _nVelLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"velocitron-kill-count-lifetime")));
            _nWinCount = int(_loc6_.child(new QName(_loc5_.uri,"win-count")));
            _nLifetimeWinCount = int(_loc6_.child(new QName(_loc5_.uri,"win-count-lifetime")));
            _nCritHitCount = int(_loc6_.child(new QName(_loc5_.uri,"critical-hit-count")));
            _nWhiffCount = int(_loc6_.child(new QName(_loc5_.uri,"whiff-count")));
            _bScreenStar = Boolean(_loc6_.child(new QName(_loc5_.uri,"screen-star")));
            _bScrapedBy = Boolean(_loc6_.child(new QName(_loc5_.uri,"scraped-by")));
            _bAllAttacksUsed = Boolean(_loc6_.child(new QName(_loc5_.uri,"all-attacks-used")));
            _bSlacker = Boolean(_loc6_.child(new QName(_loc5_.uri,"slacker")));
            _nMaxDamageGame = int(_loc6_.child(new QName(_loc5_.uri,"max-damage-game")));
            _nMaxDamageHit = int(_loc6_.child(new QName(_loc5_.uri,"max-damage-hit")));
            _nMaxRoundCount = int(_loc6_.child(new QName(_loc5_.uri,"max-round-count")));
         }
      }
      
      public function getBadgeList() : Array
      {
         if(Boolean(_aBadgeList))
         {
            return _aBadgeList.slice();
         }
         return new Array();
      }
      
      public function getHexiteKillCount() : int
      {
         return _nHexKillCount;
      }
      
      public function getHealth() : int
      {
         return _nHealth;
      }
      
      public function getTypeName() : String
      {
         return _sTypeName;
      }
      
      public function setStats(param1:int, param2:int, param3:int, param4:int) : void
      {
         _nHealth = param1;
         _nArmor = param2;
         _nSpeed = param3;
         _nStrength = param4;
      }
      
      public function getMagnamodLifetimeKillCount() : int
      {
         return _nMagLifeKillCount;
      }
      
      private function assetStatReceived(param1:FrameWorkEvent) : *
      {
         parseXMLStats(XML(param1.data));
      }
      
      public function getVelocitronKillCount() : int
      {
         return _nVelKillCount;
      }
      
      public function updateStats() : *
      {
      }
      
      public function getCriticalHitCount() : int
      {
         return _nCritHitCount;
      }
      
      private function badgesLoadError(param1:IOErrorEvent) : void
      {
         DebugLog.instance.error(">> VirmonData: badgesLoadError -- " + param1.text);
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,badgesLoadError);
         dispatchEvent(new Event(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR));
      }
      
      public function getHexiteLifetimeKillCount() : int
      {
         return _nHexLifeKillCount;
      }
      
      public function getWhiffCount() : int
      {
         return _nWhiffCount;
      }
      
      public function getBadgeById(param1:int) : IBadgeData
      {
         if(!_aBadgeList)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _aBadgeList.length)
         {
            if(BadgeData(_aBadgeList[_loc2_]).iId == param1)
            {
               return _aBadgeList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLifetimeBattleCount() : int
      {
         return _nLifeBattleCount;
      }
      
      public function areAllAttacksUsed() : Boolean
      {
         return _bAllAttacksUsed;
      }
      
      public function getBirthDate() : String
      {
         return _sBirthDate;
      }
      
      public function getFullBirthDate() : Date
      {
         return _dBirthDate;
      }
      
      public function getArmor() : int
      {
         return _nArmor;
      }
      
      public function getSpeed() : int
      {
         return _nSpeed;
      }
      
      public function parseXMLStats(param1:XML) : *
      {
      }
      
      public function getVelocitronLifetimeKillCount() : int
      {
         return _nVelLifeKillCount;
      }
      
      public function getAssetTypeID() : int
      {
         return _nAssetTypeID;
      }
      
      public function getFullEvolveDate() : Date
      {
         return _dEvolveDate;
      }
      
      public function getLifetimeDeathCount() : int
      {
         return _nLifetimeDeathCount;
      }
      
      public function isScrapedBy() : Boolean
      {
         return _bScrapedBy;
      }
      
      public function getStrength() : int
      {
         return _nStrength;
      }
      
      public function isSlacker() : Boolean
      {
         return _bSlacker;
      }
      
      public function loadBadges() : void
      {
         _serviceRequestBrokerManager.requestAssetBadges(_nAssetID,badgesReturned,badgesLoadError);
      }
      
      public function getEvolveDate() : String
      {
         return _sEvolveDate;
      }
      
      public function getSwarmValue() : int
      {
         return _nSwarmValue;
      }
      
      public function getAssetID() : String
      {
         return _nAssetID;
      }
      
      public function getProductionNumber() : int
      {
         return _nProdNum;
      }
      
      public function getKillCount() : int
      {
         return _nKillCount;
      }
      
      public function getMaxDamageGame() : int
      {
         return _nMaxDamageGame;
      }
      
      public function isScreenStar() : Boolean
      {
         return _bScreenStar;
      }
      
      public function getDeathCount() : int
      {
         return _nDeathCount;
      }
      
      public function getMaxRoundCount() : int
      {
         return _nMaxRoundCount;
      }
      
      public function getLifeKillCount() : int
      {
         return _nLifeKillCount;
      }
   }
}

