package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   
   public class BadgeAssetRetriever implements IBadgeAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function BadgeAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getBadgeURL(param1:int) : IAssetURL
      {
         return _assetManager.getAssetURL(AssetLocation.ROOT_MANIFEST_NAME.name,"badge",param1.toString());
      }
   }
}

