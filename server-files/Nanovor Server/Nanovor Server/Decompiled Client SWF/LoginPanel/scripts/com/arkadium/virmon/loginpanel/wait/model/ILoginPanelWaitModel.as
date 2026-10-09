package com.arkadium.virmon.loginpanel.wait.model
{
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitProgressUpdateHandler;
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitStatusUpdateHandler;
   
   public interface ILoginPanelWaitModel
   {
      
      function addWaitStatusUpdateHandler(param1:IWaitStatusUpdateHandler) : void;
      
      function updateStatusMessage(param1:String) : void;
      
      function updateProgress(param1:Number, param2:Number) : void;
      
      function addWaitProgressUpdateHandler(param1:IWaitProgressUpdateHandler) : void;
   }
}

