package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   
   public class BoosterAssetRetriever implements IBoosterAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      private const _MANIFEST_NAME:String = "Boosters";
      
      public function BoosterAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getBoosterPackIconURL(param1:int, param2:int) : IAssetURL
      {
         return _assetManager.getAssetURL(_MANIFEST_NAME,"pack_icons_booster" + param1,param2.toString());
      }
      
      public function getBoosterFamilyIconURL(param1:int) : IAssetURL
      {
         return _assetManager.getAssetURL(_MANIFEST_NAME,"booster_family_icons",param1.toString());
      }
   }
}

