package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IBuddyListGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.handlers.buddylist.IBuddyAddFailedHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyAddHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyDeleteHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyInvitationRequestHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyListUpdatedHandler;
   import com.arkadium.communications.handlers.buddylist.IBuddyStatusChangedHandler;
   import com.arkadium.communications.handlers.buddylist.IRecentlyPlayedListUpdatedHandler;
   import com.arkadium.communications.handlers.buddylist.IRecentlyPlayedStatusChangedHandler;
   import com.arkadium.communications.handlers.user.IBuddyAvatarDataHandler;
   import com.arkadium.virmon.framework.events.BuddyEvent;
   import com.arkadium.virmon.framework.events.BuddyListEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.EventDispatcher;
   
   public class BuddyPersistConn extends EventDispatcher implements IBuddyPersistConn, IBuddyAvatarDataHandler, IBuddyInvitationRequestHandler, IBuddyListUpdatedHandler, IRecentlyPlayedListUpdatedHandler, IBuddyAddHandler, IBuddyAddFailedHandler, IBuddyStatusChangedHandler, IRecentlyPlayedStatusChangedHandler, IBuddyDeleteHandler
   {
      
      private static const SHOW_DEBUG_LOGS:Boolean = false;
      
      private var _buddyListGameService:IBuddyListGameService;
      
      private var _myUserRefId:int;
      
      public function BuddyPersistConn(param1:IBuddyListGameService, param2:IUserGameService, param3:int)
      {
         super();
         log("BuddyPersistConn(): first constructed here: " + new Error("JUST A  STACK TRACE").getStackTrace());
         _myUserRefId = param3;
         _buddyListGameService = param1;
         _buddyListGameService.addBuddyListUpdatedHandler(IBuddyListUpdatedHandler(this));
         _buddyListGameService.addRecentlyPlayedListUpdatedHandler(IRecentlyPlayedListUpdatedHandler(this));
         _buddyListGameService.addBuddyAddHandler(IBuddyAddHandler(this));
         _buddyListGameService.addBuddyAddFailedHandler(IBuddyAddFailedHandler(this));
         _buddyListGameService.addBuddyInvitationRequestHandler(IBuddyInvitationRequestHandler(this));
         _buddyListGameService.addBuddyStatusChangedHandler(IBuddyStatusChangedHandler(this));
         _buddyListGameService.addRecentlyPlayedStatusChangedHandler(IRecentlyPlayedStatusChangedHandler(this));
         _buddyListGameService.addBuddyDeleteHandler(IBuddyDeleteHandler(this));
         param2.addBuddyAvatarDataHandler(IBuddyAvatarDataHandler(this));
      }
      
      public function handleBuddyAvatarData(param1:Object = null) : void
      {
         var _loc2_:IBuddyData = new BuddyData();
         _loc2_.UserId = int(param1.userRefId);
         _loc2_.Avatar = int(param1.avatarId);
         _loc2_.NMP = int(param1.nmp);
         dispatchEvent(new BuddyEvent(BuddyEvent.AVATAR_CHANGE,_loc2_));
      }
      
      public function handleBuddyAdd(param1:Object = null) : void
      {
         log("handleBuddyAdd: userRefId: " + param1.userRefId + ", username: " + param1.username + ", status: " + param1.status + ", avatarId: " + param1.avatarId);
         dispatchEvent(new BuddyEvent(BuddyEvent.ADD,new BuddyData(param1.userRefId,param1.username,getOnlineValue(int(param1.status)),param1.status,param1.avatarId,0,param1.nmp)));
      }
      
      public function handleBuddyStatusChanged(param1:Object = null) : void
      {
         log("handleBuddyStatusChanged: userRefId: " + param1.userRefId + ", username: " + param1.username + ", status: " + param1.status + ", avatarId: " + param1.avatarId + ", nmp: " + param1.nmp);
         dispatchEvent(new BuddyEvent(BuddyEvent.CHAT_STATUS_CHANGE,new BuddyData(param1.userRefId,param1.username,getOnlineValue(int(param1.status)),param1.status,param1.avatarId,0,param1.nmp)));
      }
      
      public function handleBuddyDelete(param1:Object = null) : void
      {
         var _loc2_:int = int(param1.userRefId);
         var _loc3_:String = BuddyEvent.REMOVE_RECEIVED;
         if(_myUserRefId == _loc2_)
         {
            _loc2_ = int(param1.buddyRefId);
            _loc3_ = BuddyEvent.REMOVE_SENT_RECEIVED;
         }
         dispatchEvent(new BuddyEvent(_loc3_,new BuddyData(_loc2_)));
      }
      
      public function sendBuddyListRequest() : void
      {
         _buddyListGameService.loadBuddyList();
      }
      
      public function handleRecentlyPlayedListUpdated(param1:Object = null) : void
      {
         log("handleRecentlyPlayedListUpdated");
         dispatchEvent(new BuddyListEvent(BuddyListEvent.RP_LIST_RECEIVED,convertToBuddyDataList(param1.recentlyPlayedList as Array)));
      }
      
      private function log(param1:String) : void
      {
         if(SHOW_DEBUG_LOGS)
         {
            DebugLog.instance.log(">> BuddyPersistConn: " + param1);
         }
      }
      
      public function handleBuddyListUpdated(param1:Object = null) : void
      {
         log("handleBuddyListUpdated");
         dispatchEvent(new BuddyListEvent(BuddyListEvent.BUDDY_LIST_RECEIVED,convertToBuddyDataList(param1.buddies as Array)));
      }
      
      private function convertToBuddyDataList(param1:Array) : Array
      {
         var _loc4_:IBuddyData = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new BuddyData();
            _loc4_.UserId = int(param1[_loc3_].userRefId);
            _loc4_.Name = param1[_loc3_].username;
            _loc4_.Block = 0;
            _loc4_.Avatar = int(param1[_loc3_].avatarId);
            _loc4_.Status = int(param1[_loc3_].status);
            _loc4_.Online = _loc4_.Status < 0 ? 0 : 1;
            _loc4_.NMP = param1[_loc3_].nmp;
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function logError(param1:String) : void
      {
         if(SHOW_DEBUG_LOGS)
         {
            DebugLog.instance.error("** BuddyPersistConn: " + param1);
         }
      }
      
      public function handleBuddyInvitationRequest(param1:String) : void
      {
         var _loc2_:IBuddyData = new BuddyData();
         _loc2_.Name = param1;
         dispatchEvent(new BuddyEvent(BuddyEvent.REQUEST_RECEIVED,_loc2_));
      }
      
      private function getOnlineValue(param1:int) : int
      {
         return -1 == param1 ? 0 : 1;
      }
      
      public function deleteBuddy(param1:IBuddyData) : void
      {
         _buddyListGameService.deleteBuddy(param1.UserId);
      }
      
      public function handleBuddyAddFailed(param1:Object = null) : void
      {
         log("handleBuddyAddFailed: " + param1.username);
         dispatchEvent(new BuddyEvent(BuddyEvent.ADD_FAILED,new BuddyData(-1,param1.username),param1.responseCode,param1.errorMessage));
      }
      
      public function sendRPListRequest() : void
      {
         _buddyListGameService.loadRecentlyPlayedList();
      }
      
      public function replyToBuddyInvitation(param1:String, param2:Boolean) : void
      {
         log("replyToBuddyInvitation: " + param1 + " - " + param2);
         _buddyListGameService.replyBuddyInvitation(param1,param2);
      }
      
      public function inviteBuddy(param1:String) : void
      {
         log("inviteBuddy: " + param1);
         _buddyListGameService.inviteBuddy(param1);
      }
      
      public function handleRecentlyPlayedStatusChanged(param1:Object = null) : void
      {
         dispatchEvent(new BuddyEvent(BuddyEvent.CHAT_STATUS_CHANGE,new BuddyData(param1.userRefId,param1.username,getOnlineValue(int(param1.status)),param1.status,param1.avatarId,0,param1.nmp)));
      }
   }
}

