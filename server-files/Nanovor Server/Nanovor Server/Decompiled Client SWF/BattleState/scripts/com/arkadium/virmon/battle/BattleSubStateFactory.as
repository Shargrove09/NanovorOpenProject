package com.arkadium.virmon.battle
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.substates.combatgame.BattleSubStateCombatGame;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOver;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.battle.substates.swarmchooser.BattleSubStateSwarmChooser;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.CharacterAssetTypeCache;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.IStateManager;
   import flash.display.DisplayObjectContainer;
   
   public class BattleSubStateFactory implements ISubStateFactory
   {
      
      public static const SUB_STATE_SWARM_CHOOSER:String = "subStateSwarmChooser";
      
      public static const SUB_STATE_COMBAT_GAME:String = "subStateCombatGame";
      
      public static const SUB_STATE_GAMEOVER:String = "subStateGameOver";
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _gameOver:BattleSubStateGameOver;
      
      private var _swarmChooser:BattleSubStateSwarmChooser;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _showGameOverNMP:Boolean;
      
      private var _battleGameService:IBattleGameService;
      
      private var _evoManager:IEvoManager;
      
      private var _battleExiter:IBattleExiter;
      
      private var _userProfile:IUserProfile;
      
      private var _battleData:IBattleData;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _combatGame:BattleSubStateCombatGame;
      
      private var _emManager:IEMManager;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _soundManager:ISoundManager;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _showGameOverBadges:Boolean;
      
      private var _currentState:IState;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _stateManager:IStateManager;
      
      public function BattleSubStateFactory(param1:IStateManager, param2:IAnalyticsManager, param3:ISoundManager, param4:INanovorFactory, param5:IPlayerFactory, param6:IEvoManager, param7:IBadgeManager, param8:IEMManager, param9:IUserProfile, param10:DisplayObjectContainer, param11:IBattleGameService, param12:IBattleData, param13:IBattleHeaderController, param14:IBattleExiter, param15:IState, param16:IBuddyRPManager, param17:Boolean = true, param18:Boolean = true)
      {
         super();
         _stateManager = param1;
         _analyticsManager = param2;
         _soundManager = param3;
         _nanovorFactory = param4;
         _playerFactory = param5;
         _evoManager = param6;
         _badgeManager = param7;
         _emManager = param8;
         _userProfile = param9;
         _uiContainer = param10;
         _battleGameService = param11;
         _battleHeaderController = param13;
         _battleData = param12;
         _battleExiter = param14;
         _currentState = param15;
         _buddyRPManager = param16;
         _userProfile = param9;
         _showGameOverBadges = param17;
         _showGameOverNMP = param18;
         _characterAssetTypeCache = new CharacterAssetTypeCache(Managers.assetRetrieverManager.characterAssetRetriever);
         MemoryWatcher.registerObject(this,"BattleSubstateFactory");
      }
      
      public function destroy() : void
      {
         if(null != _swarmChooser)
         {
            _swarmChooser.destroy();
            _swarmChooser = null;
         }
         if(null != _combatGame)
         {
            _combatGame.destroy();
            _combatGame = null;
         }
         if(null != _gameOver)
         {
            _gameOver.destroy();
            _gameOver = null;
         }
         Utils.clearAllChildren(_uiContainer);
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         switch(param1)
         {
            case SUB_STATE_SWARM_CHOOSER:
               _swarmChooser = new BattleSubStateSwarmChooser(_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile,_uiContainer,_battleGameService,_battleData,_battleHeaderController,_currentState,_battleExiter,_buddyRPManager,_characterAssetTypeCache);
               MemoryWatcher.registerObject(_swarmChooser,"SwarmChooserSubState");
               return _swarmChooser;
            case SUB_STATE_COMBAT_GAME:
               _combatGame = new BattleSubStateCombatGame(_soundManager,_playerFactory,_uiContainer,_battleGameService,_battleHeaderController,_battleData,param2 as Array,_battleExiter,_userProfile,_buddyRPManager,_characterAssetTypeCache,Managers.assetRetrieverManager.overlayAssetRetriever);
               MemoryWatcher.registerObject(_combatGame,"CombatGameSubState");
               return _combatGame;
            case SUB_STATE_GAMEOVER:
               _gameOver = new BattleSubStateGameOver(_nanovorFactory,_stateManager,_analyticsManager,_soundManager,_combatGame.roundControllerNanovorChooser,_uiContainer,_battleExiter,param2 as BattleSubStateGameOverData,_showGameOverBadges,_showGameOverNMP,_battleGameService,_battleData);
               MemoryWatcher.registerObject(_gameOver,"GameOverSubState");
               return _gameOver;
            default:
               throw new Error("Unknown subStateType: " + param1);
         }
      }
   }
}

