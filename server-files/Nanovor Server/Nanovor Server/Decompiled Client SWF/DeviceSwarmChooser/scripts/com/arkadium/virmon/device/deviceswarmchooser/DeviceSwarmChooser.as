package com.arkadium.virmon.device.deviceswarmchooser
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.swarmchooser.SwarmContainerEvent;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.IDevicePanelController;
   import com.arkadium.virmon.device.deviceswarmchooser.deviceswarmcontainer.DeviceSwarmContainer;
   import com.arkadium.virmon.device.deviceswarmchooser.deviceswarmspinner.DeviceSwarmSpinner;
   import com.arkadium.virmon.device.footer.DeviceFooter;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenuEvent;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DeviceSwarmChooser extends Sprite implements IDeviceSwarmChooser, ITransferTimeEstimaterConsumer
   {
      
      public static const TREEVIEW_MENU_POSITION:Point = new Point(57,125);
      
      public static const EXIT_BTN_POSITION:Point = new Point(731,722);
      
      public static const DEVICE_SWARM_SPINNER_POSITION:Point = new Point(33,90);
      
      public static const DEVICE_SWARM_SPINNER_SCALE:Number = 0.6;
      
      public static const DEVICE_SWARM_SPINNER_ROTATION:Number = 15;
      
      public static const MAX_DEVICE_NANOVOR:int = 10;
      
      private var _swarmContainer:DeviceSwarmContainer;
      
      private var _devicePanelController:IDevicePanelController;
      
      private var _evoManager:IEvoManager;
      
      private var _exitButton:DeviceExitButton;
      
      private var _userProfile:IUserProfile;
      
      private var _deviceSwarmSpinner:DeviceSwarmSpinner;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _selectedSwarm:Array;
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _nanovorFactory:INanovorFactory;
      
      public var mcFooter:DeviceFooter;
      
      private var _transferTimeEstimater:ITransferTimeEstimater;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _selectedSwarmAssetIds:Array;
      
      private var _showDeviceSwarmSpinner:Boolean = true;
      
      private var _uiInstructions:IDeviceSwarmChooserUIInstructions;
      
      private var _soundManager:ISoundManager;
      
      private var _emManager:IEMManager;
      
      public function DeviceSwarmChooser()
      {
         super();
      }
      
      public function destroy() : void
      {
         log("destroy() clearing from memory!");
         if(null != _transferTimeEstimater)
         {
            _transferTimeEstimater.killDialogs();
         }
         resetSelectedNanovors();
         if(null != mcFooter)
         {
            mcFooter.resetDeviceSwarmMeter();
            mcFooter.btnRedButton.removeEventListener(MouseEvent.CLICK,onTransferButtonClick);
            mcFooter.destroy();
            mcFooter = null;
         }
         if(null != _exitButton)
         {
            _exitButton.removeEventListener(MouseEvent.CLICK,onExitButtonClick);
            _exitButton.destroy();
            _exitButton = null;
         }
         if(null != _deviceSwarmSpinner)
         {
            _deviceSwarmSpinner.destroy();
            _deviceSwarmSpinner = null;
         }
         if(null != _swarmContainer)
         {
            _swarmContainer.removeEventListener(DeviceSwarmContainer.SPOTLIGHT_OPEN,onSpotlightOpen);
            _swarmContainer.removeEventListener(SwarmContainerEvent.NANOVOR_REMOVED,onNanovorRemoved);
            _swarmContainer.destroy();
            _swarmContainer = null;
         }
         if(null != _treeViewMenu)
         {
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.TREETILE_ROLLOVER,onTreeTileRollOver);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.TREETILE_ROLLOUT,onTreeTileRollOut);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened);
            _treeViewMenu.destroy();
            _treeViewMenu = null;
         }
         _devicePanelController = null;
      }
      
      private function createTreeViewMenu() : void
      {
         log("createTreeViewMenu()");
         if(_treeViewMenu != null)
         {
            return;
         }
         _treeViewMenu = new TreeViewMenu(_nanovorFactory,SwarmChooserDataHandler.getNanovorIdsInTrees(),SwarmChooserDataHandler.getNanovors(_nanovorFactory),SwarmChooserDataHandler.getTreeNames());
         _treeViewMenu.x = TREEVIEW_MENU_POSITION.x;
         _treeViewMenu.y = TREEVIEW_MENU_POSITION.y;
         this.addChild(_treeViewMenu);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_ROLLOVER,onTreeTileRollOver,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_ROLLOUT,onTreeTileRollOut,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened,false,0,true);
         MemoryWatcher.registerObject(_treeViewMenu,"TreeviewMenu" + int(Math.random() * 1000));
      }
      
      private function createExitButton() : void
      {
         if(_exitButton != null)
         {
            return;
         }
         _exitButton = new DeviceExitButton();
         _exitButton.x = EXIT_BTN_POSITION.x;
         _exitButton.y = EXIT_BTN_POSITION.y;
         addChild(_exitButton);
         _exitButton.color = SpinningButtonComponent.COLOR_RED;
         _exitButton.icon = new SpinnerIconX();
         _exitButton.addEventListener(MouseEvent.CLICK,onExitButtonClick,false,0,true);
         MemoryWatcher.registerObject(_exitButton,"ExitButton" + int(Math.random() * 1000));
      }
      
      private function createDeviceSwarmSpinner() : void
      {
         if(_deviceSwarmSpinner != null)
         {
            return;
         }
         _deviceSwarmSpinner = new DeviceSwarmSpinner();
         _deviceSwarmSpinner.scaleX = _deviceSwarmSpinner.scaleY = DEVICE_SWARM_SPINNER_SCALE;
         _deviceSwarmSpinner.rotation = DEVICE_SWARM_SPINNER_ROTATION;
         _deviceSwarmSpinner.x = DEVICE_SWARM_SPINNER_POSITION.x;
         _deviceSwarmSpinner.y = DEVICE_SWARM_SPINNER_POSITION.y;
         _swarmContainer._mainContainer.addChild(_deviceSwarmSpinner);
         _deviceSwarmSpinner.init();
         _deviceSwarmSpinner.color = DeviceSwarmSpinner.COLOR_GREEN;
         _deviceSwarmSpinner.startAnimation();
         MemoryWatcher.registerObject(_deviceSwarmSpinner,"_deviceSwarmSpinners" + int(Math.random() * 1000));
      }
      
      private function createSwarmContainer() : void
      {
         if(_swarmContainer != null)
         {
            return;
         }
         _swarmContainer = new DeviceSwarmContainer(_characterAssetTypeCache,_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile);
         _swarmContainer.y = 320;
         this.addChild(_swarmContainer);
         _swarmContainer.addEventListener(SwarmContainerEvent.NANOVOR_REMOVED,onNanovorRemoved,false,0,true);
         _swarmContainer.mode = DeviceSwarmContainer.MODE_ATTACKS;
         MemoryWatcher.registerObject(_swarmContainer,"SwarmContainer" + int(Math.random() * 1000));
      }
      
      private function resetSelectedNanovors() : void
      {
         var _loc1_:INanovor = null;
         for each(_loc1_ in _selectedSwarm)
         {
            _treeViewMenu.replaceTileById(_loc1_.assetId);
         }
         _swarmContainer.clearSwarm();
      }
      
      private function onExitButtonClick(param1:MouseEvent) : void
      {
         if(_selectedSwarm.length > 0)
         {
            resetSelectedNanovors();
            _selectedSwarm = new Array();
            _exitButton.close();
         }
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_HOME_INITIALIZE);
      }
      
      private function checkSwarmEligibility() : Boolean
      {
         _deviceSwarmSpinner.updateCount(MAX_DEVICE_NANOVOR - _selectedSwarm.length);
         if(_selectedSwarm.length < 10)
         {
            _swarmContainer.swarmIsNotFull();
            _treeViewMenu.checkTileEligibility(100000);
            mcFooter.stopPulse();
            return true;
         }
         _swarmContainer.swarmIsFull();
         _treeViewMenu.checkTileEligibility(0);
         mcFooter.startPulse();
         return false;
      }
      
      private function onCollectionTileClick(param1:TreeViewMenuEvent) : void
      {
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_CharacterSelect",true,SoundManagerConst.soundApplicationDomain,true));
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_CharacterSlide",true,SoundManagerConst.soundApplicationDomain,true));
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         param1.target.showNanoscopeIcon();
         _selectedSwarm.push(_loc2_);
         _swarmContainer.addCandidate();
         checkSwarmEligibility();
         _showDeviceSwarmSpinner = true;
         _swarmContainer.addEventListener(DeviceSwarmContainer.SPOTLIGHT_OPEN,onSpotlightOpen,false,0,true);
         mcFooter.addNanovor();
      }
      
      private function onTreeTileRollOut(param1:TreeViewMenuEvent) : void
      {
      }
      
      private function toggleFooter(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(mcFooter,{
               "y":700,
               "time":1,
               "transition":Equations.easeInOutQuad
            });
            mcFooter.mouseChildren = true;
         }
         else
         {
            Tweener.addTween(mcFooter,{
               "y":800,
               "time":1,
               "transition":Equations.easeInOutQuad
            });
            mcFooter.mouseChildren = false;
         }
      }
      
      public function init(param1:INanovorFactory, param2:IPlayerFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile, param7:IDevicePanelController, param8:IDeviceSwarmChooserUIInstructions, param9:ITransferTimeEstimater, param10:ICharacterAssetTypeCache, param11:ISoundManager) : void
      {
         log("init()");
         _nanovorFactory = param1;
         _devicePanelController = param7;
         _uiInstructions = param8;
         _transferTimeEstimater = param9;
         _characterAssetTypeCache = param10;
         _playerFactory = param2;
         _evoManager = param3;
         _badgeManager = param4;
         _emManager = param5;
         _userProfile = param6;
         _soundManager = param11;
         mcFooter.init();
         createSwarmContainer();
         createTreeViewMenu();
         createExitButton();
         createDeviceSwarmSpinner();
         _selectedSwarm = new Array();
         this.visible = false;
         mcFooter.btnRedButton.addEventListener(MouseEvent.CLICK,onTransferButtonClick,false,0,true);
      }
      
      private function onCollectionOpened(param1:TreeViewMenuEvent) : void
      {
         _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened);
         _swarmContainer.showSelectNanovor();
         _deviceSwarmSpinner.show();
      }
      
      private function onSpotlightOpen(param1:Event) : void
      {
         _swarmContainer.removeEventListener(DeviceSwarmContainer.SPOTLIGHT_OPEN,onSpotlightOpen);
         if(_showDeviceSwarmSpinner)
         {
            _deviceSwarmSpinner.show();
         }
      }
      
      public function cancelTimeEstimate() : void
      {
         mcFooter.btnRedButton.addEventListener(MouseEvent.CLICK,onTransferButtonClick,false,0,true);
      }
      
      private function onNanovorRemoved(param1:SwarmContainerEvent) : void
      {
         _treeViewMenu.replaceTile(param1.nanovor);
         var _loc2_:* = 0;
         while(_loc2_ < _selectedSwarm.length)
         {
            if(_selectedSwarm[_loc2_].assetId == param1.nanovor.assetId)
            {
               _selectedSwarm.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_SwarmRemove",true,SoundManagerConst.soundApplicationDomain,true));
         checkSwarmEligibility();
         mcFooter.removeNanovor();
      }
      
      private function onTransferButtonClick(param1:MouseEvent) : void
      {
         if(_selectedSwarm.length < 1)
         {
            return;
         }
         mcFooter.btnRedButton.removeEventListener(MouseEvent.CLICK,onTransferButtonClick);
         _transferTimeEstimater.promptTransferTimeDialog(_selectedSwarm,ITransferTimeEstimaterConsumer(this));
      }
      
      private function onCollectionTileRollOver(param1:TreeViewMenuEvent) : void
      {
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         _swarmContainer.showCandidate(_loc2_);
         _deviceSwarmSpinner.hide();
         _showDeviceSwarmSpinner = false;
      }
      
      public function acceptTimeEstimate() : void
      {
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_TRANSFER_NANOVOR,_selectedSwarm);
      }
      
      public function open(param1:Array) : void
      {
         var _loc3_:INanovor = null;
         var _loc4_:INanovor = null;
         mcFooter.btnRedButton.addEventListener(MouseEvent.CLICK,onTransferButtonClick,false,0,true);
         resetSelectedNanovors();
         mcFooter.resetDeviceSwarmMeter();
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            _treeViewMenu.selectTileById(_loc3_.assetId);
            _treeViewMenu.getTileById(_loc3_.assetId).showNanoscopeIcon();
            _loc4_ = _treeViewMenu.getTileNanovorById(_loc3_.assetId);
            _swarmContainer.showCandidate(_loc4_);
            _swarmContainer.addCandidate();
            mcFooter.addNanovor();
         }
         _selectedSwarm = param1.slice();
         checkSwarmEligibility();
         _exitButton.open();
         this.visible = true;
         _swarmContainer.open();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceSwarmChooser>>\t" + param1);
      }
      
      private function onTreeTileClick(param1:TreeViewMenuEvent) : void
      {
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_TreeSelect",true,SoundManagerConst.soundApplicationDomain,true));
      }
      
      private function onCollectionTileRollOut(param1:TreeViewMenuEvent) : void
      {
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         _swarmContainer.hideCandidate();
         _deviceSwarmSpinner.show();
         _showDeviceSwarmSpinner = true;
      }
      
      private function onTreeTileRollOver(param1:TreeViewMenuEvent) : void
      {
      }
   }
}

