package com.arkadium.virmon.framework.asset
{
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.IUserProfileLoadCompleteHandler;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class OptionalAssetDownloader implements INestedAssetDownloader, IUserProfileLoadCompleteHandler, IDownloaderConsumer
   {
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _downloader:IDownloader;
      
      private var _userProfile:IUserProfile;
      
      private var _staticFileServiceURLProvider:IStaticFileServiceURLProvider;
      
      private var _optionalDownloadList:IAssetDownloadItemList;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _downloadCompleteHandler:Function;
      
      private var _isCheckForNanocashEnabled:Boolean;
      
      private var _currentAssetDownloadItem:IAssetDownloadItem;
      
      public function OptionalAssetDownloader(param1:IAssetDownloadItemList, param2:IDownloader, param3:IStaticFileServiceURLProvider, param4:IUserProfile, param5:Boolean, param6:IVirmonDataRetriever, param7:IEvoDataRetriever)
      {
         super();
         _optionalDownloadList = param1;
         _downloader = param2;
         _staticFileServiceURLProvider = param3;
         _userProfile = param4;
         _isCheckForNanocashEnabled = param5;
         _virmonDataRetriever = param6;
         _evoDataRetriever = param7;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> OptionalAssetDownloader: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** OptionalAssetDownloader: " + param1);
      }
      
      private function downloadNextAsset() : void
      {
         if(0 == _optionalDownloadList.length)
         {
            log("Download complete: all optional assets downloaded.");
            if(_downloadCompleteHandler != null)
            {
               _downloadCompleteHandler();
            }
            return;
         }
         _currentAssetDownloadItem = _optionalDownloadList.pop();
         if(isRedundantAsset(_currentAssetDownloadItem))
         {
            if(false == canDownloadRedundantAssets)
            {
               log("Found redundant asset but we are skipping the rest of optional downloads.");
               return;
            }
         }
         _downloader.downloadFile(this as IDownloaderConsumer,_staticFileServiceURLProvider.staticFileServiceURL + "/" + Utils.DOStoPOSIXpath(_currentAssetDownloadItem.asset.fullFilePath),AssetLocation.ASSETS_DIRECTORY.name + Environment.localPathDelimeter + Environment.posixToLocalPath(_currentAssetDownloadItem.asset.fullFilePath),_currentAssetDownloadItem.asset.CRC);
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleDownloadError(): " + param1);
         downloadNextAsset();
      }
      
      private function isRedundantAsset(param1:IAssetDownloadItem) : Boolean
      {
         return Boolean(param1.priority < 0);
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
      }
      
      private function sortOnPriority(param1:IAssetDownloadItem, param2:IAssetDownloadItem) : Number
      {
         if(param1.priority > param2.priority)
         {
            return 1;
         }
         if(param1.priority < param2.priority)
         {
            return -1;
         }
         return 0;
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         log("handleDownloadComplete(): " + param1 + " --> " + param2);
         _currentAssetDownloadItem.asset.updateAssetInManifestMetadata();
         downloadNextAsset();
      }
      
      public function downloadAssets(param1:Function) : void
      {
         if(0 == _optionalDownloadList.length)
         {
            log("Download complete: no optional assets to download.");
            param1();
            return;
         }
         log("downloadAssets()");
         _downloadCompleteHandler = param1;
         if(_userProfile.loaded)
         {
            handleUserProfileLoadComplete();
            return;
         }
         _userProfile.addUserProfileLoadCompleteHandler(this as IUserProfileLoadCompleteHandler);
      }
      
      private function prioritizeOptionalDownloadList() : void
      {
         log("prioritizeOptionalDownloadList()");
         var _loc1_:IOptionalDownloadPrioritizer = new OptionalDownloadPrioritizer(_virmonDataRetriever,_evoDataRetriever,_optionalDownloadList);
         _loc1_.prioritize();
         _optionalDownloadList.sort(sortOnPriority);
         downloadNextAsset();
      }
      
      public function handleUserProfileLoadComplete() : void
      {
         _userProfile.removeUserProfileLoadCompleteHandler(this);
         prioritizeOptionalDownloadList();
      }
      
      private function get canDownloadRedundantAssets() : Boolean
      {
         if(false == _isCheckForNanocashEnabled)
         {
            return true;
         }
         if(_userProfile.nanocash > 0)
         {
            return true;
         }
         return false;
      }
   }
}

