package com.arkadium.virmon.gameengine.gameservice
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.GameServiceConnectionData;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.ServiceRequestBrokerValueType;
   import com.arkadium.communications.handlers.IGameServiceProviderInitConsumer;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class GameEngineGameServiceController implements IGameServiceProviderInitConsumer
   {
      
      private var _gameServiceProvider:GameServiceProvider;
      
      private var _consumer:IGameEngineGameServiceControllerConsumer;
      
      public function GameEngineGameServiceController(param1:IGameEngineGameServiceControllerConsumer)
      {
         super();
         _consumer = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineGameServiceController>>\t" + param1);
      }
      
      public function handleGameServicesInitFailure(param1:String) : void
      {
         _consumer.handleGameServiceLoginError(param1);
      }
      
      public function init(param1:IApplicationExiter, param2:IServiceRequestBrokerManager, param3:IUserProfile, param4:IAnalyticsManager) : void
      {
         log("handleServiceRequestBrokerLoadComplete()");
         var _loc5_:String = param2.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.GAME_SERVICE_IP);
         var _loc6_:int = param2.getGameServicePort();
         var _loc7_:String = param2.getLoginToken();
         var _loc8_:GameServiceConnectionData = new GameServiceConnectionData(_loc5_,_loc6_,_loc7_);
         var _loc9_:GameServiceConnectionData = new GameServiceConnectionData(_loc5_,_loc6_,_loc7_);
         var _loc10_:GameServiceConnectionData = new GameServiceConnectionData(_loc5_,_loc6_,_loc7_);
         _gameServiceProvider = GameServiceProvider.getInstance();
         _gameServiceProvider.init(param3,param4,param2,IGameServiceProviderInitConsumer(this),param1,_loc8_,_loc9_,_loc10_);
         log("handleServiceRequestBrokerLoadComplete() - Called consumer");
      }
      
      public function handleGameServicesInvalidLogin() : void
      {
         _consumer.handleGameServiceLoginError("");
      }
      
      public function handleGameServicesLoginSuccess() : void
      {
         _consumer.handleGameServiceLoginComplete();
      }
      
      public function handleGameServicesInitSuccess() : void
      {
         _consumer.handleGameServicesInitialized();
      }
      
      public function loginToGameService(param1:IStateManager) : void
      {
         _gameServiceProvider.loginToGameService(param1);
      }
   }
}

