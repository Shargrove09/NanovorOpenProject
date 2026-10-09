package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.device.devicedata.DeviceData;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.ByteArray;
   
   public class DeviceManager implements IDeviceManager, IChainLoaderConsumer, IDeviceNanovorWriter, IDeviceMiniGameWriter, IDeviceNanovorReceiver, IDeviceMiniGamesReceiver, IAssociatedDevicesRefreshedHandler
   {
      
      private static const MAX_DEVICE_NANOVOR:int = 10;
      
      private var _deviceNanovorWriter:IDeviceNanovorWriter;
      
      private var _deviceIDLoader:IDeviceIDLoader;
      
      private var _deviceMiniGameWriter:IDeviceMiniGameWriter;
      
      private var _deviceReader:IDeviceReader;
      
      private var _deviceRecoverer:IDeviceRecoverer;
      
      private var _fileOperator:IFileOperator;
      
      private var _driveLetter:String;
      
      private var _deviceIDFileByteArray:ByteArray;
      
      private var _deviceIDFileParser:IDeviceIDFileParser;
      
      private var _deviceNanovorList:Array;
      
      private var _deviceAssociatorConsumer:IDeviceAssociatorConsumer;
      
      private var _deviceMiniGameList:Array;
      
      private var _deviceData:DeviceData;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _errorDialogBox:CommonDialogBox;
      
      private var _dataManager:IDataManager;
      
      private var _download:IDownload;
      
      private var _myChainLoader:IChainLoader;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _associatedDevices:IAssociatedDevices;
      
      public function DeviceManager(param1:INanovorFactory, param2:IDeviceConnectionDetector, param3:IServiceRequestBrokerManager, param4:IDataManager, param5:IDownloader, param6:IFileOperator, param7:IStateManager)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"nanovorFactory\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"serviceRequestBrokerManager\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"dataManager\" cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \"downloader\" cannot be null.");
         }
         if(null == param6)
         {
            throw new Error("Parameter \"fileOperator\" cannot be null.");
         }
         if(null == param7)
         {
            throw new Error("Parameter \"stateManager\" cannot be null.");
         }
         _dataManager = param4;
         _fileOperator = param6;
         _downloader = param5;
         _serviceRequestBrokerManager = param3;
         _driveLetter = param2.driveLetter;
         _deviceReader = new DeviceReader(param1,_fileOperator,param2,_driveLetter);
         _deviceNanovorList = new Array();
         _deviceMiniGameList = new Array();
         _download = new Download(_driveLetter,_downloader,_fileOperator,param7,_serviceRequestBrokerManager);
         _deviceManagerCommunicator = new DeviceManagerCommunicator(_serviceRequestBrokerManager as ILoginTokenProvider,_serviceRequestBrokerManager.bankURL,_serviceRequestBrokerManager.staticFileServiceURL);
         _associatedDevices = new AssociatedDevices(_serviceRequestBrokerManager.getAccountID(),_deviceManagerCommunicator);
         _deviceIDFileByteArray = null;
         _deviceRecoverer = new DeviceRecoverer(_driveLetter,_deviceManagerCommunicator,param7,_fileOperator,_serviceRequestBrokerManager,_downloader);
         _deviceIDLoader = new DeviceIDLoader(_driveLetter,_fileOperator);
         _deviceIDFileParser = new DeviceIDFileParser();
      }
      
      public function get deviceID() : String
      {
         return _deviceData.deviceID;
      }
      
      public function handleErrorLogFound() : void
      {
         log("handleErrorLogFound()");
         _deviceData = new DeviceData(_deviceData.deviceID,-1);
      }
      
      public function get download() : IDownload
      {
         return _download;
      }
      
      public function get name() : String
      {
         return "DeviceManager";
      }
      
      public function deleteAllRootFilesExceptJolts() : void
      {
         var _loc1_:String = null;
         log("deleteAllRootFilesExceptJolts()");
         for each(_loc1_ in _fileOperator.getFileList(_driveLetter,"*.*"))
         {
            if(-1 == _loc1_.toLowerCase().indexOf("jolts"))
            {
               log("deleteAllRootFilesExceptJolts(): deleting file: " + _driveLetter + _loc1_);
               _fileOperator.deleteFile(_driveLetter + _loc1_);
            }
         }
      }
      
      public function associateDevice(param1:IDeviceAssociatorConsumer) : void
      {
         log("associateDevice()");
         if(isDeviceAssociated())
         {
            log("associateDevice(): device already associated->deleting extraneous files...");
            deleteExtraneousFiles();
            return param1.handleDeviceAssociationSuccess();
         }
         _deviceAssociatorConsumer = param1;
         associateDeviceWithNewUser();
         deleteNanovorFolders();
      }
      
      public function getDeviceNanovorList() : Array
      {
         return _deviceNanovorList.slice();
      }
      
      public function getDeviceMiniGameList() : Array
      {
         return _deviceMiniGameList.slice();
      }
      
      public function get firmwareVersion() : int
      {
         return _deviceData.firmwareVersion;
      }
      
      public function writeDeviceNanovorList(param1:Array, param2:ILoadProgressMonitor, param3:Function) : void
      {
         _deviceNanovorList = param1;
         if(null == _deviceNanovorWriter)
         {
            _deviceNanovorWriter = new DeviceNanovorWriter(IDeviceManager(this),_fileOperator,_downloader,_serviceRequestBrokerManager);
         }
         _deviceNanovorWriter.writeDeviceNanovorList(param1,param2,param3);
      }
      
      public function handleDeviceMiniGamesReceived(param1:Array) : void
      {
         log("handleDeviceMiniGamesReceived()");
         _deviceMiniGameList = param1;
         _deviceReader.resetDeviceNanovor(IDeviceNanovorReceiver(this));
      }
      
      public function startDeviceRecovery(param1:String) : void
      {
         log("startDeviceRecovery(): code=" + param1);
         _deviceRecoverer.startDeviceRecovery(param1);
      }
      
      private function associateDeviceWithNewUser() : void
      {
         log("associateDeviceWithNewUser()");
         _deviceIDLoader.loadDeviceIDFile(_deviceIDFileByteArray,function(param1:Event):void
         {
            if(param1 != null)
            {
               param1.target.removeEventListener(param1.type,arguments.callee);
               param1.target.removeEventListener(Event.COMPLETE,associateDeviceWithNewUser);
               param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceFileError);
            }
            if(null == _deviceIDFileByteArray)
            {
               _deviceAssociatorConsumer.handleDeviceAssociationFailure();
               return;
            }
            _deviceManagerCommunicator.associateDevice(_deviceIDFileByteArray,handleDeviceAssociationComplete,handleDeviceAssociationError);
         },handleDeviceFileError);
      }
      
      public function handleDeviceNanovorReceived(param1:Array) : void
      {
         _deviceNanovorList = param1;
         log("handleDeviceNanovorReceived(): _deviceNanovorList.length: " + _deviceNanovorList.length);
      }
      
      private function getDeviceData(param1:Event) : void
      {
         if(param1 != null)
         {
            param1.target.removeEventListener(Event.COMPLETE,getDeviceData);
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceFileError);
         }
         log("getDeviceData(): " + new Error("").getStackTrace());
         if(null == _deviceIDFileByteArray)
         {
            _deviceIDFileByteArray = ByteArray(param1.target.data);
         }
         _deviceData = _deviceIDFileParser.parseDeviceIDFile(_deviceIDFileByteArray,_associatedDevices);
         if(_associatedDevices.isDeviceAssociated(_deviceData.deviceID))
         {
            _deviceReader.resetDeviceMiniGames(IDeviceMiniGamesReceiver(this));
         }
         if(null != _chainLoader)
         {
            _chainLoader.handleChainLoadeeComplete();
         }
      }
      
      public function get downloader() : IDownloader
      {
         return _downloader;
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete(): DeviceManager is initialized.");
         _deviceIDLoader.loadDeviceIDFile(_deviceIDFileByteArray,getDeviceData,handleDeviceFileError);
      }
      
      public function isDeviceAssociated() : Boolean
      {
         log("isDeviceAssociated()");
         return _associatedDevices.isDeviceAssociated(_deviceData.deviceID);
      }
      
      public function handleAssociatedDevicesRefreshed() : void
      {
         log("handleAssociatedDevicesRefreshed()");
         _deviceAssociatorConsumer.handleDeviceAssociationSuccess();
      }
      
      public function get driveLetter() : String
      {
         return _driveLetter;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>DeviceManager<< " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceManager>> " + param1);
      }
      
      public function get communicator() : IDeviceManagerCommunicator
      {
         return _deviceManagerCommunicator;
      }
      
      private function handleDeviceAssociationError(param1:IOErrorEvent) : void
      {
         log("handleDeviceAssociationError()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleDeviceAssociationComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceAssociationError);
         _deviceAssociatorConsumer.handleDeviceAssociationFailure();
      }
      
      private function deleteExtraneousFiles() : void
      {
         log("deleteExtraneousFiles()");
         _fileOperator.deleteFile(_driveLetter + "tryme1.bin");
         _fileOperator.deleteFile(_driveLetter + "tryme2.bin");
      }
      
      public function writeDeviceMiniGameList(param1:Array, param2:ILoadProgressUpdater, param3:Function) : void
      {
         _deviceMiniGameList = param1;
         if(null == _deviceMiniGameWriter)
         {
            _deviceMiniGameWriter = new DeviceMiniGameWriter(IDeviceManager(this),_fileOperator);
         }
         _deviceMiniGameWriter.writeDeviceMiniGameList(param1,param2,param3);
      }
      
      private function handleDeviceAssociationComplete(param1:Event) : void
      {
         log("handleDeviceAssociationComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleDeviceAssociationComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceAssociationError);
         deleteAllRootFilesExceptJolts();
         _dataManager.refreshData();
         _associatedDevices.refreshAssociatedDevices(IAssociatedDevicesRefreshedHandler(this));
      }
      
      private function deleteNanovorFolders() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < MAX_DEVICE_NANOVOR)
         {
            _fileOperator.deleteFolder(_driveLetter + "v" + (_loc1_ + 1),null);
            _loc1_++;
         }
      }
      
      public function load() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(_associatedDevices);
         _myChainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      private function handleDeviceFileError(param1:Event) : void
      {
         if(param1 != null)
         {
            param1.target.removeEventListener(Event.COMPLETE,getDeviceData);
            param1.target.removeEventListener(Event.COMPLETE,associateDeviceWithNewUser);
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleDeviceFileError);
         }
         if(null != _deviceAssociatorConsumer)
         {
            _deviceAssociatorConsumer.handleDeviceAssociationFailure();
         }
         logError("Device file read error.");
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function destroy() : void
      {
         log("destroy() clearing memory!");
         if(null != _deviceRecoverer)
         {
            _deviceRecoverer.killDialogs();
         }
         if(null != _deviceMiniGameWriter)
         {
            _deviceMiniGameWriter.destroy();
            _deviceMiniGameWriter = null;
         }
         if(null != _deviceNanovorWriter)
         {
            _deviceNanovorWriter.destroy();
            _deviceNanovorWriter = null;
         }
         if(null != _download)
         {
            _download.destroy();
            _download = null;
         }
         if(_chainLoader != null)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
         if(_myChainLoader != null)
         {
            _myChainLoader.destroy();
            _myChainLoader = null;
         }
      }
   }
}

