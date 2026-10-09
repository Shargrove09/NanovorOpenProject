package com.arkadium.virmon.shared.utils.substate
{
   public interface ISubStateChanger
   {
      
      function onSubStateChange(param1:String) : void;
      
      function removeSubStateChangerConsumer(param1:ISubStateChangerConsumer) : void;
      
      function addSubStateChangerConsumer(param1:ISubStateChangerConsumer) : void;
   }
}

