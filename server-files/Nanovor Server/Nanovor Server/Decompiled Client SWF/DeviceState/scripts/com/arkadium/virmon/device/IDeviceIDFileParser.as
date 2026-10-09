package com.arkadium.virmon.device
{
   import com.arkadium.virmon.device.devicedata.DeviceData;
   import flash.utils.ByteArray;
   
   public interface IDeviceIDFileParser
   {
      
      function parseDeviceIDFile(param1:ByteArray, param2:IAssociatedDevices) : DeviceData;
   }
}

