package com.arkadium.virmon.device
{
   public interface IDeviceNanovorReceiver
   {
      
      function handleDeviceNanovorReceived(param1:Array) : void;
      
      function getDeviceNanovorList() : Array;
   }
}

