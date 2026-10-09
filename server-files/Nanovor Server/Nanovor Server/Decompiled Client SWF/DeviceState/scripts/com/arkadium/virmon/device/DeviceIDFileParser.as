package com.arkadium.virmon.device
{
   import com.arkadium.virmon.device.devicedata.DeviceData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class DeviceIDFileParser implements IDeviceIDFileParser
   {
      
      public static const DEVICE_ID_LOC:int = 30;
      
      public static const DEVICE_ID_LENGTH:int = 32;
      
      public static const FIRMWARE_VERSION_LOC:int = 22;
      
      public static const FIRMWARE_VERSION_LENGTH:int = 4;
      
      public function DeviceIDFileParser()
      {
         super();
      }
      
      public function parseDeviceIDFile(param1:ByteArray, param2:IAssociatedDevices) : DeviceData
      {
         log("parseDeviceIDFile()");
         var _loc3_:String = readMultiByteFromByteArray(param1,DEVICE_ID_LOC,DEVICE_ID_LENGTH);
         var _loc4_:int = param2.isDeviceAssociated(_loc3_) ? readIntFromByteArray(param1,FIRMWARE_VERSION_LOC,FIRMWARE_VERSION_LENGTH) : -1;
         return new DeviceData(_loc3_,_loc4_);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceIDFileParser>> " + param1);
      }
      
      private function getSubByteArray(param1:ByteArray, param2:int, param3:int) : ByteArray
      {
         var _loc4_:ByteArray = new ByteArray();
         param1.position = param2;
         param1.readBytes(_loc4_,0,param3);
         _loc4_.position = 0;
         return _loc4_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>DeviceIDFileParser<< " + param1);
      }
      
      private function readMultiByteFromByteArray(param1:ByteArray, param2:int, param3:int) : String
      {
         var _loc4_:ByteArray = getSubByteArray(param1,param2,param3);
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc4_.length)
         {
            if(_loc4_[_loc8_] != 0)
            {
               _loc5_[_loc7_] = _loc4_[_loc8_];
               _loc7_++;
            }
            _loc8_++;
         }
         _loc5_.position = 0;
         return String(_loc5_.readMultiByte(_loc5_.length,"us-ascii"));
      }
      
      private function readIntFromByteArray(param1:ByteArray, param2:int, param3:int) : int
      {
         var _loc4_:ByteArray = getSubByteArray(param1,param2,param3);
         _loc4_.endian = Endian.LITTLE_ENDIAN;
         return _loc4_.readInt();
      }
   }
}

