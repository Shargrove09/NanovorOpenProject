package com.arkadium.virmon.device.ui
{
   public class DeviceUIInstructionsBase implements IDeviceUIInstructions
   {
      
      protected var _deviceUIController:IDeviceUIController;
      
      protected var _setUIConsumer:IDeviceUIInstructionsConsumer;
      
      public function DeviceUIInstructionsBase(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super();
         _setUIConsumer = param2;
         _deviceUIController = param1;
      }
      
      public function unsetUI() : void
      {
         unsetUIFinished();
      }
      
      public function setUI() : void
      {
         setUIFinished();
      }
      
      protected function setUIFinished() : void
      {
         if(null != _setUIConsumer)
         {
            _setUIConsumer.setUIFinished();
         }
      }
      
      public function destroy() : void
      {
         _setUIConsumer = null;
         _deviceUIController = null;
      }
      
      protected function unsetUIFinished() : void
      {
         _deviceUIController.finishedUIUnset();
      }
   }
}

