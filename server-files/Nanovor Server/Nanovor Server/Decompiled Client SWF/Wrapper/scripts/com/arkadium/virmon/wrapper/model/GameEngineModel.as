package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.downloadmanager.IDownloadManager;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.gameengine.IGameEngine;
   import com.arkadium.virmon.gameengine.IGameEngineInitializedHandler;
   import com.arkadium.virmon.gameengine.gameservice.GameEngineGameServiceController;
   import com.arkadium.virmon.gameengine.gameservice.IGameEngineGameServiceControllerConsumer;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.newuserexperience.INewUserStateConsumer;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.StatePackageStatusUpdater;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class GameEngineModel implements IGameEngineModel, INewUserStatusDeterminatorHandler, INewUserStateConsumer, IGameEngineGameServiceControllerConsumer, IGameEngineInitializedHandler, IDownloadManagerLoadCompleteHandler
   {
      
      private static const GAME_ENGINE_PATH:String = "GameEngine.swf";
      
      private var _eventManager:IEventDispatcher;
      
      private var _userProfile:IUserProfile;
      
      private var _newUserStatusDeterminator:NewUserStatusDeterminator;
      
      private var _musicManager:IMusicManager;
      
      private var _assetRetrieverManager:IAssetRetrieverManager;
      
      private var _gameEngineGameServiceController:GameEngineGameServiceController;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _loader:Loader;
      
      private var _mdmManager:IMDMManager;
      
      private var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      private var _stateManager:IStateManager;
      
      private var _applicationExiter:IApplicationExiter;
      
      private var _downloadManager:IDownloadManager;
      
      private var _handlers:Dictionary;
      
      private var _webClientManager:WebClientManager;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _gameEngine:IGameEngine;
      
      public function GameEngineModel(param1:IDownloadManagerModel, param2:IDownloader, param3:IDownloadManagerStatusMediator, param4:IEventDispatcher, param5:IUserProfile, param6:IMusicManager, param7:IMDMManager, param8:IServiceRequestBrokerManager, param9:WebClientManager, param10:IHomeBreadcrumbUIManager, param11:IApplicationExiter, param12:IAnalyticsManager)
      {
         super();
         _downloader = param2;
         _downloadManagerStatusMediator = param3;
         _eventManager = param4;
         _userProfile = param5;
         _musicManager = param6;
         _mdmManager = param7;
         _serviceRequestBrokerManager = param8;
         _webClientManager = param9;
         _homeBreadcrumbUIManager = param10;
         _applicationExiter = param11;
         _analyticsManager = param12;
         param1.addDownloadManagerLoadCompleteHandler(IDownloadManagerLoadCompleteHandler(this));
         _handlers = new Dictionary();
         _handlers[IGameEngineLoadCompleteHandler] = new Dictionary(true);
         _handlers[IGameEngineInitializedHandler] = new Dictionary(true);
         _handlers[IGameEngineGameServiceControllerConsumer] = new Dictionary(true);
         _handlers[INewUserStateConsumer] = new Dictionary(true);
         _handlers[IUserTypeResponseHandler] = new Dictionary(true);
         _handlers[IToggleWaitScreenHandler] = new Dictionary(true);
      }
      
      public function addGameEngineLoadCompleteHandler(param1:IGameEngineLoadCompleteHandler) : void
      {
         _handlers[IGameEngineLoadCompleteHandler][param1] = param1;
      }
      
      public function handleGameServiceLoginComplete() : void
      {
         var _loc1_:IGameEngineGameServiceControllerConsumer = null;
         log("handleGameServiceLoginComplete()");
         for each(_loc1_ in _handlers[IGameEngineGameServiceControllerConsumer])
         {
            _loc1_.handleGameServiceLoginComplete();
         }
      }
      
      public function addUserTypeResponseHandler(param1:IUserTypeResponseHandler) : void
      {
         _handlers[IUserTypeResponseHandler][param1] = param1;
      }
      
      private function handleGameEngineLoadError(param1:IOErrorEvent) : void
      {
         logError("handleGameEngineLoadError(): " + param1.text);
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleGameEngineLoadComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleGameEngineLoadError);
      }
      
      public function addGameEngineInitializedHandler(param1:IGameEngineInitializedHandler) : void
      {
         _handlers[IGameEngineInitializedHandler][param1] = param1;
      }
      
      public function addToggleWaitScreenHandler(param1:IToggleWaitScreenHandler) : void
      {
         _handlers[IToggleWaitScreenHandler][param1] = param1;
      }
      
      public function handleGameEngineInitialized(param1:IStateManager) : void
      {
         var _loc2_:IGameEngineInitializedHandler = null;
         log("handleGameEngineInitialized()");
         _stateManager = param1;
         for each(_loc2_ in _handlers[IGameEngineInitializedHandler])
         {
            _loc2_.handleGameEngineInitialized(param1);
         }
      }
      
      public function handleDownloadManagerLoadComplete(param1:IDownloadManager) : void
      {
         _downloadManager = param1;
      }
      
      public function loadGameService() : void
      {
         log("loadGameService()");
         _gameEngineGameServiceController = new GameEngineGameServiceController(IGameEngineGameServiceControllerConsumer(this));
         _gameEngineGameServiceController.init(_applicationExiter,_serviceRequestBrokerManager,_userProfile,_analyticsManager);
      }
      
      public function handleGameServiceLoginError(param1:String) : void
      {
         var _loc2_:IGameEngineGameServiceControllerConsumer = null;
         logError("handleGameServiceLoginError()");
         for each(_loc2_ in _handlers[IGameEngineGameServiceControllerConsumer])
         {
            _loc2_.handleGameServiceLoginError(param1);
         }
      }
      
      public function addGameServiceLoadHandler(param1:IGameEngineGameServiceControllerConsumer) : void
      {
         _handlers[IGameEngineGameServiceControllerConsumer][param1] = param1;
      }
      
      public function handleNewUserStatusDeterminatorError(param1:String) : void
      {
         logError("handleNewUserStatusDeterminatorError(): " + param1);
      }
      
      public function toggleWaitScreen(param1:Boolean) : void
      {
         var _loc2_:IToggleWaitScreenHandler = null;
         for each(_loc2_ in _handlers[IToggleWaitScreenHandler])
         {
            _loc2_.handleToggleWaitScreen(param1);
         }
      }
      
      public function handleNewUserStatusDeterminatorComplete(param1:Boolean) : void
      {
         var _loc2_:IUserTypeResponseHandler = null;
         log("handleNewUserStatusDeterminatorComplete()");
         _newUserStatusDeterminator = null;
         for each(_loc2_ in _handlers[IUserTypeResponseHandler])
         {
            _loc2_.handleUserTypeResponse(param1 ? UserType.NEW_USER : UserType.EXISTING_USER);
         }
      }
      
      public function setInitialState(param1:UserType) : void
      {
         _stateManager.setStateData(StateType.NEWUSER,INewUserStateConsumer(this));
         _stateManager.setState(UserType.NEW_USER == param1 ? StateType.NEWUSER : StateType.HOME);
         toggleWaitScreen(false);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineModel>> " + param1);
      }
      
      public function loadGameEngine(param1:IAssetRetrieverManager) : void
      {
         log("loadGameEngine() - assetRetrieverManager is null? " + Boolean(null == param1));
         _assetRetrieverManager = param1;
         Managers.assetRetrieverManager = param1;
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleGameEngineLoadComplete);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleGameEngineLoadError);
         _loader.load(new URLRequest(GAME_ENGINE_PATH));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>GameEngineModel<< " + param1);
      }
      
      public function requestUserType() : void
      {
         log("requestUserType()");
         if(null == _newUserStatusDeterminator)
         {
            _newUserStatusDeterminator = new NewUserStatusDeterminator(_serviceRequestBrokerManager,_userProfile);
         }
         _newUserStatusDeterminator.determineNewUserStatus(INewUserStatusDeterminatorHandler(this));
      }
      
      public function handleNewUserStateComplete(param1:IStateManager) : void
      {
         var _loc2_:INewUserStateConsumer = null;
         log("handleNewUserStateComplete()");
         for each(_loc2_ in _handlers[INewUserStateConsumer])
         {
            _loc2_.handleNewUserStateComplete(param1);
         }
      }
      
      public function addNewUserStateConsumerHandler(param1:INewUserStateConsumer) : void
      {
         _handlers[INewUserStateConsumer][param1] = param1;
      }
      
      private function handleGameEngineLoadComplete(param1:Event) : void
      {
         var _loc2_:IGameEngineLoadCompleteHandler = null;
         log("handleGameEngineLoadComplete()");
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleGameEngineLoadComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleGameEngineLoadError);
         _gameEngine = _loader.content as IGameEngine;
         for each(_loc2_ in _handlers[IGameEngineLoadCompleteHandler])
         {
            _loc2_.handleGameEngineLoadComplete(_gameEngine);
         }
         if(null == _downloadManager)
         {
            throw new Error("DownloadManager is null");
         }
         _gameEngine.init(_downloader,_eventManager,_userProfile,_musicManager,_mdmManager,_serviceRequestBrokerManager,_webClientManager,_homeBreadcrumbUIManager,_applicationExiter,new StatePackageStatusUpdater(_downloadManagerStatusMediator,_downloadManager),IGameEngineInitializedHandler(this));
      }
      
      public function handleGameServicesInitialized() : void
      {
         var _loc1_:IGameEngineGameServiceControllerConsumer = null;
         log("handleGameServicesInitialized()");
         for each(_loc1_ in _handlers[IGameEngineGameServiceControllerConsumer])
         {
            _loc1_.handleGameServicesInitialized();
         }
      }
      
      public function loginToGameService() : void
      {
         log("loginToGameService()");
         _gameEngineGameServiceController.loginToGameService(_stateManager);
      }
   }
}

