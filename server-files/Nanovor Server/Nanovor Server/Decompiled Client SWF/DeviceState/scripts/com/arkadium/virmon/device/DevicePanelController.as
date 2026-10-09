package com.arkadium.virmon.device
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.device.associatepanel.DeviceAssociatePanel;
   import com.arkadium.virmon.device.deviceswarmchooser.DeviceSwarmChooserPanel;
   import com.arkadium.virmon.device.home.DeviceHomePanel;
   import com.arkadium.virmon.device.home.DeviceInitializeHomePanel;
   import com.arkadium.virmon.device.transferpanel.DeviceTransferNanovorPanel;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.updatepanel.DeviceUpdatePanel;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   
   public class DevicePanelController implements IDevicePanelController
   {
      
      private var _fileOperator:IFileOperator;
      
      private var _deviceUIController:IDeviceUIController;
      
      private var _deviceUpdatePanel:IDevicePanel;
      
      private var _deviceTransferNanovor:DeviceTransferNanovorPanel;
      
      private var _deviceManager:IDeviceManager;
      
      private var _deviceAssociatePanel:IDevicePanel;
      
      private var _nextPanelParameters:Object;
      
      private var _deviceInitPanel:IDevicePanel;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _currentPanel:IDevicePanel;
      
      private var _deviceState:DisplayObjectContainer;
      
      private var _nextPanelType:String;
      
      private var _userProfile:IUserProfile;
      
      private var _deviceHome:DeviceHomePanel;
      
      private var _deviceSwarmChooser:DeviceSwarmChooserPanel;
      
      private var _stateManager:IStateManager;
      
      private var _deviceNanovorReceiver:IDeviceNanovorReceiver;
      
      public function DevicePanelController(param1:INanovorFactory, param2:IPlayerFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile, param7:IFileOperator, param8:DisplayObjectContainer, param9:IDeviceUIController, param10:IDeviceManager, param11:IDeviceNanovorWriter, param12:IDeviceNanovorReceiver, param13:ICharacterAssetTypeCache, param14:IAnalyticsManager, param15:IStateManager, param16:IServiceRequestBrokerManager, param17:ISoundManager)
      {
         super();
         _deviceState = param8;
         _deviceUIController = param9;
         _deviceManager = param10;
         _deviceNanovorReceiver = param12;
         _analyticsManager = param14;
         _stateManager = param15;
         _userProfile = param6;
         _fileOperator = param7;
         _serviceRequestBrokerManager = param16;
         _deviceHome = new DeviceHomePanel();
         _deviceTransferNanovor = new DeviceTransferNanovorPanel(param11,param13);
         _deviceSwarmChooser = new DeviceSwarmChooserPanel(param1,param2,param3,param4,param5,_userProfile,_deviceState,param13,_fileOperator,_serviceRequestBrokerManager,param17);
         MemoryWatcher.registerObject(this,"DevicePanelController" + int(Math.random() * 100));
         MemoryWatcher.registerObject(_deviceHome,"DeviceHomePanel" + int(Math.random() * 100));
         MemoryWatcher.registerObject(_deviceTransferNanovor,"DeviceTransferNanovorPanel" + int(Math.random() * 100));
         MemoryWatcher.registerObject(_deviceSwarmChooser,"DeviceSwarmChooserPanel" + int(Math.random() * 100));
      }
      
      private function trackPanelView(param1:String) : *
      {
         var _loc2_:View = null;
         log("trackPanelView(): panelType=" + param1);
         switch(param1)
         {
            case DevicePanelType.DEVICE_PANEL_ASSOCIATE:
               _loc2_ = View.DEVICE_UNKNOWN_DETECTED;
               break;
            case DevicePanelType.DEVICE_PANEL_UPDATE:
               _loc2_ = View.DEVICE_UPDATING;
               break;
            case DevicePanelType.DEVICE_PANEL_HOME:
               _loc2_ = View.DEVICE_INVENTORY_HOME;
               break;
            case DevicePanelType.DEVICE_PANEL_TRANSFER_NANOVOR:
               _loc2_ = View.DEVICE_SWARM_TRANSFER;
               break;
            case DevicePanelType.DEVICE_PANEL_SWARM_CHOOSER:
               _loc2_ = View.DEVICE_SWARM_CHOOSER;
               break;
            default:
               _loc2_ = null;
         }
         if(_loc2_ != null)
         {
            _analyticsManager.trackView(_loc2_);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DevicePanelController>>\t" + param1);
      }
      
      public function nextPanel(param1:String, param2:Object = null) : void
      {
         log("nextPanel() - Going to next panel " + param1);
         _nextPanelType = param1;
         _nextPanelParameters = param2;
         _currentPanel.unsetPanel();
      }
      
      public function finishedUnsetPanel() : void
      {
         log("finishedUnsetPanel() - Finished unsetting previous panel, continuing to " + _nextPanelType);
         _currentPanel = createPanel(_nextPanelType,_nextPanelParameters);
         _currentPanel.setPanel();
         trackPanelView(_nextPanelType);
      }
      
      private function createPanel(param1:String, param2:Object = null) : IDevicePanel
      {
         var _loc3_:IDevicePanel = null;
         switch(param1)
         {
            case DevicePanelType.DEVICE_PANEL_ASSOCIATE:
               _deviceAssociatePanel = _deviceAssociatePanel == null ? new DeviceAssociatePanel(_analyticsManager) : _deviceAssociatePanel;
               _loc3_ = _deviceAssociatePanel;
               MemoryWatcher.registerObject(_deviceAssociatePanel,"_deviceAssociatePanel" + int(Math.random() * 100));
               break;
            case DevicePanelType.DEVICE_PANEL_UPDATE:
               _deviceUpdatePanel = _deviceUpdatePanel == null ? new DeviceUpdatePanel(_deviceManager,_stateManager,_userProfile,_fileOperator,_serviceRequestBrokerManager) : _deviceUpdatePanel;
               _loc3_ = _deviceUpdatePanel;
               MemoryWatcher.registerObject(_deviceUpdatePanel,"_deviceUpdatePanel" + int(Math.random() * 100));
               break;
            case DevicePanelType.DEVICE_PANEL_HOME_INITIALIZE:
               _deviceInitPanel = _deviceInitPanel == null ? new DeviceInitializeHomePanel(_deviceNanovorReceiver) : _deviceInitPanel;
               _loc3_ = _deviceInitPanel;
               MemoryWatcher.registerObject(_deviceInitPanel,"_deviceInitPanel" + int(Math.random() * 100));
               break;
            case DevicePanelType.DEVICE_PANEL_HOME:
               _loc3_ = _deviceHome;
               break;
            case DevicePanelType.DEVICE_PANEL_TRANSFER_NANOVOR:
               _deviceTransferNanovor.setTransferNanovors(param2 as Array);
               _loc3_ = _deviceTransferNanovor;
               break;
            case DevicePanelType.DEVICE_PANEL_SWARM_CHOOSER:
               _deviceSwarmChooser.setSelectedNanovors(_deviceNanovorReceiver.getDeviceNanovorList());
               _loc3_ = _deviceSwarmChooser;
               break;
            case DevicePanelType.DEVICE_PANEL_BASE:
            default:
               _loc3_ = new DevicePanelBase();
         }
         MemoryWatcher.registerObject(_loc3_,"panel-" + param1 + int(Math.random() * 100));
         _loc3_.init(IDevicePanelController(this),IDeviceUIController(_deviceUIController));
         return _loc3_;
      }
      
      public function init() : void
      {
         _currentPanel = createPanel(DevicePanelType.DEVICE_PANEL_BASE);
      }
      
      public function destroy() : void
      {
         log("destroy() clearing memory!!");
         if(null != _currentPanel)
         {
            _currentPanel.destroy();
            _currentPanel = null;
         }
         if(null != _deviceHome)
         {
            _deviceHome.destroy();
            _deviceHome = null;
         }
         if(null != _deviceSwarmChooser)
         {
            _deviceSwarmChooser.destroy();
            _deviceSwarmChooser = null;
         }
         if(null != _deviceTransferNanovor)
         {
            _deviceTransferNanovor.destroy();
            _deviceTransferNanovor = null;
         }
         if(null != _deviceAssociatePanel)
         {
            _deviceAssociatePanel.destroy();
            _deviceAssociatePanel = null;
         }
         if(null != _deviceUpdatePanel)
         {
            _deviceUpdatePanel.destroy();
            _deviceUpdatePanel = null;
         }
         if(null != _deviceInitPanel)
         {
            _deviceInitPanel.destroy();
            _deviceInitPanel = null;
         }
      }
   }
}

