package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.FileOperatorDeleteFolderChainLoadee;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceMiniGameWriter implements IDeviceMiniGameWriter, IChainLoaderConsumer
   {
      
      private static const MINI_GAME_COUNT:int = 4;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _writeDeviceMiniGameListFinishHandler:Function;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceMiniGameWriter(param1:IDeviceManager, param2:IFileOperator)
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
         _deviceManager = param1;
         _fileOperator = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceMiniGameWriter>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _writeDeviceMiniGameListFinishHandler();
      }
      
      public function destroy() : void
      {
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      public function writeDeviceMiniGameList(param1:Array, param2:ILoadProgressUpdater, param3:Function) : void
      {
         var _loc7_:String = null;
         _writeDeviceMiniGameListFinishHandler = param3;
         log("writeDeviceMiniGameList(): deviceMiniGameList.length: " + param1.length);
         var _loc4_:ChainLoadeeList = new ChainLoadeeList();
         var _loc5_:int = 0;
         while(_loc5_ < MINI_GAME_COUNT)
         {
            _loc4_.add(new FileOperatorDeleteFolderChainLoadee("g" + (_loc5_ + 1),_fileOperator));
            _loc5_++;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc7_ = GameData(param1[_loc6_]).gameFileName;
            log("adding device mini game: " + _loc7_);
            _loc4_.add(new DeviceMiniGameChainLoadee(_loc7_,_loc6_,param2,_deviceManager.driveLetter,_deviceManager.download,_fileOperator));
            _loc6_++;
         }
         _chainLoader = new ChainLoader(_loc4_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
   }
}

