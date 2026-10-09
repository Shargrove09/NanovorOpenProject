package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.ApplicationLocation;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   internal class ApplicationManagerInitializer implements IApplicationManifestLoaderConsumer, IDownloaderConsumer, IApplicationManagerInitializer, IApplicationManifestMetadataLoaderConsumer
   {
      
      private var _metadataLoader:ApplicationManifestMetadataLoader;
      
      private var _manifestLoader:ApplicationManifestLoader;
      
      private var _downloader:IDownloader;
      
      private var _fileOperator:IFileOperator;
      
      private var _applicationManifest:IApplicationManifest;
      
      private var _sfsURL:String;
      
      private var _applicationManifestMetadata:IApplicationManifestMetadata;
      
      private var _applicationManager:ApplicationManager;
      
      private var _metadataFilePath:String;
      
      public function ApplicationManagerInitializer(param1:String, param2:IDownloader, param3:IFileOperator, param4:ApplicationManager)
      {
         super();
         _downloader = param2;
         _fileOperator = param3;
         _sfsURL = param1;
         _applicationManager = param4;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManagerInitializer: " + param1);
      }
      
      public function handleManifestLoadError(param1:String) : void
      {
         logError("handleManifestLoadError(): " + param1);
      }
      
      public function parseManifest() : void
      {
         log("parseManifest()");
         var _loc1_:ApplicationManifestParser = new ApplicationManifestParser(_applicationManifestMetadata);
         _applicationManifest = _loc1_.parseManifest(_manifestLoader.applicationManifestXML);
         _applicationManager.initializerComplete(_applicationManifest,_applicationManifestMetadata);
      }
      
      public function handleManifestLoadComplete() : void
      {
         log("handleManifestLoadComplete()");
         parseManifest();
      }
      
      public function init() : void
      {
         log("init()");
         _metadataFilePath = ApplicationLocation.DATA_DIRECTORY + "/" + ApplicationLocation.METADATA_FILE_NAME;
         _metadataLoader = new ApplicationManifestMetadataLoader(_fileOperator,_metadataFilePath);
         _metadataLoader.load(this);
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleDownloadError(): " + param1);
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
      }
      
      public function handleManifestMetadataLoadError(param1:String) : void
      {
         logError("handleManifestMetadataLoadError(): " + param1 + "\nIgnoring any contents of the app manifest metadata.");
         _applicationManifestMetadata = new ApplicationManifestMetadata(_fileOperator,_metadataFilePath,new ApplicationFileList(),new Date());
         downloadManifest();
      }
      
      public function handleManifestMetadataLoadComplete(param1:Boolean) : void
      {
         log("handleManifestMetadataLoadComplete(): fileExists=" + param1);
         var _loc2_:IApplicationManifestMetadataParser = new ApplicationManifestMetadataParser(_fileOperator,_metadataFilePath);
         _applicationManifestMetadata = _loc2_.parseMetadata(_metadataLoader.manifestMetadataXML);
         downloadManifest();
      }
      
      public function downloadManifest() : void
      {
         var _loc1_:String = _sfsURL + "/" + ApplicationLocation.REMOTE_ROOT_DIRECTORY + "/" + ApplicationLocation.DATA_DIRECTORY + "/" + ApplicationLocation.MANIFEST_FILE_NAME;
         var _loc2_:String = Environment.posixToLocalPath(ApplicationLocation.DATA_DIRECTORY + "/" + ApplicationLocation.MANIFEST_FILE_NAME);
         log("downloadManifest(): remotePath=" + _loc1_ + "\n              localPath=" + _loc2_);
         _downloader.downloadFile(this,_loc1_,_loc2_);
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         log("handleDownloadComplete(): sourceURL=" + param1 + " targetFilePath=" + param2);
         var _loc3_:String = ApplicationLocation.DATA_DIRECTORY + "/" + ApplicationLocation.MANIFEST_FILE_NAME;
         _manifestLoader = new ApplicationManifestLoader(_loc3_);
         _manifestLoader.loadManifest(this);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManagerInitializer: " + param1);
      }
   }
}

