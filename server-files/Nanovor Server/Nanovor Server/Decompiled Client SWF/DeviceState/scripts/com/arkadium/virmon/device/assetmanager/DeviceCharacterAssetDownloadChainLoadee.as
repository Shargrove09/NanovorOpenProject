package com.arkadium.virmon.device.assetmanager
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.device.ILoadProgressUpdater;
   import com.arkadium.virmon.device.LoadProgressUpdaterDecorator;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.HTTPChainLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.IHTTPChainLoadeeConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceCharacterAssetDownloadChainLoadee implements IChainLoadee, IChainLoaderConsumer, IHTTPChainLoadeeConsumer, IDeviceAssetManifestCheckerConsumer
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = true;
      
      private static const LOCATION_REPLACEMENT:String = "%ASSET_TYPE_ID%";
      
      private static const TARGET_FILE_LOCATION:String = "/device/characters/%ASSET_TYPE_ID%/";
      
      private static const DESTINATION_FILE_LOCATION:String = "Assets\\Device\\Characters\\%ASSET_TYPE_ID%\\";
      
      private static const DEVICE_FILES:Array = ["spr.v2z","nano.snd","manifest.xml"];
      
      private var _writeDeviceNanovorListFinishHandler:Function;
      
      private var _downloader:IDownloader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _fileOperator:IFileOperator;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _myChainLoader:IChainLoader;
      
      private var _chainLoader:IChainLoader;
      
      private var _nanovorAssetTypeId:int;
      
      public function DeviceCharacterAssetDownloadChainLoadee(param1:int, param2:IServiceRequestBrokerManager, param3:IFileOperator, param4:IDownloader, param5:ILoadProgressUpdater, param6:Function)
      {
         super();
         log("DeviceCharacterAssetDownloadChainLoadee()");
         if(null == param5)
         {
            throw new Error("Parameter \'loadProgressUpdater\' cannot be null.");
         }
         _nanovorAssetTypeId = param1;
         _serviceRequestBrokerManager = param2;
         _fileOperator = param3;
         _downloader = param4;
         _loadProgressUpdater = param5;
         _writeDeviceNanovorListFinishHandler = param6;
      }
      
      public function manifestCheckComplete(param1:Boolean) : void
      {
         var _loc5_:String = null;
         if(param1)
         {
            log("manifestCheckComplete(): already downloaded.");
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
            return;
         }
         _loadProgressUpdater = new LoadProgressUpdaterDecorator(DEVICE_FILES.length,_loadProgressUpdater);
         var _loc2_:String = DESTINATION_FILE_LOCATION.replace(LOCATION_REPLACEMENT,_nanovorAssetTypeId.toString());
         var _loc3_:String = _serviceRequestBrokerManager.staticFileServiceURL + TARGET_FILE_LOCATION.replace(LOCATION_REPLACEMENT,_nanovorAssetTypeId.toString());
         _fileOperator.makeFolder(_loc2_);
         var _loc4_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc5_ in DEVICE_FILES)
         {
            log("DeviceCharacterAssetDownloader() - Downloading\n\t\t" + _loc3_ + _loc5_ + " to \n\t\t" + _loc2_ + _loc5_);
            _loc4_.add(new HTTPChainLoadee(_loc3_ + _loc5_,_loc2_ + _loc5_,_downloader,IHTTPChainLoadeeConsumer(this)));
         }
         _myChainLoader = new ChainLoader(_loc4_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      public function handleHTTPComplete(param1:String) : void
      {
         log("handleHTTPComplete() - Done downloading + " + param1);
         _loadProgressUpdater.handleItemCompleted();
      }
      
      public function get name() : String
      {
         return "DeviceCharacterAssetDownloadChainLoadee";
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete() - All downloads complete");
         log("handleChainLoaderComplete()");
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _writeDeviceNanovorListFinishHandler();
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<DeviceCharacterAssetDownloadChainLoadee>>\t" + param1);
         }
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function load() : void
      {
         log("load()");
         new DeviceCharacterManifestChecker(_nanovorAssetTypeId,_fileOperator,_serviceRequestBrokerManager,IDeviceAssetManifestCheckerConsumer(this));
      }
      
      public function handleHTTPError() : void
      {
         log("handleHTTPError() - Error downloading current mdmHTTP file");
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Transfer Error","File transfer was interrupted.\nPlease try again later.",0,handleTransferErrorConfirmed,handleTransferErrorConfirmed);
      }
      
      public function handleHTTPProgress(param1:int, param2:int) : void
      {
         log("handleHTTPProgress() - Current progress: " + param1.toString() + "/" + param2.toString());
         _loadProgressUpdater.updateCurrentItemProgress(0.99 * param1 / param2);
      }
   }
}

