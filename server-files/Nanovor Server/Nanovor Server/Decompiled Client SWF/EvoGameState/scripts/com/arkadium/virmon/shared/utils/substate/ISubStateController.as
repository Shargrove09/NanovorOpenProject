package com.arkadium.virmon.shared.utils.substate
{
   public interface ISubStateController
   {
      
      function changeSubState(param1:String, param2:Object = null) : void;
      
      function destroy() : void;
   }
}

