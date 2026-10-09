package com.arkadium.virmon.wrapper
{
   public interface IDialogManager
   {
      
      function get isActive() : Boolean;
      
      function clearQueue(param1:Boolean = true) : void;
   }
}

