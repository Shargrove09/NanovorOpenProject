package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.OverlayAssetType;
   
   public interface IOverlayAssetRetriever
   {
      
      function getOverlayURL(param1:OverlayAssetType, param2:int) : IAssetURL;
   }
}