import com.arkadium.virmon.battle.control.INanovor;
import com.arkadium.virmon.framework.DataManager;
import com.arkadium.virmon.framework.IVirmonData;
import com.arkadium.virmon.shared.data.INanovorFactory;
import com.smithandtinker.nanovor.debug.DebugLog;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

class SwarmChooserDataHandler extends MovieClip
{
   
   public function SwarmChooserDataHandler()
   {
      super();
   }
   
   private static function log(param1:String) : void
   {
      DebugLog.instance.log("<<SwarmChooserDataHandler>> " + param1);
   }
   
   public static function getNanovors(param1:INanovorFactory) : Array
   {
      var _loc4_:INanovor = null;
      var _loc5_:IVirmonData = null;
      var _loc2_:Array = new Array();
      var _loc3_:Array = DataManager.getInstance().getVirmonManager().getVirmonDataList();
      for each(_loc5_ in _loc3_)
      {
         _loc4_ = param1.createNanovorInstanceById(_loc5_.getAssetID());
         _loc2_.push(_loc4_);
      }
      return _loc2_;
   }
   
   public static function getTreeNames() : Dictionary
   {
      return DataManager.getInstance().getEvoManager().getTreeNames();
   }
   
   public static function getNanovorIdsInTrees() : Array
   {
      return DataManager.getInstance().getEvoManager().getNanovorIdsInTrees();
   }
}
