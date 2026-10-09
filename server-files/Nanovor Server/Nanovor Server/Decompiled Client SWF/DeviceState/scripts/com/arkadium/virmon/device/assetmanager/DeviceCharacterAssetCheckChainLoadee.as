package com.arkadium.virmon.device.assetmanager
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceCharacterAssetCheckChainLoadee implements IChainLoadee, IDeviceAssetManifestCheckerConsumer
   {
      
      public static const NAME:String = "DeviceCharacterAssetCheckChainLoadee";
      
      private var _fileOperator:IFileOperator;
      
      private var _chainLoader:IChainLoader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _nanovorAssetTypeId:int;
      
      public function DeviceCharacterAssetCheckChainLoadee(param1:int, param2:IFileOperator, param3:IServiceRequestBrokerManager)
      {
         super();
         _nanovorAssetTypeId = param1;
         _fileOperator = param2;
         _serviceRequestBrokerManager = param3;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceCharacterAssetCheckChainLoadee>>\t" + param1);
      }
      
      public function get name() : String
      {
         return NAME + _nanovorAssetTypeId;
      }
      
      public function load() : void
      {
         new DeviceCharacterManifestChecker(_nanovorAssetTypeId,_fileOperator,_serviceRequestBrokerManager,IDeviceAssetManifestCheckerConsumer(this));
      }
      
      public function manifestCheckComplete(param1:Boolean) : void
      {
         _chainLoader.handleChainLoadeeComplete(param1);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

