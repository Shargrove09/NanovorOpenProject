package com.arkadium.virmon.device
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.device.ui.DeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceStateUI;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.CharacterAssetTypeCache;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderHandleError;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.DataManagerRefreshLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class DeviceState extends AbstractState implements IDeviceState, IChainLoaderConsumer, IChainLoaderErrorConsumer
   {
      
      private static const DEVICE_STATE_UI_PATH:String = "DeviceStateUI.swf";
      
      private static const BASE_FOLDER:String = "Assets\\Device\\Characters\\";
      
      private var _devicePanelController:DevicePanelController;
      
      private var _evoManager:IEvoManager;
      
      private var _userProfile:IUserProfile;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _chatGameService:IChatGameService;
      
      private var _fileOperator:IFileOperator;
      
      private var _stateManager:IStateManager;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _deviceUIController:DeviceUIController;
      
      private var _widgetManager:IWidgetManager;
      
      private var _downloader:IDownloader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _dataManager:IDataManager;
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:IChainLoader;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _deviceManager:IDeviceManager;
      
      private var _assetManager:IAssetManager;
      
      private var _soundManager:ISoundManager;
      
      public function DeviceState()
      {
         super();
         stateName = StateType.DEVICEMANAGER.name;
         _quicktipsURL = "";
      }
      
      public function handleChainLoaderError() : void
      {
         log("handleChainLoaderError() - The MDM test failed and should open a dialog now");
         var _loc1_:CommonDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Download failed","Download failed. Please check your internet connection and try again.",30,gotoHome,gotoHome,null,gotoHome);
      }
      
      private function gotoHome(param1:Object = null) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      public function initialize(param1:IDownloader, param2:IChatGameService, param3:IUserProfile, param4:INanovorFactory, param5:IPlayerFactory, param6:IStateManager, param7:IDataManager, param8:IFileOperator, param9:IServiceRequestBrokerManager, param10:IAnalyticsManager, param11:ICharacterAssetRetriever, param12:IWidgetManager, param13:IAssetManager, param14:ISoundManager) : void
      {
         log("initialize()");
         if(null == param1)
         {
            throw new Error("Parameter \"downloader\" cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \"chatGameService\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"userProfile\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"nanovorFactory\" cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \"playerFactory\" cannot be null.");
         }
         if(null == param6)
         {
            throw new Error("Parameter \"stateManager\" cannot be null.");
         }
         if(null == param7)
         {
            throw new Error("Parameter \"dataManager\" cannot be null.");
         }
         if(null == param8)
         {
            throw new Error("Parameter \"fileOperator\" cannot be null.");
         }
         if(null == param7)
         {
            throw new Error("Parameter \"dataManager\" cannot be null.");
         }
         if(null == param9)
         {
            throw new Error("Parameter \"serviceRequestBrokerManager\" cannot be null.");
         }
         if(null == param10)
         {
            throw new Error("Parameter \"analyticsManager\" cannot be null.");
         }
         if(null == param11)
         {
            throw new Error("Parameter \"characterAssetRetriever\" cannot be null.");
         }
         if(null == param12)
         {
            throw new Error("Parameter \"widgetManager\" cannot be null.");
         }
         if(null == param13)
         {
            throw new Error("Parameter \"assetManager\" cannot be null.");
         }
         if(null == param14)
         {
            throw new Error("Parameter \"soundManager\" cannot be null.");
         }
         if(null == IDeviceConnectionDetector(param6.getStateData(StateType.DEVICEMANAGER)))
         {
            param6.setState(StateType.HOME);
         }
         if(isInitialized)
         {
            return;
         }
         isInitialized = true;
         _downloader = param1;
         _chatGameService = param2;
         _userProfile = param3;
         _nanovorFactory = param4;
         _playerFactory = param5;
         _dataManager = param7;
         _emManager = _dataManager.getEMManager();
         _badgeManager = _dataManager.getBadgeManager();
         _evoManager = _dataManager.getEvoManager();
         _serviceRequestBrokerManager = param9;
         _fileOperator = param8;
         _stateManager = param6;
         _analyticsManager = param10;
         _characterAssetRetriever = param11;
         _widgetManager = param12;
         _assetManager = param13;
         _soundManager = param14;
         _stateManager.getStateByName(StateType.DEVICEMANAGER.name).quicktipsURL = Const.QUICKTIP_DEVICE_MANAGER;
         _fileOperator.makeFolder(BASE_FOLDER);
         _deviceManager = new DeviceManager(_nanovorFactory,IDeviceConnectionDetector(_stateManager.getStateData(StateType.DEVICEMANAGER)),_serviceRequestBrokerManager,_dataManager,_downloader,_fileOperator,_stateManager);
         MemoryWatcher.registerObject(_deviceManager,"DeviceManager" + int(Math.random() * 1000));
         var _loc15_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc16_:ChainLoadeeList = new ChainLoadeeList();
         _loc16_.add(new DataManagerRefreshLoadee(_dataManager));
         _loc16_.add(new SWFLoadee(DEVICE_STATE_UI_PATH,_loc15_));
         _loc16_.add(_deviceManager);
         _chainLoader = new ChainLoaderHandleError(_loc16_,IChainLoaderConsumer(this),IChainLoaderErrorConsumer(this));
         _chainLoader.load();
         log("DeviceState state is initialized");
         _analyticsManager.trackView(View.DEVICE_LANDING);
      }
      
      override public function onUnsetState() : void
      {
         log("onUnsetState() clearing memory!!");
         _widgetManager.addWidget(WidgetType.WIDGET_AVATAR);
         if(null != _stateManager.getStateByName(StateType.HOME.name))
         {
            _stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_HOME);
         }
         if(null != _deviceManager)
         {
            _deviceManager.destroy();
            _deviceManager = null;
         }
         if(null != _deviceUIController)
         {
            _deviceUIController.destroy();
            _deviceUIController = null;
         }
         if(null != _devicePanelController)
         {
            _devicePanelController.destroy();
            _devicePanelController = null;
         }
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      override public function onSetState() : void
      {
         if(_chatGameService.isPrivateChatRoomActive())
         {
            IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).reset();
            _chatGameService.exitChatRoom();
         }
         _widgetManager.removeWidget(WidgetType.WIDGET_AVATAR);
         if(null != _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name))
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_MINIMIZED);
         }
         if(null != _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name))
         {
            IHeaderWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)).setDeviceMode();
         }
         if(null != _widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name))
         {
            IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).quitBattle();
         }
         IAutoBattleWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name)).hide();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("swfLoadComplete()");
         var _loc2_:MovieClip = param1.getLoadedAsset(SWFLoadee.NAME + DEVICE_STATE_UI_PATH) as MovieClip;
         if(null == _loc2_)
         {
            throw new Error("loadedSwf failed to load");
         }
         var _loc3_:IDeviceStateUI = IDeviceStateUI(param1.getLoadedAsset(SWFLoadee.NAME + DEVICE_STATE_UI_PATH));
         if(null == _loc3_)
         {
            throw new Error("DeviceStateUI failed to load");
         }
         _loc3_.getDeviceResetButton().visible = false;
         _characterAssetTypeCache = new CharacterAssetTypeCache(_characterAssetRetriever);
         _deviceUIController = new DeviceUIController(_stateManager,_deviceManager);
         _deviceUIController.init(_loc3_,_characterAssetTypeCache);
         log("handleChainLoaderComplete() - Done loading deviceUiCOntroller");
         var _loc4_:DeviceStateUIInstructions = new DeviceStateUIInstructions(_deviceUIController,null);
         _deviceUIController.nextUIInstructions(_loc4_);
         this.addChild(_loc3_ as DisplayObject);
         _devicePanelController = new DevicePanelController(_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile,_fileOperator,this,_deviceUIController,_deviceManager,IDeviceNanovorWriter(_deviceManager),IDeviceNanovorReceiver(_deviceManager),_characterAssetTypeCache,_analyticsManager,_stateManager,_serviceRequestBrokerManager,_soundManager);
         _devicePanelController.init();
         _devicePanelController.nextPanel(_deviceManager.isDeviceAssociated() ? DevicePanelType.DEVICE_PANEL_UPDATE : DevicePanelType.DEVICE_PANEL_ASSOCIATE);
      }
   }
}

