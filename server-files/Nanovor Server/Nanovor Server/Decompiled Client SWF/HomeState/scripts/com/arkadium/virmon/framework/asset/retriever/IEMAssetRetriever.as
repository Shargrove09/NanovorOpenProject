package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.EMAssetType;
   
   public interface IEMAssetRetriever
   {
      
      function getEMURL(param1:EMAssetType, param2:int) : IAssetURL;
   }
}

