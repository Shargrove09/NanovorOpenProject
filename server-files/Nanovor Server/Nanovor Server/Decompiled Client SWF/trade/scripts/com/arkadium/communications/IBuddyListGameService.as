package com.arkadium.communications
{
   import com.arkadium.communications.handlers.buddylist.IBuddyAddFailedHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyAddHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyDeleteHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyInvitationRequestHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyListUpdatedHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyStatusChangedHandler;
   import com.arkadium.communications.handlers.buddylist.IOfflineBuddyInvitationRequestHandler;
   import com.arkadium.communications.handlers.buddylist.IRecentlyPlayedListUpdatedHandler;
   import com.arkadium.communications.handlers.buddylist.IRecentlyPlayedStatusChangedHandler;
   
   public interface IBuddyListGameService
   {
      
      function addRecentlyPlayedStatusChangedHandler(param1:IRecentlyPlayedStatusChangedHandler) : void;
      
      function addRecentlyPlayedListUpdatedHandler(param1:IRecentlyPlayedListUpdatedHandler) : void;
      
      function removeBuddyStatusChangedHandler(param1:IBuddyStatusChangedHandler) : void;
      
      function get buddyList() : Array;
      
      function addBuddyStatusChangedHandler(param1:IBuddyStatusChangedHandler) : void;
      
      function removeBuddyListUpdatedHandler(param1:IBuddyListUpdatedHandler) : void;
      
      function addBuddyListUpdatedHandler(param1:IBuddyListUpdatedHandler) : void;
      
      function get recentlyPlayedList() : Array;
      
      function removeOfflineBuddyInvitationRequestHandler(param1:IOfflineBuddyInvitationRequestHandler) : void;
      
      function removeBuddyDeleteHandler(param1:IBuddyDeleteHandler) : void;
      
      function loadRecentlyPlayedList() : void;
      
      function getBuddyIdByUserRefId(param1:String) : int;
      
      function deleteBuddy(param1:int) : Boolean;
      
      function removeRecentlyPlayedStatusChangedHandler(param1:IRecentlyPlayedStatusChangedHandler) : void;
      
      function removeBuddyAddHandler(param1:IBuddyAddHandler) : void;
      
      function removeRecentlyPlayedListUpdatedHandler(param1:IRecentlyPlayedListUpdatedHandler) : void;
      
      function removeBuddyAddFailedHandler(param1:IBuddyAddFailedHandler) : void;
      
      function addBuddyAddFailedHandler(param1:IBuddyAddFailedHandler) : void;
      
      function getBuddyByName(param1:String) : Object;
      
      function addBuddyAddHandler(param1:IBuddyAddHandler) : void;
      
      function removeBuddyInvitationRequestHandler(param1:IBuddyInvitationRequestHandler) : void;
      
      function addOfflineBuddyInvitationRequestHandler(param1:IOfflineBuddyInvitationRequestHandler) : void;
      
      function addBuddyInvitationRequestHandler(param1:IBuddyInvitationRequestHandler) : void;
      
      function addBuddyDeleteHandler(param1:IBuddyDeleteHandler) : void;
      
      function replyBuddyInvitation(param1:String, param2:Boolean) : void;
      
      function inviteBuddy(param1:String) : void;
      
      function loadBuddyList() : void;
   }
}

