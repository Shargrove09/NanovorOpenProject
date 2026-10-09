package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.newuserexperience.INewUserStateConsumer;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.model.IGameEngineModel;
   import com.arkadium.virmon.wrapper.model.UserType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class GameEngineNewUserController implements IGameEngineNestedController, INewUserStateConsumer
   {
      
      private var _isNewUserStateComplete:Boolean;
      
      private var _model:IGameEngineModel;
      
      private var _isRequiredAssetsDownloadComplete:Boolean;
      
      private var _stateManager:IStateManager;
      
      public function GameEngineNewUserController(param1:IGameEngineModel)
      {
         super();
         _model = param1;
         _model.addNewUserStateConsumerHandler(INewUserStateConsumer(this));
         _model.setInitialState(UserType.NEW_USER);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineNewUserController>> " + param1);
      }
      
      public function handleNewUserStateComplete(param1:IStateManager) : void
      {
         log("handleNewUserStateComplete()");
         _stateManager = param1;
         if(!_isRequiredAssetsDownloadComplete)
         {
            _model.toggleWaitScreen(true);
         }
         _isNewUserStateComplete = true;
         tryLoginToGameService();
      }
      
      public function handleRequiredAssetsDownloadComplete() : void
      {
         _isRequiredAssetsDownloadComplete = true;
         tryLoginToGameService();
      }
      
      private function setHomeState() : void
      {
         _stateManager.setState(StateType.HOME);
         _model.toggleWaitScreen(false);
      }
      
      private function tryLoginToGameService() : void
      {
         if(false == _isNewUserStateComplete)
         {
            return;
         }
         if(false == _isRequiredAssetsDownloadComplete)
         {
            return;
         }
         _model.loginToGameService();
      }
      
      public function handleGameServiceLoginComplete() : void
      {
         setHomeState();
      }
   }
}

