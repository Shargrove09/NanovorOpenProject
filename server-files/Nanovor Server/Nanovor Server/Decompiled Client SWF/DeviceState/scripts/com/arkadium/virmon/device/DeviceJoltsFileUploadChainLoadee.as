package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class DeviceJoltsFileUploadChainLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "deviceJoltsRetrieverChainLoadee";
      
      private var _joltsFileName:String;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _fileOperator:IFileOperator;
      
      private var _joltsFile:ByteArray;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _stateManager:IStateManager;
      
      private var _hash:String;
      
      public function DeviceJoltsFileUploadChainLoadee(param1:IFileOperator, param2:IStateManager, param3:String, param4:IDeviceManager, param5:IDeviceManagerCommunicator, param6:ILoadProgressUpdater, param7:String)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \'fileOperator\' cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \'stateManager\' cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \'joltsFileName\' cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \'deviceManager\' cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \'deviceManagerCommunicator\' cannot be null.");
         }
         if(null == param6)
         {
            throw new Error("Parameter \'loadProgressUpdater\' cannot be null.");
         }
         _fileOperator = param1;
         _stateManager = param2;
         _joltsFileName = param3;
         _deviceManager = param4;
         _deviceManagerCommunicator = param5;
         _loadProgressUpdater = param6;
         _hash = param7;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceJoltsFileUploadChainLoadee>>\t" + param1);
      }
      
      private function loadJoltsFileSuccess(param1:Event) : void
      {
         removeJoltsEventListeners(param1);
         _joltsFile = ByteArray(param1.target.data);
         uploadJoltsFile();
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      public function get name() : String
      {
         return NAME + _hash;
      }
      
      private function loadJoltsFileError(param1:Event) : void
      {
         removeJoltsEventListeners(param1);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function handleUploadJoltsSuccess(param1:Event) : void
      {
         var e:Event = param1;
         removeJoltsUploadEventListeners(e);
         _fileOperator.deleteFile(_joltsFileName,function():void
         {
            log("handleUploadJoltsSuccess(): jolts file deleted.");
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete(_joltsFile);
         });
      }
      
      private function handleUploadJoltsFailure(param1:IOErrorEvent) : void
      {
         log("handleUploadJoltsFailure(): " + param1.text);
         removeJoltsUploadEventListeners(param1);
         _loadProgressUpdater.handleItemCompleted();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function removeJoltsEventListeners(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,loadJoltsFileSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,loadJoltsFileError);
      }
      
      public function load() : void
      {
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,loadJoltsFileSuccess);
         loader.addEventListener(IOErrorEvent.IO_ERROR,loadJoltsFileError);
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         try
         {
            log("loading jolts file: " + _joltsFileName);
            loader.load(new URLRequest(_joltsFileName));
         }
         catch(error:Error)
         {
            _chainLoader.handleChainLoadeeError();
         }
      }
      
      private function uploadJoltsFile() : void
      {
         _deviceManagerCommunicator.uploadJolts(_deviceManager.deviceID,_joltsFile,handleUploadJoltsSuccess,handleUploadJoltsFailure);
      }
      
      private function removeJoltsUploadEventListeners(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,handleUploadJoltsSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,handleUploadJoltsFailure);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

