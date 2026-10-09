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
         this._serviceRequestBrokerManager = param1;
         this._oVirmonMasterData = null;
         this._nStrength = -1;
      }
      
      public function get isBuffed() : Boolean
      {
         var _loc1_:IVirmonMasterData = this.getVirmonMasterData();
         return this.getHealth() > _loc1_.getBaseHealth() || this.getArmor() > _loc1_.getBaseArmor() || this.getStrength() > _loc1_.getBaseStrength() || this.getSpeed() > _loc1_.getBaseSpeed();
      }
      
      public function getWinCount() : int
      {
         return this._nWinCount;
      }
      
      public function getVirmonMasterData() : IVirmonMasterData
      {
         return this._oVirmonMasterData;
      }
      
      public function setNickName(param1:String) : void
      {
         this._sNickname = param1;
      }
      
      public function getNickName() : String
      {
         return this._sNickname;
      }
      
      public function getLifetimeWinCount() : int
      {
         return this._nLifetimeWinCount;
      }
      
      public function getBattleCount() : int
      {
         return this._nBattleCount;
      }
      
      public function setVirmonMasterData(param1:IVirmonMasterData) : *
      {
         this._oVirmonMasterData = param1;
         if(this._nStrength > 0)
         {
         }
         this._nSwarmValue = int(this._oVirmonMasterData.getPointValue());
         this._sTypeName = this._oVirmonMasterData.getName();
         if(!this._sNickname)
         {
            this._sNickname = "";
         }
      }
      
      public function getMaxDamageHit() : int
      {
         return this._nMaxDamageHit;
      }
      
      private function badgesReturned(param1:Event) : *
      {
         var _loc5_:IBadgeData = null;
         var _loc6_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.badgesLoadError);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = Utils.StripXmlNamespace(XML(_loc2_));
         var _loc4_:XMLList = _loc3_.child("badge");
         this._aBadgeList = new Array(_loc4_.length());
         while(_loc6_ < this._aBadgeList.length)
         {
            _loc5_ = new BadgeData();
            _loc5_.sType = BadgeData.TYPE_ASSET;
            _loc5_.parseXMLData(_loc4_[_loc6_]);
            this._aBadgeList[_loc6_] = _loc5_;
            _loc6_++;
         }
         dispatchEvent(new Event(VirmonDataEvent.ASSET_BADGES_LOADED));
      }
      
      public function getMagnamodKillCount() : int
      {
         return this._nMagKillCount;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:Namespace = param1.namespace();
         this._nAssetID = String(param1.attribute(new QName(_loc2_.uri,"id")));
         this._nProdNum = int(param1.child(new QName(_loc2_.uri,"production-number")));
         this._sBirthDate = String(param1.child(new QName(_loc2_.uri,"birth-date")));
         this._dBirthDate = MakeDate.dateFromBankTime(this._sBirthDate);
         this._sBirthDate = this._sBirthDate.slice(0,10);
         this._sEvolveDate = String(param1.child(new QName(_loc2_.uri,"last-evolution-date")));
         this._dEvolveDate = MakeDate.dateFromBankTime(this._sEvolveDate);
         this._sEvolveDate = this._sEvolveDate.slice(0,10);
         this._nSwarmValue = 0;
         var _loc3_:Namespace = param1.namespace("ns2");
         var _loc4_:XML = param1.child(new QName(_loc3_.uri,"asset-miscellany"))[0];
         if(Boolean(_loc4_))
         {
            this._sNickname = String(_loc4_.child(new QName(_loc3_.uri,"nickname")));
         }
         var _loc5_:Namespace = param1.namespace("ns3");
         var _loc6_:XML = param1.child(new QName(_loc5_.uri,"asset-stat"))[0];
         if(Boolean(_loc6_))
         {
            this._nAssetTypeID = int(_loc6_.child(new QName(_loc5_.uri,"asset-type-id")));
            this._nSpeed = int(_loc6_.child(new QName(_loc5_.uri,"speed")));
            this._nStrength = int(_loc6_.child(new QName(_loc5_.uri,"strength")));
            this._nArmor = int(_loc6_.child(new QName(_loc5_.uri,"armor")));
            this._nHealth = int(_loc6_.child(new QName(_loc5_.uri,"health")));
            this._nKillCount = int(_loc6_.child(new QName(_loc5_.uri,"kill-count")));
            this._nLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"kill-count-lifetime")));
            this._nBattleCount = int(_loc6_.child(new QName(_loc5_.uri,"battle-count")));
            this._nLifeBattleCount = int(_loc6_.child(new QName(_loc5_.uri,"battle-count-lifetime")));
            this._nDeathCount = int(_loc6_.child(new QName(_loc5_.uri,"death-count")));
            this._nLifetimeDeathCount = int(_loc6_.child(new QName(_loc5_.uri,"death-count-lifetime")));
            this._nMagKillCount = int(_loc6_.child(new QName(_loc5_.uri,"magnamod-kill-count")));
            this._nMagLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"magnamod-kill-count-lifetime")));
            this._nHexKillCount = int(_loc6_.child(new QName(_loc5_.uri,"hexite-kill-count")));
            this._nHexLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"hexite-kill-count-lifetime")));
            this._nVelKillCount = int(_loc6_.child(new QName(_loc5_.uri,"velocitron-kill-count")));
            this._nVelLifeKillCount = int(_loc6_.child(new QName(_loc5_.uri,"velocitron-kill-count-lifetime")));
            this._nWinCount = int(_loc6_.child(new QName(_loc5_.uri,"win-count")));
            this._nLifetimeWinCount = int(_loc6_.child(new QName(_loc5_.uri,"win-count-lifetime")));
            this._nCritHitCount = int(_loc6_.child(new QName(_loc5_.uri,"critical-hit-count")));
            this._nWhiffCount = int(_loc6_.child(new QName(_loc5_.uri,"whiff-count")));
            this._bScreenStar = Boolean(_loc6_.child(new QName(_loc5_.uri,"screen-star")));
            this._bScrapedBy = Boolean(_loc6_.child(new QName(_loc5_.uri,"scraped-by")));
            this._bAllAttacksUsed = Boolean(_loc6_.child(new QName(_loc5_.uri,"all-attacks-used")));
            this._bSlacker = Boolean(_loc6_.child(new QName(_loc5_.uri,"slacker")));
            this._nMaxDamageGame = int(_loc6_.child(new QName(_loc5_.uri,"max-damage-game")));
            this._nMaxDamageHit = int(_loc6_.child(new QName(_loc5_.uri,"max-damage-hit")));
            this._nMaxRoundCount = int(_loc6_.child(new QName(_loc5_.uri,"max-round-count")));
         }
      }
      
      public function getBadgeList() : Array
      {
         if(Boolean(this._aBadgeList))
         {
            return this._aBadgeList.slice();
         }
         return new Array();
      }
      
      public function getHexiteKillCount() : int
      {
         return this._nHexKillCount;
      }
      
      public function getHealth() : int
      {
         return this._nHealth;
      }
      
      public function getTypeName() : String
      {
         return this._sTypeName;
      }
      
      public function setStats(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._nHealth = param1;
         this._nArmor = param2;
         this._nSpeed = param3;
         this._nStrength = param4;
      }
      
      public function getMagnamodLifetimeKillCount() : int
      {
         return this._nMagLifeKillCount;
      }
      
      private function assetStatReceived(param1:FrameWorkEvent) : *
      {
         this.parseXMLStats(XML(param1.data));
      }
      
      public function getVelocitronKillCount() : int
      {
         return this._nVelKillCount;
      }
      
      public function updateStats() : *
      {
      }
      
      public function getCriticalHitCount() : int
      {
         return this._nCritHitCount;
      }
      
      private function badgesLoadError(param1:IOErrorEvent) : void
      {
         DebugLog.instance.error(">> VirmonData: badgesLoadError -- " + param1.text);
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.badgesLoadError);
         dispatchEvent(new Event(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR));
      }
      
      public function getHexiteLifetimeKillCount() : int
      {
         return this._nHexLifeKillCount;
      }
      
      public function getWhiffCount() : int
      {
         return this._nWhiffCount;
      }
      
      public function getBadgeById(param1:int) : IBadgeData
      {
         if(!this._aBadgeList)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._aBadgeList.length)
         {
            if(BadgeData(this._aBadgeList[_loc2_]).iId == param1)
            {
               return this._aBadgeList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLifetimeBattleCount() : int
      {
         return this._nLifeBattleCount;
      }
      
      public function areAllAttacksUsed() : Boolean
      {
         return this._bAllAttacksUsed;
      }
      
      public function getBirthDate() : String
      {
         return this._sBirthDate;
      }
      
      public function getFullBirthDate() : Date
      {
         return this._dBirthDate;
      }
      
      public function getArmor() : int
      {
         return this._nArmor;
      }
      
      public function getSpeed() : int
      {
         return this._nSpeed;
      }
      
      public function parseXMLStats(param1:XML) : *
      {
      }
      
      public function getVelocitronLifetimeKillCount() : int
      {
         return this._nVelLifeKillCount;
      }
      
      public function getAssetTypeID() : int
      {
         return this._nAssetTypeID;
      }
      
      public function getFullEvolveDate() : Date
      {
         return this._dEvolveDate;
      }
      
      public function getLifetimeDeathCount() : int
      {
         return this._nLifetimeDeathCount;
      }
      
      public function isScrapedBy() : Boolean
      {
         return this._bScrapedBy;
      }
      
      public function getStrength() : int
      {
         return this._nStrength;
      }
      
      public function isSlacker() : Boolean
      {
         return this._bSlacker;
      }
      
      public function loadBadges() : void
      {
         this._serviceRequestBrokerManager.requestAssetBadges(this._nAssetID,this.badgesReturned,this.badgesLoadError);
      }
      
      public function getEvolveDate() : String
      {
         return this._sEvolveDate;
      }
      
      public function getSwarmValue() : int
      {
         return this._nSwarmValue;
      }
      
      public function getAssetID() : String
      {
         return this._nAssetID;
      }
      
      public function getProductionNumber() : int
      {
         return this._nProdNum;
      }
      
      public function getKillCount() : int
      {
         return this._nKillCount;
      }
      
      public function getMaxDamageGame() : int
      {
         return this._nMaxDamageGame;
      }
      
      public function isScreenStar() : Boolean
      {
         return this._bScreenStar;
      }
      
      public function getDeathCount() : int
      {
         return this._nDeathCount;
      }
      
      public function getMaxRoundCount() : int
      {
         return this._nMaxRoundCount;
      }
      
      public function getLifeKillCount() : int
      {
         return this._nLifeKillCount;
      }
   }
}

