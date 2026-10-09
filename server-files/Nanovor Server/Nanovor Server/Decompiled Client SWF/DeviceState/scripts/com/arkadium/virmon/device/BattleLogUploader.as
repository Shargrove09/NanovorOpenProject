package com.arkadium.virmon.device
{
   import flash.utils.ByteArray;
   
   public class BattleLogUploader implements ILogUploader
   {
      
      private var _deviceID:String;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      public function BattleLogUploader(param1:IDeviceManagerCommunicator, param2:String)
      {
         super();
         _deviceManagerCommunicator = param1;
         _deviceID = param2;
      }
      
      public function uploadLog(param1:ByteArray, param2:Function, param3:Function) : void
      {
         _deviceManagerCommunicator.uploadBattleLog(_deviceID,param1,param2,param3);
      }
   }
}

