package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.HelpAssetType;
   
   public interface IHelpAssetRetriever
   {
      
      function getHelpURL(param1:HelpAssetType) : IAssetURL;
   }
}

