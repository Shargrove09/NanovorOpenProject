package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   
   public class MasterDataAssetRetriever implements IMasterDataAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function MasterDataAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getMasterDataURL(param1:MasterDataAssetType) : IAssetURL
      {
         return _assetManager.getAssetURL(AssetLocation.ROOT_MANIFEST_NAME.name,"master_data",param1.name);
      }
   }
}

