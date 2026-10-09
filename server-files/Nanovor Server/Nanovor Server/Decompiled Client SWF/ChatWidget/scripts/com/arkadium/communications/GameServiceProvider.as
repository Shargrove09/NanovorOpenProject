package com.arkadium.communications
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.handlers.*;
   import com.arkadium.virmon.state.*;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.smartfox.*;
   import flash.events.*;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.*;
   
   public class GameServiceProvider extends EventDispatcher implements IGameServiceInitializedHandler
   {
      
      private static var _instance:GameServiceProvider;
      
      private var _initConsumer:IGameServiceProviderInitConsumer;
      
      private var _battleGameServiceConnection:SmartFoxConnection;
      
      private var _battleGameService:IBattleGameService;
      
      private var _userGameService:IUserGameService;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _buddyListGameService:IBuddyListGameService;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _chatGameServiceConnection:SmartFoxConnection;
      
      private var _chatGameService:IChatGameService;
      
      private var _tradeGameServiceConnection:SmartFoxConnection;
      
      private var _tradeGameService:ITradeGameService;
      
      public function GameServiceProvider(param1:Function = null)
      {
         super();
         if(param1 != GameServiceProvider.getInstance)
         {
            throw new Error("GameServiceProvider singleton exception: cannot instantiate outside of this class");
         }
         if(null != GameServiceProvider._instance)
         {
            throw new Error("Only one GameServiceProvider instance should be instantiated");
         }
      }
      
      public static function getInstance() : GameServiceProvider
      {
         if(null == _instance)
         {
            _instance = new GameServiceProvider(arguments.callee);
         }
         return GameServiceProvider._instance;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> GameServiceProvider: " + param1);
      }
      
      public function get buddyListGameService() : IBuddyListGameService
      {
         return this._buddyListGameService;
      }
      
      public function init(param1:IUserProfile, param2:IAnalyticsManager, param3:IServiceRequestBrokerManager, param4:IGameServiceProviderInitConsumer, param5:IApplicationExiter, param6:GameServiceConnectionData, param7:GameServiceConnectionData, param8:GameServiceConnectionData) : void
      {
         this._analyticsManager = param2;
         this._serviceRequestBrokerManager = param3;
         this._initConsumer = param4;
         this.log("init()");
         if(null == param6)
         {
            throw new Error("Parameter \"chatGameServiceConnectionData\" cannot be null.");
         }
         if(null == param7)
         {
            throw new Error("Parameter \"battleGameServiceConnectionData\" cannot be null.");
         }
         if(null == param8)
         {
            throw new Error("Parameter \"tradeGameServiceConnectionData\" cannot be null.");
         }
         var _loc9_:Dictionary = new Dictionary();
         _loc9_[param6.ipAddress] = new SmartFoxConnection(param6);
         if(null == _loc9_[param7.ipAddress])
         {
            _loc9_[param7.ipAddress] = new SmartFoxConnection(param7);
         }
         if(null == _loc9_[param8.ipAddress])
         {
            _loc9_[param8.ipAddress] = new SmartFoxConnection(param8);
         }
         this._chatGameServiceConnection = _loc9_[param6.ipAddress];
         this._battleGameServiceConnection = _loc9_[param7.ipAddress];
         this._tradeGameServiceConnection = _loc9_[param8.ipAddress];
         this._battleGameService = new SmartFoxBattleGameService(param1,this._battleGameServiceConnection);
         this._tradeGameService = new SmartFoxTradeGameService(param1,this._tradeGameServiceConnection);
         this._chatGameService = new SmartFoxChatGameService(param1,this._chatGameServiceConnection,this._battleGameService,this._tradeGameService);
         this._userGameService = new SmartFoxUserGameService(param1,this._chatGameServiceConnection,this._initConsumer,param5);
         this._buddyListGameService = new SmartFoxBuddyListGameService(param1,this._chatGameServiceConnection,this._battleGameService);
         this._initConsumer.handleGameServicesInitSuccess();
      }
      
      public function get battleGameService() : IBattleGameService
      {
         return this._battleGameService;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** GameServiceProvider: " + param1);
      }
      
      public function get userGameService() : IUserGameService
      {
         return this._userGameService;
      }
      
      public function get chatGameService() : IChatGameService
      {
         return this._chatGameService;
      }
      
      public function get tradeGameService() : ITradeGameService
      {
         return this._tradeGameService;
      }
      
      public function handleGameServiceFailure(param1:String) : void
      {
         this.logError("handleGameServiceFailure(): " + param1);
         this._analyticsManager.trackAction(Action.LOGIN_GAMESERVER_LOGIN_FAILED);
         this._initConsumer.handleGameServicesInitFailure(param1);
      }
      
      public function handleGameServiceInitialized(param1:Object = null) : void
      {
         this.log("handleGameServiceInitialized()");
         this._initConsumer.handleGameServicesLoginSuccess();
         this._analyticsManager.trackAction(Action.LOGIN_GAMESERVER_LOGIN_OK);
         this._serviceRequestBrokerManager.startTokenRefresh();
      }
      
      public function loginToGameService(param1:IStateManager) : void
      {
         var _loc2_:IGameServiceInvitationManager = new GameServiceInvitationManager(param1);
         this._battleGameService.setGameServiceInivitationManager(_loc2_);
         this._tradeGameService.setGameServiceInivitationManager(_loc2_);
         this._chatGameService.setGameServiceInivitationManager(_loc2_);
         this._userGameService.init(IGameServiceInitializedHandler(this));
      }
   }
}

