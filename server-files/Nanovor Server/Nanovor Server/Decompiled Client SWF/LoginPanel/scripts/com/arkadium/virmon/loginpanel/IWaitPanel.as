package com.arkadium.virmon.loginpanel
{
   public interface IWaitPanel
   {
      
      function handleStatusMessage(param1:String) : void;
      
      function handleUpdateProgress(param1:Number, param2:Number) : void;
   }
}

