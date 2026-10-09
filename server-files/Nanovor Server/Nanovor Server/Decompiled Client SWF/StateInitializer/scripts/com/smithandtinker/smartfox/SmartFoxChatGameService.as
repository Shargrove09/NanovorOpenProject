package com.smithandtinker.smartfox
{
   import com.arkadium.communications.*;
   import com.arkadium.communications.handlers.*;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.battle.IPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IQuittingGameHandler;
   import com.arkadium.communications.handlers.chat.*;
   import com.arkadium.communications.handlers.trade.IQuittingTradeHandler;
   import com.arkadium.communications.handlers.trade.ITradeOverHandler;
   import com.arkadium.communications.handlers.trade.ITradeStartedHandler;
   import com.arkadium.virmon.shared.data.PermissionsManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.*;
   
   public class SmartFoxChatGameService extends AbstractSmartFoxGameService implements IChatGameService, IQuittingTradeHandler, ITradeOverHandler, ITradeStartedHandler, IBattleStartedHandler, IBattleCreatedHandler, IQuittingGameHandler, IPlayerJoinBattleHandler, IGameServiceInvitationManagerConsumer
   {
      
      private static const EXTENSION_NAME:String = "chatXt";
      
      private static const REQUEST_GET_CHAT_ROOM_LIST:String = "getChatRoomList";
      
      private static const REQUEST_INVITE_TO_CHAT:String = "inviteToChat";
      
      private static const REQUEST_REPLY_CHAT_ROOM_INVITATION:String = "replyChatInvitation";
      
      private static const REQUEST_JOIN_CHAT_ROOM:String = "joinChatRoom";
      
      private static const REQUEST_EXIT_CHAT_ROOM:String = "exitChatRoom";
      
      private static const REQUEST_REMOVE_USER_FROM_CHAT_ROOM:String = "removeUserFromChatRoom";
      
      private static const REQUEST_SEND_CHAT_MESSAGE:String = "sendChatMessage";
      
      private static const RESPONSE_GET_CHAT_ROOM_LIST:String = "chatRoomListResponse";
      
      private static const RESPONSE_CHAT_ROOM_CREATED:String = "chatRoomCreated";
      
      private static const RESPONSE_CHAT_INVITATION_ERROR:String = "chatInvitationRejected";
      
      private static const RESPONSE_CHAT_ROOM_JOINED:String = "chatInvitationJoined";
      
      private static const SERVER_CHAT_INVITATION_REQUEST:String = "chatInvitationRequest";
      
      private static const SERVER_CHAT_INVITATION_RESPONSE:String = "chatInvitationResponse";
      
      private static const SERVER_USER_LEFT_CHAT_ROOM:String = "userLeftChatRoom";
      
      private static const SERVER_USER_REMOVED_FROM_CHAT_ROOM:String = "userRemovedFromChatRoom";
      
      private static const SERVER_CHAT_ROOM_MEMBER_LIST:String = "chatRoomMemberList";
      
      private static const SERVER_CHAT_ROOM_DESTROYED:String = "chatRoomDestroyed";
      
      private static const SERVER_CHAT_ROOM_FULL:String = "chatRoomFull";
      
      private static const SERVER_CHAT_ROOM_ERROR:String = "chatRoomError";
      
      private static const SERVER_USER_SENT_MESSAGE:String = "sendChatMessage";
      
      private var _invitationDialogBox:CommonDialogBox;
      
      private var _battleGameService:IBattleGameService;
      
      private var _isCreator:Boolean;
      
      private var _publicChatRoomName:String;
      
      private var _activeChatRoomName:String;
      
      private var _invitationManager:IGameServiceInvitationManager;
      
      private var _messageHistory:Array = new Array();
      
      private var _tradeGameService:ITradeGameService;
      
      private var _invitationChatRoomName:String;
      
      private var _privateChatRoomName:String;
      
      private var _lastPublicChatRoomName:String;
      
      public function SmartFoxChatGameService(param1:IUserProfile, param2:SmartFoxConnection, param3:IBattleGameService, param4:ITradeGameService)
      {
         super(param1,param2,EXTENSION_NAME);
         _gameServiceConnection.addEventListener(SFSEvent.onExtensionResponse,this.handleExtensionResponse);
         this.reset();
         this._battleGameService = param3;
         this._battleGameService.addBattleCreatedHandler(IBattleCreatedHandler(this));
         this._battleGameService.addBattleStartedHandler(IBattleStartedHandler(this));
         this._battleGameService.addQuittingGameHandler(IQuittingGameHandler(this));
         this._battleGameService.addPlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         this._tradeGameService = param4;
         this._tradeGameService.addTradeStartedHandler(ITradeStartedHandler(this));
         this._tradeGameService.addQuittingTradeHandler(IQuittingTradeHandler(this));
         this._tradeGameService.addTradeOverHandler(ITradeOverHandler(this));
      }
      
      public function getChatRoomList() : void
      {
         DebugLog.instance.log("SmartFoxChatGameService.getChatRoomList()");
         sendRequestToServer(REQUEST_GET_CHAT_ROOM_LIST,{});
      }
      
      public function removeChatRoomDestroyedHandler(param1:IChatRoomDestroyedHandler) : void
      {
         removeHandler(IChatRoomDestroyedHandler,param1);
      }
      
      public function removeChatRoomJoinedHandler(param1:IChatRoomJoinedHandler) : void
      {
         removeHandler(IChatRoomJoinedHandler,param1);
      }
      
      public function handleTradeOver(param1:Object = null) : void
      {
         this.log("handleTradeOver(): setting active room: " + this._publicChatRoomName);
         this._privateChatRoomName = null;
         this._activeChatRoomName = this._publicChatRoomName;
      }
      
      public function addChatRoomJoinedHandler(param1:IChatRoomJoinedHandler) : void
      {
         addHandler(IChatRoomJoinedHandler,param1);
      }
      
      public function set publicChatRoomName(param1:String) : void
      {
         this._publicChatRoomName = param1;
      }
      
      public function removeChatRoomCreatedHandler(param1:IChatRoomCreatedHandler) : void
      {
         removeHandler(IChatRoomCreatedHandler,param1);
      }
      
      private function handleConfirmChatRoomFull(param1:Object) : void
      {
         this.log("handleConfirmChatRoomFull(): " + param1.reason);
      }
      
      public function addChatMessageReceivedHandler(param1:IChatMessageReceivedHandler) : void
      {
         addHandler(IChatMessageReceivedHandler,param1);
      }
      
      public function addChatRoomMemberListHandler(param1:IChatRoomMemberListHandler) : void
      {
         addHandler(IChatRoomMemberListHandler,param1);
      }
      
      public function addUserRemovedFromChatRoomHandler(param1:IUserRemovedFromChatRoomHandler) : void
      {
         addHandler(IUserRemovedFromChatRoomHandler,param1);
      }
      
      public function addChatRoomDestroyedHandler(param1:IChatRoomDestroyedHandler) : void
      {
         addHandler(IChatRoomDestroyedHandler,param1);
      }
      
      public function addChatInvitationDeclineHandler(param1:IChatInvitationDeclineHandler) : void
      {
         addHandler(IChatInvitationDeclineHandler,param1);
      }
      
      public function populateMessageHistory() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:IChatMessageReceivedHandler = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._messageHistory.length)
         {
            _loc2_ = this._messageHistory[_loc1_].username;
            _loc3_ = this._messageHistory[_loc1_].message;
            _loc4_ = int(this._messageHistory[_loc1_].avatarId);
            _loc5_ = int(this._messageHistory[_loc1_].nmp);
            for each(_loc6_ in _handlers[IChatMessageReceivedHandler])
            {
               _loc6_.handleChatMessageReceived(ChatRoomType.PUBLIC,_loc2_,_loc4_,_loc5_,_loc3_);
            }
            _loc1_++;
         }
      }
      
      public function addChatInvitationAcceptHandler(param1:IChatInvitationAcceptHandler) : void
      {
         addHandler(IChatInvitationAcceptHandler,param1);
      }
      
      public function rejoinPublicChatRoom() : void
      {
         if(null == this._lastPublicChatRoomName)
         {
            return;
         }
         this._publicChatRoomName = this._lastPublicChatRoomName;
         this._lastPublicChatRoomName = null;
         DebugLog.instance.log("SmartFoxChatGameService.rejoinPublicChatRoom(): _publicChatRoomName: " + this._publicChatRoomName);
         sendRequestToServer(REQUEST_JOIN_CHAT_ROOM,{"chatRoomName":this._publicChatRoomName});
      }
      
      public function handleInvitationTimeout(param1:Object) : void
      {
         var _loc2_:IChatInvitationTimeoutHandler = null;
         this.replyChatRoomInvitation(param1.chatRoomName,false);
         for each(_loc2_ in _handlers[IChatInvitationTimeoutHandler])
         {
            _loc2_.handleChatInvitationTimeout(param1.chatRoomName);
         }
      }
      
      public function removeUserFromChatRoom(param1:String, param2:String) : void
      {
         sendRequestToServer(REQUEST_REMOVE_USER_FROM_CHAT_ROOM,{
            "chatRoomName":param1,
            "userToRemove":param2
         });
      }
      
      public function removeChatMessageReceivedHandler(param1:IChatMessageReceivedHandler) : void
      {
         removeHandler(IChatMessageReceivedHandler,param1);
      }
      
      public function handleInvitationAccept(param1:Object) : void
      {
         var _loc2_:IChatInvitationAcceptHandler = null;
         if(this._privateChatRoomName != null)
         {
            this.exitChatRoom();
         }
         this.replyChatRoomInvitation(param1.chatRoomName,true);
         for each(_loc2_ in _handlers[IChatInvitationAcceptHandler])
         {
            _loc2_.handleChatInvitationAccept(param1.chatRoomName,param1.inviterName,param1.inviterAvatarId,param1.inviterNMP);
         }
         this._privateChatRoomName = String(param1.chatRoomName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("[SmartFoxChatGameService]          " + param1,_userProfile.screenname);
      }
      
      private function reset() : void
      {
         this._invitationChatRoomName = null;
         this._isCreator = false;
         this._publicChatRoomName = null;
         this._privateChatRoomName = null;
         this._activeChatRoomName = null;
      }
      
      public function addChatInvitationResponseHandler(param1:IChatInvitationResponseHandler) : void
      {
         addHandler(IChatInvitationResponseHandler,param1);
      }
      
      public function setPrivateChatRoomActive() : void
      {
         if(null == this._privateChatRoomName as String)
         {
            DebugLog.instance.error("SmartFoxChatGameService.handleExtensionReponse(): _privateChatRoomName is null and so should not be set active.");
         }
         this.log("setPrivateChatRoomActive(): _privateChatRoomName: " + this._privateChatRoomName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         var _loc6_:IChatRoomListResponseHandler = null;
         var _loc7_:IChatRoomCreatedHandler = null;
         var _loc8_:IChatInvitationErrorHandler = null;
         var _loc9_:IChatRoomJoinedHandler = null;
         var _loc10_:IChatRoomMemberListHandler = null;
         var _loc11_:IChatInvitationResponseHandler = null;
         var _loc12_:IUserLeftChatRoomHandler = null;
         var _loc13_:IUserRemovedFromChatRoomHandler = null;
         var _loc14_:IChatMessageReceivedHandler = null;
         var _loc15_:IChatRoomDestroyedHandler = null;
         var _loc2_:String = param1.params.type;
         var _loc3_:Object = param1.params.dataObj;
         var _loc4_:String = _loc3_._cmd;
         if(_loc4_ != "collectionSet")
         {
            DebugLog.instance.log(">>SMF>><< handleExtensionResponse: " + _loc4_ + "\ndata=" + Utils.ObjectToString(_loc3_));
         }
         else
         {
            DebugLog.instance.log(">>SMF>><< handleExtensionResponse: " + _loc4_ + " -- SKIPPING DATA LOGGING FOR THIS COMMAND");
         }
         var _loc5_:Boolean = true;
         switch(_loc4_)
         {
            case SmartFoxConnection.EXTENSION_RESPONSE_COMMAND_LOGIN_OK:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: EXTENSION_RESPONSE_COMMAND_LOGIN_OK: \'data.chatRoomName\' was null.");
               }
               this._publicChatRoomName = String(_loc3_.chatRoomName);
               this._activeChatRoomName = this._publicChatRoomName;
               if(Boolean(_loc3_.messageList))
               {
                  this._messageHistory = _loc3_.messageList;
               }
               break;
            case RESPONSE_GET_CHAT_ROOM_LIST:
               if(null == _loc3_.chatRoomList || "null" == "" + _loc3_.chatRoomList)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: RESPONSE_GET_CHAT_ROOM_LIST: \'data.chatRoomList\' was null.");
               }
               if(null == _loc3_.chatRoomCounts || "null" == "" + _loc3_.chatRoomCounts)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: RESPONSE_GET_CHAT_ROOM_LIST: \'data.chatRoomCounts\' was null.");
               }
               for each(_loc6_ in _handlers[IChatRoomListResponseHandler])
               {
                  _loc6_.handleChatRoomListResponse(String(_loc3_.chatRoomList),String(_loc3_.chatRoomCounts));
               }
               break;
            case RESPONSE_CHAT_ROOM_CREATED:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: RESPONSE_CHAT_ROOM_CREATED: \'data.chatRoomName\' was null.");
               }
               this.log("RESPONSE_CHAT_ROOM_CREATED: chat room: " + _loc3_.chatRoomName);
               this._privateChatRoomName = _loc3_.chatRoomName;
               this._activeChatRoomName = this._privateChatRoomName;
               for each(_loc7_ in _handlers[IChatRoomCreatedHandler])
               {
                  _loc7_.handleChatRoomCreated(_loc3_.chatRoomName);
               }
               break;
            case RESPONSE_CHAT_INVITATION_ERROR:
               if(null == _loc3_.inviteeName || "null" == "" + _loc3_.inviteeName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: RESPONSE_CHAT_INVITATION_ERROR: \'data.inviteeName\' was null.");
               }
               for each(_loc8_ in _handlers[IChatInvitationErrorHandler])
               {
                  _loc8_.handleChatInvitationError(_loc3_.inviteeName,_loc3_.inviteeReason);
               }
               break;
            case RESPONSE_CHAT_ROOM_JOINED:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: RESPONSE_CHAT_ROOM_JOINED: \'data.chatRoomName\' was null.");
               }
               this.log("RESPONSE_CHAT_ROOM_JOINED: " + _loc3_.chatRoomName);
               if(this._privateChatRoomName != null && this._privateChatRoomName != "")
               {
                  return;
               }
               this._publicChatRoomName = _loc3_.chatRoomName;
               this._activeChatRoomName = this._publicChatRoomName;
               for each(_loc9_ in _handlers[IChatRoomJoinedHandler])
               {
                  _loc9_.handleChatRoomJoined(this._publicChatRoomName);
               }
               if(Boolean(_loc3_.messageList))
               {
                  this._messageHistory = _loc3_.messageList;
                  this.populateMessageHistory();
               }
               break;
            case SERVER_CHAT_ROOM_MEMBER_LIST:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_MEMBER_LIST: \'data.chatRoomName\' was null.");
               }
               for each(_loc10_ in _handlers[IChatRoomMemberListHandler])
               {
                  _loc10_.handleChatRoomMemberList(_loc3_.chatRoomName,_loc3_.memberNames);
               }
               break;
            case SERVER_CHAT_INVITATION_REQUEST:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_REQUEST: \'data.chatRoomName\' was null.");
               }
               if(null == _loc3_.inviterName || "null" == "" + _loc3_.inviterName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_REQUEST: \'data.inviterName\' was null.");
               }
               if(null == _loc3_.inviterAvatarId || "null" == "" + _loc3_.inviterAvatarId)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_REQUEST: \'data.inviterAvatarId\' was null.");
               }
               if(null == _loc3_.inviterNMP || "null" == "" + _loc3_.inviterNMP)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_REQUEST: \'data.inviterNMP\' was null.");
               }
               this._invitationChatRoomName = _loc3_.chatRoomName;
               if(!PermissionsManager.getInstance().canChat || !this._invitationManager.checkCanAcceptInvitations())
               {
                  this.replyChatRoomInvitation(this._invitationChatRoomName,false);
                  break;
               }
               this._invitationManager.handleInvitation(_loc3_,IGameServiceInvitationManagerConsumer(this),this._invitationChatRoomName,30,false);
               break;
            case SERVER_CHAT_INVITATION_RESPONSE:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_RESPONSE: \'data.chatRoomName\' was null.");
               }
               if(null == _loc3_.inviteeName || "null" == "" + _loc3_.inviteeName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_RESPONSE: \'data.inviterName\' was null.");
               }
               if(null == _loc3_.inviteeAvatarId || "null" == "" + _loc3_.inviteeAvatarId)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_RESPONSE: \'data.inviteeAvatarId\' was null.");
               }
               if(null == _loc3_.inviteeNMP || "null" == "" + _loc3_.inviteeNMP)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_INVITATION_RESPONSE: \'data.inviteeNMP\' was null.");
               }
               for each(_loc11_ in _handlers[IChatInvitationResponseHandler])
               {
                  _loc11_.handleChatInvitationResponse(_loc3_.chatRoomName,_loc3_.inviteeName,_loc3_.accept,_loc3_.inviteeAvatarId,_loc3_.inviteeNMP);
               }
               break;
            case SERVER_USER_LEFT_CHAT_ROOM:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_LEFT_CHAT_ROOM: \'data.chatRoomName\' was null.");
               }
               if(null == _loc3_.username || "null" == "" + _loc3_.username)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_LEFT_CHAT_ROOM: \'data.username\' was null.");
               }
               if(_userProfile.screenname == String(_loc3_.username))
               {
                  if(_userProfile.screenname.toLowerCase() == String(_loc3_.username).toLowerCase())
                  {
                     if(this._privateChatRoomName == _loc3_.chatRoomName)
                     {
                        this._privateChatRoomName = null;
                     }
                     break;
                  }
               }
               for each(_loc12_ in _handlers[IUserLeftChatRoomHandler])
               {
                  _loc12_.handleUserLeftChatRoom(_loc3_.chatRoomName,_loc3_.username);
               }
               break;
            case SERVER_USER_REMOVED_FROM_CHAT_ROOM:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_REMOVED_FROM_CHAT_ROOM: \'data.chatRoomName\' was null.");
               }
               if(null == _loc3_.username || "null" == "" + _loc3_.username)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_REMOVED_FROM_CHAT_ROOM: \'data.username\' was null.");
               }
               if(_userProfile.screenname.toLowerCase() == String(_loc3_.username).toLowerCase())
               {
                  DebugLog.instance.log("SERVER_USER_REMOVED_FROM_CHAT_ROOM: setting _privateChatRoomName to null.");
                  this._privateChatRoomName = null;
               }
               for each(_loc13_ in _handlers[IUserRemovedFromChatRoomHandler])
               {
                  _loc13_.handleUserRemovedFromChatRoom(_loc3_.chatRoomName,_loc3_.username);
               }
               break;
            case SERVER_USER_SENT_MESSAGE:
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_SENT_MESSAGE: \'data.chatRoomName\' was null.");
               }
               if(null == _loc3_.username || "null" == "" + _loc3_.username)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_SENT_MESSAGE: \'data.username\' was null.");
               }
               if(null == _loc3_.avatarId || "null" == "" + _loc3_.avatarId)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_SENT_MESSAGE: \'data.avatarId\' was null.");
               }
               if(null == _loc3_.message || "null" == "" + _loc3_.message)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_SENT_MESSAGE: \'data.message\' was null.");
               }
               if(null == _loc3_.nmp || "null" == "" + _loc3_.nmp)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_USER_SENT_MESSAGE: \'data.nmp\' was null.");
                  _loc3_.nmp = -1;
               }
               this.log("SERVER_USER_SENT_MESSAGE: _publicChatRoomName: " + this._publicChatRoomName + ", data.chatRoomName: " + _loc3_.chatRoomName + ", user: " + _loc3_.username + ", message: " + _loc3_.message + ", nmp: " + _loc3_.nmp);
               for each(_loc14_ in _handlers[IChatMessageReceivedHandler])
               {
                  _loc14_.handleChatMessageReceived(this._publicChatRoomName == String(_loc3_.chatRoomName) ? ChatRoomType.PUBLIC : ChatRoomType.PRIVATE,_loc3_.username,_loc3_.avatarId,_loc3_.nmp,_loc3_.message);
               }
               break;
            case SERVER_CHAT_ROOM_DESTROYED:
               if(null == _loc3_.reason || "null" == "" + _loc3_.reason)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_DESTROYED: \'data.reason\' was null.");
               }
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_DESTROYED: \'data.chatRoomName\' was null.");
               }
               if(_loc3_.chatRoomName != null && this._privateChatRoomName != _loc3_.chatRoomName)
               {
                  return;
               }
               for each(_loc15_ in _handlers[IChatRoomDestroyedHandler])
               {
                  _loc15_.handleChatRoomDestroyed(_loc3_);
               }
               this._privateChatRoomName = null;
               break;
            case SERVER_CHAT_ROOM_FULL:
               if(null == _loc3_.reason || "null" == "" + _loc3_.reason)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_ERROR: \'data.reason\' was null.");
               }
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_ERROR: \'data.chatRoomName\' was null.");
               }
               if(_loc3_.chatRoomName != null && this._privateChatRoomName != null && this._privateChatRoomName != _loc3_.chatRoomName)
               {
                  return;
               }
               CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Chat Room Full","Sorry, this chat room is full.",0,this.handleConfirmChatRoomFull,this.handleConfirmChatRoomFull,_loc3_);
               break;
            case SERVER_CHAT_ROOM_ERROR:
               if(null == _loc3_.reason || "null" == "" + _loc3_.reason)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_ERROR: \'data.reason\' was null.");
               }
               if(null == _loc3_.chatRoomName || "null" == "" + _loc3_.chatRoomName)
               {
                  DebugLog.instance.error("SmartFoxChatGameService: SERVER_CHAT_ROOM_ERROR: \'data.chatRoomName\' was null.");
               }
               if(_loc3_.chatRoomName != null && this._privateChatRoomName != _loc3_.chatRoomName)
               {
                  return;
               }
               CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Chat Room Error","You were unable to join chat room. Please try again.",0,this.handleConfirmChatRoomError,this.handleConfirmChatRoomError,_loc3_);
               break;
            default:
               _loc5_ = false;
         }
         if(_loc5_)
         {
            this.log(">>SMF>><< handleExtensionResponse [" + EXTENSION_NAME + "]: found case for: " + _loc4_);
         }
      }
      
      public function handleBattleStarted(param1:Object = null) : void
      {
         this.log("handleBattleStarted(): setting active private chat room: " + param1.battleName);
         this._privateChatRoomName = String(param1.battleName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      public function addChatInvitationTimeoutHandler(param1:IChatInvitationTimeoutHandler) : void
      {
         addHandler(IChatInvitationTimeoutHandler,param1);
      }
      
      public function removeChatInvitationResponseHandler(param1:IChatInvitationResponseHandler) : void
      {
         removeHandler(IChatInvitationResponseHandler,param1);
      }
      
      public function addChatInvitationErrorHandler(param1:IChatInvitationErrorHandler) : void
      {
         addHandler(IChatInvitationErrorHandler,param1);
      }
      
      public function removeChatInvitationAcceptHandler(param1:IChatInvitationAcceptHandler) : void
      {
         removeHandler(IChatInvitationAcceptHandler,param1);
      }
      
      public function addChatRoomCreatedHandler(param1:IChatRoomCreatedHandler) : void
      {
         addHandler(IChatRoomCreatedHandler,param1);
      }
      
      public function removeExitingChatRoomHandler(param1:IExitingChatRoomHandler) : void
      {
         removeHandler(IExitingChatRoomHandler,param1);
      }
      
      public function handleInvitationBusy(param1:Object) : void
      {
         this.replyChatRoomInvitation(param1.chatRoomName,false);
      }
      
      public function removeUserLeftChatRoomHandler(param1:IUserLeftChatRoomHandler) : void
      {
         removeHandler(IUserLeftChatRoomHandler,param1);
      }
      
      public function setPublicChatRoomActive() : void
      {
         this.log("setPublicChatRoomActive(): _publicChatRoomName: " + this._publicChatRoomName);
         this._activeChatRoomName = this._publicChatRoomName;
      }
      
      public function chatRoomName() : String
      {
         return this._privateChatRoomName;
      }
      
      public function get publicChatRoomName() : String
      {
         return this._publicChatRoomName;
      }
      
      public function removeChatInvitationDeclineHandler(param1:IChatInvitationDeclineHandler) : void
      {
         removeHandler(IChatInvitationDeclineHandler,param1);
      }
      
      public function handlePlayerJoinBattle(param1:Object = null) : void
      {
         this._privateChatRoomName = String(param1.battleName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      public function handleQuttingTrade() : void
      {
         this.log("handleQuttingTrade(): setting active room: " + this._publicChatRoomName);
         this._privateChatRoomName = null;
         this._activeChatRoomName = this._publicChatRoomName;
      }
      
      public function removeChatInvitationErrorHandler(param1:IChatInvitationErrorHandler) : void
      {
         removeHandler(IChatInvitationErrorHandler,param1);
      }
      
      public function exitChatRoom() : void
      {
         var _loc1_:IExitingChatRoomHandler = null;
         this.log("exitChatRoom() - _privateChatRoomName: " + this._privateChatRoomName);
         this.log("exitChatRoom() - _activeChatRoomName: " + this._activeChatRoomName);
         if(null == this._privateChatRoomName)
         {
            return;
         }
         sendRequestToServer(REQUEST_EXIT_CHAT_ROOM,{"chatRoomName":this._privateChatRoomName});
         DebugLog.instance.log("SmartFoxChatGameService.exitChatRoom(): setting _privateChatRoomName to null.");
         this._privateChatRoomName = null;
         this._isCreator = false;
         for each(_loc1_ in _handlers[IExitingChatRoomHandler])
         {
            _loc1_.handleExitingChatRoom();
         }
      }
      
      public function handleQuittingGame() : void
      {
         this.log("handleQuittingGame(): setting active room: " + this._publicChatRoomName);
         this._privateChatRoomName = null;
         this._activeChatRoomName = this._publicChatRoomName;
      }
      
      public function exitPublicChatRoom() : void
      {
         this.log("exitPublicChatRoom() - _publicChatRoomName: " + this._publicChatRoomName);
         this.log("exitPublicChatRoom() - _activeChatRoomName: " + this._activeChatRoomName);
         if(null == this._publicChatRoomName)
         {
            return;
         }
         sendRequestToServer(REQUEST_EXIT_CHAT_ROOM,{"chatRoomName":this._publicChatRoomName});
         this._lastPublicChatRoomName = this._publicChatRoomName;
         this._publicChatRoomName = null;
      }
      
      public function removeChatRoomMemberListHandler(param1:IChatRoomMemberListHandler) : void
      {
         removeHandler(IChatRoomMemberListHandler,param1);
      }
      
      public function joinChatRoom(param1:String) : void
      {
         DebugLog.instance.log("SmartFoxChatGameService.joinChatRoom(): chatRoomName: " + param1);
         sendRequestToServer(REQUEST_JOIN_CHAT_ROOM,{"chatRoomName":param1});
      }
      
      public function getDialogText(param1:Object) : String
      {
         return "User " + String(param1.inviterName).toUpperCase() + " has invited you to private chat. Do you accept?";
      }
      
      public function get privateChatRoomName() : String
      {
         return this._privateChatRoomName;
      }
      
      public function addChatRoomListResponseHandler(param1:IChatRoomListResponseHandler) : void
      {
         addHandler(IChatRoomListResponseHandler,param1);
      }
      
      public function isPrivateChatRoomActive() : Boolean
      {
         return null != this._privateChatRoomName;
      }
      
      public function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void
      {
         this._invitationManager = param1;
      }
      
      public function killInvitation() : void
      {
      }
      
      public function getDialogTitle() : String
      {
         return "Chat Invitation";
      }
      
      public function removeUserRemovedFromChatRoomHandler(param1:IUserRemovedFromChatRoomHandler) : void
      {
         removeHandler(IUserRemovedFromChatRoomHandler,param1);
      }
      
      public function handleTradeStarted(param1:Object = null) : void
      {
         this.log("handleTradeStarted(): setting active private chat room: " + param1.tradeName);
         this._privateChatRoomName = String(param1.tradeName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      public function handleBattleCreated(param1:Object = null) : void
      {
         this.log("handleBattleCreated(): setting active private chat room: " + param1.battleName);
         this._privateChatRoomName = String(param1.battleName);
         this._activeChatRoomName = this._privateChatRoomName;
      }
      
      public function addUserLeftChatRoomHandler(param1:IUserLeftChatRoomHandler) : void
      {
         addHandler(IUserLeftChatRoomHandler,param1);
      }
      
      public function removeChatInvitationTimeoutHandler(param1:IChatInvitationTimeoutHandler) : void
      {
         removeHandler(IChatInvitationTimeoutHandler,param1);
      }
      
      public function removeChatRoomListResponseHandler(param1:IChatRoomListResponseHandler) : void
      {
         removeHandler(IChatRoomListResponseHandler,param1);
      }
      
      public function handleInvitationDecline(param1:Object) : void
      {
         var _loc2_:IChatInvitationDeclineHandler = null;
         this.replyChatRoomInvitation(param1.chatRoomName,false);
         for each(_loc2_ in _handlers[IChatInvitationDeclineHandler])
         {
            _loc2_.handleChatInvitationDecline(param1.chatRoomName);
         }
      }
      
      public function inviteToChat(param1:String) : void
      {
         DebugLog.instance.log("SmartFoxChatGameService.inviteToChat(): chatRoomName: " + (null == this._privateChatRoomName ? "null" : this._privateChatRoomName) + ", inviteeName: " + param1);
         sendRequestToServer(REQUEST_INVITE_TO_CHAT,{
            "chatRoomName":this._privateChatRoomName,
            "inviteeName":param1
         });
      }
      
      public function replyChatRoomInvitation(param1:String, param2:Boolean) : void
      {
         if(param2)
         {
            this._privateChatRoomName = param1;
         }
         sendRequestToServer(REQUEST_REPLY_CHAT_ROOM_INVITATION,{
            "chatRoomName":param1,
            "accept":param2
         });
      }
      
      private function handleConfirmChatRoomError(param1:Object) : void
      {
         this.log("handleConfirmChatRoomError(): " + param1.reason);
      }
      
      public function sendChatMessage(param1:String) : void
      {
         if(null == param1 as String)
         {
            DebugLog.instance.error("SmartFoxChatGameService.sendChatMessage(): parameter \"message\" cannot be null.");
         }
         DebugLog.instance.log("SmartFoxChatGameService.sendChatMessage(): chat room: " + this._activeChatRoomName + ", message: " + param1);
         sendRequestToServer(REQUEST_SEND_CHAT_MESSAGE,{
            "chatRoomName":this._activeChatRoomName,
            "message":param1
         });
      }
      
      public function addExitingChatRoomHandler(param1:IExitingChatRoomHandler) : void
      {
         addHandler(IExitingChatRoomHandler,param1);
      }
      
      override public function destroy() : void
      {
         _gameServiceConnection.removeEventListener(SFSEvent.onExtensionResponse,this.handleExtensionResponse);
         super.destroy();
      }
      
      override protected function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[IChatRoomJoinedHandler] = new Dictionary(true);
         _handlers[IChatRoomMemberListHandler] = new Dictionary(true);
         _handlers[IChatInvitationErrorHandler] = new Dictionary(true);
         _handlers[IChatInvitationAcceptHandler] = new Dictionary(true);
         _handlers[IChatInvitationDeclineHandler] = new Dictionary(true);
         _handlers[IChatInvitationTimeoutHandler] = new Dictionary(true);
         _handlers[IChatInvitationResponseHandler] = new Dictionary(true);
         _handlers[IChatRoomCreatedHandler] = new Dictionary(true);
         _handlers[IChatMessageReceivedHandler] = new Dictionary(true);
         _handlers[IUserLeftChatRoomHandler] = new Dictionary(true);
         _handlers[IUserRemovedFromChatRoomHandler] = new Dictionary(true);
         _handlers[IChatRoomListResponseHandler] = new Dictionary(true);
         _handlers[IChatRoomDestroyedHandler] = new Dictionary(true);
         _handlers[IExitingChatRoomHandler] = new Dictionary(true);
      }
   }
}

