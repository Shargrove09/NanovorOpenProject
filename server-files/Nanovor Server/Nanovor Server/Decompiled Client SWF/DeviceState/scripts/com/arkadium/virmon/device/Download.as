package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.HTTPChainLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.IHTTPChainLoadeeConsumer;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class Download extends EventDispatcher implements IDownload, IChainLoaderConsumer, IHTTPChainLoadeeConsumer
   {
      
      private var _driveLetter:String;
      
      private var _deviceNanovorDownloadHandler:IDeviceNanovorDownloadHandler;
      
      private var _requiredFiles:Array;
      
      private var _firmwareLoadProgressUpdater:ILoadProgressUpdater;
      
      private var _fileOperator:IFileOperator;
      
      private var deviceSoundsFileLocation:String;
      
      private var myHTTP:*;
      
      private var _stateManager:IStateManager;
      
      private var deviceAnimationFileLocation:String;
      
      private var _deviceID:String;
      
      private var _downloader:IDownloader;
      
      private var sfsSoundsFileLocation:String;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _requiredFileIndex:uint;
      
      private var sfsAnimationFileLocation:String;
      
      private var _sSFSUrl:String;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      public function Download(param1:String, param2:IDownloader, param3:IFileOperator, param4:IStateManager, param5:IServiceRequestBrokerManager)
      {
         super();
         _driveLetter = param1;
         _sSFSUrl = param5.staticFileServiceURL + "/";
         _downloader = param2;
         _fileOperator = param3;
         _stateManager = param4;
         reset();
      }
      
      public function destroy() : void
      {
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      public function handleHTTPProgress(param1:int, param2:int) : void
      {
         if(null != _loadProgressUpdater)
         {
            _loadProgressUpdater.updateCurrentItemProgress(0.99 * (_requiredFileIndex + param1 / param2) / _requiredFiles.length);
         }
      }
      
      public function handleHTTPComplete(param1:String) : void
      {
         ++_requiredFileIndex;
      }
      
      private function handleGetDeviceManifestBinarySuccess(param1:Event) : void
      {
         log("handleGetDeviceManifestBinarySuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleGetDeviceManifestBinaryFailure);
         var _loc3_:DeviceEvent = new DeviceEvent(DeviceEvent.DEVICE_MANIFEST_RECEIVED);
         _loc3_.data = param1.target.data;
         dispatchEvent(_loc3_);
      }
      
      private function handleGetDeviceManifestBinaryFailure(param1:IOErrorEvent) : void
      {
         log("handleGetDeviceManifestBinaryFailure():\n" + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleGetDeviceManifestBinarySuccess);
      }
      
      public function handleHTTPError() : void
      {
         log("handleHTTPError()");
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Transfer Error","File transfer was interrupted.\nPlease try again later.",0,handleTransferErrorConfirmed,handleTransferErrorConfirmed);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<Download>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _deviceManagerCommunicator.getDeviceManifestBinary(_deviceID,handleGetDeviceManifestBinarySuccess,handleGetDeviceManifestBinaryFailure);
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      private function reset() : void
      {
         log("reset(): " + new Error("RESET").getStackTrace());
         _requiredFileIndex = 0;
         _requiredFiles = new Array();
         _deviceNanovorDownloadHandler = null;
      }
      
      private function downloadError() : void
      {
         log("Error downloading file");
         handleHTTPError();
      }
      
      public function downloadRequiredFiles(param1:Array, param2:IDeviceManagerCommunicator, param3:String, param4:ILoadProgressUpdater) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         log("downloadRequiredFiles()");
         reset();
         _requiredFiles = param1;
         _deviceManagerCommunicator = param2;
         _deviceID = param3;
         _loadProgressUpdater = param4;
         _loadProgressUpdater.updateCurrentItemProgress(0);
         var _loc5_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc6_ in _requiredFiles)
         {
            _loc7_ = _driveLetter + _loc6_.replace(/\//g,"\\");
            _loc8_ = int(_loc7_.indexOf("\\"));
            while(_loc8_ != -1)
            {
               _loc9_ = _loc7_.substring(0,_loc8_);
               _fileOperator.makeFolder(_loc9_);
               _loc8_ = int(_loc7_.indexOf("\\",_loc8_ + 1));
            }
            _loc5_.add(new HTTPChainLoadee(_sSFSUrl + "device/" + _loc6_,_loc7_,_downloader,IHTTPChainLoadeeConsumer(this)));
         }
         _chainLoader = new ChainLoader(_loc5_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
   }
}

