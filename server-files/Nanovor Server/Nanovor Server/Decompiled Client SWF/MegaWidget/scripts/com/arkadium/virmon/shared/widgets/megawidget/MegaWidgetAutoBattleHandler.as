package com.arkadium.virmon.shared.widgets.megawidget
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IBattleCreationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationRequestHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationResponseHandler;
   import com.arkadium.communications.handlers.battle.IBattlePlayerKickedOutHandler;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.battle.IGameOverHandler;
   import com.arkadium.communications.handlers.battle.IOtherPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPlayerQuitGameHandler;
   import com.arkadium.virmon.battle.BattleData;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MegaWidgetAutoBattleHandler implements IBattleCreationErrorHandler, IBattleErrorHandler, IBattleInvitationErrorHandler, IPlayerJoinBattleHandler, IOtherPlayerJoinBattleHandler, IBattleStartedHandler, IBattlePlayerKickedOutHandler, IBattleInvitationResponseHandler, IBattleInvitationRequestHandler, IBattleCreatedHandler, IPlayerQuitGameHandler, IGameOverHandler
   {
      
      public static const INVITE_TIMEOUT_SECONDS:int = 30;
      
      private static const BATTLE_TYPE:String = "AutoBattle";
      
      private static const TIMER_RATE_MILLISECONDS:int = 250;
      
      private static const MATCH_MAKING_DELAY_SECONDS:int = 5;
      
      private static const START_BATTLE_COUNTDOWN_SECONDS:int = 10;
      
      private static const START_BATTLE_COUNTDOWN_RATE_MILLISECONDS:int = 1000;
      
      private var _playerEventDialogBox:CommonDialogBox;
      
      private var _startBattleTimer:Timer;
      
      private var _invitationDialogBox:CommonDialogBox;
      
      private var _battleGameService:IBattleGameService;
      
      private var _avatarSpinners:Array;
      
      private var _playersKicked:Array;
      
      private var _playersInBattle:Array;
      
      private var _hackyStateCheckTimer:Timer;
      
      private var _numAutoBattlePlayers:int;
      
      private var _matchMakingDelayTimer:Timer;
      
      private var _megaWidget:MegaWidget;
      
      public function MegaWidgetAutoBattleHandler(param1:MegaWidget)
      {
         super();
         _megaWidget = param1;
         _avatarSpinners = _megaWidget.getAvatarSpinners();
         _megaWidget.quitButtonController.clickHandler = quitButtonHandler;
         var _loc2_:Array = _megaWidget.autoBattleButtons;
         _megaWidget.setAutoBattleButtonHandler(_loc2_[0],autoBattleButton2PlayerHandler);
         _megaWidget.setAutoBattleButtonHandler(_loc2_[1],autoBattleButton3PlayerHandler);
         _megaWidget.setAutoBattleButtonHandler(_loc2_[2],autoBattleButton4PlayerHandler);
         _battleGameService = GameServiceProvider.getInstance().battleGameService;
         _battleGameService.addBattleCreatedHandler(IBattleCreatedHandler(this));
         _battleGameService.addBattleInvitationResponseHandler(IBattleInvitationResponseHandler(this));
         _battleGameService.addBattleStartedHandler(IBattleStartedHandler(this));
         _battleGameService.addOtherPlayerJoinBattleHandler(IOtherPlayerJoinBattleHandler(this));
         _battleGameService.addPlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         _battleGameService.addBattleCreationErrorHandler(IBattleCreationErrorHandler(this));
         _battleGameService.addBattleErrorHandler(IBattleErrorHandler(this));
         _battleGameService.addBattleInvitationErrorHandler(IBattleInvitationErrorHandler(this));
         _battleGameService.addPlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _startBattleTimer = new Timer(START_BATTLE_COUNTDOWN_RATE_MILLISECONDS,START_BATTLE_COUNTDOWN_SECONDS * 1000 / START_BATTLE_COUNTDOWN_RATE_MILLISECONDS);
         _startBattleTimer.addEventListener(TimerEvent.TIMER,updateCountdownUI);
         _startBattleTimer.addEventListener(TimerEvent.TIMER_COMPLETE,goToBattle);
         _matchMakingDelayTimer = new Timer(MATCH_MAKING_DELAY_SECONDS * 1000,1);
         _matchMakingDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onMatchMakingDelayTimerComplete);
         _playersInBattle = new Array();
         _hackyStateCheckTimer = new Timer(1000,0);
         _hackyStateCheckTimer.addEventListener(TimerEvent.TIMER,onStateCheckTimer);
      }
      
      private function removePlayer(param1:String) : void
      {
         log("RemovePlayer");
         removePlayerFromBattleData(param1);
         var _loc2_:MegaWidgetAvatarSpinner = getPlayerAvatarSpinner(param1);
         if(_loc2_ == null)
         {
            return;
         }
         _megaWidget.resetAvatarSpinner(_loc2_);
      }
      
      private function setAvatarSpinnerInfo(param1:MegaWidgetAvatarSpinner, param2:String, param3:int, param4:int, param5:Boolean = false, param6:Boolean = false) : void
      {
         log("setAvatarSpinnerInfo");
         param1.playerName = param2;
         param1.playerNameTitle = param2;
         param1.avatarId = param3;
         param1.loadAvatarPicture();
         param1.showAvatar = true;
         param1.showName = true;
         param1.disabled = false;
         param1.playerNameSubtitle = "NMP " + param4;
      }
      
      public function handleBattleInvitationResponse(param1:Object = null) : void
      {
         log("handleBattleInvitationResponse");
      }
      
      private function goToBattle(param1:TimerEvent) : void
      {
         var _loc3_:Object = null;
         log("goToBattle");
         var _loc2_:BattleData = new BattleData(1000,90,60,"AutoBattle");
         for each(_loc3_ in _playersInBattle)
         {
            _loc2_.addPlayer(_loc3_.username,_loc3_.userRefId);
         }
         Managers.stateManager.setStateData(StateType.BATTLE,_loc2_);
         Managers.stateManager.setState(StateType.BATTLE);
         _megaWidget.reset(false);
      }
      
      public function handleBattleInvitationRequest(param1:Object = null) : void
      {
         log("handleBattleInvitationRequest().  convertedChatRoom: " + param1.convertedChatRoom);
      }
      
      public function handlePlayerJoinBattle(param1:Object = null) : void
      {
         log("handlePlayerJoinBattle -> data.battleName: " + param1.battleName);
      }
      
      private function quitButtonHandler() : void
      {
         Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)["disableMenu"](false);
         log("quitButtonHandler()");
         _startBattleTimer.stop();
         _matchMakingDelayTimer.stop();
         if(_battleGameService.battleName != "")
         {
            _battleGameService.quitGame();
         }
         else
         {
            _battleGameService.cancelMatchMaking();
         }
         _megaWidget.reset();
      }
      
      public function handleOtherPlayerJoinBattle(param1:Object = null) : void
      {
         log("handleOtherPlayerJoinBattle");
         addPlayer(param1.username,param1.avatarId,param1.nmp,param1.creator);
         addPlayerToBattleData(param1.username,param1.userRefId);
         if(Managers.stateManager.playersInBattle == null || Managers.stateManager.playersInBattle.length == 0)
         {
            Managers.stateManager.playersInBattle = [{
               "username":UserProfile.getInstance().screenname,
               "userRefId":UserProfile.getInstance().id
            }];
         }
         Managers.stateManager.playersInBattle.push({
            "userRefId":param1.userRefId,
            "username":param1.username
         });
      }
      
      private function onMatchMakingDelayTimerComplete(param1:TimerEvent) : void
      {
         log("onMatchMakingDelayTimerComplete()");
         _battleGameService.createQuickBattle(1000,_numAutoBattlePlayers);
      }
      
      public function handleGameOver(param1:int, param2:Object) : void
      {
         log("handleGameOver");
         _battleGameService.cancelMatchMaking();
         resetUIToSearching(_numAutoBattlePlayers);
         _matchMakingDelayTimer.stop();
      }
      
      private function onStateCheckTimer(param1:TimerEvent) : void
      {
         if(Managers.stateManager.state != StateType.HOME.name)
         {
            quitButtonHandler();
         }
      }
      
      private function autoBattleButton2PlayerHandler() : void
      {
         log("autoBattleButton2PlayerHandler");
         _battleGameService.cancelMatchMaking();
         _battleGameService.quitGame();
         resetUIToSearching(2);
         _numAutoBattlePlayers = 2;
         _matchMakingDelayTimer.reset();
         _matchMakingDelayTimer.start();
      }
      
      private function removePlayerFromBattleData(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < _playersInBattle.length)
         {
            if(_playersInBattle[_loc2_].username == param1)
            {
               _playersInBattle.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function handleBattlePlayerKickedOut(param1:Object = null) : void
      {
         log("Player got kicked out, resetting all info");
      }
      
      public function handlePlayerQuitGame(param1:int, param2:String) : void
      {
         log("handlePlayerQuitGame.  Player " + param2 + " has quit");
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Left",param2 + " has left.",INVITE_TIMEOUT_SECONDS);
         removePlayer(param2);
         if(_playersInBattle.length < 2)
         {
            _megaWidget.showAutoBattlePicker();
            _battleGameService.quitGame();
            _battleGameService.cancelMatchMaking();
            resetUIToSearching(_numAutoBattlePlayers);
            _matchMakingDelayTimer.reset();
            _matchMakingDelayTimer.start();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<MegaWidgetAutoBattleHandler>>\t" + param1);
      }
      
      public function handleBattleCreationError() : void
      {
         _megaWidget.reset();
      }
      
      public function handleBattleCreated(param1:Object = null) : void
      {
      }
      
      public function handleBattleInvitationError() : void
      {
         _megaWidget.reset();
      }
      
      private function resetUIToSearching(param1:*) : void
      {
         Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)["disableMenu"](false);
         _megaWidget.setCenterMode(MegaWidget.CENTER_MODE_SEARCHING);
         _megaWidget.setNumAutoBattlePlayers(param1);
         _megaWidget.showAutoBattlePicker();
         _megaWidget.quitButtonController.open();
         _startBattleTimer.stop();
      }
      
      private function addPlayerToBattleData(param1:String, param2:int) : void
      {
         var _loc3_:Object = null;
         log("addPlayerToBattleData()");
         for each(_loc3_ in _playersInBattle)
         {
            if(_loc3_.username == param1)
            {
               return;
            }
         }
         _playersInBattle.push({
            "username":param1,
            "userRefId":param2
         });
      }
      
      public function startAutoBattle(param1:int) : void
      {
         Managers.analyticsManager.trackView(View.HOME_MEGAWIDGET_BATTLE_AUTO);
         _megaWidget.openSpinner(MegaWidget.COLOR_BLUE);
         _megaWidget.setRoomType(MegaWidget.ROOM_TYPE_AUTO_BATTLE);
         _megaWidget.quitButtonController.close();
         _megaWidget.launchButtonController.close();
         _megaWidget.quitChatButtonController.close();
         _megaWidget.convertButtonController.close();
         resetUIToSearching(param1);
         addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp,true);
         addPlayerToBattleData(UserProfile.getInstance().screenname,UserProfile.getInstance().id);
         log("startAutoBattle");
         _numAutoBattlePlayers = param1;
         _matchMakingDelayTimer.reset();
         _matchMakingDelayTimer.start();
         Managers.stateManager.playersInBattle = [{
            "username":UserProfile.getInstance().screenname,
            "userRefId":UserProfile.getInstance().id
         }];
      }
      
      private function addPlayer(param1:String, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:MegaWidgetAvatarSpinner = null;
         log("addPlayer(!) " + param4);
         if(getPlayerAvatarSpinner(param1) != null)
         {
            log("addPlayer() pending player!");
            return;
         }
         _loc5_ = _avatarSpinners[getAvailableIndex(param4)];
         setAvatarSpinnerInfo(_loc5_,param1,param2,param3,param4);
         _loc5_.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_NONE;
      }
      
      private function autoBattleButton3PlayerHandler() : void
      {
         log("autoBattleButton3PlayerHandler");
         _battleGameService.cancelMatchMaking();
         _battleGameService.quitGame();
         resetUIToSearching(3);
         _numAutoBattlePlayers = 3;
         _matchMakingDelayTimer.reset();
         _matchMakingDelayTimer.start();
      }
      
      public function handleBattleError() : void
      {
         _megaWidget.reset();
      }
      
      private function getPlayerAvatarSpinner(param1:String) : MegaWidgetAvatarSpinner
      {
         var _loc2_:MegaWidgetAvatarSpinner = null;
         for each(_loc2_ in _avatarSpinners)
         {
            if(_loc2_.playerName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function autoBattleButton4PlayerHandler() : void
      {
         log("autoBattleButton4PlayerHandler");
         _battleGameService.cancelMatchMaking();
         _battleGameService.quitGame();
         resetUIToSearching(4);
         _numAutoBattlePlayers = 4;
         _matchMakingDelayTimer.reset();
         _matchMakingDelayTimer.start();
      }
      
      public function handleBattleStarted(param1:Object = null) : void
      {
         log("handleBattleStarted()");
         _megaWidget.hideAutoBattlePicker();
         _startBattleTimer.reset();
         _startBattleTimer.start();
         _megaWidget.setCenterMode(MegaWidget.CENTER_MODE_TIMER);
         _megaWidget.setTimerText(START_BATTLE_COUNTDOWN_SECONDS.toString());
         Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)["disableMenu"](true);
      }
      
      public function destroy() : void
      {
         log("destroy()");
         _startBattleTimer.removeEventListener(TimerEvent.TIMER,updateCountdownUI);
         _startBattleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,goToBattle);
         _matchMakingDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onMatchMakingDelayTimerComplete);
         _hackyStateCheckTimer.removeEventListener(TimerEvent.TIMER,onStateCheckTimer);
         _hackyStateCheckTimer.stop();
         _hackyStateCheckTimer = null;
         _startBattleTimer.stop();
         _matchMakingDelayTimer.stop();
         _startBattleTimer = null;
         _battleGameService.removeBattleCreatedHandler(IBattleCreatedHandler(this));
         _battleGameService.removeBattleInvitationRequestHandler(IBattleInvitationRequestHandler(this));
         _battleGameService.removeBattleInvitationResponseHandler(IBattleInvitationResponseHandler(this));
         _battleGameService.removeBattlePlayerKickedOutHandler(IBattlePlayerKickedOutHandler(this));
         _battleGameService.removeBattleStartedHandler(IBattleStartedHandler(this));
         _battleGameService.removeOtherPlayerJoinBattleHandler(IOtherPlayerJoinBattleHandler(this));
         _battleGameService.removePlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         _battleGameService.removePlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _battleGameService.removeGameOverHandler(IGameOverHandler(this));
         _battleGameService.removeBattleCreationErrorHandler(IBattleCreationErrorHandler(this));
         _battleGameService.removeBattleErrorHandler(IBattleErrorHandler(this));
         _battleGameService.removeBattleInvitationErrorHandler(IBattleInvitationErrorHandler(this));
      }
      
      private function updateCountdownUI(param1:TimerEvent) : void
      {
         var _loc2_:int = int(START_BATTLE_COUNTDOWN_SECONDS * 1000 - _startBattleTimer.currentCount * START_BATTLE_COUNTDOWN_RATE_MILLISECONDS) / 1000;
         _megaWidget.setTimerText(_loc2_.toString());
      }
      
      private function getAvailableIndex(param1:Boolean = false) : int
      {
         if(param1)
         {
            return 0;
         }
         var _loc2_:int = 1;
         while(_loc2_ < _avatarSpinners.length)
         {
            if(_avatarSpinners[_loc2_].playerName == "")
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}

