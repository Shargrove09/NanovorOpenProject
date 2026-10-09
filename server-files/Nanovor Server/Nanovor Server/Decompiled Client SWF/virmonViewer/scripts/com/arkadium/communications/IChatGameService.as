package com.arkadium.communications
{
   import com.arkadium.communications.handlers.chat.IChatInvitationAcceptHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationDeclineHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationErrorHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationResponseHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationTimeoutHandler;
   import com.arkadium.communications.handlers.chat.IChatMessageReceivedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomCreatedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomDestroyedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomJoinedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomListResponseHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomMemberListHandler;
   import com.arkadium.communications.handlers.chat.IExitingChatRoomHandler;
   import com.arkadium.communications.handlers.chat.IUserLeftChatRoomHandler;
   import com.arkadium.communications.handlers.chat.IUserRemovedFromChatRoomHandler;
   
   public interface IChatGameService extends IGameService
   {
      
      function addChatRoomMemberListHandler(param1:IChatRoomMemberListHandler) : void;
      
      function removeUserLeftChatRoomHandler(param1:IUserLeftChatRoomHandler) : void;
      
      function addUserLeftChatRoomHandler(param1:IUserLeftChatRoomHandler) : void;
      
      function removeChatMessageReceivedHandler(param1:IChatMessageReceivedHandler) : void;
      
      function removeExitingChatRoomHandler(param1:IExitingChatRoomHandler) : void;
      
      function getChatRoomList() : void;
      
      function removeChatRoomDestroyedHandler(param1:IChatRoomDestroyedHandler) : void;
      
      function removeChatInvitationDeclineHandler(param1:IChatInvitationDeclineHandler) : void;
      
      function removeChatRoomJoinedHandler(param1:IChatRoomJoinedHandler) : void;
      
      function setPublicChatRoomActive() : void;
      
      function addChatRoomJoinedHandler(param1:IChatRoomJoinedHandler) : void;
      
      function get publicChatRoomName() : String;
      
      function killInvitation() : void;
      
      function exitChatRoom() : void;
      
      function isPrivateChatRoomActive() : Boolean;
      
      function addChatInvitationErrorHandler(param1:IChatInvitationErrorHandler) : void;
      
      function set publicChatRoomName(param1:String) : void;
      
      function replyChatRoomInvitation(param1:String, param2:Boolean) : void;
      
      function addChatInvitationResponseHandler(param1:IChatInvitationResponseHandler) : void;
      
      function addUserRemovedFromChatRoomHandler(param1:IUserRemovedFromChatRoomHandler) : void;
      
      function addExitingChatRoomHandler(param1:IExitingChatRoomHandler) : void;
      
      function addChatInvitationTimeoutHandler(param1:IChatInvitationTimeoutHandler) : void;
      
      function inviteToChat(param1:String) : void;
      
      function joinChatRoom(param1:String) : void;
      
      function addChatRoomListResponseHandler(param1:IChatRoomListResponseHandler) : void;
      
      function removeChatRoomCreatedHandler(param1:IChatRoomCreatedHandler) : void;
      
      function exitPublicChatRoom() : void;
      
      function addChatMessageReceivedHandler(param1:IChatMessageReceivedHandler) : void;
      
      function removeChatInvitationResponseHandler(param1:IChatInvitationResponseHandler) : void;
      
      function addChatRoomDestroyedHandler(param1:IChatRoomDestroyedHandler) : void;
      
      function addChatInvitationDeclineHandler(param1:IChatInvitationDeclineHandler) : void;
      
      function sendChatMessage(param1:String) : void;
      
      function rejoinPublicChatRoom() : void;
      
      function setPrivateChatRoomActive() : void;
      
      function removeChatRoomMemberListHandler(param1:IChatRoomMemberListHandler) : void;
      
      function removeChatRoomListResponseHandler(param1:IChatRoomListResponseHandler) : void;
      
      function removeChatInvitationAcceptHandler(param1:IChatInvitationAcceptHandler) : void;
      
      function populateMessageHistory() : void;
      
      function addChatInvitationAcceptHandler(param1:IChatInvitationAcceptHandler) : void;
      
      function removeUserFromChatRoom(param1:String, param2:String) : void;
      
      function addChatRoomCreatedHandler(param1:IChatRoomCreatedHandler) : void;
      
      function removeChatInvitationErrorHandler(param1:IChatInvitationErrorHandler) : void;
      
      function get privateChatRoomName() : String;
      
      function removeUserRemovedFromChatRoomHandler(param1:IUserRemovedFromChatRoomHandler) : void;
      
      function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void;
      
      function removeChatInvitationTimeoutHandler(param1:IChatInvitationTimeoutHandler) : void;
   }
}

