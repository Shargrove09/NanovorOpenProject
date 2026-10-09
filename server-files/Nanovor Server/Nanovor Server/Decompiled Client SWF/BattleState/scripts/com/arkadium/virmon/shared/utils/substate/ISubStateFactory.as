package com.arkadium.virmon.shared.utils.substate
{
   public interface ISubStateFactory
   {
      
      function createSubState(param1:String, param2:Object = null) : ISubState;
   }
}

