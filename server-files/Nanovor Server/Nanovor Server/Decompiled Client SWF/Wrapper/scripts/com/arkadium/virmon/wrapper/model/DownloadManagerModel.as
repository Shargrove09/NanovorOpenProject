package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.IDownloadManager;
   import com.arkadium.virmon.downloadmanager.handlers.IAllAssetManifestsLoadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IBackgroundApplicationDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.ICopyAndRestartClientHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadmanager.handlers.IFileDownloadProgressHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IPackageCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IPreWaitAppsDownloadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredApplicationDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredAssetDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRestartClientHandler;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class DownloadManagerModel implements IDownloadManagerModel
   {
      
      private static const DOWNLOAD_MANAGER_FILE_PATH:String = "DownloadManager.swf";
      
      private static const EVOLVER_FINISHER_FILE_PATH:String = "EvolverFinisher.exe";
      
      private var _userProfile:IUserProfile;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _fileOperator:IFileOperator;
      
      private var _loader:Loader;
      
      private var _mdmManager:IMDMManager;
      
      private var _downloadManager:IDownloadManager;
      
      private var _handlers:Dictionary;
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      public function DownloadManagerModel(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:IFileOperator, param6:IVirmonDataRetriever, param7:IEvoDataRetriever, param8:IAnalyticsManager, param9:IMDMManager)
      {
         super();
         _downloadManagerStatusMediator = param1;
         _userProfile = param2;
         _downloader = param3;
         _serviceRequestBrokerManager = param4;
         _fileOperator = param5;
         _virmonDataRetriever = param6;
         _evoDataRetriever = param7;
         _analyticsManager = param8;
         _mdmManager = param9;
         createHandlersDictionary();
      }
      
      public function addRestartClientHandler(param1:IRestartClientHandler) : void
      {
         _downloadManagerStatusMediator.addRestartClientHandler(param1);
      }
      
      private function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[IDownloadManagerLoadErrorHandler] = new Dictionary(true);
         _handlers[IDownloadManagerLoadCompleteHandler] = new Dictionary(true);
      }
      
      private function handleDownloadManagerLoadError(param1:IOErrorEvent) : void
      {
         var _loc2_:IDownloadManagerLoadErrorHandler = null;
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleDownloadManagerLoadComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleDownloadManagerLoadError);
         for each(_loc2_ in _handlers[IDownloadManagerLoadErrorHandler])
         {
            _loc2_.handleDownloadManagerLoadError(param1.text);
         }
      }
      
      public function addCopyAndRestartClientHandler(param1:ICopyAndRestartClientHandler) : void
      {
         _downloadManagerStatusMediator.addCopyAndRestartClientHandler(param1);
      }
      
      private function handleDownloadManagerLoadComplete(param1:Event) : void
      {
         var _loc2_:IDownloadManagerLoadCompleteHandler = null;
         log("handleDownloadManagerLoadComplete()");
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleDownloadManagerLoadComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleDownloadManagerLoadError);
         _downloadManager = _loader.content as IDownloadManager;
         _downloadManager.init(_downloadManagerStatusMediator,_userProfile,_downloader,_serviceRequestBrokerManager,_fileOperator,_virmonDataRetriever,_evoDataRetriever,_analyticsManager);
         for each(_loc2_ in _handlers[IDownloadManagerLoadCompleteHandler])
         {
            _loc2_.handleDownloadManagerLoadComplete(_downloadManager);
         }
      }
      
      public function addBackgroundApplicationDownloadsCompleteHandler(param1:IBackgroundApplicationDownloadsCompleteHandler) : void
      {
         _downloadManagerStatusMediator.addBackgroundApplicationDownloadsCompleteHandler(param1);
      }
      
      public function addPackageCompleteHandler(param1:IPackageCompleteHandler) : void
      {
         _downloadManagerStatusMediator.addPackageCompleteHandler(param1);
      }
      
      public function addFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void
      {
         _downloadManagerStatusMediator.addFileDownloadProgressHandler(param1);
      }
      
      public function addPreWaitAppsDownloadedHandler(param1:IPreWaitAppsDownloadedHandler) : void
      {
         _downloadManagerStatusMediator.addPreWaitAppsDownloadedHandler(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadManagerModel>> " + param1);
      }
      
      public function addDownloadManagerLoadCompleteHandler(param1:IDownloadManagerLoadCompleteHandler) : void
      {
         _handlers[IDownloadManagerLoadCompleteHandler][param1] = param1;
      }
      
      public function addRequiredApplicationDownloadsCompleteHandler(param1:IRequiredApplicationDownloadsCompleteHandler) : void
      {
         _downloadManagerStatusMediator.addRequiredApplicationDownloadsCompleteHandler(param1);
      }
      
      public function loadDownloadManager() : void
      {
         log("loadDownloadManager()");
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleDownloadManagerLoadComplete);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleDownloadManagerLoadError);
         _loader.load(new URLRequest(DOWNLOAD_MANAGER_FILE_PATH));
      }
      
      public function addDownloadManagerLoadErrorHandler(param1:IDownloadManagerLoadErrorHandler) : void
      {
         _handlers[IDownloadManagerLoadErrorHandler][param1] = param1;
      }
      
      public function addAllAssetManifestsLoadedHandler(param1:IAllAssetManifestsLoadedHandler) : void
      {
         log("addAllAssetManifestsLoadedHandler()");
         _downloadManagerStatusMediator.addAllAssetManifestsLoadedHandler(param1);
      }
      
      public function removeRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void
      {
         _downloadManagerStatusMediator.removeRequiredAssetDownloadsCompleteHandler(param1);
      }
      
      public function addRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void
      {
         _downloadManagerStatusMediator.addRequiredAssetDownloadsCompleteHandler(param1);
      }
      
      public function executeUpdateFinisher() : void
      {
         _mdmManager.mdmProcess.create(EVOLVER_FINISHER_FILE_PATH,0,0,0,0,"","cmd.exe /C " + EVOLVER_FINISHER_FILE_PATH,_mdmManager.mdmApplication.path,3,1);
      }
      
      public function removeFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void
      {
         _downloadManagerStatusMediator.removeFileDownloadProgressHandler(param1);
      }
   }
}

