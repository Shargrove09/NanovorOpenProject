package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Dictionary;
   
   public class BadgeManager extends EventDispatcher implements IBadgeManager
   {
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _aUserBadges:Array;
      
      private var _masterBadgesLookup:Dictionary;
      
      public function BadgeManager(param1:IServiceRequestBrokerManager)
      {
         super();
         this._serviceRequestBrokerManager = param1;
         this._aUserBadges = new Array();
         this._masterBadgesLookup = new Dictionary();
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> Badge Mgr: " + param1);
      }
      
      public function getAccountBadgeData(param1:int) : BadgeMasterData
      {
         if(this._masterBadgesLookup[param1] == null)
         {
            this.logError("getAccountBadgeData: failed to find badge id==" + param1 + "; returning null");
            return null;
         }
         return this._masterBadgesLookup[param1];
      }
      
      public function onInitialize() : void
      {
      }
      
      public function getAssetBadgeData(param1:int) : BadgeMasterData
      {
         if(this._masterBadgesLookup[param1] == null)
         {
            this.logError("getAssetBadgeData: failed to find badge id==" + param1 + "; returning null");
            return null;
         }
         return this._masterBadgesLookup[param1];
      }
      
      private function badgesReturned(param1:Event) : *
      {
         var _loc5_:IBadgeData = null;
         var _loc6_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.badgeStatFailed);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = Utils.StripXmlNamespace(new XML(_loc2_));
         var _loc4_:XMLList = _loc3_.child("badge");
         this._aUserBadges = new Array(_loc4_.length());
         while(_loc6_ < this._aUserBadges.length)
         {
            _loc5_ = new BadgeData();
            _loc5_.sType = BadgeData.TYPE_ACCOUNT;
            _loc5_.parseXMLData(_loc4_[_loc6_]);
            this._aUserBadges[_loc6_] = _loc5_;
            _loc6_++;
         }
         this.log("badgesReturned: got " + this._aUserBadges.length + " account badge(s)");
         dispatchEvent(new FrameWorkEvent(FrameWorkEvent.BM_ACCOUNT_BADGES_UPDATED));
      }
      
      public function setList(param1:XML) : void
      {
         this.badgeMasterReceived(param1);
         this.assetListReceived();
      }
      
      public function logError(param1:String) : void
      {
         DebugLog.instance.error("** Badge Mgr: " + param1);
      }
      
      private function badgeMasterReceived(param1:XML) : *
      {
         var _loc4_:int = 0;
         var _loc5_:BadgeMasterData = null;
         var _loc2_:Namespace = param1.namespace();
         var _loc3_:XMLList = param1.child(new QName(_loc2_.uri,"asset-badge"));
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new BadgeMasterData();
            _loc5_.parseXMLData(_loc3_[_loc4_]);
            this._masterBadgesLookup[_loc5_.getID()] = _loc5_;
            _loc4_++;
         }
         _loc3_ = param1.child(new QName(_loc2_.uri,"account-badge"));
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new BadgeMasterData();
            _loc5_.parseXMLData(_loc3_[_loc4_]);
            this._masterBadgesLookup[_loc5_.getID()] = _loc5_;
            _loc4_++;
         }
      }
      
      public function getUserBadge(param1:int) : IBadgeData
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._aUserBadges.length)
         {
            if(param1 == BadgeData(this._aUserBadges[_loc2_]).getID())
            {
               return this._aUserBadges[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function badgeStatFailed(param1:IOErrorEvent) : *
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.badgesReturned);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.badgeStatFailed);
         this.logError("BADGE STAT FAILED");
         trace("BADGE STAT FAILED");
      }
      
      private function assetListReceived() : void
      {
         this.loadAndParseAccountBadges();
      }
      
      public function getUserBadgeList() : Array
      {
         return this._aUserBadges.slice();
      }
      
      public function loadAndParseAccountBadges() : void
      {
         this._serviceRequestBrokerManager.requestAccountBadges(this.badgesReturned,this.badgeStatFailed);
      }
   }
}

