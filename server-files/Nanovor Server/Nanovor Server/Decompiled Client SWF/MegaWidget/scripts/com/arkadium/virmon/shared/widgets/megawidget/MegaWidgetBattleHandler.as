package com.arkadium.virmon.shared.widgets.megawidget
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IBattleCreationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationAcceptHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationResponseHandler;
   import com.arkadium.communications.handlers.battle.IBattlePlayerKickedOutHandler;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.battle.IGameOverHandler;
   import com.arkadium.communications.handlers.battle.IOtherPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPlayerQuitGameHandler;
   import com.arkadium.communications.handlers.battle.IRoomDestroyedHandler;
   import com.arkadium.virmon.battle.BattleData;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MegaWidgetBattleHandler implements IBattleCreationErrorHandler, IBattleErrorHandler, IBattleInvitationErrorHandler, IPlayerJoinBattleHandler, IOtherPlayerJoinBattleHandler, IBattleStartedHandler, IBattlePlayerKickedOutHandler, IBattleInvitationResponseHandler, IBattleCreatedHandler, IPlayerQuitGameHandler, IGameOverHandler, IRoomDestroyedHandler, IBattleInvitationAcceptHandler, IMegaWidgetAvatarSpinnerCloseHandler
   {
      
      public static const INVITE_TIMEOUT_SECONDS:int = 30;
      
      private static const BATTLE_TYPE:String = "FriendsBattle";
      
      private static const TIMER_RATE_MILLISECONDS:int = 250;
      
      private var _inviteTimer:Timer;
      
      private var _playerEventDialogBox:CommonDialogBox;
      
      private var _invitationDialogBox:CommonDialogBox;
      
      private var _battleGameService:IBattleGameService;
      
      private var _creatorName:String;
      
      private var _pendingInvites:Array;
      
      private var _avatarSpinners:Array;
      
      private var _isCreator:Boolean;
      
      private var _haveRequestedSwitchToHomeState:Boolean;
      
      private var _playersKicked:Array;
      
      private var _playersInBattle:Array;
      
      private var _numPlayers:int = 0;
      
      private var _megaWidget:MegaWidget;
      
      public function MegaWidgetBattleHandler(param1:MegaWidget)
      {
         super();
         _megaWidget = param1;
         _avatarSpinners = _megaWidget.getAvatarSpinners();
         _megaWidget.quitButtonController.clickHandler = quitButtonHandler;
         _megaWidget.launchButtonController.clickHandler = launchButtonHandler;
         _megaWidget.avatarSpinnerCloseButtonHandler = IMegaWidgetAvatarSpinnerCloseHandler(this);
         _battleGameService = GameServiceProvider.getInstance().battleGameService;
         _battleGameService.addBattleCreatedHandler(IBattleCreatedHandler(this));
         _battleGameService.addBattlePlayerKickedOutHandler(IBattlePlayerKickedOutHandler(this));
         _battleGameService.addBattleStartedHandler(IBattleStartedHandler(this));
         _battleGameService.addOtherPlayerJoinBattleHandler(IOtherPlayerJoinBattleHandler(this));
         _battleGameService.addPlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         _battleGameService.addPlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _battleGameService.addRoomDestroyedHandler(IRoomDestroyedHandler(this));
         _battleGameService.addBattleCreationErrorHandler(IBattleCreationErrorHandler(this));
         _battleGameService.addBattleErrorHandler(IBattleErrorHandler(this));
         _battleGameService.addBattleInvitationErrorHandler(IBattleInvitationErrorHandler(this));
         _inviteTimer = new Timer(TIMER_RATE_MILLISECONDS,0);
         _inviteTimer.addEventListener(TimerEvent.TIMER,updateInviteUI);
         _pendingInvites = new Array();
         _playersKicked = new Array();
         _isCreator = false;
         _playersInBattle = new Array();
      }
      
      public function destroy(param1:Boolean) : void
      {
         _isCreator = false;
         _battleGameService.removeBattleCreatedHandler(IBattleCreatedHandler(this));
         _battleGameService.removeBattleInvitationResponseHandler(IBattleInvitationResponseHandler(this));
         _battleGameService.removeBattlePlayerKickedOutHandler(IBattlePlayerKickedOutHandler(this));
         _battleGameService.removeBattleStartedHandler(IBattleStartedHandler(this));
         _battleGameService.removeOtherPlayerJoinBattleHandler(IOtherPlayerJoinBattleHandler(this));
         _battleGameService.removePlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         _battleGameService.removePlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _battleGameService.removeGameOverHandler(IGameOverHandler(this));
         _battleGameService.removeRoomDestroyedHandler(IRoomDestroyedHandler(this));
         _battleGameService.removeBattleCreationErrorHandler(IBattleCreationErrorHandler(this));
         _battleGameService.removeBattleErrorHandler(IBattleErrorHandler(this));
         _battleGameService.removeBattleInvitationErrorHandler(IBattleInvitationErrorHandler(this));
         _inviteTimer.stop();
      }
      
      private function removePlayer(param1:String) : void
      {
         log("removePlayer() - Player: " + param1);
         removePlayerFromBattleData(param1);
         var _loc2_:MegaWidgetAvatarSpinner = getPlayerAvatarSpinner(param1);
         if(_loc2_ == null)
         {
            return;
         }
         --_numPlayers;
         _megaWidget.resetAvatarSpinner(_loc2_);
      }
      
      private function applyKickButtons() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < _avatarSpinners.length)
         {
            if(!_isCreator)
            {
               _avatarSpinners[_loc1_].showCloseButton = false;
            }
            else if(_avatarSpinners[_loc1_].playerName != "" && findPendingPlayer(_avatarSpinners[_loc1_].playerName) == null)
            {
               _avatarSpinners[_loc1_].showCloseButton = true;
            }
            _loc1_++;
         }
      }
      
      private function setAvatarSpinnerInfo(param1:MegaWidgetAvatarSpinner, param2:String, param3:int, param4:int, param5:Boolean = false) : void
      {
         log("setAvatarSpinnerInfo");
         param1.playerName = param2;
         param1.playerNameTitle = param2;
         if(param3 != -1)
         {
            param1.playerNameSubtitle = "NMP " + param3;
         }
         param1.avatarId = param4;
         param1.loadAvatarPicture();
         param1.showAvatar = true;
         param1.showName = true;
         param1.disabled = false;
         if(param5)
         {
            param1.playerNameSuperTitle = "Battle Host";
         }
      }
      
      public function handleBattleInvitationResponse(param1:Object = null) : void
      {
         log("handleBattleInvitationResponse");
         if(!_isCreator)
         {
            return;
         }
         if(!param1.player.acceptedInvitation)
         {
            log("handleBattleInvitationResponse: User declined, removing");
            removePendingPlayer(param1.player.username);
            if(param1.player.replyReason == Const.REPLY_CODE_DECLINE)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Declined",param1.player.username + " has declined your battle invitation.",INVITE_TIMEOUT_SECONDS);
            }
            else if(param1.player.replyReason == Const.REPLY_CODE_BUSY)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Busy",param1.player.username + " is currently busy.",INVITE_TIMEOUT_SECONDS);
            }
            else
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Timed Out",param1.player.username + " has timed out on your battle invitation.",INVITE_TIMEOUT_SECONDS);
            }
         }
         else
         {
            log("handleBattleInvitationResponse: User accepted, adding");
            addPlayer(param1.player.username,param1.player.avatarId,param1.player.nmp,false);
            addPlayerToBattleData(param1.player.username,param1.player.userRefId);
         }
         checkIfEnoughPeopleForBattle();
      }
      
      private function findPendingPlayer(param1:*) : MegaWidgetPendingInvite
      {
         var _loc2_:MegaWidgetPendingInvite = null;
         log("findPendingPlayer");
         for each(_loc2_ in _pendingInvites)
         {
            log("\tpendingPlayer: " + _loc2_.playerName);
            if(_loc2_.playerName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function handleAvatarSpinnerClose(param1:MegaWidgetAvatarSpinner) : void
      {
         if(getPlayerAvatarSpinner(param1.playerName) != null)
         {
            _battleGameService.kickPlayerOut(param1.playerName);
            _playersKicked.push(param1.playerName);
         }
      }
      
      private function setOpenState() : void
      {
         Managers.analyticsManager.trackView(View.HOME_MEGAWIDGET_BATTLE_ARRANGE);
         _megaWidget.convertButtonController.close();
         _megaWidget.openSpinner(MegaWidget.COLOR_BLUE);
         _megaWidget.setCenterMode(MegaWidget.CENTER_MODE_UNKNOWN);
         _megaWidget.setRoomType(MegaWidget.ROOM_TYPE_BATTLE,_isCreator);
         _megaWidget.hideAutoBattlePicker();
         _megaWidget.quitButtonController.open();
         _megaWidget.launchButtonController.close();
         _megaWidget.quitChatButtonController.close();
         _megaWidget.convertButtonController.close();
         reset();
         applyKickButtons();
      }
      
      public function handleBattlePlayerKickedOut(param1:Object = null) : void
      {
         log("Player got kicked out, resetting all info");
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Kicked Out","You were kicked out.",INVITE_TIMEOUT_SECONDS);
         _battleGameService.quitGame();
         _megaWidget.reset();
      }
      
      private function quitButtonHandler() : void
      {
         _battleGameService.quitGame();
         _megaWidget.reset();
      }
      
      public function handlePlayerQuitGame(param1:int, param2:String) : void
      {
         var _loc3_:int = 0;
         log("handlePlayerQuitGame.  Player " + param2 + " has quit");
         if(param2 == null)
         {
            return;
         }
         if(param2.toLowerCase() == _battleGameService.getCreatorName().toLowerCase())
         {
            if(_invitationDialogBox != null)
            {
               _invitationDialogBox.kill();
               _invitationDialogBox = null;
            }
            _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Creator Left",param2 + " has left.",INVITE_TIMEOUT_SECONDS);
            _battleGameService.quitGame();
            _megaWidget.reset();
         }
         else
         {
            _loc3_ = int(_playersKicked.indexOf(param2));
            if(Boolean(_battleGameService.isCreator) && _loc3_ != -1)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Kicked",param2 + " has been kicked out.",INVITE_TIMEOUT_SECONDS);
            }
            else
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Left",param2 + " has left.",INVITE_TIMEOUT_SECONDS);
            }
            removePlayer(param2);
            if(_isCreator)
            {
               checkIfEnoughPeopleForBattle();
            }
         }
      }
      
      public function handlePlayerJoinBattle(param1:Object = null) : void
      {
         log("handlePlayerJoinBattle -> data.battleName: " + param1.battleName);
         if(!_isCreator && !_haveRequestedSwitchToHomeState)
         {
            _haveRequestedSwitchToHomeState = true;
            if(Managers.stateManager.state != StateType.HOME.name)
            {
               Managers.stateManager.setStateData(StateType.HOME,{"mode":StateType.MODE_BATTLE});
               Managers.stateManager.setState(StateType.HOME);
            }
            Managers.stateManager.playersInBattle = [{
               "username":UserProfile.getInstance().screenname,
               "userRefId":UserProfile.getInstance().id
            }];
            setOpenState();
            addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp,false);
            addPlayerToBattleData(UserProfile.getInstance().screenname,UserProfile.getInstance().id);
         }
      }
      
      public function handleGameOver(param1:int, param2:Object) : void
      {
         log("handleGameOver");
         _megaWidget.reset();
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
      
      private function removePendingPlayer(param1:String) : void
      {
         var _loc2_:MegaWidgetPendingInvite = null;
         var _loc3_:int = 0;
         while(_loc3_ < _pendingInvites.length)
         {
            _loc2_ = _pendingInvites[_loc3_] as MegaWidgetPendingInvite;
            if(_loc2_.playerName == param1)
            {
               _pendingInvites.splice(_loc3_,1);
               _megaWidget.resetAvatarSpinner(_loc2_.avatarSpinner);
            }
            _loc3_++;
         }
      }
      
      public function handleRoomDestroyed() : void
      {
         if(_invitationDialogBox != null)
         {
            _invitationDialogBox.kill();
         }
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Creator Left",_creatorName + " has left.",INVITE_TIMEOUT_SECONDS);
         _battleGameService.quitGame();
         _megaWidget.reset();
      }
      
      private function addPendingPlayer(param1:String, param2:int, param3:int = -1) : void
      {
         log("addPendingPlayer");
         if(findPendingPlayer(param1) != null || getPlayerAvatarSpinner(param1) != null)
         {
            return;
         }
         log("addPendingPlayer() - Adding player: " + param1);
         var _loc4_:int = getAvailableIndex(false);
         var _loc5_:MegaWidgetAvatarSpinner = _avatarSpinners[_loc4_] as MegaWidgetAvatarSpinner;
         setAvatarSpinnerInfo(_loc5_,param1,param3,param2,false);
         _loc5_.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_TIMER;
         _pendingInvites.push(new MegaWidgetPendingInvite(param1,INVITE_TIMEOUT_SECONDS,_loc5_));
         if(!_inviteTimer.running)
         {
            _inviteTimer.start();
         }
      }
      
      public function handleOtherPlayerJoinBattle(param1:Object = null) : void
      {
         log("handleOtherPlayerJoinBattle");
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
         addPlayer(param1.username,param1.avatarId,param1.nmp,param1.creator);
         addPlayerToBattleData(param1.username,param1.userRefId);
         if(_isCreator)
         {
            checkIfEnoughPeopleForBattle();
            applyKickButtons();
         }
      }
      
      private function checkIfEnoughPeopleForBattle() : void
      {
         log("checkIfEnoughPeopleForBattle: Total players: " + _numPlayers);
         if(_numPlayers > 1 && _pendingInvites.length == 0)
         {
            log("checkIfEnoughPeopleForBattle: Yep, it\'s a party.");
            _megaWidget.launchButtonController.open();
            _avatarSpinners[0].close();
            _avatarSpinners[0].showName = false;
         }
         else
         {
            log("checkIfEnoughPeopleForBattle: Nope, you\'re alone.");
            _megaWidget.launchButtonController.close();
            _avatarSpinners[0].open();
            _avatarSpinners[0].showAvatar = true;
            _avatarSpinners[0].showName = true;
         }
      }
      
      private function launchButtonHandler() : void
      {
         _battleGameService.startGame();
      }
      
      public function handleBattleCreated(param1:Object = null) : void
      {
         log("handleGameCreated: " + UserProfile.getInstance().screenname + " :: " + UserProfile.getInstance().id);
         addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp,true);
         addPlayerToBattleData(UserProfile.getInstance().screenname,UserProfile.getInstance().id);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<MegaWidgetBattleHandler>>\t" + param1);
      }
      
      private function updateInviteUI(param1:TimerEvent) : void
      {
         var _loc2_:MegaWidgetPendingInvite = null;
         if(_pendingInvites.length == 0)
         {
            _inviteTimer.stop();
         }
         for each(_loc2_ in _pendingInvites)
         {
            _loc2_.secondsLeft -= TIMER_RATE_MILLISECONDS / 1000;
            _loc2_.avatarSpinner.timerPercent = _loc2_.secondsLeft / INVITE_TIMEOUT_SECONDS * 100;
            if(_loc2_.secondsLeft <= 0)
            {
               removePendingPlayer(_loc2_.playerName);
            }
         }
         checkIfEnoughPeopleForBattle();
      }
      
      public function handleBattleInvitationError() : void
      {
         var _loc1_:MegaWidgetPendingInvite = null;
         for each(_loc1_ in _pendingInvites)
         {
            removePendingPlayer(_loc1_.playerName);
         }
         _pendingInvites = new Array();
      }
      
      public function handleBattleCreationError() : void
      {
         _megaWidget.reset();
      }
      
      public function handleBattleInvitationAccept(param1:String, param2:String, param3:int, param4:Boolean) : *
      {
         log("handleBattleInvitationAccept()");
         _invitationDialogBox = null;
         _isCreator = false;
         _haveRequestedSwitchToHomeState = false;
         GameServiceProvider.getInstance().chatGameService.killInvitation();
         _megaWidget.killChat(true);
         _creatorName = param2;
         log("handleBattleInvitationAccept() - Creator Name : " + _creatorName);
         if(param4)
         {
            GameServiceProvider.getInstance().chatGameService.exitChatRoom();
         }
      }
      
      private function addPlayerToBattleData(param1:String, param2:int) : void
      {
         var _loc3_:Object = null;
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
      
      public function handleBattleStarted(param1:Object = null) : void
      {
         var _loc3_:Object = null;
         log("handleBattleStarted()");
         var _loc2_:BattleData = new BattleData();
         for each(_loc3_ in _playersInBattle)
         {
            _loc2_.addPlayer(_loc3_.username,_loc3_.userRefId);
         }
         Managers.stateManager.setStateData(StateType.BATTLE,_loc2_);
         Managers.stateManager.setState(StateType.BATTLE);
         _megaWidget.reset(false);
      }
      
      private function addPlayer(param1:String, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         var _loc7_:MegaWidgetAvatarSpinner = null;
         var _loc9_:Object = null;
         var _loc6_:String = "";
         _loc6_ += "addPlayer() --> arguments:";
         _loc6_ += "\n\t playerName: " + param1;
         _loc6_ += "\n\t avatarId: " + param2;
         _loc6_ += "\n\t playerNMP: " + param3;
         if(param3 == 0)
         {
            _loc6_ += new Error("foo").getStackTrace();
         }
         _loc6_ += "\n\t playerIsCreator: " + param4;
         log(_loc6_);
         var _loc8_:MegaWidgetPendingInvite = findPendingPlayer(param1);
         if(_loc8_ != null)
         {
            log("addPlayer() - pendingInvite != null.  Player: " + param1);
            _loc7_ = _loc8_.avatarSpinner;
            removePendingPlayer(_loc8_.playerName);
            ++_numPlayers;
         }
         else
         {
            if(getPlayerAvatarSpinner(param1) != null && !param4)
            {
               log("addPlayer() - getPlayerAvatarSpinner(playerName) != null. Player: " + param1);
               getPlayerAvatarSpinner(param1).playerNameSubtitle = "NMP " + param3;
               return;
            }
            log("addPlayer() - else!!.  Player: " + param1);
            for each(_loc9_ in _playersInBattle)
            {
               if(param1.toLowerCase() == _loc9_.username.toLowerCase())
               {
                  return;
               }
            }
            _loc7_ = _avatarSpinners[getAvailableIndex(param4)];
            ++_numPlayers;
         }
         log("addPlayer: avatarSpinner null? " + (_loc7_ == null));
         setAvatarSpinnerInfo(_loc7_,param1,param3,param2,param4);
         _loc7_.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_NONE;
      }
      
      public function convertToBattle() : void
      {
         var _loc2_:MegaWidgetAvatarSpinner = null;
         var _loc3_:int = 0;
         log("convertToBattle");
         Managers.analyticsManager.trackAction(Action.HOME_CONVERT_CHAT_TO_BATTLE);
         _pendingInvites = new Array();
         _megaWidget.setMode(WidgetType.MODE_BATTLE);
         var _loc1_:Array = new Array();
         _loc3_ = 1;
         while(_loc3_ < _avatarSpinners.length)
         {
            _loc2_ = _avatarSpinners[_loc3_];
            if(_loc2_.playerName.split(" ").join("") != "")
            {
               _loc1_.push([_loc2_.playerName,_loc2_.avatarId]);
            }
            _loc3_++;
         }
         _megaWidget.resetAllSpinners();
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            invitePlayerToBattle(_loc1_[_loc3_][0],_loc1_[_loc3_][1],true);
            _loc3_++;
         }
         GameServiceProvider.getInstance().chatGameService.exitChatRoom();
      }
      
      private function reset() : void
      {
         _pendingInvites = new Array();
         _playersKicked = new Array();
         _playersInBattle = new Array();
         _megaWidget.resetAllSpinners();
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
      
      public function canInvitePlayerToBattle(param1:String) : Boolean
      {
         if(getPlayerAvatarSpinner(param1) != null)
         {
            return false;
         }
         if(_avatarSpinners[0].playerName == "")
         {
            return true;
         }
         if(!_isCreator)
         {
            return false;
         }
         return getAvailableIndex(false) != -1;
      }
      
      public function invitePlayerToBattle(param1:String, param2:int, param3:Boolean = false) : void
      {
         log("User is invited to battle.  Now added them to the pending list");
         if(!_isCreator)
         {
            _isCreator = true;
            setOpenState();
            _battleGameService.addBattleInvitationResponseHandler(IBattleInvitationResponseHandler(this));
            addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp,true);
            addPlayerToBattleData(UserProfile.getInstance().screenname,UserProfile.getInstance().id);
         }
         addPendingPlayer(param1,param2);
         _battleGameService.inviteUser(param1,param3);
         checkIfEnoughPeopleForBattle();
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

