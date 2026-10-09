package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.application.enum.ApplicationLocation;
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class ApplicationDownloader implements IDownloaderConsumer
   {
      
      private var _tempUpdateLocationMetadata:ITempUpdateLocationMetadata;
      
      private var _downloadProgressCount:uint;
      
      private var _downloader:IDownloader;
      
      private var _currentDownloadItem:IApplicationDownloadItem;
      
      private var _filteredDownloadList:IApplicationDownloadItemList;
      
      private var _consumer:IApplicationDownloaderConsumer;
      
      private var _highestPriority:PackagePriority;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _outdatedFileCount:uint;
      
      private var _sfsURL:String;
      
      private var _applicationManifestMetadata:IApplicationManifestMetadata;
      
      private var _completedPackagesHistory:Dictionary;
      
      private var _completeDownloadList:IApplicationDownloadItemList;
      
      public function ApplicationDownloader(param1:IFileOperator, param2:String, param3:IApplicationManifestMetadata, param4:IDownloadManagerStatusMediator, param5:IDownloader)
      {
         super();
         _sfsURL = param2;
         _applicationManifestMetadata = param3;
         _downloadManagerStatusMediator = param4;
         _downloader = param5;
         _tempUpdateLocationMetadata = new TempUpdateLocationMetadata(param1);
         _completedPackagesHistory = new Dictionary();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationDownloader: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationDownloader: " + param1);
      }
      
      private function getTargetPath(param1:IApplicationDownloadItem) : String
      {
         if(param1.priority <= PackagePriority.MOVE_AND_RESTART.priority)
         {
            return Environment.posixToLocalPath(ApplicationLocation.TEMP_DIRECTORY + "/" + param1.file.filename);
         }
         return Environment.posixToLocalPath(param1.file.filename);
      }
      
      private function downloadNextItem() : void
      {
         log("downloadNextItem(): _filteredDownloadList.length=" + _filteredDownloadList.length);
         if(_filteredDownloadList.length == 0)
         {
            return handleAllDownloadsComplete();
         }
         _currentDownloadItem = _filteredDownloadList.pop();
         if(_currentDownloadItem.priority < _highestPriority.priority)
         {
            _highestPriority = PackagePriority.parse(_currentDownloadItem.priority);
         }
         var _loc1_:String = _sfsURL + "/" + ApplicationLocation.REMOTE_ROOT_DIRECTORY + "/" + Utils.DOStoPOSIXpath(_currentDownloadItem.file.filename);
         var _loc2_:String = getTargetPath(_currentDownloadItem);
         _downloadManagerStatusMediator.handleDownloadFileStarted(_downloadProgressCount,_outdatedFileCount);
         _downloader.downloadFile(this,_loc1_,_loc2_,_currentDownloadItem.file.CRC);
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
         _downloadManagerStatusMediator.handleDownloadFileProgress(param1,param2);
      }
      
      public function downloadItems(param1:IApplicationDownloadItemList, param2:PackagePriority) : void
      {
         log("downloadItems(): downloadItemList.length=" + param1.length + " packagePriority=" + param2);
         _downloadManagerStatusMediator.handleApplicationCheckStarted();
         _outdatedFileCount = 0;
         _downloadProgressCount = 0;
         _highestPriority = param2;
         _completeDownloadList = param1;
         _filteredDownloadList = param1.getItemsByPriority(param2);
         if(param2.priority > PackagePriority.RESTART.priority)
         {
            if(_filteredDownloadList.getItemsByPriority(PackagePriority.RESTART).length > 0)
            {
               _filteredDownloadList = _filteredDownloadList.getItemsByPriority(PackagePriority.RESTART);
            }
         }
         _outdatedFileCount = _filteredDownloadList.length;
         _downloadManagerStatusMediator.handleApplicationCheckComplete(_outdatedFileCount);
         downloadNextItem();
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleDownloadError()");
         _downloadManagerStatusMediator.handleDownloadError();
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         var _loc3_:IApplicationPackage = null;
         ++_downloadProgressCount;
         _downloadManagerStatusMediator.handleDownloadFileCompleted();
         if(PackagePriority.parse(_currentDownloadItem.priority) == PackagePriority.MOVE_AND_RESTART)
         {
            _tempUpdateLocationMetadata.fileList.addFile(_currentDownloadItem.file);
         }
         else
         {
            _applicationManifestMetadata.updateFileCRC(_currentDownloadItem.file.id,_currentDownloadItem.file.CRC);
            _applicationManifestMetadata.writeToFile();
            for each(_loc3_ in _currentDownloadItem.packageList.packages)
            {
               if(null == _completedPackagesHistory[_loc3_.type])
               {
                  if(false == _loc3_.isOutdated)
                  {
                     _completedPackagesHistory[_loc3_.type] = _loc3_.type;
                     _downloadManagerStatusMediator.handlePackageComplete(_loc3_.type);
                  }
               }
            }
            _completeDownloadList.removeItem(_currentDownloadItem);
         }
         downloadNextItem();
      }
      
      private function handleAllDownloadsComplete() : void
      {
         log("handleAllDownloadsComplete(): _highestPriority=" + _highestPriority);
         _tempUpdateLocationMetadata.writeToDisk();
         switch(_highestPriority)
         {
            case PackagePriority.MOVE_AND_RESTART:
               _downloadManagerStatusMediator.handleCopyAndRestartClient();
               break;
            case PackagePriority.RESTART:
               _downloadManagerStatusMediator.handleRestartClient();
               break;
            case PackagePriority.PRE_WAIT_STATE:
               _downloadManagerStatusMediator.handlePreWaitAppsDownloaded();
               break;
            case PackagePriority.WAIT_STATE:
               _downloadManagerStatusMediator.handleRequiredApplicationDownloadsComplete();
               break;
            case PackagePriority.BACKGROUND:
            default:
               _downloadManagerStatusMediator.handleBackgroundApplicationDownloadsComplete();
         }
      }
   }
}

