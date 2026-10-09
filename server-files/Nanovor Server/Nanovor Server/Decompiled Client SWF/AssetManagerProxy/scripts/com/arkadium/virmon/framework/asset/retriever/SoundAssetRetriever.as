package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   
   public class SoundAssetRetriever implements ISoundAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function SoundAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getMusicURL(param1:String) : IAssetURL
      {
         return _assetManager.getAssetURL("Sound","Music",param1);
      }
   }
}

