package com.arkadium.virmon.device
{
   public interface IDeviceConnectionDetector
   {
      
      function startDeviceCheck() : void;
      
      function removeDeviceConnectionHandler(param1:IDeviceConnectionHandler) : void;
      
      function addDeviceConnectionHandler(param1:IDeviceConnectionHandler) : void;
      
      function get driveLetter() : String;
      
      function stopDeviceCheck() : void;
   }
}

