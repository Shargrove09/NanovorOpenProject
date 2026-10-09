package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.wrapper.model.IGameEngineModel;
   import com.arkadium.virmon.wrapper.model.UserType;
   
   public class GameEngineExistingUserController implements IGameEngineNestedController
   {
      
      private var _isGameServiceLoginComplete:Boolean;
      
      private var _model:IGameEngineModel;
      
      private var _isRequiredAssetsDownloadComplete:Boolean;
      
      public function GameEngineExistingUserController(param1:IGameEngineModel)
      {
         super();
         _model = param1;
         if(!_isRequiredAssetsDownloadComplete)
         {
            _model.toggleWaitScreen(true);
         }
      }
      
      public function handleGameServiceLoginComplete() : void
      {
         _model.setInitialState(UserType.EXISTING_USER);
      }
      
      public function handleRequiredAssetsDownloadComplete() : void
      {
         _model.loginToGameService();
      }
   }
}

