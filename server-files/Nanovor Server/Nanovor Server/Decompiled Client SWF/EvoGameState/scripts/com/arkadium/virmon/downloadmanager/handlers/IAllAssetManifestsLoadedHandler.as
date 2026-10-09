package com.arkadium.virmon.downloadmanager.handlers
{
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   
   public interface IAllAssetManifestsLoadedHandler
   {
      
      function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void;
   }
}

