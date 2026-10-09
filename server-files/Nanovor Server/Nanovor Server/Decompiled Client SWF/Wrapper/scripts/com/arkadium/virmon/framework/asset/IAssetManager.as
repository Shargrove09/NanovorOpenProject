package com.arkadium.virmon.framework.asset
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public interface IAssetManager
   {
      
      function init(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:Function, param6:IFileOperator, param7:IVirmonDataRetriever, param8:IEvoDataRetriever, param9:IAnalyticsManager) : void;
      
      function getManifestSuperName(param1:String) : String;
      
      function getAssetURL(param1:String, param2:String, param3:String, param4:AssetURLType = null, param5:int = 0) : IAssetURL;
      
      function get assetRetrieverManager() : IAssetRetrieverManager;
      
      function getAssetList(param1:String, param2:String) : Array;
      
      function downloadBackgroundAssets() : void;
      
      function downloadRequiredAssets() : void;
      
      function loadManifests() : void;
   }
}

