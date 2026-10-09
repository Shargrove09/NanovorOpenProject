package com.arkadium.virmon.senseibattle
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.BattleData;
   import com.arkadium.virmon.battle.BattleHeaderController;
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.BattleSubStateFactory;
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAI;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAIFactoryConsumer;
   import com.arkadium.virmon.senseibattle.ai.PatienceAttackGenerator;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIBattleTracker;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIFactory;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIMoveGenerator;
   import com.arkadium.virmon.senseibattle.battlelogic.BattleLogic;
   import com.arkadium.virmon.senseibattle.battlelogic.IBattleLogic;
   import com.arkadium.virmon.senseibattle.ui.SenseiBattleHeaderAvatarFactory;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidgetLeaveBattleHandler;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import flash.display.DisplayObjectContainer;
   
   public class SenseiBattleState extends AbstractState implements ISenseiBattleState, IBattleExiter, ISenseiAIFactoryConsumer, IHeaderWidgetLeaveBattleHandler
   {
      
      private var _evoManager:IEvoManager;
      
      private var _headerWidget:IHeaderWidget;
      
      private var _userProfile:IUserProfile;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private var _stateManager:IStateManager;
      
      private var _battleSubStateFactory:BattleSubStateFactory;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _targetSenseiId:int;
      
      private var _autoBattleWidget:IAutoBattleWidget;
      
      private var _subStateController:SubStateController;
      
      private var _masterDataAssetRetriever:IMasterDataAssetRetriever;
      
      private var _chatWidget:IWidget;
      
      private var _emManager:IEMManager;
      
      private var _senseiAIFactory:SenseiAIFactory;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _targetSenseiName:String;
      
      private var _soundManager:ISoundManager;
      
      public function SenseiBattleState()
      {
         super();
         stateName = StateType.SENSEI_BATTLE.name;
         _quicktipsURL = "";
      }
      
      override public function destroy() : void
      {
         if(null != _battleSubStateFactory)
         {
            _battleSubStateFactory.destroy();
            _battleSubStateFactory = null;
         }
         if(null != _subStateController)
         {
            _subStateController.destroy();
            _subStateController = null;
         }
         super.destroy();
      }
      
      public function handleSenseiAILoadComplete() : void
      {
         var _loc1_:BattleData = new BattleData(1000,0,0,_targetSenseiId.toString());
         var _loc2_:BattlePlayer = _loc1_.addPlayer(_userProfile.screenname,_userProfile.id);
         var _loc3_:IPlayer = _playerFactory.createPlayer(_loc2_.playerName,_loc2_.playerId);
         var _loc4_:ISenseiAI = _senseiAIFactory.createAIById(_loc3_,new SenseiAIBattleTracker(),new SenseiAIMoveGenerator(new PatienceAttackGenerator()),_targetSenseiId);
         _loc1_.addPlayer(_loc4_.getPlayerName(),_loc4_.getPlayerId());
         var _loc5_:SenseiBattleGameServiceHandler = new SenseiBattleGameServiceHandler();
         var _loc6_:IBattleLogic = new BattleLogic(_loc1_,_masterDataAssetRetriever);
         var _loc7_:IBattleGameService = new SenseiBattleGameService(new SenseiBattleServerImitator(_nanovorFactory,_loc4_,_loc1_,_loc6_,IBattleGameServerConsumer(_loc5_)),IBattleGameServiceHandler(_loc5_));
         var _loc8_:IBattleHeaderController = new BattleHeaderController(_headerWidget,null,new SenseiBattleHeaderAvatarFactory());
         _loc8_.setBattleMode(_loc1_,_userProfile.screenname);
         _battleSubStateFactory = new BattleSubStateFactory(_stateManager,_analyticsManager,_soundManager,_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile,DisplayObjectContainer(this),_loc7_,_loc1_,_loc8_,IBattleExiter(this),IState(this),_buddyRPManager,false,false);
         _subStateController = new SubStateController(_battleSubStateFactory);
         _subStateController.changeSubState(BattleSubStateFactory.SUB_STATE_SWARM_CHOOSER);
      }
      
      public function handleHeaderWidgetLeaveBattle() : void
      {
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Leaving Battle","Are you sure you want to leave battle?",30,handleLeaveBattleConfirmed,CommonDialogBox.GenericTimeoutKill,CommonDialogBox.GenericTimeoutKill,null,CommonDialogBox.GenericTimeoutKill);
      }
      
      public function handleSenseiAILoadFailure() : void
      {
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Error Loading Sensei AIs","There was an error loading Sensei AIs",0,CommonDialogBox.GenericTimeoutKill,CommonDialogBox.GenericTimeoutKill,null,CommonDialogBox.GenericTimeoutKill);
         exitBattle();
      }
      
      public function exitBattle() : void
      {
         _stateManager.setState(StateType.HOME);
         _stateManager.toggleHelp(false);
      }
      
      override public function onUnsetState() : void
      {
         _headerWidget.hideLeaveBattle();
      }
      
      private function handleLeaveBattleConfirmed(param1:Object) : void
      {
         exitBattle();
      }
      
      public function initialize(param1:Object, param2:ISoundManager, param3:INanovorFactory, param4:IPlayerFactory, param5:IEvoManager, param6:IBadgeManager, param7:IEMManager, param8:IAnalyticsManager, param9:IHeaderWidget, param10:IWidget, param11:IAutoBattleWidget, param12:IUserProfile, param13:IStateManager, param14:IBuddyRPManager, param15:IMasterDataAssetRetriever) : void
      {
         _soundManager = param2;
         _nanovorFactory = param3;
         _playerFactory = param4;
         _evoManager = param5;
         _badgeManager = param6;
         _emManager = param7;
         _headerWidget = param9;
         _chatWidget = param10;
         _autoBattleWidget = param11;
         _userProfile = param12;
         _stateManager = param13;
         _buddyRPManager = param14;
         _analyticsManager = param8;
         _masterDataAssetRetriever = param15;
         _targetSenseiName = "";
         if(null != param1)
         {
            _targetSenseiName = String(param1.senseiName);
            _targetSenseiId = int(param1.senseiId);
         }
         isInitialized = true;
         var _loc16_:String = View.SENSEI_BATTLE_LANDING.name.replace("%AI_PLAYER_ID%",_targetSenseiId);
         param8.trackView(View.createDynamic(_loc16_));
      }
      
      override public function onSetState() : void
      {
         IWidget(_headerWidget).setMode(WidgetType.MODE_BATTLE);
         _headerWidget.showLeaveBattle(IHeaderWidgetLeaveBattleHandler(this));
         _chatWidget.setMode(WidgetType.MODE_HIDDEN);
         _autoBattleWidget.hide();
         _senseiAIFactory = new SenseiAIFactory(_nanovorFactory,_playerFactory,_masterDataAssetRetriever,ISenseiAIFactoryConsumer(this));
      }
   }
}

