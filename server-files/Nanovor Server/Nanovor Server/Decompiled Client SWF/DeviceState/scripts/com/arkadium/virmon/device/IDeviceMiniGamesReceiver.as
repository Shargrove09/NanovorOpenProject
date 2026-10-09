package com.arkadium.virmon.device
{
   public interface IDeviceMiniGamesReceiver
   {
      
      function getDeviceMiniGameList() : Array;
      
      function handleDeviceMiniGamesReceived(param1:Array) : void;
   }
}

