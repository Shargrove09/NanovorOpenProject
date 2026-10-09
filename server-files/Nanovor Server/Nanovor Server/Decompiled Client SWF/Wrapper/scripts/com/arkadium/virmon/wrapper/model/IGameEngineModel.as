package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.gameengine.IGameEngineInitializedHandler;
   import com.arkadium.virmon.gameengine.gameservice.IGameEngineGameServiceControllerConsumer;
   import com.arkadium.virmon.newuserexperience.INewUserStateConsumer;
   
   public interface IGameEngineModel
   {
      
      function addGameServiceLoadHandler(param1:IGameEngineGameServiceControllerConsumer) : void;
      
      function addUserTypeResponseHandler(param1:IUserTypeResponseHandler) : void;
      
      function addGameEngineInitializedHandler(param1:IGameEngineInitializedHandler) : void;
      
      function addNewUserStateConsumerHandler(param1:INewUserStateConsumer) : void;
      
      function setInitialState(param1:UserType) : void;
      
      function addToggleWaitScreenHandler(param1:IToggleWaitScreenHandler) : void;
      
      function toggleWaitScreen(param1:Boolean) : void;
      
      function addGameEngineLoadCompleteHandler(param1:IGameEngineLoadCompleteHandler) : void;
      
      function loadGameEngine(param1:IAssetRetrieverManager) : void;
      
      function requestUserType() : void;
      
      function loadGameService() : void;
      
      function loginToGameService() : void;
   }
}

