package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import flash.utils.Dictionary;
   
   public class ApplicationExiter implements IApplicationExiter
   {
      
      private var _mdmManager:IMDMManager;
      
      private var _handlers:Dictionary;
      
      public function ApplicationExiter(param1:IMDMManager)
      {
         super();
         _mdmManager = param1;
         _handlers = new Dictionary();
         _handlers[IApplicationExitHandler] = new Dictionary(true);
         _mdmManager.mdmApplication.enableExitHandler();
         _mdmManager.mdmApplication.onAppExit = exitApplication;
      }
      
      public function exitApplication(param1:Boolean = false) : void
      {
         var _loc3_:IApplicationExitHandler = null;
         if(param1)
         {
            _mdmManager.exitApplication();
            return;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in _handlers[IApplicationExitHandler])
         {
            _loc3_.handleApplicationExit();
            _loc2_ = true;
         }
         if(false == _loc2_)
         {
            _mdmManager.exitApplication();
         }
      }
      
      public function removeApplicationExitHandler(param1:IApplicationExitHandler) : void
      {
         delete _handlers[IApplicationExitHandler][param1];
      }
      
      public function addApplicationExitHandler(param1:IApplicationExitHandler) : void
      {
         _handlers[IApplicationExitHandler][param1] = param1;
      }
   }
}

