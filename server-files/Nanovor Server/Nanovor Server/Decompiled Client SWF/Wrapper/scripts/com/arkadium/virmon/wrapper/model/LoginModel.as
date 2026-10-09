package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.IVersionDataProvider;
   import com.arkadium.communications.ServiceRequestBrokerManagerEvent;
   import com.arkadium.communications.ServiceRequestBrokerValueType;
   import com.arkadium.communications.handlers.IServiceRequestBrokerHandler;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.ILoginPanelConsumer;
   import com.arkadium.virmon.loginpanel.IShardDataHandler;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.loginpanel.ShardData;
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.FinalComponentsLoader;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.wrapper.DefaultMusicTrack;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.arkadium.virmon.wrapper.view.ILoginSubmitHandler;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   
   public class LoginModel implements ILoginModel, IShardDataHandler, ILoginSubmitHandler, ILoginPanelConsumer, IChainLoaderConsumer
   {
      
      private static const LOGIN_PANEL_FILE_PATH:String = "LoginPanel.swf";
      
      private var _userProfile:IUserProfile;
      
      private var _musicManager:IMusicManager;
      
      private var _shardData:ShardData;
      
      private var _applicationExiter:IApplicationExiter;
      
      private var _handlers:Dictionary;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _loginPanelLoader:Loader;
      
      private var _chainLoader:ChainLoader;
      
      public function LoginModel(param1:IServiceRequestBrokerManager, param2:IUserProfile, param3:IMusicManager, param4:IApplicationExiter)
      {
         super();
         _handlers = new Dictionary();
         _handlers[ILoginPanelLoadedHandler] = new Dictionary(true);
         _handlers[IServiceRequestBrokerHandler] = new Dictionary(true);
         _handlers[IShardListReceivedHandler] = new Dictionary(true);
         _handlers[IUserTypeResponseHandler] = new Dictionary(true);
         _userProfile = param2;
         _serviceRequestBrokerManager = param1;
         _musicManager = param3;
         _applicationExiter = param4;
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.INITIALIZED,handleServiceRequestBrokerInitialized);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.COMPLETE,handleServiceRequestBrokerComplete);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.CORRUPTED_SETTINGS_FILE,handleCorruptedSettingsFile);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.ERROR,handleServiceRequestBrokerError);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.NO_ACTION,handleServiceRequestBrokerNoAction);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.MAINTENANCE,handleServiceRequestBrokerMaintenance);
         _serviceRequestBrokerManager.addEventListener(ServiceRequestBrokerManagerEvent.REFRESH,handleServiceRequestBrokerRefresh);
      }
      
      private function handleServiceRequestBrokerRefresh(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc5_:IServiceRequestBrokerHandler = null;
         Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_REFRESH);
         var _loc2_:String = _serviceRequestBrokerManager.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.DOWNLOAD_SERVICE_IP);
         var _loc3_:String = _serviceRequestBrokerManager.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.DOWNLOAD_SERVICE_URL);
         var _loc4_:String = "http://" + _loc2_ + _loc3_;
         Managers.mdmManager.mdmFilesystem.saveFile(Managers.mdmManager.mdmApplication.path + "VersionUpdate.txt",_loc4_);
         for each(_loc5_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc5_.handleServiceRequestBrokerRefresh(Managers.mdmManager.mdmFilesystem.fileExists(Managers.mdmManager.mdmApplication.path + "VersionUpdate.txt"));
         }
      }
      
      private function handleCorruptedSettingsFile(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerCorruptedSettingsFile();
         }
      }
      
      public function shardDataEmpty(param1:String) : void
      {
         logError("ShardDateEmpty: " + param1);
         Managers.analyticsManager.trackAction(Action.LOGIN_SHARD_LIST_EMPTY);
      }
      
      public function addUserTypeResponseHandler(param1:IUserTypeResponseHandler) : void
      {
         _handlers[IUserTypeResponseHandler][param1] = param1;
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      public function handleExitApplication() : void
      {
         _applicationExiter.exitApplication();
      }
      
      public function handleLoginSubmit(param1:String, param2:String, param3:String) : void
      {
         login(param1,param2,param3);
      }
      
      public function loadLoginPanel() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(new SWFLoadee(LOGIN_PANEL_FILE_PATH));
         _loc1_.add(new FinalComponentsLoader());
         _chainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<LoginModel>> " + param1);
      }
      
      public function handleForgotPassword() : void
      {
         EventManager.getInstance().dispatchEvent(new FrameWorkEvent(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,false,false,"password-reset"));
      }
      
      public function shardDataReceived(param1:Array) : void
      {
         var _loc2_:IShardListReceivedHandler = null;
         Managers.analyticsManager.trackAction(Action.LOGIN_SHARD_LIST_LOADED);
         for each(_loc2_ in _handlers[IShardListReceivedHandler])
         {
            _loc2_.handleShardListRecievedHandler(param1);
         }
      }
      
      public function addShardListReceivedHandler(param1:IShardListReceivedHandler) : void
      {
         _handlers[IShardListReceivedHandler][param1] = param1;
      }
      
      private function handleServiceRequestBrokerComplete(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_CONNECT);
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerComplete();
         }
      }
      
      private function handleServiceRequestBrokerMaintenance(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_MAINTENANCE);
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerMaintenance(_serviceRequestBrokerManager.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.MESSAGE));
         }
      }
      
      public function shardDataError(param1:IOErrorEvent) : void
      {
         logError("Shard Data Load Error: " + param1.text);
         Managers.analyticsManager.trackAction(Action.LOGIN_SHARD_LIST_LOAD_ERROR);
      }
      
      public function initializeServiceRequestBroker() : void
      {
         _serviceRequestBrokerManager.init();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<LoginModel>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc4_:ILoginPanelLoadedHandler = null;
         var _loc5_:DefaultMusicTrack = null;
         var _loc2_:ILoginPanel = param1.getLoadedAsset(SWFLoadee.NAME + LOGIN_PANEL_FILE_PATH) as ILoginPanel;
         var _loc3_:IWaitPanel = param1.getLoadedAsset(SWFLoadee.NAME + LOGIN_PANEL_FILE_PATH) as IWaitPanel;
         _loc2_.init(ILoginSubmitHandler(this),ILoginPanelConsumer(this));
         for each(_loc4_ in _handlers[ILoginPanelLoadedHandler])
         {
            _loc4_.handleLoginPanelLoaded(_loc2_,_loc3_);
         }
         _loc5_ = new DefaultMusicTrack();
         log("handleLoginPanelLoadComplete(): defaultMusicTrack.url=" + _loc5_);
         if(Boolean(Managers.mdmManager.mdmFilesystem.fileExists(Environment.posixToLocalPath(_loc5_.url))))
         {
            _musicManager.FadeOutFadeInToTrack(_loc5_,1000,0);
         }
      }
      
      public function addLoginPanelLoadedHandler(param1:ILoginPanelLoadedHandler) : void
      {
         _handlers[ILoginPanelLoadedHandler][param1] = param1;
      }
      
      public function handleNewAccount() : void
      {
         EventManager.getInstance().dispatchEvent(new FrameWorkEvent(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,false,false,"account-creation"));
      }
      
      public function addServiceRequestBrokerHandler(param1:IServiceRequestBrokerHandler) : void
      {
         _handlers[IServiceRequestBrokerHandler][param1] = param1;
      }
      
      private function handleServiceRequestBrokerNoAction(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerNoAction(param1.responseString);
         }
      }
      
      public function login(param1:String, param2:String, param3:String) : void
      {
         _serviceRequestBrokerManager.loadServiceRequestBroker(param1,param2,_userProfile,param3);
      }
      
      private function getShardData() : void
      {
         _shardData = new ShardData(IShardDataHandler(this),_serviceRequestBrokerManager);
         Managers.analyticsManager.trackAction(Action.LOGIN_SHARD_LIST_REQUESTED);
      }
      
      private function handleServiceRequestBrokerError(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerError();
         }
      }
      
      private function handleServiceRequestBrokerInitialized(param1:ServiceRequestBrokerManagerEvent) : void
      {
         var _loc2_:IServiceRequestBrokerHandler = null;
         for each(_loc2_ in _handlers[IServiceRequestBrokerHandler])
         {
            _loc2_.handleServiceRequestBrokerInitialized(_serviceRequestBrokerManager as IVersionDataProvider);
         }
         getShardData();
      }
   }
}

