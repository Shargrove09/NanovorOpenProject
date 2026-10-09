package com.arkadium.virmon.device.updatepanel
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.UserProfileEvent;
   import com.arkadium.virmon.device.BattleLogUpdateData;
   import com.arkadium.virmon.device.DeviceBattleLogUploadChainLoadee;
   import com.arkadium.virmon.device.DeviceErrorLogCheckChainLoadee;
   import com.arkadium.virmon.device.DeviceFirmwareChainLoadee;
   import com.arkadium.virmon.device.DeviceJoltsUploadChainLoadee;
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.DevicePlayerInfoWriterChainLoadee;
   import com.arkadium.virmon.device.DeviceRequiredFilesChainLoadee;
   import com.arkadium.virmon.device.DeviceSenseiGameFolderUpdateChainLoadee;
   import com.arkadium.virmon.device.IDeviceAssociatorConsumer;
   import com.arkadium.virmon.device.IDeviceManager;
   import com.arkadium.virmon.device.IDeviceMiniGamesReceiver;
   import com.arkadium.virmon.device.IDeviceWriteFailureConsumer;
   import com.arkadium.virmon.device.ILoadProgressMonitor;
   import com.arkadium.virmon.device.ILoadProgressUpdater;
   import com.arkadium.virmon.device.LoadProgressUpdater;
   import com.arkadium.virmon.device.WriteAllMiniGamesToDeviceChainLoadee;
   import com.arkadium.virmon.device.ui.DeviceJoltsAwards;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.shared.data.JoltsInfo;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   
   public class DeviceUpdatePanel extends DevicePanelBase implements ILoadProgressMonitor, IChainLoaderConsumer, IDeviceAssociatorConsumer, IDeviceUIInstructionsConsumer, IDeviceWriteFailureConsumer
   {
      
      private var _preUpdateJoltsInfo:JoltsInfo;
      
      private var _postUpdateJoltsInfo:JoltsInfo;
      
      private var _fileOperator:IFileOperator;
      
      private var _userProfile:IUserProfile;
      
      private var _msgBox:CommonDialogBox;
      
      private var _stateManager:IStateManager;
      
      private var _battleLogUpdateData:BattleLogUpdateData;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _chainLoader:IChainLoader;
      
      private var _uiInstructions:DeviceUpdatePanelUIInstructions;
      
      private var _deviceManager:IDeviceManager;
      
      public function DeviceUpdatePanel(param1:IDeviceManager, param2:IStateManager, param3:IUserProfile, param4:IFileOperator, param5:IServiceRequestBrokerManager)
      {
         super();
         _deviceManager = param1;
         _stateManager = param2;
         _userProfile = param3;
         _fileOperator = param4;
         _serviceRequestBrokerManager = param5;
      }
      
      public function handleDeviceAssociationSuccess() : void
      {
         log("handleDeviceAssociationSuccess()");
         var _loc1_:ILoadProgressUpdater = new LoadProgressUpdater(8,ILoadProgressMonitor(this),[1,1,2,1,1,20,1,1]);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new DeviceBattleLogUploadChainLoadee(_deviceManager,_deviceManager.communicator,_loc1_,_fileOperator,_serviceRequestBrokerManager));
         _loc2_.add(new DeviceJoltsUploadChainLoadee(_deviceManager,_deviceManager.communicator,_loc1_,_fileOperator,_stateManager,_serviceRequestBrokerManager));
         _loc2_.add(new DeviceErrorLogCheckChainLoadee(_deviceManager,_fileOperator));
         _loc2_.add(new DeviceFirmwareChainLoadee(_fileOperator,_stateManager,_deviceManager,_deviceManager.communicator,_deviceManager.download,_serviceRequestBrokerManager,_loc1_,this));
         _loc2_.add(new DevicePlayerInfoWriterChainLoadee(_serviceRequestBrokerManager,_stateManager,_fileOperator,_deviceManager,_loc1_,this));
         _loc2_.add(new DeviceRequiredFilesChainLoadee(_fileOperator,_stateManager,_deviceManager,_deviceManager.download,_deviceManager.communicator,_loc1_,this));
         _loc2_.add(new DeviceSenseiGameFolderUpdateChainLoadee(_fileOperator,"game.bin",_deviceManager,_loc1_));
         _loc2_.add(new WriteAllMiniGamesToDeviceChainLoadee(_fileOperator,_deviceManager.communicator,_deviceManager.driveLetter,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      override public function destroy() : void
      {
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUpdatedUserProfile);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onErrorUserProfile);
         super.destroy();
         _deviceManager = null;
         if(_chainLoader != null)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
         if(_uiInstructions != null)
         {
            _uiInstructions.destroy();
         }
         _deviceUIController = null;
      }
      
      public function setUIFinished() : void
      {
         log("spinnerOpened()");
         _deviceManager.associateDevice(IDeviceAssociatorConsumer(this));
      }
      
      public function handleNoRetryUpdateProcess(param1:Object = null) : void
      {
         log("handleNoRetryUpdateProcess()");
         _deviceUIController.handleDeviceReset(gotoHomeState);
      }
      
      public function handleDeviceAssociationFailure() : void
      {
         log("handleDeviceAssociationFailure()");
         _deviceUIController.showErrorPopup({"deviceID":_deviceManager.deviceID});
      }
      
      public function handleYesRetryUpdateProcess(param1:Object = null) : void
      {
         log("handleYesRetryUpdateProcess()");
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUpdatedUserProfile);
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_UPDATE);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceUpdatePanel: " + param1);
      }
      
      public function updateProgress(param1:Number) : void
      {
         _uiInstructions.updateProgress(param1);
      }
      
      private function onErrorUserProfile(param1:Event) : void
      {
         logError("onErrorUserProfile(): failed to update User Profile.");
         onUpdatedUserProfile(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceUpdatePanel: " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _deviceUIController.getSpinner().toggleTimer(false);
         _battleLogUpdateData = param1.getLoadedAsset(DeviceBattleLogUploadChainLoadee.NAME) as BattleLogUpdateData;
         _userProfile.addEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUpdatedUserProfile,false,0,true);
         _userProfile.addEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onErrorUserProfile,false,0,true);
         _userProfile.retrieveProfileData(true);
      }
      
      override public function setPanel() : void
      {
         log("setPanel()");
         _preUpdateJoltsInfo = new JoltsInfo(_userProfile.healthJolts,_userProfile.armorJolts,_userProfile.strengthJolts,_userProfile.speedJolts);
         _uiInstructions = new DeviceUpdatePanelUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
         _deviceUIController.getDeviceResetButton().visible = false;
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      private function getDeviceJoltsAwardsType(param1:String) : String
      {
         switch(param1)
         {
            case "Health":
               return DeviceJoltsAwards.TYPE_HEALTH;
            case "Strength":
               return DeviceJoltsAwards.TYPE_STRENGTH;
            case "Armor":
               return DeviceJoltsAwards.TYPE_ARMOR;
            case "Speed":
               return DeviceJoltsAwards.TYPE_SPEED;
            default:
               return "";
         }
      }
      
      private function gotoHomeState() : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      public function addStatusTextLine(param1:String) : void
      {
         _uiInstructions.addStatusTextLine(param1);
      }
      
      public function replaceLastStatusTextLine(param1:String) : void
      {
         _uiInstructions.replaceLastStatusTextLine(param1);
      }
      
      public function onDeviceWriteFailure() : CommonDialogBox
      {
         log("onDeviceWriteFailure()");
         _msgBox = null;
         if(_stateManager.state == StateType.DEVICEMANAGER.name)
         {
            _msgBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Nanoscope Error","There was a problem writing to the Nanoscope,\nWould you like to try again?",0,handleYesRetryUpdateProcess,handleNoRetryUpdateProcess,handleNoRetryUpdateProcess,null,null);
         }
         return _msgBox;
      }
      
      private function onUpdatedUserProfile(param1:Event) : void
      {
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUpdatedUserProfile);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onErrorUserProfile);
         _postUpdateJoltsInfo = new JoltsInfo(_userProfile.healthJolts,_userProfile.armorJolts,_userProfile.strengthJolts,_userProfile.speedJolts);
         var _loc2_:int = Math.max(_postUpdateJoltsInfo.healthJolts - _preUpdateJoltsInfo.healthJolts,0);
         var _loc3_:int = Math.max(_postUpdateJoltsInfo.armorJolts - _preUpdateJoltsInfo.armorJolts,0);
         var _loc4_:int = Math.max(_postUpdateJoltsInfo.strengthJolts - _preUpdateJoltsInfo.strengthJolts,0);
         var _loc5_:int = Math.max(_postUpdateJoltsInfo.speedJolts - _preUpdateJoltsInfo.speedJolts,0);
         log("onUpdatedUserProfile() - healthJoltsGained: " + _loc2_);
         log("onUpdatedUserProfile() - armorJoltsGained: " + _loc3_);
         log("onUpdatedUserProfile() - strengthJoltsGained: " + _loc4_);
         log("onUpdatedUserProfile() - speedJoltsGained: " + _loc5_);
         var _loc6_:Array = IDeviceMiniGamesReceiver(_deviceManager).getDeviceMiniGameList();
         _deviceUIController.getJoltsAwards().setJolts(DeviceJoltsAwards.TYPE_HEALTH,_loc2_);
         _deviceUIController.getJoltsAwards().setJolts(DeviceJoltsAwards.TYPE_STRENGTH,_loc4_);
         _deviceUIController.getJoltsAwards().setJolts(DeviceJoltsAwards.TYPE_ARMOR,_loc3_);
         _deviceUIController.getJoltsAwards().setJolts(DeviceJoltsAwards.TYPE_SPEED,_loc5_);
         if(_battleLogUpdateData != null)
         {
            _deviceUIController.getJoltsAwards().tfNMP.text = "NMP: " + _battleLogUpdateData.deltaNMP;
            _deviceUIController.getJoltsAwards().tfUpdates.text = "BATTLES: " + _battleLogUpdateData.successfulUpdates;
         }
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_HOME_INITIALIZE);
      }
      
      override public function unsetPanel() : void
      {
         log("unsetting update panel");
         if(_msgBox != null)
         {
            log("killing handleYesRetryUpdateProcess message box");
            _msgBox.kill();
         }
         finishUnsetPanel();
      }
   }
}

