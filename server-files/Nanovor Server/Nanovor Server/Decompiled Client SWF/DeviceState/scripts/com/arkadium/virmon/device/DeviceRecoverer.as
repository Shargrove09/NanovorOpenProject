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
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   
   public class DeviceRecoverer implements IDeviceRecoverer, IHTTPChainLoadeeConsumer, IChainLoaderConsumer
   {
      
      private static const NEW_PRIV_KEY_FILE:String = "privkey2.bbb";
      
      private static const RESET_PRIV_KEY_FILE:String = "privkey.bbb";
      
      private static const RESET_FIRMWARE_FILE:String = "frm.bbb";
      
      private static const EXPECTED_RECOVERY_DEVICE_ID:String = "999";
      
      private var _finishGetDeviceData:Function;
      
      private var _deviceID:String;
      
      private var _driveLetter:String;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _firmwareVersion:int;
      
      private var _fileOperator:IFileOperator;
      
      private var _deviceFileByteArray:ByteArray;
      
      private var _privKeyLoader:URLLoader;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _commonDialogBoxList:Array;
      
      private var _associatedDevices:IAssociatedDevices;
      
      private var _stateManager:IStateManager;
      
      public function DeviceRecoverer(param1:String, param2:IDeviceManagerCommunicator, param3:IStateManager, param4:IFileOperator, param5:IServiceRequestBrokerManager, param6:IDownloader)
      {
         super();
         _driveLetter = param1;
         _deviceManagerCommunicator = param2;
         _stateManager = param3;
         _fileOperator = param4;
         _serviceRequestBrokerManager = param5;
         _downloader = param6;
         _commonDialogBoxList = new Array();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceRecoverer: " + param1);
      }
      
      public function handleHTTPError() : void
      {
         logError("handleHTTPError()");
         handleRecoveryError();
      }
      
      public function handleHTTPComplete(param1:String) : void
      {
         log("handleHTTPComplete(): file: " + param1);
      }
      
      public function handleHTTPProgress(param1:int, param2:int) : void
      {
         log("handleHTTPProgress(): " + Number(param1 / param2).toFixed(1) + "%");
      }
      
      public function startDeviceRecovery(param1:String) : void
      {
         log("startDeviceRecovery(): code=" + param1);
         _deviceManagerCommunicator.getNewPrivKey(param1,handleNewPrivKeySuccess,handleNewPrivKeyError);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceRecoverer: " + param1);
      }
      
      private function handleRecoveryErrorDialogDismissed(param1:Object = null) : void
      {
         navigateToURL(new URLRequest("http://www.nanovor.com"),"_blank");
         _stateManager.setState(StateType.HOME);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _commonDialogBoxList.push(CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Device Recovery Info","Device recovery is almost complete.\nPlease disconnect Nanoscope and following directions to complete recovery process.",0,null,null));
      }
      
      private function handleRecoveryError() : void
      {
         _commonDialogBoxList.push(CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Device Recovery Error","Device recovery has failed. Please click \"OK\" to contact customer support.",0,handleRecoveryErrorDialogDismissed,handleRecoveryErrorDialogDismissed));
      }
      
      private function handleNewPrivKeySuccess(param1:Event) : void
      {
         var newPrivKey:ByteArray = null;
         var tempFile:String = null;
         var chainLoadeeList:ChainLoadeeList = null;
         var e:Event = param1;
         log("handleNewPrivKeySuccess()");
         IEventDispatcher(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleNewPrivKeyError);
         IEventDispatcher(e.currentTarget).removeEventListener(Event.COMPLETE,handleNewPrivKeySuccess);
         try
         {
            newPrivKey = ByteArray(e.target.data);
            tempFile = int(Math.random() * 99999999).toString();
            _fileOperator.writeByteArray(newPrivKey,tempFile);
            _fileOperator.moveFile(tempFile,_driveLetter + NEW_PRIV_KEY_FILE);
            chainLoadeeList = new ChainLoadeeList();
            chainLoadeeList.add(new HTTPChainLoadee(_serviceRequestBrokerManager.staticFileServiceURL + "/device/reset/" + RESET_PRIV_KEY_FILE,_driveLetter + RESET_PRIV_KEY_FILE,_downloader,IHTTPChainLoadeeConsumer(this)));
            chainLoadeeList.add(new HTTPChainLoadee(_serviceRequestBrokerManager.staticFileServiceURL + "/device/reset/" + RESET_FIRMWARE_FILE,_driveLetter + RESET_FIRMWARE_FILE,_downloader,IHTTPChainLoadeeConsumer(this)));
            _chainLoader = new ChainLoader(chainLoadeeList,IChainLoaderConsumer(this));
            _chainLoader.load();
         }
         catch(error:Error)
         {
            logError("handleNewPrivKeySuccess(): error parsing ByteArray data:\n\t" + error.message);
            handleRecoveryError();
         }
      }
      
      public function killDialogs() : void
      {
         var _loc1_:CommonDialogBox = null;
         log("killDialogs()");
         for each(_loc1_ in _commonDialogBoxList)
         {
            if(null != _loc1_)
            {
               _loc1_.kill();
            }
         }
      }
      
      private function handleNewPrivKeyError(param1:IOErrorEvent) : void
      {
         logError("handleNewPrivKeyError(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleNewPrivKeyError);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleNewPrivKeySuccess);
         handleRecoveryError();
      }
   }
}

