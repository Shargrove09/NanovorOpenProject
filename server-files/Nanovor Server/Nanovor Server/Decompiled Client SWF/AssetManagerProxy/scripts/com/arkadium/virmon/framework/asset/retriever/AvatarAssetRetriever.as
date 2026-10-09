package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   
   public class AvatarAssetRetriever implements IAvatarAssetRetriever
   {
      
      private const _MANIFEST_NAME:String = "Avatars";
      
      private var _assetManager:IAssetManager;
      
      public function AvatarAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getAvatarURL(param1:AvatarAssetType, param2:int) : IAssetURL
      {
         return _assetManager.getAssetURL(_MANIFEST_NAME,param1.name,param2.toString());
      }
      
      public function getAvatarAssetList(param1:AvatarAssetType) : Array
      {
         return _assetManager.getAssetList(_MANIFEST_NAME,param1.name);
      }
   }
}

