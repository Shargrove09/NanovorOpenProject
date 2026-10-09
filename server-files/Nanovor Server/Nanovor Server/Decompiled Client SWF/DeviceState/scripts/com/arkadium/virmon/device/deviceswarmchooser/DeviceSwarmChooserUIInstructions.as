package com.arkadium.virmon.device.deviceswarmchooser
{
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.device.ui.spinner.DeviceSpinner;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.geom.Point;
   
   public class DeviceSwarmChooserUIInstructions extends DeviceUIInstructionsBase implements IDeviceSwarmChooserUIInstructions
   {
      
      private static const SPINNER_POSITION_CENTER:Point = new Point(512,384);
      
      private var _spinner:DeviceSpinner;
      
      public function DeviceSwarmChooserUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceSwarmChooserUIInstructions>>\t" + param1);
      }
      
      override public function unsetUI() : void
      {
         _deviceUIController.getDeviceContents().clearNanovors();
         unsetUIFinished();
      }
      
      override public function setUI() : void
      {
         _deviceUIController.getDeviceContents().hide();
         _spinner = _deviceUIController.getSpinner();
         _spinner.clearCenterObject();
         _spinner.close(setUIFinished);
         _spinner.initForDeviceSwarmChooser();
      }
   }
}

