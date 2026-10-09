package com.arkadium.virmon.framework.application
{
   import com.adobe.utils.DictionaryUtil;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ApplicationManager implements IApplicationManager
   {
      
      private var _initLoadConsumer:IApplicationManagerInitializedConsumer;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _downloadItemList:IApplicationDownloadItemList;
      
      private var _applicationManifest:IApplicationManifest;
      
      private var _initializer:IApplicationManagerInitializer;
      
      private var _applicationDownloader:ApplicationDownloader;
      
      private var _fileOperator:IFileOperator;
      
      private var _applicationManifestMetadata:IApplicationManifestMetadata;
      
      public function ApplicationManager(param1:IDownloader, param2:IFileOperator, param3:IServiceRequestBrokerManager)
      {
         super();
         _downloader = param1;
         _fileOperator = param2;
         _serviceRequestBrokerManager = param3;
      }
      
      public function isPackageOutdated(param1:PackageType) : Boolean
      {
         if(PackageType.NONE == param1)
         {
            return false;
         }
         var _loc2_:IApplicationPackage = _applicationManifest.packageList.getPackage(param1);
         if(null == _loc2_)
         {
            return true;
         }
         return _loc2_.isOutdated;
      }
      
      public function init(param1:IApplicationManagerInitializedConsumer) : void
      {
         log("init()");
         _initLoadConsumer = param1;
         _initializer = new ApplicationManagerInitializer(_serviceRequestBrokerManager.staticFileServiceURL,_downloader,_fileOperator,this);
         _initializer.init();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManager: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManager: " + param1);
      }
      
      public function downloadItems(param1:IDownloadManagerStatusMediator, param2:PackagePriority) : void
      {
         log("downloadItems(): packagePriority=" + param2);
         if(_downloadItemList == null)
         {
            throw new Error("Cannot call this method before instantiating the download item list");
         }
         _applicationDownloader = new ApplicationDownloader(_fileOperator,_serviceRequestBrokerManager.staticFileServiceURL,_applicationManifestMetadata,param1,_downloader);
         _applicationDownloader.downloadItems(_downloadItemList,param2);
      }
      
      private function createDownloadItemsList() : void
      {
         var _loc1_:ApplicationManifestComparator = new ApplicationManifestComparator();
         _loc1_.prioritizeOutdatedFiles(_applicationManifest);
         _downloadItemList = _loc1_.downloadItemList;
      }
      
      public function initializerComplete(param1:IApplicationManifest, param2:IApplicationManifestMetadata) : void
      {
         log("initializerComplete() ... applicationManifest file Keys:" + DictionaryUtil.getKeys(param1.fileList.files));
         _applicationManifest = param1;
         _applicationManifestMetadata = param2;
         createDownloadItemsList();
         _initLoadConsumer.handleApplicationManagerInitialized(_downloadItemList.hasDownloadItemsWithPriority(PackagePriority.WAIT_STATE));
      }
   }
}

