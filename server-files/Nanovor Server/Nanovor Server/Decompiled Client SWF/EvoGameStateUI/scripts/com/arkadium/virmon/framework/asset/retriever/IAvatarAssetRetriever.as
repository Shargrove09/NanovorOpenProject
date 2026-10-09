package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   
   public interface IAvatarAssetRetriever
   {
      
      function getAvatarURL(param1:AvatarAssetType, param2:int) : IAssetURL;
      
      function getAvatarAssetList(param1:AvatarAssetType) : Array;
   }
}

