package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.ByteArray;
   
   public class DeviceFirmwareChainLoadee implements IChainLoadee, IDownloaderConsumer
   {
      
      private static const FIRMWARE_FILE_NAME:String = "frm.bin";
      
      private static const FIRMWARE_BBB_FILE_NAME:String = "FRM.BBB";
      
      private static const SFS_FIRMWARE_LOCATION:String = "device/firmware/";
      
      private static const FIRMWARE_TEMP_FOLDER:String = "devicetemp\\";
      
      private static const SIGNATURE_TEMP_FILE:String = FIRMWARE_TEMP_FOLDER + "signature";
      
      private static const FIRMWARE_TEMP_FILE:String = FIRMWARE_TEMP_FOLDER + FIRMWARE_FILE_NAME;
      
      private var _firmwareLoader:URLLoader;
      
      private var _firmwareSignature:ByteArray;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      private var _download:IDownload;
      
      private var _msgBox:CommonDialogBox;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _stateManager:IStateManager;
      
      private var _failCatch:IDeviceWriteFailureConsumer;
      
      public function DeviceFirmwareChainLoadee(param1:IFileOperator, param2:IStateManager, param3:IDeviceManager, param4:IDeviceManagerCommunicator, param5:IDownload, param6:IServiceRequestBrokerManager, param7:ILoadProgressUpdater, param8:IDeviceWriteFailureConsumer)
      {
         super();
         _fileOperator = param1;
         _stateManager = param2;
         _deviceManager = param3;
         _deviceManagerCommunicator = param4;
         _download = param5;
         _serviceRequestBrokerManager = param6;
         _loadProgressUpdater = param7;
         _failCatch = param8;
         log("current firmware version: " + param3.firmwareVersion);
      }
      
      private function handleError(param1:String) : void
      {
         logError("handleError(): " + param1);
         if(Boolean(_msgBox))
         {
            _msgBox.kill();
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Transfer Error","File transfer was interrupted.\nPlease try again later.",0,handleTransferErrorConfirmed,handleTransferErrorConfirmed);
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         _loadProgressUpdater.handleItemCompleted();
         _fileOperator.writeByteArray(_firmwareSignature,SIGNATURE_TEMP_FILE);
         _fileOperator.concatenateFiles(SIGNATURE_TEMP_FILE,FIRMWARE_TEMP_FILE,_deviceManager.driveLetter + FIRMWARE_BBB_FILE_NAME,true,onBBBFileConcatComplete);
      }
      
      private function onBBBFileConcatComplete() : void
      {
         _fileOperator.deleteFolder("devicetemp",handleDeleteFirmware);
      }
      
      private function loadFirmwareSignature() : void
      {
         log("loadFirmwareSignature()");
         _loadProgressUpdater.handleItemCompleted();
         _deviceManagerCommunicator.getFirmwareSignature(_deviceManager.deviceID,getFirmwareSignatureSuccess,getFirmwareSignatureFailure);
      }
      
      private function getFirmwareSignatureFailure(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,getFirmwareSignatureSuccess);
         handleError("getFirmwareSignatureFailure(): " + param1.text);
      }
      
      public function get name() : String
      {
         return "DeviceFirmwareChainLoadee";
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      private function handleGetDeviceManifestXmlFailure(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleGetDeviceManifestXmlSuccess);
         handleError("handleGetDeviceManifestXmlFailure(): " + param1.text);
      }
      
      private function getFirmwareSignatureSuccess(param1:Event) : void
      {
         log("getFirmwareSignatureSuccess()");
         _loadProgressUpdater.handleItemCompleted();
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,getFirmwareSignatureFailure);
         _firmwareSignature = ByteArray(param1.target.data);
         loadFirmwareFile();
      }
      
      private function handleDeleteFirmware() : void
      {
         log("handleDeleteFirmware()");
         if(!_fileOperator.doesFileExist(_deviceManager.driveLetter + FIRMWARE_BBB_FILE_NAME))
         {
            log(FIRMWARE_BBB_FILE_NAME + " is missing. Aborting");
            _msgBox = _failCatch.onDeviceWriteFailure();
            return;
         }
         _loadProgressUpdater.handleItemCompleted();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function handleDownloadError(param1:String) : void
      {
         handleError("handleDownloadError(): " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceFirmwareChainLoadee: " + param1);
      }
      
      private function loadFirmwareFile() : void
      {
         _fileOperator.deleteFolder(FIRMWARE_TEMP_FOLDER.replace(/[\/\\]$/,""));
         _fileOperator.makeFolder(FIRMWARE_TEMP_FOLDER.replace(/[\/\\]$/,""));
         var _loc1_:String = _serviceRequestBrokerManager.staticFileServiceURL + "/" + SFS_FIRMWARE_LOCATION + FIRMWARE_FILE_NAME;
         _deviceManager.downloader.downloadFile(IDownloaderConsumer(this),_loc1_,FIRMWARE_TEMP_FILE);
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
         _loadProgressUpdater.updateCurrentItemProgress(0.95 * (param1 / param2));
      }
      
      public function load() : void
      {
         _loadProgressUpdater.addStatusTextLine("DOWNLOADING FIRMWARE...0%");
         _deviceManagerCommunicator.getDeviceManifestXml(handleGetDeviceManifestXmlSuccess,handleGetDeviceManifestXmlFailure);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceFirmwareChainLoadee: " + param1);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function handleGetDeviceManifestXmlSuccess(param1:Event) : void
      {
         log("handleGetDeviceManifestXmlSuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleGetDeviceManifestXmlFailure);
         var _loc3_:XML = XML(param1.target.data);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         var _loc4_:int = int(_loc3_.child("firmware-version").toString());
         if(_loc4_ > _deviceManager.firmwareVersion)
         {
            log("newestFirmware > _deviceManager.firmwareVersion");
            _deviceManager.deleteAllRootFilesExceptJolts();
            _loadProgressUpdater = new LoadProgressUpdaterDecorator(4,_loadProgressUpdater);
            loadFirmwareSignature();
         }
         else
         {
            log("Already latest firmware: newest: " + _loc4_ + ", current: " + _deviceManager.firmwareVersion);
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
         }
      }
   }
}

