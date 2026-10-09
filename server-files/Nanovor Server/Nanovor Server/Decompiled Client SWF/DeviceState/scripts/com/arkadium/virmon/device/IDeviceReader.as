package com.arkadium.virmon.device
{
   public interface IDeviceReader
   {
      
      function resetDeviceNanovor(param1:IDeviceNanovorReceiver) : void;
      
      function resetDeviceMiniGames(param1:IDeviceMiniGamesReceiver) : void;
   }
}

