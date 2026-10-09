package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.BattleSubStateFactory;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.NanovorBadgeLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class BattleSubStateCombatGame extends AbstractSubState implements IChainLoaderConsumer, ICombatGamePanelConsumer
   {
      
      private static const COMBAT_GAME_SWF:String = "BattleCombatPanel.swf";
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _battleGameService:IBattleGameService;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var _userProfile:IUserProfile;
      
      private var _battleData:IBattleData;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _combatGamePanel:ICombatGamePanel;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:IChainLoader;
      
      private var _selectedSwarmIds:Array;
      
      private var _soundManager:ISoundManager;
      
      public function BattleSubStateCombatGame(param1:ISoundManager, param2:IPlayerFactory, param3:DisplayObjectContainer, param4:IBattleGameService, param5:IBattleHeaderController, param6:IBattleData, param7:Array, param8:IBattleExiter, param9:IUserProfile, param10:IBuddyRPManager, param11:ICharacterAssetTypeCache, param12:IOverlayAssetRetriever)
      {
         super();
         _soundManager = param1;
         _playerFactory = param2;
         _uiContainer = param3;
         _battleGameService = param4;
         _battleHeaderController = param5;
         _battleData = param6;
         _selectedSwarmIds = param7;
         _userProfile = param9;
         _buddyRPManager = param10;
         _characterAssetTypeCache = param11;
         _overlayAssetRetriever = param12;
      }
      
      public function handleGameOver(param1:BattleSubStateGameOverData) : void
      {
         log("handleGameOver() - gameOverSubStateData null? " + Boolean(null == param1));
         if(null == param1)
         {
            Managers.stateManager.setState(StateType.HOME);
         }
         else
         {
            _subStateController.changeSubState(BattleSubStateFactory.SUB_STATE_GAMEOVER,param1);
         }
      }
      
      public function destroy() : void
      {
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
         if(null != _combatGamePanel)
         {
            _combatGamePanel.destroy();
            _combatGamePanel = null;
         }
      }
      
      override public function setSubState() : void
      {
         var _loc3_:String = null;
         _battleHeaderController.setCombatMode();
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(COMBAT_GAME_SWF,_loc1_));
         for each(_loc3_ in _selectedSwarmIds)
         {
            _loc2_.add(new NanovorBadgeLoadee(DataManager.getInstance().getVirmonManager(),_loc3_));
         }
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function get roundControllerNanovorChooser() : IRoundControllerNanovorChooser
      {
         return _combatGamePanel.roundControllerNanovorChooser;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleSubStateCombatGame>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         log("handleChainLoaderComplete() - preloading badges should be complete");
         _combatGamePanel = (param1.getLoadedAsset(SWFLoadee.NAME + COMBAT_GAME_SWF) as MovieClip).panel as ICombatGamePanel;
         if(null == _combatGamePanel)
         {
            throw new Error("CombatGamePanel failed to load.");
         }
         _uiContainer.addChild(_combatGamePanel as DisplayObject);
         _combatGamePanel.init(_soundManager,_playerFactory,_battleGameService,_battleData,ICombatGamePanelConsumer(this),_selectedSwarmIds,_battleHeaderController,_userProfile,_buddyRPManager,_characterAssetTypeCache,_overlayAssetRetriever);
      }
   }
}

