package com.arkadium.virmon.framework.asset
{
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class AbstractRequiredAssetDownloader implements INestedAssetDownloader, IDownloaderConsumer
   {
      
      private var _fileDownloadedCache:Dictionary;
      
      private var _requiredDownloadIndex:int;
      
      private var _uniqueDownloadCount:int;
      
      private var _staticFileServiceURLProvider:IStaticFileServiceURLProvider;
      
      private var _uniqueDownloadListLength:int;
      
      private var _downloader:IDownloader;
      
      private var _requiredDownloadList:IAssetDownloadItemList;
      
      private var _downloadCompleteHandler:Function;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      public function AbstractRequiredAssetDownloader(param1:IAssetDownloadItemList, param2:IDownloadManagerStatusMediator, param3:IDownloader, param4:IStaticFileServiceURLProvider)
      {
         super();
         _requiredDownloadIndex = 0;
         _requiredDownloadList = param1;
         _downloadManagerStatusMediator = param2;
         _downloader = param3;
         _staticFileServiceURLProvider = param4;
         _fileDownloadedCache = new Dictionary();
         _uniqueDownloadListLength = 0;
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log("<<RequiredAssetDownloaderConsumer>> " + param1);
      }
      
      private function downloadNextAsset() : void
      {
         _downloadManagerStatusMediator.handleDownloadFileStarted(_uniqueDownloadCount,_uniqueDownloadListLength);
         if(_requiredDownloadIndex > _requiredDownloadList.length - 1)
         {
            _downloadCompleteHandler();
            return;
         }
         log("downloadNextAsset(): _requiredDownloadIndex=" + _requiredDownloadIndex + ", _requiredDownloadList.length=" + _uniqueDownloadListLength + ", item:" + _requiredDownloadList.getItem(_requiredDownloadIndex));
         var _loc1_:IAsset = _requiredDownloadList.getItem(_requiredDownloadIndex).asset;
         _downloader.downloadFile(this as IDownloaderConsumer,_staticFileServiceURLProvider.staticFileServiceURL + "/" + Utils.DOStoPOSIXpath(_loc1_.fullFilePath),AssetLocation.ASSETS_DIRECTORY.name + Environment.localPathDelimeter + Environment.posixToLocalPath(_loc1_.fullFilePath),_loc1_.CRC);
      }
      
      protected function handleAssetsCheckComplete() : void
      {
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleDownloadError(): " + param1);
         _downloadManagerStatusMediator.handleDownloadError();
      }
      
      private function getUniqueDownloadListCount(param1:IAssetDownloadItemList) : int
      {
         var _loc5_:IAssetDownloadItem = null;
         var _loc2_:int = 0;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.getItem(_loc4_);
            if(null == _loc3_[_loc5_.asset.fullFilePath])
            {
               _loc2_++;
               _loc3_[_loc5_.asset.fullFilePath] = _loc5_.asset.fullFilePath;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         log("handleDownloadComplete(): " + param1 + " --> " + param2);
         if(null == _fileDownloadedCache[param2])
         {
            _fileDownloadedCache[param2] = param2;
            _downloadManagerStatusMediator.handleDownloadFileCompleted();
            ++_uniqueDownloadCount;
         }
         _requiredDownloadList.getItem(_requiredDownloadIndex).asset.updateAssetInManifestMetadata();
         ++_requiredDownloadIndex;
         downloadNextAsset();
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
         _downloadManagerStatusMediator.handleDownloadFileProgress(param1,param2);
      }
      
      public function downloadAssets(param1:Function) : void
      {
         log("downloadAssets()");
         _downloadCompleteHandler = param1;
         _uniqueDownloadListLength = getUniqueDownloadListCount(_requiredDownloadList);
         if(_requiredDownloadList.length > 0)
         {
            handleAssetsCheckComplete();
            _downloadManagerStatusMediator.handleAssetsCheckComplete(_uniqueDownloadListLength);
         }
         downloadNextAsset();
      }
      
      protected function logError(param1:String) : void
      {
         DebugLog.instance.error("<<RequiredAssetDownloaderConsumer>> " + param1);
      }
   }
}

