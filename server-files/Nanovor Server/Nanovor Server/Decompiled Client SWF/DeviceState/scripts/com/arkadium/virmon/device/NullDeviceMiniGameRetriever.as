package com.arkadium.virmon.device
{
   public class NullDeviceMiniGameRetriever implements IDeviceMiniGameRetriever
   {
      
      public function NullDeviceMiniGameRetriever()
      {
         super();
      }
      
      public function getDeviceMiniGames(param1:IDeviceMiniGamesReceiver, param2:Array = null, param3:int = 1) : void
      {
      }
   }
}

