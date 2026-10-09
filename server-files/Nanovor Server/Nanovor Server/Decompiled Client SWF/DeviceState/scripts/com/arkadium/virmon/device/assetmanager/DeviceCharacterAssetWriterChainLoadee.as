package com.arkadium.virmon.device.assetmanager
{
   import com.arkadium.virmon.device.ILoadProgressUpdater;
   import com.arkadium.virmon.device.LoadProgressUpdaterDecorator;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.FileOperatorCopyChainLoadee;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceCharacterAssetWriterChainLoadee implements IChainLoadee, IChainLoaderConsumer
   {
      
      public static const NAME:String = "DeviceCharacterAssetWriterChainLoadee";
      
      private static const DEVICE_ASSET_TYPE_ID:String = "%DEVICE_ASSET_TYPE_ID%";
      
      private static const ASSET_FOLDER_PATH:String = "Assets\\Device\\Characters\\%DEVICE_ASSET_TYPE_ID%\\";
      
      private static const DEVICE_FILES:Array = ["spr.v2z","nano.snd"];
      
      private var _destinationFolderPath:String;
      
      private var _nanovorAssetTypeId:int;
      
      private var _myChainLoader:IChainLoader;
      
      private var _chainLoader:IChainLoader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceCharacterAssetWriterChainLoadee(param1:int, param2:String, param3:IFileOperator, param4:ILoadProgressUpdater, param5:int, param6:int)
      {
         super();
         if(null == param2)
         {
            throw new Error("Parameter \'destinationFolderPath\' cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \'fileOperator\' cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \'loadProgressUpdater\' cannot be null.");
         }
         _nanovorAssetTypeId = param1;
         _destinationFolderPath = param2;
         _fileOperator = param3;
         _loadProgressUpdater = new LoadProgressUpdaterDecorator(DEVICE_FILES.length,param4);
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         var _loc3_:String = null;
         log("load()");
         var _loc1_:String = ASSET_FOLDER_PATH.replace(DEVICE_ASSET_TYPE_ID,_nanovorAssetTypeId.toString());
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc3_ in DEVICE_FILES)
         {
            _loc2_.add(new FileOperatorCopyChainLoadee(_loc1_ + _loc3_,_destinationFolderPath + _loc3_,_fileOperator,_loadProgressUpdater));
         }
         _myChainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceCharacterAssetWriterChainLoadee>>\t" + param1);
      }
   }
}

