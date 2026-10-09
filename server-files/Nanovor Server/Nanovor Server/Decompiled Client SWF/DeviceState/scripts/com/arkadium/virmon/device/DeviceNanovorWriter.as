package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.device.assetmanager.DeviceCharacterAssetDownloadChainLoadee;
   import com.arkadium.virmon.device.assetmanager.DeviceCharacterAssetWriterChainLoadee;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.FileOperatorDeleteFolderChainLoadee;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceNanovorWriter implements IDeviceNanovorWriter, IChainLoaderConsumer
   {
      
      private static const NANOVOR_COUNT:uint = 10;
      
      private var _downloader:IDownloader;
      
      private var _writeDeviceNanovorListFinishHandler:Function;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceNanovorWriter(param1:IDeviceManager, param2:IFileOperator, param3:IDownloader, param4:IServiceRequestBrokerManager)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"deviceManager\" cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \"fileOperator\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"downloader\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"serviceRequestBrokerManager\" cannot be null.");
         }
         _deviceManager = param1;
         _fileOperator = param2;
         _downloader = param3;
         _serviceRequestBrokerManager = param4;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceNanovorWriter>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _writeDeviceNanovorListFinishHandler();
      }
      
      public function writeDeviceNanovorList(param1:Array, param2:ILoadProgressMonitor, param3:Function) : void
      {
         var _loc8_:INanovor = null;
         log("writeDeviceNanovorList(): deviceNanovorList.length: " + param1.length);
         _writeDeviceNanovorListFinishHandler = param3;
         var _loc4_:Array = getUniqueAssetTypeIds(param1);
         var _loc5_:ILoadProgressUpdater = new LoadProgressUpdater(param1.length + _loc4_.length,param2);
         var _loc6_:ChainLoadeeList = new ChainLoadeeList();
         var _loc7_:uint = 0;
         while(_loc7_ < 10)
         {
            _loc6_.add(new FileOperatorDeleteFolderChainLoadee(_deviceManager.driveLetter + "v" + (_loc7_ + 1),_fileOperator));
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_ = param1[_loc7_] as INanovor;
            if(-1 != _loc4_.indexOf(_loc8_.assetTypeId))
            {
               _loc6_.add(new DeviceCharacterAssetDownloadChainLoadee(_loc8_.assetTypeId,_serviceRequestBrokerManager,_fileOperator,_downloader,_loc5_,_writeDeviceNanovorListFinishHandler));
               _loc4_.splice(_loc4_.indexOf(_loc8_.assetTypeId),1);
            }
            _loc6_.add(new DeviceNanovorBinaryChainLoadee(_deviceManager,_fileOperator,_loc8_.assetId,_deviceManager.driveLetter + "v" + (_loc7_ + 1)));
            _loc6_.add(new DeviceCharacterAssetWriterChainLoadee(_loc8_.assetTypeId,_deviceManager.driveLetter + "v" + (_loc7_ + 1) + "\\",_fileOperator,_loc5_,_loc7_,param1.length));
            _loc7_++;
         }
         _chainLoader = new ChainLoader(_loc6_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function destroy() : void
      {
         log("destroy()");
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      private function getUniqueAssetTypeIds(param1:Array) : Array
      {
         var _loc3_:INanovor = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(-1 == _loc2_.indexOf(_loc3_.assetTypeId))
            {
               _loc2_.push(_loc3_.assetTypeId);
            }
         }
         return _loc2_;
      }
   }
}

