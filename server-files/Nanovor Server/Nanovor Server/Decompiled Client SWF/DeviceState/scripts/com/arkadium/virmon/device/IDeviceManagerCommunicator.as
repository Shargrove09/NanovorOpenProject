package com.arkadium.virmon.device
{
   import flash.utils.ByteArray;
   
   public interface IDeviceManagerCommunicator
   {
      
      function getAssociatedDevices(param1:String, param2:Function, param3:Function) : void;
      
      function getDevicePlayerInfo(param1:String, param2:String, param3:Function, param4:Function) : void;
      
      function getDeviceManifestXml(param1:Function, param2:Function) : void;
      
      function uploadJolts(param1:String, param2:ByteArray, param3:Function, param4:Function) : void;
      
      function getNewPrivKey(param1:String, param2:Function, param3:Function) : void;
      
      function getFirmwareSignature(param1:String, param2:Function, param3:Function) : void;
      
      function uploadSenseiLog(param1:String, param2:ByteArray, param3:Function, param4:Function) : void;
      
      function uploadBattleLog(param1:String, param2:ByteArray, param3:Function, param4:Function) : void;
      
      function associateDevice(param1:ByteArray, param2:Function = null, param3:Function = null) : void;
      
      function getAssetBinary(param1:String, param2:String, param3:Function, param4:Function) : void;
      
      function getDeviceManifestBinary(param1:String, param2:Function, param3:Function) : void;
   }
}

