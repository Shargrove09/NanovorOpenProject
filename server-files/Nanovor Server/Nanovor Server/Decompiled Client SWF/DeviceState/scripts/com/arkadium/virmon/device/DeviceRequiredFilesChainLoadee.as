package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class DeviceRequiredFilesChainLoadee implements IChainLoadee
   {
      
      private static const DEVICE_MANIFEST:String = "manifest.bbb";
      
      private var _failCatch:IDeviceWriteFailureConsumer;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _requiredFiles:Array;
      
      private var _fileOperator:IFileOperator;
      
      private var _download:IDownload;
      
      private var _msgBox:CommonDialogBox;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _stateManager:IStateManager;
      
      public function DeviceRequiredFilesChainLoadee(param1:IFileOperator, param2:IStateManager, param3:IDeviceManager, param4:IDownload, param5:IDeviceManagerCommunicator, param6:ILoadProgressUpdater, param7:IDeviceWriteFailureConsumer)
      {
         super();
         _fileOperator = param1;
         _stateManager = param2;
         _deviceManager = param3;
         _download = param4;
         _deviceManagerCommunicator = param5;
         _loadProgressUpdater = param6;
         _failCatch = param7;
         _download.addEventListener(DeviceEvent.DEVICE_MANIFEST_RECEIVED,handleDeviceManifestReceived);
      }
      
      private function handleError(param1:IOErrorEvent) : void
      {
         log("handleError(): " + param1.text);
         if(Boolean(_msgBox))
         {
            _msgBox.kill();
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Transfer Error","File transfer was interrupted.\nPlease try again later.",0,handleTransferErrorConfirmed,handleTransferErrorConfirmed);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function removeDeviceManifestXMLEventHandlers(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,handleGetDeviceManifestXmlSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,handleGetDeviceManifestXmlFailure);
      }
      
      private function checkRequiredFilesExist(param1:Array) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            if(false == _fileOperator.doesFileExist(_deviceManager.driveLetter + _loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      private function isSkippableFile(param1:String) : Boolean
      {
         if(param1.search("/") != -1)
         {
            return true;
         }
         if(param1.toLowerCase().search(/tryme[0-9]+\.bin/) != -1)
         {
            return true;
         }
         if(param1.toLowerCase().search(/sensei/) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function handleGetDeviceManifestXmlFailure(param1:IOErrorEvent) : void
      {
         log("handleGetDeviceManifestXmlFailure()");
         removeDeviceManifestXMLEventHandlers(param1);
         handleError(param1);
      }
      
      private function parseRequiredFilesXML(param1:XML) : Array
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc2_:Array = new Array();
         param1 = Utils.StripXmlNamespace(param1);
         var _loc3_:XMLList = param1.elements("file");
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = _loc5_.elements("name");
            _loc4_ = _loc4_.replace(/\\/g,"/");
            if(false == isSkippableFile(_loc4_))
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function get name() : String
      {
         return "DeviceRequiredFilesChainLoadee";
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceRequiredFilesChainLoadee>>\t" + param1);
      }
      
      public function load() : void
      {
         log("load()");
         _loadProgressUpdater.addStatusTextLine("DOWNLOADING REQUIRED FILES...0%");
         _deviceManagerCommunicator.getDeviceManifestXml(handleGetDeviceManifestXmlSuccess,handleGetDeviceManifestXmlFailure);
      }
      
      private function handleGetDeviceManifestXmlSuccess(param1:Event) : void
      {
         log("handleGetDeviceManifestXmlSuccess()");
         removeDeviceManifestXMLEventHandlers(param1);
         _requiredFiles = parseRequiredFilesXML(XML(param1.target.data));
         if(!checkRequiredFilesExist(_requiredFiles))
         {
            log("handleGetDeviceManifestXmlSuccess() - Nanoscope does not have all the required files");
            downloadRequiredFiles(_requiredFiles);
         }
         else
         {
            log("handleGetDeviceManifestXmlSuccess() - Nanoscope has  all the required files");
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
         }
      }
      
      private function handleDeviceManifestReceived(param1:DeviceEvent) : void
      {
         log("handleDeviceManifestReceived()");
         _download.removeEventListener(DeviceEvent.DEVICE_MANIFEST_RECEIVED,handleDeviceManifestReceived);
         if(!checkRequiredFilesExist(_requiredFiles))
         {
            log("handleDeviceManifestReceived() - Nanoscope does not have all the required files");
            _msgBox = _failCatch.onDeviceWriteFailure();
            return;
         }
         var _loc2_:ByteArray = ByteArray(param1.data);
         _fileOperator.writeByteArray(_loc2_,_deviceManager.driveLetter + DEVICE_MANIFEST);
         if(!_fileOperator.doesFileExist(_deviceManager.driveLetter + DEVICE_MANIFEST))
         {
            log("handleDeviceManifestReceived() - Failed to write the device manifest file!");
            _msgBox = _failCatch.onDeviceWriteFailure();
            return;
         }
         _loadProgressUpdater.handleItemCompleted();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function downloadRequiredFiles(param1:Array) : void
      {
         log("downloadRequiredFiles()");
         _download.downloadRequiredFiles(param1,_deviceManagerCommunicator,_deviceManager.deviceID,_loadProgressUpdater);
      }
   }
}

