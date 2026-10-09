package com.arkadium.virmon.loginpanel.wait.model
{
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitProgressUpdateHandler;
   import com.arkadium.virmon.loginpanel.wait.model.handlers.IWaitStatusUpdateHandler;
   import flash.utils.Dictionary;
   
   public class LoginPanelWaitModel implements ILoginPanelWaitModel
   {
      
      private var _handlers:Dictionary;
      
      public function LoginPanelWaitModel()
      {
         super();
         this._handlers = new Dictionary();
         this._handlers[IWaitStatusUpdateHandler] = new Dictionary(true);
         this._handlers[IWaitProgressUpdateHandler] = new Dictionary(true);
      }
      
      public function updateProgress(param1:Number, param2:Number) : void
      {
         var _loc3_:IWaitProgressUpdateHandler = null;
         for each(_loc3_ in this._handlers[IWaitProgressUpdateHandler])
         {
            _loc3_.handleUpdateProgress(Math.min(param1,param2),param2);
         }
      }
      
      public function addWaitStatusUpdateHandler(param1:IWaitStatusUpdateHandler) : void
      {
         this._handlers[IWaitStatusUpdateHandler][param1] = param1;
      }
      
      public function updateStatusMessage(param1:String) : void
      {
         var _loc2_:IWaitStatusUpdateHandler = null;
         for each(_loc2_ in this._handlers[IWaitStatusUpdateHandler])
         {
            _loc2_.handleStatusUpdate(param1);
         }
      }
      
      public function addWaitProgressUpdateHandler(param1:IWaitProgressUpdateHandler) : void
      {
         this._handlers[IWaitProgressUpdateHandler][param1] = param1;
      }
   }
}

