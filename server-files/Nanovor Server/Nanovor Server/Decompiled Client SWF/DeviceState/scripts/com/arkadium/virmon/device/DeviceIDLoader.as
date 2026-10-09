package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class DeviceIDLoader implements IDeviceIDLoader
   {
      
      public static const DEVICE_FILE:String = "deviceid.bbb";
      
      private var _driveLetter:String;
      
      private var _deviceIDFileByteArray:ByteArray;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceIDLoader(param1:String, param2:IFileOperator)
      {
         super();
         _driveLetter = param1;
         _fileOperator = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceIDLoader: " + param1);
      }
      
      public function loadDeviceIDFile(param1:ByteArray, param2:Function, param3:Function) : void
      {
         var loader:URLLoader;
         var deviceFilePath:String;
         var request:URLRequest;
         var deviceIDFileByteArray:ByteArray = param1;
         var successHandler:Function = param2;
         var errorHandler:Function = param3;
         if(null != deviceIDFileByteArray)
         {
            successHandler(null);
            return;
         }
         deviceFilePath = _driveLetter + DEVICE_FILE;
         log("loadDeviceIDFile(): deviceFilePath: " + deviceFilePath);
         if(false == _fileOperator.doesFileExist(deviceFilePath))
         {
            logError("DeviceID file does not exist.");
            errorHandler(null);
            return;
         }
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,successHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         request = new URLRequest(deviceFilePath);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
            logError("error loading devicefile");
            errorHandler(null);
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceIDLoader: " + param1);
      }
   }
}

