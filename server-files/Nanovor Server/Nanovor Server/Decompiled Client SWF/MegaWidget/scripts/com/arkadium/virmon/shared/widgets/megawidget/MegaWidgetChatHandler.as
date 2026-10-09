package com.arkadium.virmon.shared.widgets.megawidget
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.handlers.chat.ChatRoomType;
   import com.arkadium.communications.handlers.chat.IChatInvitationAcceptHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationErrorHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationResponseHandler;
   import com.arkadium.communications.handlers.chat.IChatMessageReceivedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomCreatedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomDestroyedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomJoinedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomMemberListHandler;
   import com.arkadium.communications.handlers.chat.IUserLeftChatRoomHandler;
   import com.arkadium.communications.handlers.chat.IUserRemovedFromChatRoomHandler;
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   import com.arkadium.communications.handlers.user.IBuddyAvatarDataHandler;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MegaWidgetChatHandler implements IChatInvitationErrorHandler, IChatInvitationResponseHandler, IChatMessageReceivedHandler, IChatRoomCreatedHandler, IUserLeftChatRoomHandler, IUserRemovedFromChatRoomHandler, IChatInvitationAcceptHandler, IChatRoomJoinedHandler, IChatRoomMemberListHandler, IChatRoomDestroyedHandler, IMegaWidgetAvatarSpinnerCloseHandler, IBuddyAvatarDataHandler, IAvatarUpdatedHandler
   {
      
      public static const INVITE_TIMEOUT_SECONDS:int = 30;
      
      private static const TIMER_RATE_MILLISECONDS:int = 250;
      
      private var _playerEventDialogBox:CommonDialogBox;
      
      private var _pendingInvites:Array;
      
      private var _creatorName:String;
      
      private var _avatarSpinners:Array;
      
      private var _isCreator:Boolean = false;
      
      private var _chatGameService:IChatGameService;
      
      private var _playersKicked:Array;
      
      private var _haveRequestedSwitchToHomeState:Boolean;
      
      private var _userGameService:IUserGameService;
      
      private var _megaWidget:MegaWidget;
      
      private var _playersInChat:Array;
      
      private var _inviteTimer:Timer;
      
      public function MegaWidgetChatHandler(param1:MegaWidget)
      {
         super();
         _megaWidget = param1;
         _avatarSpinners = _megaWidget.getAvatarSpinners();
         _megaWidget.quitChatButtonController.clickHandler = quitButtonHandler;
         _megaWidget.convertButtonController.clickHandler = _megaWidget.convertToBattle;
         _megaWidget.avatarSpinnerCloseButtonHandler = IMegaWidgetAvatarSpinnerCloseHandler(this);
         _userGameService = GameServiceProvider.getInstance().userGameService;
         _userGameService.addBuddyAvatarDataHandler(IBuddyAvatarDataHandler(this));
         _userGameService.addAvatarUpdatedHandler(IAvatarUpdatedHandler(this));
         _chatGameService = GameServiceProvider.getInstance().chatGameService;
         _chatGameService.addChatInvitationResponseHandler(IChatInvitationResponseHandler(this));
         _chatGameService.addChatRoomCreatedHandler(IChatRoomCreatedHandler(this));
         _chatGameService.addUserLeftChatRoomHandler(IUserLeftChatRoomHandler(this));
         _chatGameService.addUserRemovedFromChatRoomHandler(IUserRemovedFromChatRoomHandler(this));
         _chatGameService.addChatRoomMemberListHandler(IChatRoomMemberListHandler(this));
         _chatGameService.addChatRoomDestroyedHandler(IChatRoomDestroyedHandler(this));
         _inviteTimer = new Timer(TIMER_RATE_MILLISECONDS,0);
         _inviteTimer.addEventListener(TimerEvent.TIMER,updateInviteUI);
         _pendingInvites = new Array();
         _playersKicked = new Array();
         _playersInChat = new Array();
      }
      
      private function removePlayer(param1:String) : void
      {
         log("RemovePlayer");
         var _loc2_:MegaWidgetAvatarSpinner = getPlayerAvatarSpinner(param1);
         _playersInChat.splice(_playersInChat.indexOf(param1),1);
         if(_loc2_ == null)
         {
            log("Remove Player: Player not found");
            return;
         }
         _megaWidget.resetAvatarSpinner(_loc2_);
      }
      
      public function handleUserRemovedFromChatRoom(param1:String, param2:String) : void
      {
         log("handleUserRemovedFromChatRoom()");
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Kicked Out","You were kicked out.",INVITE_TIMEOUT_SECONDS);
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
      
      private function setAvatarSpinnerInfo(param1:MegaWidgetAvatarSpinner, param2:String, param3:int, param4:int, param5:Boolean = false, param6:Boolean = false) : void
      {
         log("setAvatarSpinnerInfo");
         param1.playerName = param2;
         param1.playerNameTitle = param2;
         param1.avatarId = param4;
         if(param3 != -1)
         {
            param1.playerNameSubtitle = "NMP " + param3;
         }
         param1.loadAvatarPicture();
         param1.showAvatar = true;
         param1.showName = true;
         param1.disabled = false;
         if(param5)
         {
            param1.playerNameSuperTitle = "Chat Host";
         }
      }
      
      private function applyKickButtons() : void
      {
         log("\t\t\tapplyKickButtons");
         var _loc1_:int = 1;
         while(_loc1_ < _avatarSpinners.length)
         {
            if(_avatarSpinners[_loc1_].playerName.split(" ").join("") != "" && findPendingPlayer(_avatarSpinners[_loc1_].playerName) == null)
            {
               log("\t\t\t\t...setting kick button.  AvatarSpinner.playername: \'" + _avatarSpinners[_loc1_].playerName + "\'");
               _avatarSpinners[_loc1_].showKickButton = true;
            }
            _loc1_++;
         }
      }
      
      public function destroy(param1:Boolean) : void
      {
         _isCreator = false;
         _chatGameService.removeChatInvitationResponseHandler(IChatInvitationResponseHandler(this));
         _chatGameService.removeChatRoomCreatedHandler(IChatRoomCreatedHandler(this));
         _chatGameService.removeUserLeftChatRoomHandler(IUserLeftChatRoomHandler(this));
         _chatGameService.removeUserRemovedFromChatRoomHandler(IUserRemovedFromChatRoomHandler(this));
         _chatGameService.removeChatRoomMemberListHandler(IChatRoomMemberListHandler(this));
         _chatGameService.removeChatRoomDestroyedHandler(IChatRoomDestroyedHandler(this));
         _inviteTimer.stop();
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
         _chatGameService.removeUserFromChatRoom(_chatGameService.privateChatRoomName,param1.playerName);
         _playersKicked.push(param1.playerName);
      }
      
      private function setOpenState() : void
      {
         _megaWidget.hideAutoBattlePicker();
         Managers.analyticsManager.trackView(View.HOME_MEGAWIDGET_PRIVATE_CHAT);
         _megaWidget.setCenterMode(MegaWidget.CENTER_MODE_UNKNOWN);
         _megaWidget.setRoomType(MegaWidget.ROOM_TYPE_CHAT,_isCreator);
         _megaWidget.openSpinner(MegaWidget.COLOR_ORANGE);
         _megaWidget.quitButtonController.close();
         _megaWidget.quitChatButtonController.open();
         _megaWidget.launchButtonController.close();
         if(_isCreator)
         {
            _megaWidget.convertButtonController.open();
         }
         else
         {
            _megaWidget.convertButtonController.close();
         }
      }
      
      private function quitButtonHandler() : void
      {
         log("quitButtonHandler");
         _chatGameService.exitChatRoom();
         _megaWidget.reset();
      }
      
      public function handleUserLeftChatRoom(param1:String, param2:String) : void
      {
         log("handleUserLeftChatRoom(): User " + param2 + " has left chat");
         removePlayer(param2);
         checkIfEnoughPeopleForConvert();
      }
      
      public function handleChatInvitationError(param1:String, param2:String) : void
      {
         log("handleChatInvitationError");
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Invitation Error","There were errors inviting " + param1 + ". Please try again later.");
      }
      
      public function isPlayerInSameChatRoom(param1:String) : Boolean
      {
         return getPlayerAvatarSpinner(param1) != null;
      }
      
      public function handleChatInvitationResponse(param1:String, param2:String, param3:Boolean, param4:int, param5:int) : void
      {
         log("handleChatInvitationResponse");
         if(param3)
         {
            addPlayer(param2,param4,param5,false);
         }
         else if(!param3 && _isCreator)
         {
            removePendingPlayer(param2);
         }
         if(_isCreator)
         {
            applyKickButtons();
            checkIfEnoughPeopleForConvert();
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
      
      private function addPendingPlayer(param1:String, param2:int, param3:int = -1) : void
      {
         log("addPendingPlayer");
         if(findPendingPlayer(param1) != null || getPlayerAvatarSpinner(param1) != null)
         {
            return;
         }
         var _loc4_:int = getAvailableIndex(false);
         var _loc5_:MegaWidgetAvatarSpinner = _avatarSpinners[_loc4_] as MegaWidgetAvatarSpinner;
         setAvatarSpinnerInfo(_loc5_,param1,param3,param2,false,true);
         _loc5_.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_TIMER;
         _pendingInvites.push(new MegaWidgetPendingInvite(param1,INVITE_TIMEOUT_SECONDS,_loc5_));
         if(!_inviteTimer.running)
         {
            _inviteTimer.start();
         }
      }
      
      public function handleBuddyAvatarData(param1:Object = null) : void
      {
         log("handleBuddyAvatarData");
      }
      
      public function handleChatRoomJoined(param1:String) : void
      {
         log("handleChatRoomJoined");
      }
      
      public function handleChatRoomDestroyed(param1:Object) : void
      {
         if(_isCreator)
         {
            return;
         }
         log("handleChatRoomDestroyed");
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Creator Left","Creator has left.",INVITE_TIMEOUT_SECONDS);
         _megaWidget.reset();
      }
      
      public function canInvitePlayerToChat(param1:String) : Boolean
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
      
      private function checkIfEnoughPeopleForConvert() : void
      {
         var _loc2_:MegaWidgetAvatarSpinner = null;
         if(!_isCreator)
         {
            return;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in _avatarSpinners)
         {
            if(_loc2_.playerName != "")
            {
               _loc1_++;
            }
         }
         if(_loc1_ > 1 && _pendingInvites.length == 0)
         {
            log("checkIfEnoughPeopleForConvert: Yep, it\'s a party.");
            _megaWidget.convertButtonController.open();
         }
         else
         {
            log("checkIfEnoughPeopleForConvert: Nope, you\'re alone.");
            _megaWidget.convertButtonController.close();
         }
      }
      
      public function handleChatInvitationTimeout(param1:String) : void
      {
         log("handleChatInvitationTimeout");
      }
      
      public function handleChatInvitationAccept(param1:String, param2:String, param3:int, param4:int) : void
      {
         log("handleChatInvitationAccept");
         log("handleChatInvitationAccept: inviterNMP: " + param4);
         _isCreator = false;
         _haveRequestedSwitchToHomeState = false;
         _creatorName = param2;
         addPlayer(param2,param3,param4,true);
         if(_isCreator)
         {
            applyKickButtons();
            checkIfEnoughPeopleForConvert();
         }
      }
      
      public function handleChatRoomCreated(param1:String) : void
      {
         log("handleChatRoomCreated: " + UserProfile.getInstance().screenname + " :: " + UserProfile.getInstance().id);
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
      }
      
      public function handleChatMessageReceived(param1:ChatRoomType, param2:String, param3:int, param4:int, param5:String) : void
      {
         log("handleChatMessageReceived");
      }
      
      public function handleChatInvitationDecline(param1:String) : void
      {
         log("handleChatInvitationDecline");
      }
      
      public function handleAvatarUpdated(param1:Object = null) : void
      {
         log("handleBuddyAvatarUpdated");
      }
      
      public function handleChatRoomMemberList(param1:String, param2:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc8_:String = null;
         log("handleChatRoomMemberList: Member Info: " + param2);
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
            addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp);
         }
         var _loc3_:Array = param2.split(",");
         var _loc7_:int = -1;
         for each(_loc8_ in _loc3_)
         {
            _loc4_ = _loc8_.split(":");
            _loc5_ = _loc4_[0];
            _loc6_ = int(_loc4_[1]);
            if(_loc4_.length > 2)
            {
               _loc7_ = int(_loc4_[2]);
            }
            if(_loc5_ == _creatorName)
            {
               addPlayer(_loc5_,_loc6_,_loc7_,true);
            }
            else
            {
               addPlayer(_loc5_,_loc6_,_loc7_,false);
            }
         }
      }
      
      public function invitePlayerToChat(param1:String, param2:int) : void
      {
         if(!_isCreator)
         {
            _isCreator = true;
            setOpenState();
            addPlayer(UserProfile.getInstance().screenname,UserProfile.getInstance().avatarId,UserProfile.getInstance().nmp,true);
         }
         _chatGameService.inviteToChat(param1);
         addPendingPlayer(param1,param2);
         applyKickButtons();
         checkIfEnoughPeopleForConvert();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<MegaWidgetChatHandler>>\t" + param1);
      }
      
      private function addPlayer(param1:String, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:MegaWidgetAvatarSpinner = null;
         log("addPlayer()");
         var _loc6_:MegaWidgetPendingInvite = findPendingPlayer(param1);
         if(_loc6_ != null)
         {
            _loc5_ = _loc6_.avatarSpinner;
            removePendingPlayer(_loc6_.playerName);
         }
         else
         {
            if(getPlayerAvatarSpinner(param1) != null)
            {
               log("addPlayer(): Player " + param1 + " found, not adding");
               getPlayerAvatarSpinner(param1).playerNameSubtitle = "NMP " + param3;
               return;
            }
            _playersInChat.push(param1);
            _loc5_ = _avatarSpinners[getAvailableIndex(param4)];
         }
         log("addPlayer: avatarSpinner null? " + (_loc5_ == null));
         setAvatarSpinnerInfo(_loc5_,param1,param3,param2,param4);
         _loc5_.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_NONE;
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

