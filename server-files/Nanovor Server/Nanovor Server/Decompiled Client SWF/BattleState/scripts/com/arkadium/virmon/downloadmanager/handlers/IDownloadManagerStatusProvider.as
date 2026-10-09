package com.arkadium.virmon.downloadmanager.handlers
{
   public interface IDownloadManagerStatusProvider
   {
      
      function addCopyAndRestartClientHandler(param1:ICopyAndRestartClientHandler) : void;
      
      function addPreWaitAppsDownloadedHandler(param1:IPreWaitAppsDownloadedHandler) : void;
      
      function addBackgroundApplicationDownloadsCompleteHandler(param1:IBackgroundApplicationDownloadsCompleteHandler) : void;
      
      function addPackageCompleteHandler(param1:IPackageCompleteHandler) : void;
      
      function addAllAssetManifestsLoadedHandler(param1:IAllAssetManifestsLoadedHandler) : void;
      
      function removeFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void;
      
      function addRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void;
      
      function addRestartClientHandler(param1:IRestartClientHandler) : void;
      
      function removeRequiredAssetDownloadsCompleteHandler(param1:IRequiredAssetDownloadsCompleteHandler) : void;
      
      function addRequiredApplicationDownloadsCompleteHandler(param1:IRequiredApplicationDownloadsCompleteHandler) : void;
      
      function addFileDownloadProgressHandler(param1:IFileDownloadProgressHandler) : void;
   }
}

