package com.arkadium.virmon.downloadmanager.handlers
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class DownloadManagerStatusMediator implements IDownloadManagerStatusMediator
   {
      
      private var _handlers:Dictionary;
      
      public function DownloadManagerStatusMediator()
      {
         super();
         _handlers = new Dictionary();
         _handlers[ICopyAndRestartClientHandler] = new Dictionary(true);
         _handlers[IRestartClientHandler] = new Dictionary(true);
         _handlers[IPreWaitAppsDownloadedHandler] = new Dictionary(true);
         _handlers[IAllAssetManifestsLoadedHandler] = new Dictionary(true);
         _handlers[IRequiredAssetDownloadsCompleteHandler] = new Dictionary(true);
         _handlers[IFileDownloadProgressHandler] = new Dictionary(true);
         _handlers[IRequiredApplicationDownloadsCompleteHandler] = new Dictionary(true);
         _handlers[IBackgroundApplicationDownloadsCompleteHandler] = new Dictionary(true);
         _handlers[IPackageCompleteHandler] = new Dictionary(true);
      }
      
      public function handleCopyAndRestartClient() : void
      {
         var _loc1_:ICopyAndRestartClientHandler = null;
         for each(_loc1_ in _handlers[ICopyAndRestartClientHandler])
         {
            _loc1_.handleCopyAndRestartClient();
         }
      }
      
      public function handleApplicationCheckStarted() : void
      {
         var _loc1_:IFileDownloadProgressHandler = null;
         for each(_loc1_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc1_.handleApplicationCheckStarted();
         }
      }
      
      public function removeFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void
      {
         if(null != _handlers[IFileDownloadProgressHandler][param1])
         {
            delete _handlers[IFileDownloadProgressHandler][param1];
         }
      }
      
      public function handleRequiredAssetDownloadsComplete() : void
      {
         var _loc1_:IRequiredAssetDownloadsCompleteHandler = null;
         for each(_loc1_ in _handlers[IRequiredAssetDownloadsCompleteHandler])
         {
            _loc1_.handleRequiredAssetDownloadsComplete();
         }
      }
      
      public function addCopyAndRestartClientHandler(param1:ICopyAndRestartClientHandler) : void
      {
         _handlers[ICopyAndRestartClientHandler][param1] = param1;
      }
      
      public function handleDownloadError() : void
      {
         var _loc1_:IFileDownloadProgressHandler = null;
         for each(_loc1_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc1_.handleDownloadError();
         }
      }
      
      public function addBackgroundApplicationDownloadsCompleteHandler(param1:IBackgroundApplicationDownloadsCompleteHandler) : void
      {
         _handlers[IBackgroundApplicationDownloadsCompleteHandler][param1] = param1;
      }
      
      public function addPackageCompleteHandler(param1:IPackageCompleteHandler) : void
      {
         _handlers[IPackageCompleteHandler][param1] = param1;
      }
      
      public function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void
      {
         var _loc2_:IAllAssetManifestsLoadedHandler = null;
         log("handleAllAssetManifestsLoaded()");
         for each(_loc2_ in _handlers[IAllAssetManifestsLoadedHandler])
         {
            log("handleAllAssetManifestsLoaded(): handler: " + _loc2_);
            _loc2_.handleAllAssetManifestsLoaded(param1);
         }
      }
      
      public function addPreWaitAppsDownloadedHandler(param1:IPreWaitAppsDownloadedHandler) : void
      {
         _handlers[IPreWaitAppsDownloadedHandler][param1] = param1;
      }
      
      public function handleDownloadFileCompleted() : void
      {
         var _loc1_:IFileDownloadProgressHandler = null;
         for each(_loc1_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc1_.handleDownloadFileCompleted();
         }
      }
      
      public function handleDownloadFileProgress(param1:Number, param2:Number) : void
      {
         var _loc3_:IFileDownloadProgressHandler = null;
         for each(_loc3_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc3_.handleDownloadFileProgress(param1,param2);
         }
      }
      
      public function handleAssetsCheckStarted() : void
      {
         var _loc1_:IFileDownloadProgressHandler = null;
         for each(_loc1_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc1_.handleAssetsCheckStarted();
         }
      }
      
      public function addFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void
      {
         _handlers[IFileDownloadProgressHandler][param1] = param1;
      }
      
      public function handlePreWaitAppsDownloaded() : void
      {
         var _loc1_:IPreWaitAppsDownloadedHandler = null;
         for each(_loc1_ in _handlers[IPreWaitAppsDownloadedHandler])
         {
            _loc1_.handlePreWaitAppsDownloaded();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadManagerStatusMediator>> " + param1);
      }
      
      public function handlePackageComplete(param1:PackageType) : void
      {
         var _loc2_:IPackageCompleteHandler = null;
         for each(_loc2_ in _handlers[IPackageCompleteHandler])
         {
            _loc2_.handlePackageComplete(param1);
         }
      }
      
      public function addRequiredApplicationDownloadsCompleteHandler(param1:IRequiredApplicationDownloadsCompleteHandler) : void
      {
         _handlers[IRequiredApplicationDownloadsCompleteHandler][param1] = param1;
      }
      
      public function handleRequiredApplicationDownloadsComplete() : void
      {
         var _loc1_:IRequiredApplicationDownloadsCompleteHandler = null;
         for each(_loc1_ in _handlers[IRequiredApplicationDownloadsCompleteHandler])
         {
            _loc1_.handleRequiredApplicationDownloadsComplete();
         }
      }
      
      public function handleApplicationCheckComplete(param1:uint) : void
      {
         var _loc2_:IFileDownloadProgressHandler = null;
         for each(_loc2_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc2_.handleApplicationCheckComplete(param1);
         }
      }
      
      public function handleManifestParsed(param1:uint) : void
      {
         var _loc2_:IFileDownloadProgressHandler = null;
         for each(_loc2_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc2_.handleManifestParsed(param1);
         }
      }
      
      public function handleBackgroundApplicationDownloadsComplete() : void
      {
         var _loc1_:IBackgroundApplicationDownloadsCompleteHandler = null;
         for each(_loc1_ in _handlers[IBackgroundApplicationDownloadsCompleteHandler])
         {
            _loc1_.handleBackgroundApplicationDownloadsComplete();
         }
      }
      
      public function handleAssetsCheckComplete(param1:uint) : void
      {
         var _loc2_:IFileDownloadProgressHandler = null;
         for each(_loc2_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc2_.handleAssetsCheckComplete(param1);
         }
      }
      
      public function addAllAssetManifestsLoadedHandler(param1:IAllAssetManifestsLoadedHandler) : void
      {
         log("addAllAssetManifestsLoadedHandler(): " + param1);
         _handlers[IAllAssetManifestsLoadedHandler][param1] = param1;
      }
      
      public function removeRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void
      {
         if(null != _handlers[IRequiredAssetDownloadsCompleteHandler][param1])
         {
            delete _handlers[IRequiredAssetDownloadsCompleteHandler][param1];
         }
      }
      
      public function handleDownloadFileStarted(param1:uint, param2:uint) : void
      {
         var _loc3_:IFileDownloadProgressHandler = null;
         for each(_loc3_ in _handlers[IFileDownloadProgressHandler])
         {
            _loc3_.handleDownloadFileStarted(param1,param2);
         }
      }
      
      public function addRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void
      {
         _handlers[IRequiredAssetDownloadsCompleteHandler][param1] = param1;
      }
      
      public function addRestartClientHandler(param1:IRestartClientHandler) : void
      {
         _handlers[IRestartClientHandler][param1] = param1;
      }
      
      public function handleRestartClient() : void
      {
         var _loc1_:IRestartClientHandler = null;
         for each(_loc1_ in _handlers[IRestartClientHandler])
         {
            _loc1_.handleRestartClient();
         }
      }
   }
}

