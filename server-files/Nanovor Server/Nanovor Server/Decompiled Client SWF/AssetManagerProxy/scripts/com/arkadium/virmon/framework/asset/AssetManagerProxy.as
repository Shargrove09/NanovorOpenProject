package com.arkadium.virmon.framework.asset
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.migration.IMigrationWizard;
   import com.arkadium.virmon.framework.asset.migration.IMigrationWizardCompleteHandler;
   import com.arkadium.virmon.framework.asset.migration.MigrationWizard;
   import com.arkadium.virmon.framework.asset.retriever.AssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.AssetURL;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.framework.asset.retriever.NullAssetURL;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class AssetManagerProxy extends Sprite implements IMigrationWizardCompleteHandler, IStaticFileServiceURLProvider, IAssetManagerProxy, IManifestMetadataParserConsumer, IManifestMetadataLoaderConsumer, IManifestLoaderConsumer, IAssetManager
   {
      
      private static const DEBUG_SFS_URL:String = "http://sfs-dev:8080";
      
      private static const NAME:String = "AssetManager";
      
      private var _manifestComparator:IManifestComparator;
      
      private var _assetDownloader:IAssetDownloader;
      
      private var _superManifestList:IManifestList;
      
      private var _staticFileServiceURLProvider:IStaticFileServiceURLProvider;
      
      private var _migrationWizard:IMigrationWizard;
      
      private var _checkIfFirstTimeCommand:Function;
      
      private var _userProfile:IUserProfile;
      
      private var _parsedManifestsCount:uint;
      
      private var _manifestQueue:Array;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _assetRetrieverManager:IAssetRetrieverManager;
      
      private var _optionalDownloadPrioritizer:IOptionalDownloadPrioritizer;
      
      private var _fileOperator:IFileOperator;
      
      private var _manifestList:IManifestList;
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _manifestMetadataLoader:IManifestMetadataLoader;
      
      private var _downloader:IDownloader;
      
      private var _manifestMetadataParser:IManifestMetadataParser;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _isCheckForNanocashEnabled:Boolean;
      
      private var _assetManifestLoader:IManifestLoader;
      
      private var _assetManifestParser:IAssetManifestParser;
      
      public function AssetManagerProxy()
      {
         super();
         _superManifestList = new ManifestList();
         _manifestList = new ManifestList();
         _manifestQueue = new Array();
         _assetRetrieverManager = new AssetRetrieverManager(this as IAssetManager);
      }
      
      public function getManifestSuperName(param1:String) : String
      {
         var _loc2_:IAssetManifest = _manifestList.getManifest(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         if(_loc2_.superManifestName == null || _loc2_.superManifestName == "")
         {
            return null;
         }
         return _loc2_.superManifestName;
      }
      
      public function getAssetList(param1:String, param2:String) : Array
      {
         var _loc3_:IAssetManifest = _manifestList.getManifest(param1);
         if(null == _loc3_)
         {
            return [];
         }
         var _loc4_:IAssetGroup = _loc3_.getGroupByName(param2);
         if(null == _loc4_ || null == _loc4_.assetList)
         {
            return [];
         }
         return _loc4_.assetList;
      }
      
      public function handleManifestLoadError(param1:String) : void
      {
         logError("handleManifestLoadError(): " + param1);
      }
      
      public function init(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:Function, param6:IFileOperator, param7:IVirmonDataRetriever, param8:IEvoDataRetriever, param9:IAnalyticsManager) : void
      {
         _downloadManagerStatusMediator = param1;
         _userProfile = param2;
         _downloader = param3;
         _staticFileServiceURLProvider = param4 as IStaticFileServiceURLProvider;
         _isCheckForNanocashEnabled = param4.isCheckForNanocashEnabled;
         _checkIfFirstTimeCommand = param5;
         _fileOperator = param6;
         _virmonDataRetriever = param7;
         _evoDataRetriever = param8;
         _analyticsManager = param9;
      }
      
      public function handleManifestMetadataLoadError(param1:String) : void
      {
         logError("handleManifestMetadataLoadError(): " + param1);
      }
      
      public function downloadWaitStateAssets() : void
      {
      }
      
      public function handleManifestMetadataLoadComplete(param1:Boolean, param2:String, param3:IManifestReference) : void
      {
         _manifestMetadataParser = new ManifestMetadataParser(_fileOperator,param2);
         _manifestMetadataParser.parseManifestMetadata(IManifestMetadataParserConsumer(this),_manifestMetadataLoader.manifestMetadataXML,param3);
      }
      
      public function get assetRetrieverManager() : IAssetRetrieverManager
      {
         return _assetRetrieverManager;
      }
      
      public function downloadRequiredAssets() : void
      {
         log("downloadRequiredAssets()");
         _assetDownloader.downloadRequiredAssets();
      }
      
      public function get staticFileServiceURL() : String
      {
         return DEBUG_SFS_URL;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<AssetManagerProxy>> " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetManagerProxy>> " + param1);
      }
      
      public function loadNextManifest(param1:Array) : void
      {
         _manifestQueue = _manifestQueue.concat(param1);
         if(0 == _manifestQueue.length)
         {
            log("We are done downloading manifests.");
            compareManifests();
            return;
         }
         _downloadManagerStatusMediator.handleManifestParsed(_parsedManifestsCount++);
         _assetManifestLoader = new AssetManifestLoader(_manifestQueue.pop() as IManifestReference,_fileOperator,_downloader,_staticFileServiceURLProvider);
         _assetManifestLoader.load(IManifestLoaderConsumer(this));
      }
      
      public function migrationComplete() : void
      {
         log("migrationComplete()");
         log("loading manifests...");
         _downloadManagerStatusMediator.handleAssetsCheckStarted();
         _parsedManifestsCount = 0;
         loadNextManifest([new RootManifestReference()]);
      }
      
      private function compareManifests() : void
      {
         log("compareManifests()");
         _manifestComparator = new ManifestComparator();
         _manifestComparator.compareManifests(_manifestList,_superManifestList);
         downloadPreMinSetAssets();
      }
      
      public function handleManifestLoadComplete(param1:IManifestReference) : void
      {
         _manifestMetadataLoader = new ManifestMetadataLoader(_fileOperator,param1);
         _manifestMetadataLoader.load(_assetManifestLoader.posixFileName.replace(AssetLocation.MANIFEST_FILE_NAME.name,AssetLocation.MANIFEST_METADATA_FILE_NAME.name),IManifestMetadataLoaderConsumer(this));
      }
      
      public function loadManifests() : void
      {
         log("loadManifests()");
         _analyticsManager.trackAction(Action.LOGIN_MANIFEST_PARSE_STARTED);
         _migrationWizard = new MigrationWizard(_fileOperator);
         _migrationWizard.addMigrationWizardCompleteHandler(this as IMigrationWizardCompleteHandler);
         _migrationWizard.start();
      }
      
      public function getAssetURL(param1:String, param2:String, param3:String, param4:AssetURLType = null, param5:int = 0) : IAssetURL
      {
         var _loc9_:IAssetManifest = null;
         var _loc10_:IAssetGroup = null;
         if(++param5 > 500)
         {
            logError("getAssetURL(): RECURSION ERROR: hit iteration limit of 500 :: manifestName=\'" + param1 + "\' groupName=\'" + param2 + "\' + assetID=\'" + param3 + "\' overrideAssetURLType=" + param4);
            throw new Error("Hit recursion limit of 500 in getAssetURL :: manifestName=\'" + param1 + "\' groupName=\'" + param2 + "\' + assetID=\'" + param3 + "\' overrideAssetURLType=" + param4);
         }
         if(null == param4)
         {
            param4 = AssetURLType.ACTUAL;
         }
         var _loc6_:IAssetManifest = _manifestList.getManifest(param1);
         if(null == _loc6_)
         {
            _loc6_ = _superManifestList.getManifest(param1);
            if(null == _loc6_)
            {
               return new NullAssetURL("(manifestName=" + param1 + " groupName=" + param2 + " assetID=" + param3 + " overrideAssetURLType=" + param4 + ")");
            }
         }
         var _loc7_:IAssetGroup = _loc6_.getGroupByName(param2);
         if(null == _loc7_)
         {
            return new NullAssetURL("(manifestName=" + param1 + " groupName=" + param2 + " assetID=" + param3 + " overrideAssetURLType=" + param4 + ")");
         }
         var _loc8_:IAsset = AssetURLType.FALLBACK_DEFAULT == param4 ? _loc7_.getDefaultAsset() : _loc7_.getAssetById(param3);
         if(null == _loc8_)
         {
            return new NullAssetURL("(manifestName=" + param1 + " groupName=" + param2 + " assetID=" + param3 + " overrideAssetURLType=" + param4 + ")");
         }
         if(AssetURLType.FALLBACK_SUPERSEDED == param4)
         {
            _loc9_ = _superManifestList.getManifest(_loc6_.superManifestName);
            if(null == _loc9_)
            {
               logError("Error: Prototypical asset was not found: manifest: " + param1 + ", group: " + param2 + ", assetID: " + param3);
               return getAssetURL(param1,param2,param3,AssetURLType.ACTUAL,param5);
            }
            _loc10_ = _loc9_.getGroupByName(param2);
            if(null == _loc10_)
            {
               logError("Error: Prototypical asset was not found: manifest: " + param1 + ", group: " + param2 + ", assetID: " + param3);
               return getAssetURL(param1,param2,param3,AssetURLType.ACTUAL,param5);
            }
            _loc8_ = _loc10_.getAssetById(_loc8_.assetGroup.redundant ? _loc8_.assetGroup.getDefaultAsset().superId : _loc8_.superId);
            if(null == _loc8_)
            {
               logError("Error: Prototypical asset was not found: manifest: " + param1 + ", group: " + param2 + ", assetID: " + param3);
               return getAssetURL(param1,param2,param3,AssetURLType.ACTUAL,param5);
            }
         }
         if(false == _loc6_.assetManifestMetadata.hasAllRequiredAssets && _loc8_.superId != null)
         {
            return getAssetURL(param1,param2,param3,AssetURLType.FALLBACK_SUPERSEDED,param5);
         }
         if(_loc8_.isOutdated)
         {
            if(_loc8_.isDefault)
            {
               return new NullAssetURL("(manifestName=" + param1 + " groupName=" + param2 + " assetID=" + param3 + " overrideAssetURLType=" + param4 + ")");
            }
            _loc8_ = _loc7_.getDefaultAsset();
            if(null == _loc8_)
            {
               return new NullAssetURL("(manifestName=" + param1 + " groupName=" + param2 + " assetID=" + param3 + " overrideAssetURLType=" + param4 + ")");
            }
            if(false == _loc6_.assetManifestMetadata.hasAllRequiredAssets && _loc8_.superId != null)
            {
               return getAssetURL(param1,param2,_loc8_.id,AssetURLType.FALLBACK_SUPERSEDED,param5);
            }
            param4 = AssetURLType.FALLBACK_DEFAULT;
         }
         return new AssetURL(AssetLocation.ASSETS_DIRECTORY.name + "/" + Utils.DOStoPOSIXpath(_loc8_.fullFilePath),param4,_loc8_);
      }
      
      private function downloadPreMinSetAssets() : void
      {
         log("downloadPreMinSetAssets(): download list length = " + _manifestComparator.preMinSetDownloadList.length);
         _analyticsManager.trackAction(Action.LOGIN_MANIFEST_PARSE_COMPLETE);
         _assetDownloader = new AssetDownloader(_manifestComparator,_downloader,_staticFileServiceURLProvider,_downloadManagerStatusMediator,_userProfile,_isCheckForNanocashEnabled,_virmonDataRetriever,_evoDataRetriever,_assetRetrieverManager,_analyticsManager);
         _assetDownloader.downloadPreMinSetAssets();
      }
      
      public function handleManifestMetadataParseComplete(param1:IAssetManifestMetadata, param2:IManifestReference) : void
      {
         _assetManifestParser = new AssetManifestParser(param1,IAssetManagerProxy(this));
         _assetManifestParser.parseManifest(param2,_assetManifestLoader.assetManifestXML);
      }
      
      private function handleRootManifestDownloadError() : void
      {
         logError("handleRootManifestDownloadError()");
         _downloadManagerStatusMediator.handleDownloadError();
      }
      
      public function addManifest(param1:IAssetManifest) : void
      {
         if(null == param1)
         {
            throw new Error("Parameter \"assetManifest\" cannot be null.");
         }
         switch(param1.manifestType)
         {
            case ManifestType.NORMAL:
               _manifestList.addManifest(param1);
               break;
            case ManifestType.SUPER:
               _superManifestList.addManifest(param1);
               break;
            default:
               throw new Error("Unknown ManifestType: " + param1.manifestType);
         }
      }
      
      public function downloadBackgroundAssets() : void
      {
         log("downloadBackgroundAssets()");
         _assetDownloader.downloadBackgroundAssets();
      }
   }
}

