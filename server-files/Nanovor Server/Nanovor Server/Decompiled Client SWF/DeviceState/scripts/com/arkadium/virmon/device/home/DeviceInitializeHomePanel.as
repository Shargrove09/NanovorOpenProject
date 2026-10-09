package com.arkadium.virmon.device.home
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.IDeviceNanovorReceiver;
   import com.arkadium.virmon.device.ui.DeviceContentNanovor;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceInitializeHomePanel extends DevicePanelBase implements IDeviceUIInstructionsConsumer
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = false;
      
      private var _uiInstructions:DeviceInitializeHomePanelUIInstructions;
      
      private var _deviceNanovorReceiver:IDeviceNanovorReceiver;
      
      public function DeviceInitializeHomePanel(param1:IDeviceNanovorReceiver)
      {
         super();
         log("DeviceInitializeHomePanel()");
         _deviceNanovorReceiver = param1;
      }
      
      override public function setPanel() : void
      {
         log("setPanel()");
         _uiInstructions = new DeviceInitializeHomePanelUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<DeviceInitializeHomePanel>>\t" + param1);
         }
      }
      
      public function setUIFinished() : void
      {
         log("setUIFinished()");
         showExistingDeviceNanovors();
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_HOME);
      }
      
      private function showExistingDeviceNanovors() : void
      {
         var _loc3_:INanovor = null;
         var _loc1_:Array = _deviceNanovorReceiver.getDeviceNanovorList();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as INanovor;
            _deviceUIController.getDeviceContents().addNanovor(_loc3_,DeviceContentNanovor.STATE_DEVICE);
            _loc2_++;
         }
         _deviceUIController.getDeviceContents().show();
      }
      
      override public function destroy() : void
      {
         _deviceUIController.getDeviceContents().clearNanovors();
         super.destroy();
         _uiInstructions.destroy();
      }
   }
}

