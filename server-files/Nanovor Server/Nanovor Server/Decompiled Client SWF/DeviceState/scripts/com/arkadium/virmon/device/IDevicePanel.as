package com.arkadium.virmon.device
{
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   
   public interface IDevicePanel
   {
      
      function init(param1:IDevicePanelController, param2:IDeviceUIController) : void;
      
      function destroy() : void;
      
      function setPanel() : void;
      
      function unsetPanel() : void;
   }
}

