package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.data.JoltsInfo;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.JoltsInfoLoadee;
   import com.arkadium.virmon.state.IStateManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class DeviceJoltsUploadChainLoadee implements IChainLoadee, IChainLoaderConsumer
   {
      
      private static const DEBUG_COMPARE_JOLTS:Boolean = false;
      
      private static const JOLTS_FILE_PATTERN:String = "jolts*.bbb";
      
      private static const PRE_UPLOAD_HASH:String = "preUploadHash";
      
      private static const POST_UPLOAD_HASH:String = "postUploadHash";
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      private var _sortedJoltsFileList:Array;
      
      private var _myChainLoader:IChainLoader;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _stateManager:IStateManager;
      
      public function DeviceJoltsUploadChainLoadee(param1:IDeviceManager, param2:IDeviceManagerCommunicator, param3:ILoadProgressUpdater, param4:IFileOperator, param5:IStateManager, param6:IServiceRequestBrokerManager)
      {
         super();
         _deviceManager = param1;
         _deviceManagerCommunicator = param2;
         _loadProgressUpdater = param3;
         _fileOperator = param4;
         _stateManager = param5;
         _serviceRequestBrokerManager = param6;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceJoltsUploadChainLoadee>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:JoltsInfo = null;
         var _loc9_:JoltsInfo = null;
         var _loc10_:ByteArray = null;
         if(DEBUG_COMPARE_JOLTS)
         {
            _loc8_ = param1.getLoadedAsset(JoltsInfoLoadee.NAME + PRE_UPLOAD_HASH) as JoltsInfo;
         }
         if(DEBUG_COMPARE_JOLTS)
         {
            _loc9_ = param1.getLoadedAsset(JoltsInfoLoadee.NAME + POST_UPLOAD_HASH) as JoltsInfo;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in _sortedJoltsFileList)
         {
            _loc10_ = param1.getLoadedAsset(DeviceJoltsFileUploadChainLoadee.NAME + _loc6_) as ByteArray;
            if(null != _loc10_)
            {
               _loc10_.position = 22;
               _loc10_.endian = Endian.LITTLE_ENDIAN;
               _loc2_ += _loc10_.readInt();
               _loc3_ += _loc10_.readInt();
               _loc4_ += _loc10_.readInt();
               _loc5_ += _loc10_.readInt();
            }
         }
         _loc7_ = new JoltsInfo(_loc5_,_loc4_,_loc3_,_loc2_);
         log("handleChainLoaderComplete() - Device Jolts: " + _loc7_);
         if(DEBUG_COMPARE_JOLTS && !_loc8_.plus(_loc7_).equals(_loc9_))
         {
            log("handleChainLoaderComplete() - Jolts uploaded numbers do not match expected, possibly hitting jolts earned velocity cap 1 jolt/sec?");
         }
         log("handleChainLoaderComplete() - Finished uploading and verifying Jolts.");
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function get name() : String
      {
         return "DeviceJoltsUploadChainLoadee";
      }
      
      private function getUsbConnectionSequenceNumber(param1:String) : int
      {
         return int(String(param1).replace(/^[jJ][oO][lL][tT][sS]-([0-9]+)\.[bB]{3}/,"$1"));
      }
      
      public function load() : void
      {
         var _loc2_:String = null;
         _loadProgressUpdater.addStatusTextLine("UPLOADING JOLTS...0%");
         _sortedJoltsFileList = getSortedJoltsFileList();
         log("load() - Number of jolts files found: " + _sortedJoltsFileList.length);
         if(0 == _sortedJoltsFileList.length)
         {
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
            return;
         }
         log("load() - Jolts file found, uploading...");
         _loadProgressUpdater = new LoadProgressUpdaterDecorator(_sortedJoltsFileList.length,_loadProgressUpdater);
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc2_ in _sortedJoltsFileList)
         {
            if(DEBUG_COMPARE_JOLTS)
            {
               _loc1_.add(new JoltsInfoLoadee(_serviceRequestBrokerManager,PRE_UPLOAD_HASH));
            }
            _loc1_.add(new DeviceJoltsFileUploadChainLoadee(_fileOperator,_stateManager,_deviceManager.driveLetter + _loc2_,_deviceManager,_deviceManagerCommunicator,_loadProgressUpdater,_loc2_));
            if(DEBUG_COMPARE_JOLTS)
            {
               _loc1_.add(new JoltsInfoLoadee(_serviceRequestBrokerManager,POST_UPLOAD_HASH));
            }
         }
         _myChainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function getSortedJoltsFileList() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = _fileOperator.getFileList(_deviceManager.driveLetter,JOLTS_FILE_PATTERN);
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push({
               "fileName":_loc3_,
               "usbConnectionSequenceNumber":getUsbConnectionSequenceNumber(_loc3_)
            });
         }
         _loc1_.sortOn("usbConnectionSequenceNumber",Array.NUMERIC);
         _loc4_ = new Array();
         for each(_loc5_ in _loc1_)
         {
            _loc4_.push(_loc5_.fileName);
         }
         return _loc4_;
      }
   }
}

