package com.arkadium.virmon.wrapper.statepackagestatusupdater
{
   import com.arkadium.virmon.state.StateType;
   
   public interface IStatePackageReadyHandler
   {
      
      function handleStatePackageReady(param1:StateType) : void;
   }
}

