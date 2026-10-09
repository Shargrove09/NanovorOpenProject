package com.arkadium.virmon.framework.asset
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class RequiredAssetDownloader extends AbstractRequiredAssetDownloader
   {
      
      private var _analyticsManager:IAnalyticsManager;
      
      public function RequiredAssetDownloader(param1:IAssetDownloadItemList, param2:IDownloadManagerStatusMediator, param3:IDownloader, param4:IStaticFileServiceURLProvider, param5:IAnalyticsManager)
      {
         super(param1,param2,param3,param4);
         _analyticsManager = param5;
      }
      
      override protected function log(param1:String) : void
      {
         DebugLog.instance.log("<<RequiredAssetDownloaderConsumer>> " + param1);
      }
      
      override protected function handleAssetsCheckComplete() : void
      {
         _analyticsManager.trackAction(Action.LOGIN_MINSET_DOWNLOAD_STARTED);
      }
      
      override public function handleDownloadError(param1:String) : void
      {
         _analyticsManager.trackAction(Action.LOGIN_MINSET_DOWNLOAD_FAILED);
         super.handleDownloadError(param1);
      }
      
      override protected function logError(param1:String) : void
      {
         DebugLog.instance.error("<<RequiredAssetDownloaderConsumer>> " + param1);
      }
   }
}

