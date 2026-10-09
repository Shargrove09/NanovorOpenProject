package com.arkadium.virmon.device
{
   public class NullDeviceNanovorRetriever implements IDeviceNanovorRetriever
   {
      
      public function NullDeviceNanovorRetriever()
      {
         super();
      }
      
      public function getDeviceNanovor(param1:IDeviceNanovorReceiver, param2:Array = null, param3:int = 1) : void
      {
      }
   }
}

