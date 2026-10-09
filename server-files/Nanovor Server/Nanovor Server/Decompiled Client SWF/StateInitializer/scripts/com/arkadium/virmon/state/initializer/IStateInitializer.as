package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   
   public interface IStateInitializer
   {
      
      function init(param1:IDownloader, param2:IApplicationExiter) : void;
      
      function initializeState(param1:StateType, param2:IState, param3:Object = null) : void;
   }
}

