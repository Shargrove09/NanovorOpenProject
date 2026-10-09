package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.wrapper.model.UserType;
   
   public interface IGameEngineController extends IGameEngineNestedController
   {
      
      function handleGameEngineInitialized(param1:IStateManager) : void;
      
      function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void;
      
      function handleGameServicesInitialized() : void;
      
      function handleUserTypeResponse(param1:UserType) : void;
   }
}

