package com.arkadium.virmon.device
{
   public interface IDeviceConnectionHandler
   {
      
      function handleDeviceDisconnected() : void;
      
      function handleDeviceConnected(param1:String) : void;
   }
}

