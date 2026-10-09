package com.arkadium.virmon.state
{
   public interface IStateChanger
   {
      
      function setStateData(param1:StateType, param2:Object) : void;
      
      function setState(param1:StateType, param2:Object = null, param3:Boolean = false) : void;
   }
}

