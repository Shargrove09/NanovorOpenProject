package com.arkadium.virmon.downloadmanager
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.MainConfigManager;
   import com.arkadium.virmon.common.MainConfigOptions;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.downloadmanager.handlers.IAllAssetManifestsLoadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IBackgroundApplicationDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadmanager.handlers.IPreWaitAppsDownloadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredApplicationDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredAssetDownloadsCompleteHandler;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.application.ApplicationManager;
   import com.arkadium.virmon.framework.application.IApplicationManager;
   import com.arkadium.virmon.framework.application.IApplicationManagerInitializedConsumer;
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.framework.asset.AssetManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   public class DownloadManager extends MovieClip implements IDownloadManager, IApplicationManagerInitializedConsumer, IPreWaitAppsDownloadedHandler, IAllAssetManifestsLoadedHandler, IRequiredApplicationDownloadsCompleteHandler, IRequiredAssetDownloadsCompleteHandler, IBackgroundApplicationDownloadsCompleteHandler
   {
      
      private static const ASSET_MANAGER_PATH:String = "AssetManagerProxy.swf";
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _applicationManager:IApplicationManager;
      
      private var _userProfile:IUserProfile;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _analyticsManagers:IAnalyticsManager;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _fileOperator:IFileOperator;
      
      public function DownloadManager()
      {
         super();
      }
      
      public function isPackageOutdated(param1:PackageType) : Boolean
      {
         return _applicationManager.isPackageOutdated(param1);
      }
      
      private function startAssetManagerDownload() : void
      {
         AssetManager.getInstance().init(_downloadManagerStatusMediator,_userProfile,_downloader,_serviceRequestBrokerManager,checkIfFirstTime,_fileOperator,_virmonDataRetriever,_evoDataRetriever,_analyticsManager);
         AssetManager.getInstance().loadManifests();
      }
      
      public function handlePreWaitAppsDownloaded() : void
      {
         log("handlePreWaitAppsDownloaded()");
         startAssetManagerDownload();
      }
      
      private function startDownload() : void
      {
         _applicationManager.init(IApplicationManagerInitializedConsumer(this));
      }
      
      public function handleApplicationManagerInitialized(param1:Boolean) : void
      {
         log("handleApplicationManagerInitialized(): hasRequiredOutdatedFiles=" + param1);
         if("yes" == MainConfigManager.getInstance().getSetting(MainConfigOptions.SKIP_REQUIRED_APP_DOWNLOADS))
         {
            log("Skipping required application downloads...");
            startAssetManagerDownload();
            return;
         }
         if(param1)
         {
            _applicationManager.downloadItems(_downloadManagerStatusMediator,PackagePriority.PRE_WAIT_STATE);
         }
         else
         {
            startAssetManagerDownload();
         }
      }
      
      public function init(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:IFileOperator, param6:IVirmonDataRetriever, param7:IEvoDataRetriever, param8:IAnalyticsManager) : void
      {
         _downloadManagerStatusMediator = param1;
         _userProfile = param2;
         _downloader = param3;
         _serviceRequestBrokerManager = param4;
         _fileOperator = param5;
         _virmonDataRetriever = param6;
         _evoDataRetriever = param7;
         _analyticsManager = param8;
         _applicationManager = new ApplicationManager(_downloader,_fileOperator,_serviceRequestBrokerManager);
         _downloadManagerStatusMediator.addAllAssetManifestsLoadedHandler(IAllAssetManifestsLoadedHandler(this));
         _downloadManagerStatusMediator.addBackgroundApplicationDownloadsCompleteHandler(IBackgroundApplicationDownloadsCompleteHandler(this));
         _downloadManagerStatusMediator.addPreWaitAppsDownloadedHandler(IPreWaitAppsDownloadedHandler(this));
         _downloadManagerStatusMediator.addRequiredApplicationDownloadsCompleteHandler(IRequiredApplicationDownloadsCompleteHandler(this));
         _downloadManagerStatusMediator.addRequiredAssetDownloadsCompleteHandler(IRequiredAssetDownloadsCompleteHandler(this));
         startDownload();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadManager>> " + param1);
      }
      
      private function startAssetDownloads() : void
      {
         AssetManager.getInstance().downloadRequiredAssets();
      }
      
      public function handleRequiredApplicationDownloadsComplete() : void
      {
         log("handleRequiredApplicationDownloadsComplete()");
         startAssetDownloads();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>DownloadManager<< " + param1);
      }
      
      private function checkIfFirstTime() : void
      {
         if(StoredSettingManager.getInstance().getSetting(StoredSetting.SFS_DOWNLOAD_ONCE) == true)
         {
            return;
         }
         if(StoredSettingManager.getInstance().getSetting(StoredSetting.BREADCRUMB_COUNT) && StoredSettingManager.getInstance().getSetting(StoredSetting.BREADCRUMB_COUNT) > 1)
         {
            StoredSettingManager.getInstance().storeSettingAndSave(StoredSetting.SFS_DOWNLOAD_ONCE,true);
            return;
         }
         if(MainConfigManager.getInstance().getSetting(MainConfigOptions.LAUNCH_WEB_ON_FIRST_SFS).toLowerCase() == "yes")
         {
            EventManager.getInstance().dispatchEvent(new FrameWorkEvent(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,false,false,"first-sfs-download"));
         }
         StoredSettingManager.getInstance().storeSettingAndSave(StoredSetting.SFS_DOWNLOAD_ONCE,true);
      }
      
      public function handleBackgroundApplicationDownloadsComplete() : void
      {
         log("handleBackgroundApplicationDownloadsComplete()");
         if("yes" == MainConfigManager.getInstance().getSetting(MainConfigOptions.SKIP_BACKGROUND_ASSET_DOWNLOADS))
         {
            log("Skipping background asset downloads...");
            return;
         }
         AssetManager.getInstance().downloadBackgroundAssets();
      }
      
      public function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void
      {
         log("handleAllAssetManifestsLoaded()");
         if("yes" == MainConfigManager.getInstance().getSetting(MainConfigOptions.SKIP_REQUIRED_APP_DOWNLOADS))
         {
            log("handleAllAssetManifestsLoaded(): SKIPPING required app downloads");
            _downloadManagerStatusMediator.handleRequiredApplicationDownloadsComplete();
            return;
         }
         _applicationManager.downloadItems(_downloadManagerStatusMediator,PackagePriority.WAIT_STATE);
      }
      
      public function handleRequiredAssetDownloadsComplete() : void
      {
         log("handleRequiredAssetDownloadsComplete()");
         if("yes" == MainConfigManager.getInstance().getSetting(MainConfigOptions.SKIP_BACKGROUND_APP_DOWNLOADS))
         {
            log("Skipping background application downloads...");
            _downloadManagerStatusMediator.handleBackgroundApplicationDownloadsComplete();
            return;
         }
         _applicationManager.downloadItems(_downloadManagerStatusMediator,PackagePriority.BACKGROUND);
      }
   }
}

