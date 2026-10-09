package com.arkadium.virmon.wrapper
{
   public interface IApplicationExiter
   {
      
      function removeApplicationExitHandler(param1:IApplicationExitHandler) : void;
      
      function exitApplication(param1:Boolean = false) : void;
      
      function addApplicationExitHandler(param1:IApplicationExitHandler) : void;
   }
}

