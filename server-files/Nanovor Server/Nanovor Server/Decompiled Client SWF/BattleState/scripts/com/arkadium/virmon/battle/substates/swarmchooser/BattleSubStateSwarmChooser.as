package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.battle.IGameSwarmSelectedHandler;
   import com.arkadium.communications.handlers.battle.IPlayerQuitGameHandler;
   import com.arkadium.communications.handlers.battle.IReadyForTurnHandler;
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.BattleSubStateFactory;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class BattleSubStateSwarmChooser extends AbstractSubState implements ISwarmContainerFactory, ISwarmChooserConsumer, IChainLoaderConsumer, IReadyForTurnHandler, IGameSwarmSelectedHandler, IPlayerQuitGameHandler
   {
      
      private static const SWARM_CHOOSER_SWF:String = "SwarmChooser.swf";
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _swarmChooser:ISwarmChooser;
      
      private var _battleExiter:IBattleExiter;
      
      private var _battleGameService:IBattleGameService;
      
      private var _evoManager:IEvoManager;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _userProfile:IUserProfile;
      
      private var _battleData:IBattleData;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private var _selectedSwarmIds:Array;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:ChainLoader;
      
      private var _currentState:IState;
      
      public function BattleSubStateSwarmChooser(param1:INanovorFactory, param2:IPlayerFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile, param7:DisplayObjectContainer, param8:IBattleGameService, param9:IBattleData, param10:IBattleHeaderController, param11:IState, param12:IBattleExiter, param13:IBuddyRPManager, param14:ICharacterAssetTypeCache)
      {
         super();
         _nanovorFactory = param1;
         _playerFactory = param2;
         _evoManager = param3;
         _badgeManager = param4;
         _emManager = param5;
         _userProfile = param6;
         _uiContainer = param7;
         _battleGameService = param8;
         _battleData = param9;
         _battleHeaderController = param10;
         _currentState = param11;
         _battleExiter = param12;
         _buddyRPManager = param13;
         _characterAssetTypeCache = param14;
         _battleGameService.addGameSwarmSelectedHandler(IGameSwarmSelectedHandler(this));
         _battleGameService.addPlayerQuitGameHandler(IPlayerQuitGameHandler(this));
      }
      
      public function createSwarmContainer() : ISwarmContainer
      {
         return new SwarmContainer(_characterAssetTypeCache,_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile);
      }
      
      public function handleReadyForTurn(param1:String, param2:int, param3:Boolean) : void
      {
         _battleGameService.removeReadyForTurnHandler(IReadyForTurnHandler(this));
         if(null == _selectedSwarmIds)
         {
            throw new Error("Current selected swarm is null");
         }
         destroy();
         _subStateController.changeSubState(BattleSubStateFactory.SUB_STATE_COMBAT_GAME,_selectedSwarmIds);
      }
      
      public function handleGameSwarmSelected(param1:String, param2:int, param3:String, param4:int) : void
      {
         log("handleGameSwarmSelected() player: " + param3 + " selected " + param2.toString() + " nanovors.");
         var _loc5_:int = getPlayerIndexById(param4);
         if(_loc5_ == -1)
         {
            return;
         }
         var _loc6_:Boolean = false;
         if(_loc5_ > 1 && _loc5_ == _battleData.playersInBattle.length - 1)
         {
            _loc6_ = true;
         }
         _battleHeaderController.playerSwarmSelected(param4,param2,_loc6_);
      }
      
      private function handleDialogBoxClose(param1:Object) : void
      {
         log("handleDialogBoxClose()");
         _battleExiter.exitBattle();
      }
      
      public function handlePlayerQuitGame(param1:int, param2:String) : void
      {
         var _loc3_:String = "User " + param2.toUpperCase() + " has left the game";
         var _loc4_:IBuddyData = _buddyRPManager.getBuddy(param1);
         if(null != _loc4_ && _loc4_.Status <= -1)
         {
            _loc3_ += ", and has gone offline.";
         }
         else
         {
            _loc3_ += ".";
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Player Left Battle",_loc3_,10,null,null,null,CommonDialogBox.GenericTimeoutKill);
         _battleData.removePlayerByName(param2);
         _battleHeaderController.removePlayerAvatar(param1,_battleData.playersInBattle.length);
         if(_battleData.playersInBattle.length < 2)
         {
            _battleExiter.exitBattle();
         }
      }
      
      private function getPlayerIndexById(param1:int) : int
      {
         var _loc3_:BattlePlayer = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _battleData.playersInBattle.length)
         {
            _loc3_ = _battleData.playersInBattle[_loc2_];
            if(_loc3_.playerId == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      override public function setSubState() : void
      {
         _currentState.quicktipsURL = Const.QUICKTIP_GENERATE_SWARM;
         _battleHeaderController.setAllStatusWaiting();
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(SWARM_CHOOSER_SWF,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _swarmChooser = (param1.getLoadedAsset(SWFLoadee.NAME + SWARM_CHOOSER_SWF) as MovieClip).mcSwarmChooser as ISwarmChooser;
         _chainLoader.destroy();
         if(null == _swarmChooser)
         {
            throw new Error("SwarmChooser failed to load");
         }
         _uiContainer.addChild(_swarmChooser as DisplayObject);
         _swarmChooser.init(_nanovorFactory,_battleData.swarmSize,_battleData.swarmChooserTimeout,ISwarmChooserConsumer(this),ISwarmContainerFactory(this));
         if(Managers.stateManager.state == StateType.SENSEI_BATTLE.name)
         {
            Managers.analyticsManager.trackView(View.SENSEI_SWARM_CHOOSER);
         }
         else
         {
            Managers.analyticsManager.trackView(View.BATTLE_SWARM_CHOOSER);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleSubStateSwarmChooser>>\t" + param1);
      }
      
      public function handleSwarmSelected(param1:Array) : void
      {
         _selectedSwarmIds = param1;
         _battleGameService.addReadyForTurnHandler(IReadyForTurnHandler(this));
         _battleGameService.setSwarm(_selectedSwarmIds);
         log("handleSwarmSelected() - swarm.length: " + param1.length.toString());
      }
      
      public function handleTimeOut() : void
      {
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Time Out!","You didn\'t select any Nanovor and time ran out!",0,handleDialogBoxClose,handleDialogBoxClose);
         _battleGameService.quitGame();
      }
      
      public function destroy() : void
      {
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
         _battleGameService.removeGameSwarmSelectedHandler(IGameSwarmSelectedHandler(this));
         _battleGameService.removePlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         if(null != _swarmChooser)
         {
            _swarmChooser.destroy();
         }
      }
   }
}

