package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   
   public interface IMasterDataAssetRetriever
   {
      
      function getMasterDataURL(param1:MasterDataAssetType) : IAssetURL;
   }
}

