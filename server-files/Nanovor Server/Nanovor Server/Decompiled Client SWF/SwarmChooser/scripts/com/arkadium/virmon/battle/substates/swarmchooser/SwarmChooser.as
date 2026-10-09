package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.help.swarmchooser.IHelpSwarmChooser;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenuEvent;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.shared.widgets.wait.WaitWidget;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol144")]
   public class SwarmChooser extends Sprite implements ISwarmChooser
   {
      
      private static const EMPTY_SWARM_TITLE:String = "No Swarm Selected";
      
      private static const EMPTY_SWARM_TEXT:String = "You must select at least 1 Nanovor before going to battle.";
      
      private static const TREEVIEW_MENU_POSITION:Point = new Point(57,122);
      
      private static const METER_POSITION:Point = new Point(117,712);
      
      private static const FOOTER_POSITION:Point = new Point(0,703);
      
      private static const WAITWIDGET_POSITION:Point = new Point(512,315);
      
      private var _swarmContainer:ISwarmContainer;
      
      private var _helpHandler:IHelpSwarmChooser;
      
      private var _swarmMeter:SwarmMeter;
      
      private var _selectedSwarm:Array;
      
      private var _firstGoToBattle:Boolean;
      
      private var _currentSwarmValue:int;
      
      private var _waitWidget:WaitWidget;
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _firstTreeSelect:Boolean;
      
      private var _firstNanovorSelect:Boolean;
      
      private var _consumer:ISwarmChooserConsumer;
      
      private var _allottedSwarmValue:int;
      
      private var _swarmFooter:SwarmFooter;
      
      public function SwarmChooser()
      {
         super();
         _currentSwarmValue = 0;
         _selectedSwarm = new Array();
         _firstTreeSelect = true;
         _firstNanovorSelect = true;
         _firstGoToBattle = true;
      }
      
      public function destroy() : void
      {
         if(null != _treeViewMenu)
         {
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened);
            _treeViewMenu.destroy();
            _treeViewMenu = null;
         }
         if(null != _swarmMeter)
         {
            _swarmMeter.destroy();
            _swarmMeter = null;
         }
         if(null != _swarmContainer)
         {
            _swarmContainer.removeEventListener(SwarmContainerEvent.NANOVOR_REMOVED,onNanovorRemoved);
            _swarmContainer.destroy();
            _swarmContainer = null;
         }
         if(null != _swarmFooter)
         {
            _swarmFooter.removeEventListener(SwarmFooterEvent.TIMER_COMPLETE,onSwarmTimerComplete);
            _swarmFooter.removeEventListener(SwarmFooterEvent.STARTBATTLE_CLICK,onStartBattleClick);
            _swarmFooter.destroy();
            _swarmFooter = null;
         }
         Managers.stateManager.handleHelp("",null);
         _consumer = null;
         _selectedSwarm = null;
         Utils.clearAllChildren(this);
      }
      
      private function createSwarmContainer(param1:ISwarmContainerFactory) : void
      {
         _swarmContainer = param1.createSwarmContainer();
         _swarmContainer.addEventListener(SwarmContainerEvent.NANOVOR_REMOVED,onNanovorRemoved);
         _swarmContainer.mode = SwarmContainer.MODE_ATTACKS;
         (_swarmContainer as DisplayObject).y = 320;
         this.addChild(_swarmContainer as DisplayObject);
         _swarmContainer.open();
         MemoryWatcher.registerObject(_swarmContainer,"SwarmContainer");
      }
      
      public function setHelpHandler(param1:IHelpSwarmChooser) : void
      {
         _helpHandler = param1;
      }
      
      private function createSwarmMeter() : void
      {
         _swarmMeter = new SwarmMeter(_allottedSwarmValue);
         addChild(_swarmMeter);
         _swarmMeter.x = METER_POSITION.x;
         _swarmMeter.y = METER_POSITION.y;
         MemoryWatcher.registerObject(_swarmMeter,"SwarmMeter");
      }
      
      private function setWaitWidget() : void
      {
         _waitWidget = new WaitWidget();
         addChild(_waitWidget);
         _waitWidget.x = WAITWIDGET_POSITION.x;
         _waitWidget.y = WAITWIDGET_POSITION.y;
      }
      
      private function checkSwarmEligibility() : void
      {
         if(_treeViewMenu.checkTileEligibility(_allottedSwarmValue - _currentSwarmValue))
         {
            _swarmMeter.mode = SwarmMeter.MODE_FILLING;
            _swarmContainer.swarmIsNotFull();
         }
         else
         {
            _swarmMeter.mode = SwarmMeter.MODE_GO_TO_BATTLE;
            _swarmContainer.swarmIsFull();
            if(_firstGoToBattle)
            {
               _firstGoToBattle = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showGoToBattleHelp(2000);
               }
            }
         }
      }
      
      public function init(param1:INanovorFactory, param2:int, param3:int, param4:ISwarmChooserConsumer, param5:ISwarmContainerFactory) : void
      {
         _nanovorFactory = param1;
         _allottedSwarmValue = param2;
         _consumer = param4;
         Managers.stateManager.handleHelp(Const.HELP_SWARMCHOOSER,this);
         createSwarmContainer(param5);
         createTreeViewMenu();
         createSwarmMeter();
         createSwarmFooter(param3);
      }
      
      private function prepareForWaitScreen() : void
      {
         _treeViewMenu.hide();
         _swarmContainer.prepareForWaitScreen();
         _swarmMeter.hide();
         setWaitWidget();
      }
      
      private function onCollectionTileClick(param1:TreeViewMenuEvent) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_CharacterSelect",true,SoundManagerConst.soundApplicationDomain,true));
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         _swarmContainer.addCandidate();
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_CharacterSlide",true,SoundManagerConst.soundApplicationDomain,true));
         _currentSwarmValue += _loc2_.swarmValue;
         _swarmMeter.sv = _currentSwarmValue;
         checkSwarmEligibility();
         _selectedSwarm.push(_loc2_.assetId);
         if(_firstNanovorSelect)
         {
            _firstNanovorSelect = false;
            if(Boolean(_helpHandler))
            {
               _helpHandler.showAddNanovorHelp(2000);
            }
         }
      }
      
      private function createSwarmFooter(param1:int) : void
      {
         _swarmFooter = new SwarmFooter();
         addChild(_swarmFooter);
         _swarmFooter.x = FOOTER_POSITION.x;
         _swarmFooter.y = FOOTER_POSITION.y;
         _swarmFooter.initTimer(param1);
         _swarmFooter.startTimer();
         _swarmFooter.addEventListener(SwarmFooterEvent.STARTBATTLE_CLICK,onStartBattleClick,false,0,true);
         _swarmFooter.addEventListener(SwarmFooterEvent.TIMER_COMPLETE,onSwarmTimerComplete,false,0,true);
         MemoryWatcher.registerObject(_swarmFooter,"SwarmFooter");
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<SwarmChooser>> " + param1);
      }
      
      private function onCollectionOpened(param1:TreeViewMenuEvent) : void
      {
         _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened);
         _swarmContainer.showSelectNanovor();
      }
      
      private function onNanovorRemoved(param1:SwarmContainerEvent) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_SwarmRemove",true,SoundManagerConst.soundApplicationDomain,true));
         var _loc2_:INanovor = param1.nanovor;
         _treeViewMenu.replaceTile(_loc2_);
         _currentSwarmValue -= _loc2_.swarmValue;
         _swarmMeter.sv = _currentSwarmValue;
         checkSwarmEligibility();
         _selectedSwarm.splice(_selectedSwarm.indexOf(_loc2_.assetId),1);
      }
      
      private function onCollectionTileRollOver(param1:TreeViewMenuEvent) : void
      {
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         _swarmContainer.showCandidate(_loc2_);
      }
      
      private function onSwarmTimerComplete(param1:SwarmFooterEvent) : *
      {
         Managers.analyticsManager.trackAction(Action.BATTLE_SWARMCHOOSER_CLOCK_ZERO);
         _swarmFooter.removeEventListener(SwarmFooterEvent.TIMER_COMPLETE,onSwarmTimerComplete);
         _swarmFooter.removeEventListener(SwarmFooterEvent.STARTBATTLE_CLICK,onStartBattleClick);
         if(_selectedSwarm.length > 0)
         {
            prepareForWaitScreen();
            _consumer.handleSwarmSelected(_selectedSwarm);
         }
         else
         {
            Managers.analyticsManager.trackAction(Action.BATTLE_SWARMCHOOSER_NO_NANOVOR);
            _consumer.handleTimeOut();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SwarmChooser>>\t" + param1);
      }
      
      public function reset() : void
      {
         _swarmFooter.stopTimer();
         _swarmFooter.removeEventListener(SwarmFooterEvent.TIMER_COMPLETE,onSwarmTimerComplete);
      }
      
      private function onTreeTileClick(param1:TreeViewMenuEvent) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Swarm_TreeSelect",true,SoundManagerConst.soundApplicationDomain,true));
         if(_firstTreeSelect)
         {
            _firstTreeSelect = false;
            if(Boolean(_helpHandler))
            {
               _helpHandler.showNanovorSelectHelp(_treeViewMenu,2000);
            }
         }
      }
      
      private function onStartBattleClick(param1:SwarmFooterEvent) : *
      {
         if(_selectedSwarm.length > 0)
         {
            _swarmFooter.removeEventListener(SwarmFooterEvent.TIMER_COMPLETE,onSwarmTimerComplete);
            _swarmFooter.removeEventListener(SwarmFooterEvent.STARTBATTLE_CLICK,onStartBattleClick);
            prepareForWaitScreen();
            _swarmFooter.btnRedButton.enabled = false;
            _swarmContainer.isSwarmSelected = true;
            _consumer.handleSwarmSelected(_selectedSwarm);
            if(Boolean(_helpHandler))
            {
               _helpHandler.destroy();
            }
         }
         else
         {
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,EMPTY_SWARM_TITLE,EMPTY_SWARM_TEXT,0);
            _swarmFooter.btnRedButton.enabled = true;
         }
      }
      
      private function onCollectionTileRollOut(param1:TreeViewMenuEvent) : void
      {
         var _loc2_:INanovor = param1.data.nanovor as INanovor;
         _swarmContainer.hideCandidate();
      }
      
      private function createTreeViewMenu() : void
      {
         log("createTreeViewMenu()");
         var _loc1_:Array = DataManager.getInstance().getVirmonManager().getVirmonDataList();
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_.push(_nanovorFactory.createNanovorInstanceById(_loc1_[_loc3_].getAssetID()));
            _loc3_++;
         }
         var _loc4_:Array = DataManager.getInstance().getEvoManager().getNanovorIdsInTrees();
         var _loc5_:Dictionary = DataManager.getInstance().getEvoManager().getTreeNames();
         log("nanovorsIdsInTrees.length: " + _loc4_.length);
         log("nanovors.length: " + _loc2_.length);
         _treeViewMenu = new TreeViewMenu(_nanovorFactory,_loc4_,_loc2_,_loc5_);
         _treeViewMenu.x = TREEVIEW_MENU_POSITION.x;
         _treeViewMenu.y = TREEVIEW_MENU_POSITION.y;
         this.addChild(_treeViewMenu);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTION_OPENED,onCollectionOpened,false,0,true);
         if(Boolean(_helpHandler))
         {
            _helpHandler.showTreeSelectHelp(_treeViewMenu,3000);
         }
         MemoryWatcher.registerObject(_treeViewMenu,"TreeViewMenu");
      }
   }
}

