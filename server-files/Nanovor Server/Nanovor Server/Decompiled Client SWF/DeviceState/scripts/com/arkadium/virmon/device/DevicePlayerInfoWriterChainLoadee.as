package com.arkadium.virmon.device
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class DevicePlayerInfoWriterChainLoadee implements IChainLoadee
   {
      
      private static const PLAYER_INFO_FILE:String = "plyinfo.bbb";
      
      private var _failCatch:IDeviceWriteFailureConsumer;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      private var _msgBox:CommonDialogBox;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _stateManager:IStateManager;
      
      public function DevicePlayerInfoWriterChainLoadee(param1:IServiceRequestBrokerManager, param2:IStateManager, param3:IFileOperator, param4:IDeviceManager, param5:ILoadProgressUpdater, param6:IDeviceWriteFailureConsumer)
      {
         super();
         _serviceRequestBrokerManager = param1;
         _stateManager = param2;
         _fileOperator = param3;
         _deviceManager = param4;
         _loadProgressUpdater = param5;
         _failCatch = param6;
      }
      
      private function removeEventListeners(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,onPlayerInfoDownloadComplete);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,onPlayerInfoDownloadFailure);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DevicePlayerInfoWriterChainLoadee>>\t" + param1);
      }
      
      private function handleTransferErrorConfirmed(param1:Object) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      public function get name() : String
      {
         return "DevicePlayerInfoWriterChainLoadee";
      }
      
      private function onPlayerInfoDownloadFailure(param1:IOErrorEvent) : void
      {
         log("onPlayerInfoDownloadFailure(): " + param1.text);
         removeEventListeners(param1);
         if(Boolean(_msgBox))
         {
            _msgBox.kill();
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Transfer Error","File transfer was interrupted.\nPlease try again later.",0,handleTransferErrorConfirmed,handleTransferErrorConfirmed);
      }
      
      public function load() : void
      {
         _loadProgressUpdater.addStatusTextLine("WRITING PLAYER INFO DATA...0%");
         _deviceManager.communicator.getDevicePlayerInfo(_serviceRequestBrokerManager.getAccountID(),_deviceManager.deviceID,onPlayerInfoDownloadComplete,onPlayerInfoDownloadFailure);
      }
      
      private function onPlayerInfoDownloadComplete(param1:Event) : void
      {
         var e:Event = param1;
         log("onPlayerInfoDownloadComplete()");
         _fileOperator.deleteFile(_deviceManager.driveLetter + PLAYER_INFO_FILE,function():void
         {
            _fileOperator.writeByteArray(ByteArray(e.target.data),_deviceManager.driveLetter + PLAYER_INFO_FILE);
            removeEventListeners(e);
            if(!_fileOperator.doesFileExist(_deviceManager.driveLetter + PLAYER_INFO_FILE))
            {
               log("onPlayerInfoDownloadComplete(): Failed to write PlayerInfo file. Aborting");
               _msgBox = _failCatch.onDeviceWriteFailure();
               return;
            }
            _loadProgressUpdater.handleItemCompleted();
            _chainLoader.handleChainLoadeeComplete();
         });
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

