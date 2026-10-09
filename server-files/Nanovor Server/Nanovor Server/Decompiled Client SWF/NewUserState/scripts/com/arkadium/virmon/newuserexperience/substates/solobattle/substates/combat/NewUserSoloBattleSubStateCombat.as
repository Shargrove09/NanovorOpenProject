package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.combat
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatGamePanel;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatGamePanelConsumer;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.NewUserSoloBattleSubStates;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class NewUserSoloBattleSubStateCombat extends AbstractSubState implements ICombatGamePanelConsumer, IChainLoaderConsumer
   {
      
      private static const COMBAT_GAME_SWF:String = "BattleCombatPanel.swf";
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _battleGameService:IBattleGameService;
      
      private var _uiContainer:Sprite;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var _combatGamePanel:ICombatGamePanel;
      
      private var _battleData:IBattleData;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _userProfile:IUserProfile;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:ChainLoader;
      
      private var _selectedSwarmIds:Array;
      
      private var _soundManager:ISoundManager;
      
      public function NewUserSoloBattleSubStateCombat(param1:ISoundManager, param2:IPlayerFactory, param3:Sprite, param4:IBattleGameService, param5:IBattleData, param6:IBattleHeaderController, param7:IUserProfile, param8:IBuddyRPManager, param9:ICharacterAssetTypeCache, param10:IOverlayAssetRetriever)
      {
         super();
         _soundManager = param1;
         _playerFactory = param2;
         _uiContainer = param3;
         _battleGameService = param4;
         _battleData = param5;
         _battleHeaderController = param6;
         _userProfile = param7;
         _characterAssetTypeCache = param9;
         _overlayAssetRetriever = param10;
      }
      
      public function handleGameOver(param1:BattleSubStateGameOverData) : void
      {
         _subStateController.changeSubState(NewUserSoloBattleSubStates.SUB_STATE_SWARM_GAME_OVER,param1);
      }
      
      public function destroy() : void
      {
         var _loc1_:Sprite = null;
         if(null != _combatGamePanel)
         {
            _combatGamePanel.destroy();
            _loc1_ = _combatGamePanel as Sprite;
            if(null != _loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _combatGamePanel = null;
         }
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      override public function setSubState() : void
      {
         _battleHeaderController.setCombatMode();
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(COMBAT_GAME_SWF,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function setSelectedSwarmIds(param1:Array) : void
      {
         _selectedSwarmIds = param1;
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _combatGamePanel = (param1.getLoadedAsset(SWFLoadee.NAME + COMBAT_GAME_SWF) as MovieClip).panel as ICombatGamePanel;
         if(null == _combatGamePanel)
         {
            throw new Error("CombatGamePanel failed to load.");
         }
         _uiContainer.addChild(_combatGamePanel as Sprite);
         _chainLoader.destroy();
         _chainLoader = null;
         _combatGamePanel.init(_soundManager,_playerFactory,_battleGameService,_battleData,ICombatGamePanelConsumer(this),_selectedSwarmIds,_battleHeaderController,_userProfile,_buddyRPManager,_characterAssetTypeCache,_overlayAssetRetriever);
      }
   }
}

