package com.arkadium.virmon.framework.asset
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class AssetDownloader implements IAssetDownloader
   {
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _nestedAssetDownloader:INestedAssetDownloader;
      
      private var _staticFileServiceURLProvider:IStaticFileServiceURLProvider;
      
      private var _downloader:IDownloader;
      
      private var _userProfile:IUserProfile;
      
      private var _preMinSetDownloadList:IAssetDownloadItemList;
      
      private var _requiredDownloadList:IAssetDownloadItemList;
      
      private var _optionalDownloadList:IAssetDownloadItemList;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _isCheckForNanocashEnabled:Boolean;
      
      private var _assetRetrieverManager:IAssetRetrieverManager;
      
      public function AssetDownloader(param1:IManifestComparator, param2:IDownloader, param3:IStaticFileServiceURLProvider, param4:IDownloadManagerStatusMediator, param5:IUserProfile, param6:Boolean, param7:IVirmonDataRetriever, param8:IEvoDataRetriever, param9:IAssetRetrieverManager, param10:IAnalyticsManager)
      {
         super();
         _preMinSetDownloadList = param1.preMinSetDownloadList;
         _requiredDownloadList = param1.requiredDownloadList;
         _optionalDownloadList = param1.optionalDownloadList;
         _downloader = param2;
         _staticFileServiceURLProvider = param3;
         _downloadManagerStatusMediator = param4;
         _userProfile = param5;
         _isCheckForNanocashEnabled = param6;
         _virmonDataRetriever = param7;
         _evoDataRetriever = param8;
         _assetRetrieverManager = param9;
         _analyticsManager = param10;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AssetDownloader: " + param1);
      }
      
      private function handleOptionalAssetsDownloaded() : void
      {
         log("handleOptionalAssetsDownloaded()");
      }
      
      private function handlePreMinSetAssetsDownloaded() : void
      {
         log("handlePreMinSetAssetsDownloaded()");
         _downloadManagerStatusMediator.handleAllAssetManifestsLoaded(_assetRetrieverManager);
      }
      
      private function handleRequiredAssetsDownloaded() : void
      {
         log("handleRequiredAssetsDownloaded()");
         _analyticsManager.trackAction(Action.LOGIN_MINSET_DOWNLOAD_COMPLETE);
         _downloadManagerStatusMediator.handleRequiredAssetDownloadsComplete();
      }
      
      public function downloadRequiredAssets() : void
      {
         _nestedAssetDownloader = new RequiredAssetDownloader(_requiredDownloadList,_downloadManagerStatusMediator,_downloader,_staticFileServiceURLProvider,_analyticsManager);
         _nestedAssetDownloader.downloadAssets(handleRequiredAssetsDownloaded);
      }
      
      public function downloadPreMinSetAssets() : void
      {
         _nestedAssetDownloader = new PreMinSetAssetDownloader(_preMinSetDownloadList,_downloadManagerStatusMediator,_downloader,_staticFileServiceURLProvider);
         _nestedAssetDownloader.downloadAssets(handlePreMinSetAssetsDownloaded);
      }
      
      public function downloadBackgroundAssets() : void
      {
         _nestedAssetDownloader = new OptionalAssetDownloader(_optionalDownloadList,_downloader,_staticFileServiceURLProvider,_userProfile,_isCheckForNanocashEnabled,_virmonDataRetriever,_evoDataRetriever);
         _nestedAssetDownloader.downloadAssets(handleOptionalAssetsDownloaded);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** AssetDownloader: " + param1);
      }
   }
}

