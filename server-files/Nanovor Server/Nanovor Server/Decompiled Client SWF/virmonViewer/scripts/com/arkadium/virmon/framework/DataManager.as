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
         return _oBadgeManager;
      }
      
      private function assetListFailed(param1:IOErrorEvent) : void
      {
         var oEvent:IOErrorEvent = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,assetListReceived);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,assetListFailed);
         }
         catch(e:Error)
         {
            logError("assetListFailed(): " + oEvent.text);
         }
      }
      
      public function onInitialize(param1:IServiceRequestBrokerManager) : *
      {
         log("Initialize");
         _serviceRequestBrokerManager = param1;
         _oVirmonManager = new VirmonManager(_serviceRequestBrokerManager);
         _oVirmonManager.onInitialize();
         _oEMManager = new EMManager();
         _oEMManager.onInitialize();
         _oEvoManager = new EvoManager();
         _oEvoManager.onInitialize();
         _oBadgeManager = new BadgeManager(_serviceRequestBrokerManager);
         _oBadgeManager.onInitialize();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DataManager: " + param1);
      }
      
      public function getEvoManager() : IEvoManager
      {
         return _oEvoManager;
      }
      
      public function getEMManager() : IEMManager
      {
         return _oEMManager;
      }
      
      private function assetListReceived(param1:Event) : void
      {
         var oCustomEvent:FrameWorkEvent;
         var oEvent:Event = param1;
         try
         {
            oEvent.target.removeEventListener(Event.COMPLETE,assetListReceived);
            oEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,assetListFailed);
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
         return _oVirmonManager;
      }
      
      public function refreshData() : void
      {
         var _loc1_:String = _serviceRequestBrokerManager.getAssetListURL();
         _loc1_ = encodeURI(Utils.appendKillCache(_loc1_));
         var _loc2_:URLLoader = new URLLoader();
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         _loc2_.addEventListener(Event.COMPLETE,assetListReceived);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,assetListFailed);
         _loc2_.load(_loc3_);
      }
   }
}

