package com.arkadium.virmon.device
{
   public interface IDevicePanelController
   {
      
      function nextPanel(param1:String, param2:Object = null) : void;
      
      function finishedUnsetPanel() : void;
   }
}

