package com.arkadium.virmon.battle
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.user.IForcedLogOutHandler;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.substate.substatecontrollerwithname.SubStateControllerWithName;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.ICanAcceptInvitationChecker;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.DisplayObjectContainer;
   
   public class BattleState extends AbstractState implements IBattleState, IBattleExiter, IForcedLogOutHandler, ICanAcceptInvitationChecker
   {
      
      private var _battleSubStateFactory:BattleSubStateFactory;
      
      private var _widgetManager:IWidgetManager;
      
      private var _battleGameService:IBattleGameService;
      
      private var _subStateController:SubStateControllerWithName;
      
      private var _userGameService:IUserGameService;
      
      private var _headerController:IBattleHeaderController;
      
      private var _stateManager:IStateManager;
      
      public function BattleState()
      {
         super();
         stateName = StateType.BATTLE.name;
         _quicktipsURL = "";
      }
      
      override public function onSetState() : void
      {
         log("onSetState() - NOT removing the AvatarWidget.");
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_BATTLE);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) != null)
         {
            IAutoBattleWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name)).hide();
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            IWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)).setMode(WidgetType.MODE_BATTLE);
         }
         _subStateController.changeSubState(BattleSubStateFactory.SUB_STATE_SWARM_CHOOSER);
      }
      
      public function checkCanAcceptInvitations() : Boolean
      {
         log("checkCanAcceptInvitations()");
         var _loc1_:String = _subStateController.currentSubStateType;
         return _loc1_ == BattleSubStateFactory.SUB_STATE_GAMEOVER;
      }
      
      public function initialize(param1:ISoundManager, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile, param8:IStateManager, param9:IWidgetManager, param10:IAnalyticsManager, param11:IBattleGameService, param12:IUserGameService, param13:IBuddyRPManager, param14:IAvatarAssetRetriever) : void
      {
         _stateManager = param8;
         _widgetManager = param9;
         var _loc15_:IBattleData = _stateManager.getStateData(StateType.BATTLE) as IBattleData;
         _battleGameService = param11;
         _userGameService = param12;
         _userGameService.addForcedLogOutHandler(IForcedLogOutHandler(this));
         _headerController = new BattleHeaderController(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) as IHeaderWidget,_userGameService,new BattleHeaderAvatarFactory(param14));
         _headerController.setBattleMode(_loc15_,param7.screenname);
         _battleSubStateFactory = new BattleSubStateFactory(_stateManager,param10,param1,param2,param3,param4,param5,param6,param7,DisplayObjectContainer(this),_battleGameService,_loc15_,_headerController,IBattleExiter(this),IState(this),param13);
         _subStateController = new SubStateControllerWithName(_battleSubStateFactory);
         isInitialized = true;
         var _loc16_:Object = _stateManager.getStateData(StateType.BATTLE);
         if(_loc15_ != null && _loc15_.battleType == "AutoBattle")
         {
            param10.trackView(View.BATTLE_LANDING_AUTO);
         }
         else
         {
            param10.trackView(View.BATTLE_LANDING_ARRANGED);
         }
      }
      
      override public function onUnsetState() : void
      {
         _battleSubStateFactory.destroy();
         _battleSubStateFactory = null;
         _subStateController.destroy();
         _subStateController = null;
         _userGameService.removeForcedLogOutHandler(IForcedLogOutHandler(this));
         _stateManager.setStateData(StateType.BATTLE,null);
         super.onUnsetState();
      }
      
      public function handleForcedLogOut(param1:Object = null) : void
      {
         _battleGameService.quitGame();
      }
      
      public function exitBattle() : void
      {
         var _loc1_:String = _subStateController.currentSubStateType;
         if(_loc1_ != BattleSubStateFactory.SUB_STATE_GAMEOVER)
         {
            _battleGameService.quitGame();
         }
         _stateManager.toggleHelp(false);
         _stateManager.setState(StateType.HOME);
      }
   }
}

