package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.HelpAssetType;
   
   public class HelpAssetRetriever implements IHelpAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function HelpAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getHelpURL(param1:HelpAssetType) : IAssetURL
      {
         return _assetManager.getAssetURL(AssetLocation.ROOT_MANIFEST_NAME.name,"help",param1.name);
      }
   }
}

