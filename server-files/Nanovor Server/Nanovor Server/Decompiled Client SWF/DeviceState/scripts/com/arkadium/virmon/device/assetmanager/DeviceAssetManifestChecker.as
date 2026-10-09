package com.arkadium.virmon.device.assetmanager
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   
   public class DeviceAssetManifestChecker implements IChainLoaderConsumer
   {
      
      private var _manifestPath:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _otherManifestPath:String;
      
      private var _consumer:IDeviceAssetManifestCheckerConsumer;
      
      public function DeviceAssetManifestChecker(param1:String, param2:String, param3:IDeviceAssetManifestCheckerConsumer)
      {
         super();
         if(null == param1 || null == param2)
         {
            param3.manifestCheckComplete(false);
            return;
         }
         _consumer = param3;
         _manifestPath = param1;
         _otherManifestPath = param2;
         var _loc4_:ChainLoadeeList = new ChainLoadeeList();
         _loc4_.add(new URLAssetChainLoadee(_manifestPath));
         _loc4_.add(new URLAssetChainLoadee(_otherManifestPath));
         _chainLoader = new ChainLoader(_loc4_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc2_:String = param1.getLoadedAsset(_manifestPath) as String;
         var _loc3_:String = param1.getLoadedAsset(_otherManifestPath) as String;
         _consumer.manifestCheckComplete(_loc2_ == _loc3_);
      }
   }
}

