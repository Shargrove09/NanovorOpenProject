package com.arkadium.virmon.device.home
{
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceInitializeHomePanelUIInstructions extends DeviceUIInstructionsBase
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = false;
      
      public function DeviceInitializeHomePanelUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
      }
      
      private function spinnerOpened() : void
      {
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         setUIFinished();
      }
      
      override public function setUI() : void
      {
         log("setUI()");
         _deviceUIController.getSpinner().open(spinnerOpened);
         _deviceUIController.getDeviceContents().show();
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<DeviceInitializeHomePanelUIInstructions>>\t" + param1);
         }
      }
      
      override public function unsetUI() : void
      {
         log("unsetUI()");
         unsetUIFinished();
      }
   }
}

