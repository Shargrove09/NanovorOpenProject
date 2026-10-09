package com.arkadium.virmon.device
{
   import flash.utils.ByteArray;
   
   public interface ILogUploader
   {
      
      function uploadLog(param1:ByteArray, param2:Function, param3:Function) : void;
   }
}

