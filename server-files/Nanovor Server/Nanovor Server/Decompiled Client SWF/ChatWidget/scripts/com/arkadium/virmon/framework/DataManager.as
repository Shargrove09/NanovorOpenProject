package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class DataManager extends EventDispatcher implements IDataManager
   {
      
      private static var _oInstance:IDataManager = null;
      
      private var _oVirmonManager:IVirmonManager;
      
      private var _oBadgeManager:IBadgeManager;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _oEMManager:IEMManager;
      
      private var _oEvoManager:IEvoManager;
      
      public function DataManager()
      {
         super();
      }
      
      public static function getInstance() : IDataManager
      {
         if(!_oInstance)
         {
            _oInstance = new DataManager();
         }
         return _oInstance;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DataManager: " + param1);
      }
      
      public function getBadgeManager() : IBadgeManager
      {
         return this._oBadgeManager;
      }
      
      private function assetListFailed(param1:IOErrorEvent) : void
      {
         var oEvent:IOErrorEvent = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,this.assetListReceived);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,this.assetListFailed);
         }
         catch(e:Error)
         {
            logError("assetListFailed(): " + oEvent.text);
         }
      }
      
      public function onInitialize(param1:IServiceRequestBrokerManager) : *
      {
         this.log("Initialize");
         this._serviceRequestBrokerManager = param1;
         this._oVirmonManager = new VirmonManager(this._serviceRequestBrokerManager);
         this._oVirmonManager.onInitialize();
         this._oEMManager = new EMManager();
         this._oEMManager.onInitialize();
         this._oEvoManager = new EvoManager();
         this._oEvoManager.onInitialize();
         this._oBadgeManager = new BadgeManager(this._serviceRequestBrokerManager);
         this._oBadgeManager.onInitialize();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DataManager: " + param1);
      }
      
      public function getEvoManager() : IEvoManager
      {
         return this._oEvoManager;
      }
      
      public function getEMManager() : IEMManager
      {
         return this._oEMManager;
      }
      
      private function assetListReceived(param1:Event) : void
      {
         var oCustomEvent:FrameWorkEvent;
         var oEvent:Event = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,this.assetListReceived);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,this.assetListFailed);
         }
         catch(e:Error)
         {
            logError("assetListReceived(): " + e.message);
         }
         oCustomEvent = new FrameWorkEvent(FrameWorkEvent.CM_ASSET_LIST_RECEIVED);
         oCustomEvent.data = oEvent.target.data;
         dispatchEvent(oCustomEvent);
      }
      
      public function getVirmonManager() : IVirmonManager
      {
         return this._oVirmonManager;
      }
      
      public function refreshData() : void
      {
         var _loc1_:String = this._serviceRequestBrokerManager.getAssetListURL();
         _loc1_ = encodeURI(Utils.appendKillCache(_loc1_));
         var _loc2_:URLLoader = new URLLoader();
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         _loc2_.addEventListener(Event.COMPLETE,this.assetListReceived);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.assetListFailed);
         _loc2_.load(_loc3_);
      }
   }
}

