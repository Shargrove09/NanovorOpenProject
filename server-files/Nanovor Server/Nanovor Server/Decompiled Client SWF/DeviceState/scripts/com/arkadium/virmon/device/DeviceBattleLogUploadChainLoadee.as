package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.NMPInfoLoadee;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceBattleLogUploadChainLoadee implements IChainLoadee, IChainLoaderConsumer
   {
      
      private static const BATTLE_LOG_FILE:String = "clog.bbb";
      
      private static const PRE_UPLOAD_HASH:String = "preCLOGUploadHash";
      
      private static const POST_UPLOAD_HASH:String = "postCLOGUploadHash";
      
      public static const NAME:String = "DeviceBattleLogUploadChainLoadee";
      
      private var _myChainLoader:IChainLoader;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _deviceManager:IDeviceManager;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceBattleLogUploadChainLoadee(param1:IDeviceManager, param2:IDeviceManagerCommunicator, param3:ILoadProgressUpdater, param4:IFileOperator, param5:IServiceRequestBrokerManager)
      {
         super();
         _deviceManager = param1;
         _deviceManagerCommunicator = param2;
         _loadProgressUpdater = param3;
         _fileOperator = param4;
         _serviceRequestBrokerManager = param5;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceBattleLogUploadChainLoadee>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc2_:int = int(param1.getLoadedAsset(_deviceManager.driveLetter + BATTLE_LOG_FILE));
         var _loc3_:int = int(param1.getLoadedAsset(NMPInfoLoadee.NAME + PRE_UPLOAD_HASH));
         var _loc4_:int = int(param1.getLoadedAsset(NMPInfoLoadee.NAME + POST_UPLOAD_HASH));
         var _loc5_:int = _loc4_ - _loc3_;
         var _loc6_:BattleLogUpdateData = new BattleLogUpdateData(_loc5_,_loc2_);
         log("handleChainLoaderComplete() - nmp: pre: " + _loc3_ + ", post: " + _loc4_ + ", delta: " + _loc5_ + ", updates: " + _loc2_);
         _loadProgressUpdater.handleItemCompleted();
         _chainLoader.handleChainLoadeeComplete(_loc6_);
      }
      
      public function load() : void
      {
         var _loc1_:ChainLoadeeList = null;
         log("load() looking for CLOG at " + _deviceManager.driveLetter + BATTLE_LOG_FILE);
         _fileOperator.deleteFile(_deviceManager.driveLetter + BATTLE_LOG_FILE);
         if(_fileOperator.doesFileExist(_deviceManager.driveLetter + BATTLE_LOG_FILE))
         {
            log("load() CLOG found, uploading..");
            _loadProgressUpdater.addStatusTextLine("UPLOADING BATTLE LOG...0%");
            _loc1_ = new ChainLoadeeList();
            _loc1_.add(new NMPInfoLoadee(_serviceRequestBrokerManager,PRE_UPLOAD_HASH));
            _loc1_.add(new DeviceLogChainLoadee(_deviceManager.driveLetter + BATTLE_LOG_FILE,new BattleLogUploader(_deviceManagerCommunicator,_deviceManager.deviceID),_fileOperator,_deviceManager.deviceID));
            _loc1_.add(new NMPInfoLoadee(_serviceRequestBrokerManager,POST_UPLOAD_HASH));
            _myChainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
            _myChainLoader.load();
         }
         else
         {
            log("load() no CLOG found, continuing");
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
         }
      }
      
      public function get name() : String
      {
         return DeviceBattleLogUploadChainLoadee.NAME;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

