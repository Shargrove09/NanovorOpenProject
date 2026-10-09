package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.EMAssetType;
   
   public class EMAssetRetriever implements IEMAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function EMAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getEMURL(param1:EMAssetType, param2:int) : IAssetURL
      {
         return _assetManager.getAssetURL("EMs",param1.name,param2.toString());
      }
   }
}

