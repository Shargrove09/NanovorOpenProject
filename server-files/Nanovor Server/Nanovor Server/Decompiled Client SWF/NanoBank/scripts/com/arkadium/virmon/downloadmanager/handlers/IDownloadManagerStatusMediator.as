package com.arkadium.virmon.downloadmanager.handlers
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   
   public interface IDownloadManagerStatusMediator extends IDownloadManagerStatusProvider
   {
      
      function handleCopyAndRestartClient() : void;
      
      function handleApplicationCheckStarted() : void;
      
      function handleRequiredApplicationDownloadsComplete() : void;
      
      function handleAssetsCheckStarted() : void;
      
      function handleApplicationCheckComplete(param1:uint) : void;
      
      function handlePreWaitAppsDownloaded() : void;
      
      function handleBackgroundApplicationDownloadsComplete() : void;
      
      function handleManifestParsed(param1:uint) : void;
      
      function handleDownloadFileProgress(param1:Number, param2:Number) : void;
      
      function handleRestartClient() : void;
      
      function handleDownloadFileStarted(param1:uint, param2:uint) : void;
      
      function handleAssetsCheckComplete(param1:uint) : void;
      
      function handlePackageComplete(param1:PackageType) : void;
      
      function handleDownloadError() : void;
      
      function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void;
      
      function handleRequiredAssetDownloadsComplete() : void;
      
      function handleDownloadFileCompleted() : void;
   }
}

