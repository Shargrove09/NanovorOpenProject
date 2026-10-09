package com.arkadium.virmon.device
{
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   
   public class DevicePanelBase implements IDevicePanel
   {
      
      protected var _deviceUIController:IDeviceUIController;
      
      protected var _devicePanelController:IDevicePanelController;
      
      public function DevicePanelBase()
      {
         super();
      }
      
      public function setPanel() : void
      {
      }
      
      protected function finishUnsetPanel() : void
      {
         _devicePanelController.finishedUnsetPanel();
      }
      
      public function init(param1:IDevicePanelController, param2:IDeviceUIController) : void
      {
         _devicePanelController = param1;
         _deviceUIController = param2;
      }
      
      public function destroy() : void
      {
         _devicePanelController = null;
         _deviceUIController = null;
      }
      
      public function unsetPanel() : void
      {
         finishUnsetPanel();
      }
   }
}

