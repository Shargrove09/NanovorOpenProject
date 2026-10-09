package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.ByteArray;
   
   public class DeviceNanovorBinaryChainLoadee implements IChainLoadee, IDeviceNanovorDownloadHandler
   {
      
      private static const DEVICE_INFO_FILE:String = "vinfo.bbb";
      
      private var _nanovorAssetID:String;
      
      private var _destinationFolderName:String;
      
      private var _fileOperator:IFileOperator;
      
      private var _download:IDownload;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      public function DeviceNanovorBinaryChainLoadee(param1:IDeviceManager, param2:IFileOperator, param3:String, param4:String)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"deviceManager\" cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \"fileOperator\" cannot be null.");
         }
         if("" == param3)
         {
            throw new Error("Parameter \"nanovorAssetID\" cannot be empty.");
         }
         if("" == param4)
         {
            throw new Error("Parameter \"destinationFolderName\" cannot be empty.");
         }
         _deviceManager = param1;
         _fileOperator = param2;
         _deviceManagerCommunicator = param1.communicator;
         _download = _deviceManager.download;
         _destinationFolderName = param4;
         _nanovorAssetID = param3;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceNanovorBinaryChainLoadee>> " + param1);
      }
      
      public function handleDeviceNanovorDownload() : void
      {
         log("handleDeviceNanovorDownload(): assetID: " + _nanovorAssetID);
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function get name() : String
      {
         return "DeviceNanovorBinaryChainLoadee" + _nanovorAssetID;
      }
      
      private function handleDeviceNanovorLoadSuccess(param1:Event) : void
      {
         log("handleDeviceNanovorLoadSuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleDeviceNanovorLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceNanovorLoadFailure);
         downloadNanovorAsset(ByteArray(param1.target.data));
      }
      
      private function handleDeviceNanovorLoadFailure(param1:IOErrorEvent) : void
      {
         logError("handleDeviceNanovorLoadFailure(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleDeviceNanovorLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceNanovorLoadFailure);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<DeviceNanovorBinaryChainLoadee>> " + param1);
      }
      
      public function load() : void
      {
         log("load(): _deviceManagerCommunicator is null?: " + (null == _deviceManagerCommunicator));
         _deviceManagerCommunicator.getAssetBinary(_deviceManager.deviceID,_nanovorAssetID,handleDeviceNanovorLoadSuccess,handleDeviceNanovorLoadFailure);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function downloadNanovorAsset(param1:ByteArray) : void
      {
         _fileOperator.makeFolder(_destinationFolderName);
         _fileOperator.writeByteArray(param1,_destinationFolderName + "/" + DEVICE_INFO_FILE);
         _chainLoader.handleChainLoadeeComplete();
      }
   }
}

