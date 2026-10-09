package com.arkadium.virmon.framework.asset
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class AssetManager extends EventDispatcher implements IAssetManager
   {
      
      private static const ASSET_MANAGER_PROXY_PATH:String = "AssetManagerProxy.swf";
      
      private static var _instance:AssetManager = null;
      
      private var _assetManagerProxyLoader:Loader;
      
      private var _analyticsManagers:IAnalyticsManager;
      
      private var _assetManagerProxy:IAssetManager;
      
      private var _checkIfFirstTimeCommand:Function;
      
      private var _downloader:IDownloader;
      
      private var _evoDataRetriever:IEvoDataRetriever;
      
      private var _fileOperator:IFileOperator;
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _userProfile:IUserProfile;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      public function AssetManager()
      {
         super();
      }
      
      public static function getInstance() : AssetManager
      {
         if(AssetManager._instance == null)
         {
            _instance = new AssetManager();
         }
         return AssetManager._instance;
      }
      
      public function getManifestSuperName(param1:String) : String
      {
         return _assetManagerProxy.getManifestSuperName(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetManager>> " + param1);
      }
      
      public function init(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:Function, param6:IFileOperator, param7:IVirmonDataRetriever, param8:IEvoDataRetriever, param9:IAnalyticsManager) : void
      {
         _downloadManagerStatusMediator = param1;
         _userProfile = param2;
         _downloader = param3;
         _serviceRequestBrokerManager = param4;
         _checkIfFirstTimeCommand = param5;
         _fileOperator = param6;
         _virmonDataRetriever = param7;
         _evoDataRetriever = param8;
         _analyticsManagers = param9;
      }
      
      private function handleAssetManagerProxyLoadError(param1:IOErrorEvent) : void
      {
         log("handleAssetManagerProxyLoadError(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleAssetManagerProxyLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleAssetManagerProxyLoadError);
      }
      
      public function getAssetURL(param1:String, param2:String, param3:String, param4:AssetURLType = null, param5:int = 0) : IAssetURL
      {
         return _assetManagerProxy.getAssetURL(param1,param2,param3,param4,param5);
      }
      
      public function loadManifests() : void
      {
         _assetManagerProxyLoader = new Loader();
         _assetManagerProxyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleAssetManagerProxyLoadComplete);
         _assetManagerProxyLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleAssetManagerProxyLoadError);
         _assetManagerProxyLoader.load(new URLRequest(ASSET_MANAGER_PROXY_PATH),new LoaderContext(false,ApplicationDomain.currentDomain));
      }
      
      public function get assetRetrieverManager() : IAssetRetrieverManager
      {
         return _assetManagerProxy.assetRetrieverManager;
      }
      
      public function downloadRequiredAssets() : void
      {
         _assetManagerProxy.downloadRequiredAssets();
      }
      
      public function getAssetList(param1:String, param2:String) : Array
      {
         return _assetManagerProxy.getAssetList(param1,param2);
      }
      
      public function downloadBackgroundAssets() : void
      {
         _assetManagerProxy.downloadBackgroundAssets();
      }
      
      private function handleAssetManagerProxyLoadComplete(param1:Event) : void
      {
         log("handleAssetManagerProxyLoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleAssetManagerProxyLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleAssetManagerProxyLoadError);
         _assetManagerProxy = IAssetManager(LoaderInfo(param1.target).content);
         _assetManagerProxy.init(_downloadManagerStatusMediator,_userProfile,_downloader,_serviceRequestBrokerManager,_checkIfFirstTimeCommand,_fileOperator,_virmonDataRetriever,_evoDataRetriever,_analyticsManagers);
         _assetManagerProxy.loadManifests();
      }
   }
}

