package com.arkadium.virmon.device.devicedata
{
   public class DeviceData
   {
      
      private var _deviceID:String;
      
      private var _firmwareVersion:int;
      
      public function DeviceData(param1:String, param2:int)
      {
         super();
         _deviceID = param1;
         _firmwareVersion = param2;
      }
      
      public function get deviceID() : String
      {
         return _deviceID;
      }
      
      public function get firmwareVersion() : int
      {
         return _firmwareVersion;
      }
   }
}

