package com.arkadium.virmon.device.assetmanager
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceCharacterManifestChecker extends DeviceAssetManifestChecker
   {
      
      private static const BASE_FOLDER:String = "Assets\\Device\\Characters\\";
      
      private static const DEVICE_FILES:Array = ["spr.v2z","nano.snd","manifest.xml"];
      
      private static const LOCATION_REPLACEMENT:String = "%ASSET_TYPE_ID%";
      
      private static const LOCAL_FILE_LOCATION:String = "/Assets/Device/Characters/%ASSET_TYPE_ID%/manifest.xml";
      
      private static const SFS_FILE_LOCATION:String = "/device/characters/%ASSET_TYPE_ID%/manifest.xml";
      
      private var _nanovorAssetTypeId:int;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceCharacterManifestChecker(param1:int, param2:IFileOperator, param3:IServiceRequestBrokerManager, param4:IDeviceAssetManifestCheckerConsumer)
      {
         _nanovorAssetTypeId = param1;
         _fileOperator = param2;
         var _loc5_:* = LOCAL_FILE_LOCATION.replace(LOCATION_REPLACEMENT,param1.toString());
         var _loc6_:* = SFS_FILE_LOCATION.replace(LOCATION_REPLACEMENT,param1.toString());
         _loc6_ = param3.staticFileServiceURL + _loc6_;
         if(false == checkFoldersAndFilesExist())
         {
            _loc5_ = _loc6_ = null;
         }
         super(_loc5_,_loc6_,param4);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceCharacterManifestChecker>> " + param1);
      }
      
      private function checkFoldersAndFilesExist() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:* = BASE_FOLDER + _nanovorAssetTypeId;
         log("checkFoldersAndFilesExist() - Base path: " + _loc1_);
         if(false == _fileOperator.doesFolderExist(_loc1_))
         {
            return false;
         }
         for each(_loc2_ in DEVICE_FILES)
         {
            if(false == _fileOperator.doesFileExist(_loc1_ + "\\" + _loc2_))
            {
               return false;
            }
         }
         return true;
      }
   }
}

