package com.arkadium.virmon.framework.asset.retriever
{
   public interface IBoosterAssetRetriever
   {
      
      function getBoosterFamilyIconURL(param1:int) : IAssetURL;
      
      function getBoosterPackIconURL(param1:int, param2:int) : IAssetURL;
   }
}

