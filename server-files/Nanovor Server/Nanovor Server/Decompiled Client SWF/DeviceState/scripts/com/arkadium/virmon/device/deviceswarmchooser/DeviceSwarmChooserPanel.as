package com.arkadium.virmon.device.deviceswarmchooser
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class DeviceSwarmChooserPanel extends DevicePanelBase implements IChainLoaderConsumer, IDeviceUIInstructionsConsumer
   {
      
      public static const SWARM_CHOOSER_PATH:String = "DeviceSwarmChooser.swf";
      
      private var _swarmChooser:IDeviceSwarmChooser;
      
      private var _selectedDeviceNanovors:Array;
      
      private var _parent:DisplayObjectContainer;
      
      private var _evoManager:IEvoManager;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _userProfile:IUserProfile;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:IChainLoader;
      
      private var _uiInstructions:DeviceSwarmChooserUIInstructions;
      
      private var _soundManager:ISoundManager;
      
      public function DeviceSwarmChooserPanel(param1:INanovorFactory, param2:IPlayerFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile, param7:DisplayObjectContainer, param8:ICharacterAssetTypeCache, param9:IFileOperator, param10:IServiceRequestBrokerManager, param11:ISoundManager)
      {
         super();
         _nanovorFactory = param1;
         _playerFactory = param2;
         _evoManager = param3;
         _badgeManager = param4;
         _emManager = param5;
         _userProfile = param6;
         _parent = param7;
         _characterAssetTypeCache = param8;
         _fileOperator = param9;
         _serviceRequestBrokerManager = param10;
         _soundManager = param11;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         log("destroy() clearing memory!!");
         if(null != _swarmChooser)
         {
            _parent.removeChild(_swarmChooser as DisplayObject);
            _swarmChooser.destroy();
            _swarmChooser = null;
         }
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      public function loadSwarmChooser() : void
      {
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(SWARM_CHOOSER_PATH,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceSwarmChooserPanel>>\t" + param1);
      }
      
      public function setUIFinished() : void
      {
         (_swarmChooser as DisplayObject).visible = true;
         _swarmChooser.open(_selectedDeviceNanovors);
      }
      
      override public function setPanel() : void
      {
         if(null == _swarmChooser)
         {
            _uiInstructions = new DeviceSwarmChooserUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
            loadSwarmChooser();
            return;
         }
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _swarmChooser = param1.getLoadedAsset(SWFLoadee.NAME + SWARM_CHOOSER_PATH) as IDeviceSwarmChooser;
         _swarmChooser.init(_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile,_devicePanelController,IDeviceSwarmChooserUIInstructions(_uiInstructions),new TransferTimeEstimater(_fileOperator,_serviceRequestBrokerManager),_characterAssetTypeCache,_soundManager);
         var _loc2_:DisplayObject = _swarmChooser as DisplayObject;
         _loc2_.visible = false;
         _parent.addChild(_loc2_);
         MemoryWatcher.registerObject(_loc2_,"swarmChooser!!" + int(Math.random() * 1000));
         setPanel();
      }
      
      override public function unsetPanel() : void
      {
         (_swarmChooser as DisplayObject).visible = false;
         finishUnsetPanel();
      }
      
      public function setSelectedNanovors(param1:Array) : void
      {
         _selectedDeviceNanovors = param1;
      }
   }
}

