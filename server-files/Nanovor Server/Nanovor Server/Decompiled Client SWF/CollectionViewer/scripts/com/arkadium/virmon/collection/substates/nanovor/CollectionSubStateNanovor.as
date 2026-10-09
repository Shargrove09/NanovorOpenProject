package com.arkadium.virmon.collection.substates.nanovor
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.collection.CollectionSubStateFactory;
   import com.arkadium.virmon.collection.shared.ICollectionViewerDataHandler;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorInfoPanelComponent;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorSpotlightStageComponent;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.NickNameEditor;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenuEvent;
   import com.arkadium.virmon.shared.final.components.viewbuttons.HoloButton;
   import com.arkadium.virmon.shared.final.components.viewbuttons.ViewButtons;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChanger;
   import com.arkadium.virmon.shared.utils.substate.ISubStateChangerConsumer;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CollectionSubStateNanovor extends AbstractSubState implements ISubStateChangerConsumer
   {
      
      private static const TREEVIEW_MENU_POSITION:Point = new Point(57,123);
      
      private static const INFO_PANEL_POSITION:Point = new Point(80,316);
      
      private static const NICKNAME_EDITOR_POSITION:Point = new Point(130,358);
      
      private static const VIEW_BUTTONS_POSITION:Point = new Point(10,316);
      
      private static const NANOVOR_SPOTLIGHT_POSITION:Point = new Point(668,513);
      
      private var _dataHandler:ICollectionViewerDataHandler;
      
      private var _soundManager:ISoundManager;
      
      private var _currentNanovor:INanovor;
      
      private var _myPlayer:IPlayer;
      
      private var _panels:Dictionary;
      
      private var _nanovorSpotlightStage:NanovorSpotlightStageComponent;
      
      private var _subStateChanger:ISubStateChanger;
      
      private var _nanovorAttacksPanel:NanovorAttacksPanel;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _nanovorUIContainer:Sprite;
      
      private var _nanovorStatsPanel:NanovorStatsPanel;
      
      private var _nanovorView:MovieClip;
      
      private var _nickNameEditor:NickNameEditor;
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _nanovorSpotlightView:NanovorSpotlightView;
      
      private var _nanovorBuffController:NanovorBuffController;
      
      private var _firstClick:Boolean = true;
      
      private var _viewButtons:ViewButtons;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _parentUIContainer:Sprite;
      
      private var _nanovor:INanovor;
      
      private var _currentPanel:NanovorInfoPanelComponent;
      
      private var _tempNanovor:INanovor;
      
      private var _selectedTreeId:int;
      
      private var _openedFirstTime:Boolean = false;
      
      private var _virmonData:IVirmonData;
      
      private var _nanovorBadgesPanel:NanovorBadgesPanel;
      
      public function CollectionSubStateNanovor(param1:ISoundManager, param2:IPlayer, param3:INanovorFactory, param4:Sprite, param5:IUserProfile, param6:IServiceRequestBrokerManager, param7:IAnalyticsManager, param8:ICollectionViewerDataHandler, param9:ISubStateChanger, param10:ICharacterAssetTypeCache)
      {
         super();
         _soundManager = param1;
         _myPlayer = param2;
         _nanovorFactory = param3;
         _parentUIContainer = param4;
         _dataHandler = param8;
         _serviceRequestBrokerManager = param6;
         _analyticsManager = param7;
         _subStateChanger = param9;
         _characterAssetTypeCache = param10;
         _nanovorUIContainer = new Sprite();
         _nanovorUIContainer.visible = false;
         _nanovorUIContainer.alpha = 0;
         buildUI();
         _nanovorBuffController = new NanovorBuffController(_nanovorStatsPanel,_nanovorSpotlightView,param5,_serviceRequestBrokerManager,param7);
      }
      
      private function onViewBadgesClick(param1:Event) : void
      {
         _currentPanel = _nanovorBadgesPanel;
         updateOnPanelChange();
      }
      
      private function onNickNameUpdated(param1:CustomEvent) : void
      {
         var _loc2_:IVirmonData = IVirmonData(param1.data.virmon);
         var _loc3_:INanovor = _nanovorFactory.createNanovorInstanceById(_loc2_.getAssetID());
         _treeViewMenu.updateNanovor(_loc3_);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CollectionSubStateNanovor: " + param1);
      }
      
      private function onTreeTileClick(param1:TreeViewMenuEvent) : void
      {
         _selectedTreeId = parseInt(param1.data.treeID);
      }
      
      private function buildUI() : void
      {
         _nanovorSpotlightView = new NanovorSpotlightView(_characterAssetTypeCache);
         _nanovorSpotlightView.x = NANOVOR_SPOTLIGHT_POSITION.x;
         _nanovorSpotlightView.y = NANOVOR_SPOTLIGHT_POSITION.y;
         _nanovorSpotlightStage = new NanovorSpotlightStageComponent();
         _nanovorSpotlightStage.setContent(_nanovorSpotlightView);
         _nanovorUIContainer.addChild(_nanovorSpotlightStage);
         _nanovorStatsPanel = new NanovorStatsPanel();
         _nanovorStatsPanel.x = INFO_PANEL_POSITION.x;
         _nanovorStatsPanel.y = INFO_PANEL_POSITION.y;
         _nanovorStatsPanel.alpha = 0;
         _nanovorStatsPanel.visible = false;
         _currentPanel = _nanovorStatsPanel;
         _nanovorAttacksPanel = new NanovorAttacksPanel(_soundManager,_myPlayer);
         _nanovorAttacksPanel.x = INFO_PANEL_POSITION.x;
         _nanovorAttacksPanel.y = INFO_PANEL_POSITION.y;
         _nanovorAttacksPanel.alpha = 0;
         _nanovorAttacksPanel.visible = false;
         _nanovorBadgesPanel = new NanovorBadgesPanel();
         _nanovorBadgesPanel.x = INFO_PANEL_POSITION.x;
         _nanovorBadgesPanel.y = INFO_PANEL_POSITION.y;
         _nanovorBadgesPanel.alpha = 0;
         _nanovorBadgesPanel.visible = false;
         _viewButtons = new ViewButtons();
         _viewButtons.x = VIEW_BUTTONS_POSITION.x;
         _viewButtons.y = VIEW_BUTTONS_POSITION.y;
         _viewButtons.alpha = 0;
         _viewButtons.visible = false;
         _viewButtons.mcViewBG.alpha = 1 / 3;
         _viewButtons.mcStats.addChild(new HoloButton(HoloButton.ICON_S,"STATS"));
         _viewButtons.mcStats.addEventListener(MouseEvent.CLICK,onViewStatsClick,false,0,true);
         _viewButtons.mcAttacks.addChild(new HoloButton(HoloButton.ICON_A,"ATTACKS"));
         _viewButtons.mcAttacks.addEventListener(MouseEvent.CLICK,onViewAttacksClick,false,0,true);
         _viewButtons.mcAttacks.alpha = 1 / 2;
         _viewButtons.mcPedigrees.addChild(new HoloButton(HoloButton.ICON_PEDIGREE,"BADGES"));
         _viewButtons.mcPedigrees.addEventListener(MouseEvent.CLICK,onViewBadgesClick,false,0,true);
         _viewButtons.mcPedigrees.alpha = 1 / 2;
         _panels = new Dictionary(true);
         _panels[_nanovorAttacksPanel] = _viewButtons.mcAttacks;
         _panels[_nanovorStatsPanel] = _viewButtons.mcStats;
         _panels[_nanovorBadgesPanel] = _viewButtons.mcPedigrees;
         _nanovorUIContainer.addChild(_viewButtons);
         createTreeViewMenu(_dataHandler.evoTreeData,_dataHandler.treeNames);
         _nickNameEditor = new NickNameEditor(_serviceRequestBrokerManager);
         _nanovorUIContainer.addChild(_nickNameEditor);
         _nickNameEditor.x = NICKNAME_EDITOR_POSITION.x;
         _nickNameEditor.y = NICKNAME_EDITOR_POSITION.y;
         _nickNameEditor.addEventListener(NickNameEditor.UPDATED,onNickNameUpdated,false,0,true);
      }
      
      private function onCollectionTileRollOut(param1:TreeViewMenuEvent) : void
      {
      }
      
      private function onNanovorChanged(param1:CustomEvent) : void
      {
         log("onNanovorChanged()");
         var _loc2_:IVirmonData = IVirmonData(param1.data.virmon);
         var _loc3_:INanovor = _nanovorFactory.createNanovorInstanceById(_loc2_.getAssetID());
         _treeViewMenu.updateNanovor(_loc3_);
         _nanovorAttacksPanel.setNanovor(_loc2_,_dataHandler.treeNames[_selectedTreeId]);
         _nanovorBadgesPanel.setNanovor(_loc2_,_dataHandler.treeNames[_selectedTreeId]);
         _nanovorStatsPanel.setNanovor(_loc2_,_dataHandler.treeNames[_selectedTreeId]);
      }
      
      private function trackView() : void
      {
         if(_currentPanel == _nanovorAttacksPanel)
         {
            _analyticsManager.trackView(View.COLLECTION_NANOVOR_ATTACKS);
         }
         else if(_currentPanel == _nanovorBadgesPanel)
         {
            _analyticsManager.trackView(View.COLLECTION_NANOVOR_BADGES);
         }
         else if(_currentPanel == _nanovorStatsPanel)
         {
            _analyticsManager.trackView(View.COLLECTION_NANOVOR_STATS);
         }
      }
      
      private function onCollectionTileClick(param1:TreeViewMenuEvent) : void
      {
         if(_nanovorBuffController.pendingChanges)
         {
            _tempNanovor = INanovor(param1.data.nanovor);
            _treeViewMenu.replaceTile(_tempNanovor);
            CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,"UNSAVED CHANGES","You have made changes to your Nanovor\'s stats.  If you switch Nanovor now, these changes will go unsaved.  Are you sure you want to change Nanovor?",0,onSwitchNanovorConfirmed,onSwitchNanovorCancelled);
            return;
         }
         if(_firstClick)
         {
            Tweener.addTween(_nanovorStatsPanel,{
               "_autoAlpha":1,
               "time":1
            });
            Tweener.addTween(_viewButtons,{
               "_autoAlpha":1,
               "time":1
            });
            _firstClick = false;
         }
         switchNanovor(param1.data.nanovor);
      }
      
      private function canLeaveWithoutDialog() : Boolean
      {
         if(_nanovorBuffController.pendingChanges)
         {
            CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,"UNSAVED CHANGES","You have made changes to your Nanovor\'s stats.  If you leave now, these changes will go unsaved.  Are you sure you want to exit?",0,onUnsetStateConfirmed,onUnsetStateCancelled);
            return false;
         }
         return true;
      }
      
      private function updateOnPanelChange() : void
      {
         var _loc1_:NanovorInfoPanelComponent = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         for(_loc3_ in _panels)
         {
            _loc1_ = NanovorInfoPanelComponent(_loc3_);
            _loc2_ = MovieClip(_panels[_loc3_]);
            if(_loc1_ == _currentPanel)
            {
               _loc1_.alpha = 0;
               _nanovorUIContainer.addChild(_loc1_);
               _nanovorUIContainer.swapChildren(_loc1_,_nickNameEditor);
               Tweener.addTween(_loc1_,{
                  "_autoAlpha":1,
                  "time":0.35,
                  "transition":"easeInOutQuad"
               });
            }
            else
            {
               Tweener.addTween(_loc1_,{
                  "_autoAlpha":0,
                  "time":0.35,
                  "transition":"easeInOutQuad",
                  "onComplete":removePanel,
                  "onCompleteParams":[_loc1_]
               });
            }
            _loc2_.alpha = _loc1_ == _currentPanel ? 1 : 0.5;
         }
         trackView();
      }
      
      public function preSelectNanovor(param1:ICollectionPreSelectData) : void
      {
         if(null == param1)
         {
            return;
         }
         _openedFirstTime = true;
         if(null != param1.preSelectNanovor)
         {
            _treeViewMenu.autoSelectByAssetId(param1.preSelectNanovor.assetId);
         }
         else if(0 != param1.preSelectAssetTypeId)
         {
            _treeViewMenu.autoSelectByAssetTypeId(param1.preSelectAssetTypeId);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CollectionSubStateNanovor: " + param1);
      }
      
      private function onCollectionTileRollOver(param1:TreeViewMenuEvent) : void
      {
      }
      
      private function onSwitchNanovorCancelled(param1:Object) : void
      {
         onViewStatsClick();
      }
      
      public function destroy() : void
      {
         if(null != _nanovorBuffController)
         {
            _nanovorBuffController.destroy();
         }
         if(null != _treeViewMenu)
         {
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut);
            _treeViewMenu.removeEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick);
            _treeViewMenu.destroy();
         }
         if(_viewButtons != null)
         {
            _viewButtons.mcStats.removeEventListener(MouseEvent.CLICK,onViewStatsClick);
            _viewButtons.mcAttacks.removeEventListener(MouseEvent.CLICK,onViewAttacksClick);
            _viewButtons.mcPedigrees.removeEventListener(MouseEvent.CLICK,onViewBadgesClick);
         }
         if(null != _nanovorStatsPanel)
         {
            _nanovorStatsPanel.destroy();
         }
         if(null != _nanovorAttacksPanel)
         {
            _nanovorAttacksPanel.destroy();
         }
         if(null != _nanovorBadgesPanel)
         {
            _nanovorBadgesPanel.destroy();
         }
         if(null != _nanovorSpotlightView)
         {
            _nanovorSpotlightView.destroy();
         }
      }
      
      override public function setSubState() : void
      {
         updateOnPanelChange();
         _subStateChanger.addSubStateChangerConsumer(this);
         _parentUIContainer.addChild(_nanovorUIContainer);
         Tweener.removeTweens(_nanovorUIContainer);
         Tweener.addTween(_nanovorUIContainer,{
            "_autoAlpha":1,
            "time":0.5,
            "transition":"easeInExpo"
         });
         trackView();
         if(!_openedFirstTime)
         {
            _openedFirstTime = true;
            _treeViewMenu.openFirst();
         }
      }
      
      public function handleSubStateChangeRequest(param1:String) : void
      {
         unsetState(param1);
      }
      
      private function switchNanovor(param1:INanovor) : void
      {
         if(_currentNanovor != null && _currentNanovor != param1)
         {
            _treeViewMenu.replaceTile(_currentNanovor);
         }
         _currentNanovor = param1;
         _virmonData = DataManager.getInstance().getVirmonManager().getVirmonData(param1.assetId);
         _nanovor = param1;
         _nickNameEditor.setName(_virmonData);
         _nanovorBadgesPanel.clearBadges();
         Tweener.addTween(_nanovorSpotlightStage,{
            "_autoAlpha":0,
            "time":0.25,
            "transition":"easeInOutQuad"
         });
         _nanovorBuffController.setNanovor(_virmonData,_dataHandler.treeNames[_selectedTreeId]);
         _nanovorBadgesPanel.setNanovor(_virmonData,_dataHandler.treeNames[_selectedTreeId]);
         _nanovorAttacksPanel.setNanovor(_virmonData,_dataHandler.treeNames[_selectedTreeId]);
         _nanovorAttacksPanel.setNanovorAttacks(_nanovor);
         _nanovorSpotlightView.enterNanovor(_virmonData.getAssetTypeID(),_nanovor.isFacingRight);
         Tweener.addTween(_currentPanel,{
            "_autoAlpha":1,
            "time":0.75,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(_nanovorSpotlightStage,{
            "_autoAlpha":1,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
         trackView();
      }
      
      public function get nanovorBuffController() : INanovorBuffController
      {
         return INanovorBuffController(_nanovorBuffController);
      }
      
      private function onViewAttacksClick(param1:Event) : void
      {
         _currentPanel = _nanovorAttacksPanel;
         updateOnPanelChange();
      }
      
      private function removePanel(param1:DisplayObject) : void
      {
         if(null != param1 && null != param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function unsetState(param1:String, param2:Object = null, param3:Boolean = false) : void
      {
         if(param3 || canLeaveWithoutDialog())
         {
            _subStateChanger.removeSubStateChangerConsumer(this);
            Tweener.removeTweens(_nanovorUIContainer);
            Tweener.addTween(_nanovorUIContainer,{
               "_autoAlpha":0,
               "time":0.5,
               "transition":"easeOutExpo",
               "onComplete":removePanelAfterFade
            });
            _subStateController.changeSubState(param1,param2);
            _subStateChanger.onSubStateChange(param1);
         }
      }
      
      private function onSwitchNanovorConfirmed(param1:Object) : void
      {
         _treeViewMenu.selectTile(_tempNanovor);
         switchNanovor(_tempNanovor);
      }
      
      private function removePanelAfterFade() : void
      {
         if(null != _nanovorUIContainer.parent)
         {
            _nanovorUIContainer.parent.removeChild(_nanovorUIContainer);
         }
      }
      
      private function onUnsetStateCancelled(param1:Object) : void
      {
      }
      
      public function get currentNanovor() : INanovor
      {
         return _currentNanovor;
      }
      
      private function onViewStatsClick(param1:Event = null) : void
      {
         _currentPanel = _nanovorStatsPanel;
         updateOnPanelChange();
      }
      
      private function createTreeViewMenu(param1:Array, param2:Dictionary) : void
      {
         var _loc5_:INanovor = null;
         var _loc3_:Array = _dataHandler.virmonList;
         var _loc4_:Array = new Array();
         var _loc6_:* = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc5_ = _nanovorFactory.createNanovorInstanceById(_loc3_[_loc6_].getAssetID());
            _loc5_.armor = IVirmonData(_loc3_[_loc6_]).getArmor();
            _loc5_.speed = IVirmonData(_loc3_[_loc6_]).getSpeed();
            _loc5_.health = IVirmonData(_loc3_[_loc6_]).getHealth();
            _loc5_.strength = IVirmonData(_loc3_[_loc6_]).getStrength();
            _loc4_.push(_loc5_);
            _loc6_++;
         }
         _treeViewMenu = new TreeViewMenu(_nanovorFactory,param1,_loc4_,param2);
         _treeViewMenu.x = TREEVIEW_MENU_POSITION.x;
         _treeViewMenu.y = TREEVIEW_MENU_POSITION.y;
         _nanovorUIContainer.addChild(_treeViewMenu);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOVER,onCollectionTileRollOver,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_ROLLOUT,onCollectionTileRollOut,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick,false,0,true);
      }
      
      private function onUnsetStateConfirmed(param1:Object) : void
      {
         _nanovorBuffController.setNanovor(_nanovorBuffController.currentVirmonData,_nanovorBuffController.currentTree);
         unsetState(CollectionSubStateFactory.COLLECTION_SUBSTATE_EMS,null,true);
      }
   }
}

