package com.arkadium.virmon.gameengine
{
   import com.arkadium.virmon.state.IStateManager;
   
   public interface IGameEngineInitializedHandler
   {
      
      function handleGameEngineInitialized(param1:IStateManager) : void;
   }
}

