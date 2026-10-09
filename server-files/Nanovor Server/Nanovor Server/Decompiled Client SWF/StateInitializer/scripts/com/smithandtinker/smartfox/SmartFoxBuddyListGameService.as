package com.smithandtinker.smartfox
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IBuddyListGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.buddylist.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   
   public class SmartFoxBuddyListGameService extends AbstractSmartFoxGameService implements IBuddyListGameService, IBattleStartedHandler
   {
      
      private static const EXTENSION_NAME:String = "buddyListXt";
      
      private static const REQUEST_RECENTLY_PLAYED_LIST:String = "getRecentlyPlayedList";
      
      private static const STATUS_ONLINE:String = "online";
      
      private static const STATUS_BATTLE:String = "in battle";
      
      private static const STATUS_TRADE:String = "in trade";
      
      private static const STATUS_OFFLINE:String = "offline";
      
      private var _buddyListLoaded:Boolean;
      
      private var _buddyList:Array;
      
      private var _loadingBuddyList:Boolean;
      
      private var _battleGameService:IBattleGameService;
      
      private var _recentlyPlayedListLoaded:Boolean;
      
      private var _loadingRecentlyPlayedList:Boolean;
      
      private var _invitedBuddy:String;
      
      private var _recentlyPlayedList:Array;
      
      public function SmartFoxBuddyListGameService(param1:IUserProfile, param2:SmartFoxConnection, param3:IBattleGameService)
      {
         super(param1,param2,EXTENSION_NAME);
         this._battleGameService = param3;
         this._battleGameService.addBattleStartedHandler(IBattleStartedHandler(this));
         this._buddyListLoaded = false;
         this._recentlyPlayedListLoaded = false;
         this._invitedBuddy = "";
         this._buddyList = new Array();
         this._recentlyPlayedList = new Array();
         this._loadingBuddyList = false;
         this._loadingRecentlyPlayedList = false;
         this.registerBuddyListEventHandlers();
      }
      
      public static function convertStatus(param1:String) : int
      {
         switch(param1)
         {
            case STATUS_ONLINE:
               return 0;
            case STATUS_BATTLE:
               return 1;
            case STATUS_TRADE:
               return 2;
            case STATUS_OFFLINE:
         }
         return -1;
      }
      
      public function addBuddyInvitationRequestHandler(param1:IBuddyInvitationRequestHandler) : void
      {
         addHandler(IBuddyInvitationRequestHandler,param1);
      }
      
      public function get buddyList() : Array
      {
         return this._buddyList;
      }
      
      public function addRecentlyPlayedListUpdatedHandler(param1:IRecentlyPlayedListUpdatedHandler) : void
      {
         addHandler(IRecentlyPlayedListUpdatedHandler,param1);
      }
      
      private function handleBuddyRemoved(param1:Object) : void
      {
         var _loc2_:IBuddyDeleteHandler = null;
         for each(_loc2_ in _handlers[IBuddyDeleteHandler])
         {
            _loc2_.handleBuddyDelete(param1);
         }
      }
      
      override protected function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[IBuddyListUpdatedHandler] = new Dictionary(true);
         _handlers[IRecentlyPlayedListUpdatedHandler] = new Dictionary(true);
         _handlers[IBuddyAddHandler] = new Dictionary(true);
         _handlers[IBuddyAddFailedHandler] = new Dictionary(true);
         _handlers[IBuddyStatusChangedHandler] = new Dictionary(true);
         _handlers[IRecentlyPlayedStatusChangedHandler] = new Dictionary(true);
         _handlers[IBuddyInvitationRequestHandler] = new Dictionary(true);
         _handlers[IOfflineBuddyInvitationRequestHandler] = new Dictionary(true);
         _handlers[IBuddyDeleteHandler] = new Dictionary(true);
      }
      
      private function updateBuddy(param1:Object) : void
      {
         var _loc2_:IBuddyStatusChangedHandler = null;
         this.log("Buddy Changed Status: " + param1.username + " (" + param1.status + ")");
         this.log("updateBuddy(): Name: " + param1.username + " nmp: " + param1.nmp);
         param1.status = convertStatus(param1.status);
         for each(_loc2_ in _handlers[IBuddyStatusChangedHandler])
         {
            _loc2_.handleBuddyStatusChanged(param1);
         }
      }
      
      public function removeBuddyListUpdatedHandler(param1:IBuddyListUpdatedHandler) : void
      {
         removeHandler(IBuddyListUpdatedHandler,param1);
      }
      
      private function handleOfflineBuddyInvitationRequest(param1:String) : void
      {
         var _loc2_:IOfflineBuddyInvitationRequestHandler = null;
         for each(_loc2_ in _handlers[IOfflineBuddyInvitationRequestHandler])
         {
            _loc2_.handleOfflineBuddyInvitationRequest(param1);
         }
      }
      
      public function removeOfflineBuddyInvitationRequestHandler(param1:IOfflineBuddyInvitationRequestHandler) : void
      {
         removeHandler(IOfflineBuddyInvitationRequestHandler,param1);
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.type;
         var _loc3_:Object = param1.params.dataObj;
         var _loc4_:String = _loc3_._cmd;
         var _loc5_:Boolean = true;
         switch(_loc4_)
         {
            case "buddyListLoaded":
               this.updateBuddyList(_loc3_.buddyList);
               break;
            case "buddyStatusChanged":
            case "buddyAvatarData":
               this.updateBuddy(_loc3_);
               break;
            case "recentlyPlayedListLoaded":
               this.updateRecentlyPlayedList(_loc3_.recentlyPlayedList);
               break;
            case "rpUserStatusChanged":
               this.updateRPUser(_loc3_);
               break;
            case "invitationsLoaded":
               this.log("case \'invitationsLoaded\'...");
               this.processOfflineInvitations(_loc3_.invitations,_loc3_.rejectedInvitations,_loc3_.acceptedInvitations);
               break;
            case "buddyInvitedOffline":
               this.log("buddyInvitedOffline: data.username: " + _loc3_.offlineInvitee.username);
               this.handleBuddyAddFailed({
                  "username":_loc3_.offlineInvitee.username,
                  "responseCode":5
               });
               break;
            case "noInvitations":
               break;
            case "buddyInvitationRequest":
               this.handleBuddyInvitationRequest(_loc3_.inviter);
               break;
            case "buddyInvited":
               trace(" BUDDY INVITED");
               break;
            case "buddyInvitationError":
               this.handleBuddyAddFailed({
                  "errorMessage":_loc3_.msg,
                  "responseCode":1
               });
               break;
            case "buddyInvitationAccepted":
               this.log("handleExtensionResponse: case \'buddyInvitationAccepted\': " + _loc3_.username);
               trace(" BUDDY INVITATION ACCEPTED: " + _loc3_.username + ", status: " + _loc3_.status);
               if(null == _loc3_.nmp || "null" == "" + _loc3_.nmp)
               {
                  _loc3_.nmp = -1;
               }
               this.handleBuddyAdd({
                  "username":_loc3_.username,
                  "userRefId":_loc3_.userRefId,
                  "avatarId":_loc3_.avatarId,
                  "status":convertStatus(_loc3_.status),
                  "nmp":_loc3_.nmp
               });
               break;
            case "buddyInvitationRejected":
               if(_loc3_.username != _userProfile.screenname)
               {
                  this.handleBuddyAddFailed({
                     "username":_loc3_.username,
                     "responseCode":4
                  });
               }
               break;
            case "buddyRemoved":
               this.debugTrace("Buddy removed");
               this.handleBuddyRemoved({
                  "msg":_loc3_.msg,
                  "userRefId":_loc3_.userRefId,
                  "buddyRefId":_loc3_.buddyRefId
               });
               break;
            case "buddyRemoveError":
               this.debugTrace("Error: " + _loc3_.msg);
               break;
            case "buddyDoesNotExist":
               this.handleBuddyAddFailed({
                  "username":_loc3_.username,
                  "responseCode":2
               });
               break;
            default:
               _loc5_ = false;
         }
         if(_loc5_)
         {
            this.log(">>SMF>><< handleExtensionResponse [" + EXTENSION_NAME + "]: found case for: " + _loc4_);
         }
      }
      
      public function getBuddyIdByUserRefId(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buddyList.length)
         {
            if(this._buddyList[_loc2_].userRefId == param1)
            {
               return int(this._buddyList[_loc2_].id);
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function onBuddyListError(param1:SFSEvent) : void
      {
         this.debugTrace("BuddyList Error: " + param1);
      }
      
      public function removeBuddyDeleteHandler(param1:IBuddyDeleteHandler) : void
      {
         removeHandler(IBuddyDeleteHandler,param1);
      }
      
      private function debugTrace(param1:String) : void
      {
         trace("[ LOG ] " + param1);
      }
      
      public function removeBuddyAddFailedHandler(param1:IBuddyAddFailedHandler) : void
      {
         removeHandler(IBuddyAddFailedHandler,param1);
      }
      
      public function removeBuddyAddHandler(param1:IBuddyAddHandler) : void
      {
         removeHandler(IBuddyAddHandler,param1);
      }
      
      private function updateRecentlyPlayedList(param1:Array) : void
      {
         var _loc2_:IRecentlyPlayedListUpdatedHandler = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         trace("recently played list loaded");
         this._recentlyPlayedList = new Array();
         if(param1 == null || param1.length == 0)
         {
            this.debugTrace("No recently played users yet");
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = new Object();
               _loc4_.username = param1[_loc3_].username;
               _loc4_.status = convertStatus(param1[_loc3_].status == undefined ? "offline" : param1[_loc3_].status);
               _loc4_.userRefId = param1[_loc3_].userRefId == undefined ? "-1" : param1[_loc3_].userRefId;
               _loc4_.avatarId = param1[_loc3_].avatarId == undefined ? "0" : param1[_loc3_].avatarId;
               _loc4_.inGameStatus = param1[_loc3_].inGameStatus == undefined ? null : param1[_loc3_].inGameStatus;
               _loc4_.nmp = param1[_loc3_].nmp == "" ? "-1" : param1[_loc3_].nmp;
               this._recentlyPlayedList.push(_loc4_);
               _loc3_++;
            }
         }
         this._loadingRecentlyPlayedList = false;
         this._recentlyPlayedListLoaded = true;
         for each(_loc2_ in _handlers[IRecentlyPlayedListUpdatedHandler])
         {
            _loc2_.handleRecentlyPlayedListUpdated({"recentlyPlayedList":this._recentlyPlayedList});
         }
         this.log("Recently played list received: " + this._recentlyPlayedList.length);
      }
      
      private function loadInvitations() : void
      {
         this.log("loadInvitations -- sending loadInvitations request!");
         sendRequestToServer("loadInvitations",{"n":"n"});
      }
      
      public function replyBuddyInvitation(param1:String, param2:Boolean) : void
      {
         if(param1 != "")
         {
            trace("INVITATION ACCEPTED: " + param2);
            sendRequestToServer("replyBuddyInvitation",{
               "accept":param2,
               "buddy":param1
            });
         }
         else
         {
            this.debugTrace("Buddy name is blank");
         }
      }
      
      public function addOfflineBuddyInvitationRequestHandler(param1:IOfflineBuddyInvitationRequestHandler) : void
      {
         addHandler(IOfflineBuddyInvitationRequestHandler,param1);
      }
      
      public function getBuddyByName(param1:String) : Object
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buddyList.length)
         {
            if(this._buddyList[_loc2_].username == param1)
            {
               return this._buddyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function updateBuddyList(param1:Array) : void
      {
         var _loc2_:IBuddyListUpdatedHandler = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         trace("buddies loaded");
         if(!this._buddyListLoaded)
         {
            this.loadInvitations();
         }
         this._buddyList = new Array();
         this._buddyListLoaded = true;
         if(param1 == null || param1.length == 0)
         {
            this.debugTrace("No buddies yet");
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_] != undefined)
               {
                  _loc4_ = new Object();
                  _loc4_.username = param1[_loc3_].username;
                  _loc4_.status = convertStatus(param1[_loc3_].status == undefined ? "offline" : param1[_loc3_].status);
                  _loc4_.userRefId = param1[_loc3_].userRefId == undefined ? "-1" : param1[_loc3_].userRefId;
                  _loc4_.avatarId = param1[_loc3_].avatarId == undefined ? "0" : param1[_loc3_].avatarId;
                  _loc4_.inGameStatus = param1[_loc3_].inGameStatus == undefined ? null : param1[_loc3_].inGameStatus;
                  _loc4_.nmp = param1[_loc3_].nmp == "" ? "-1" : param1[_loc3_].nmp;
                  this._buddyList.push(_loc4_);
                  this.log("Buddy: " + _loc4_.username + " (" + _loc4_.status + ") NMP: " + param1[_loc3_].nmp + " userRefId: " + _loc4_.userRefId);
               }
               _loc3_++;
            }
         }
         this._loadingBuddyList = false;
         for each(_loc2_ in _handlers[IBuddyListUpdatedHandler])
         {
            _loc2_.handleBuddyListUpdated({"buddies":this._buddyList});
         }
      }
      
      public function inviteBuddy(param1:String) : void
      {
         if(this._buddyListLoaded)
         {
            if(param1 != "")
            {
               sendRequestToServer("inviteBuddy",{"buddy":param1});
               this._invitedBuddy = "";
            }
            else
            {
               this.debugTrace("Buddy name is blank");
            }
         }
         else
         {
            this.debugTrace("Buddy List not ready");
            this.loadBuddyList();
            this._invitedBuddy = param1;
         }
      }
      
      public function loadBuddyList() : void
      {
         if(!this._loadingBuddyList)
         {
            this._loadingBuddyList = true;
            sendRequestToServer("getBuddyList",{"n":"n"});
         }
      }
      
      private function handleBuddyAdd(param1:Object) : void
      {
         var _loc2_:IBuddyAddHandler = null;
         for each(_loc2_ in _handlers[IBuddyAddHandler])
         {
            _loc2_.handleBuddyAdd(param1);
         }
      }
      
      public function addRecentlyPlayedStatusChangedHandler(param1:IRecentlyPlayedStatusChangedHandler) : void
      {
         addHandler(IRecentlyPlayedStatusChangedHandler,param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("[SMARTFOX BUDDY LIST]    " + param1,_userProfile.screenname);
      }
      
      private function registerBuddyListEventHandlers() : void
      {
         _gameServiceConnection.addEventListener(SFSEvent.onExtensionResponse,this.handleExtensionResponse);
         _gameServiceConnection.addEventListener(SFSEvent.onBuddyListError,this.onBuddyListError);
         _gameServiceConnection.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      public function removeBuddyStatusChangedHandler(param1:IBuddyStatusChangedHandler) : void
      {
         removeHandler(IBuddyStatusChangedHandler,param1);
      }
      
      public function addBuddyStatusChangedHandler(param1:IBuddyStatusChangedHandler) : void
      {
         addHandler(IBuddyStatusChangedHandler,param1);
      }
      
      private function unregisterBuddyListEventHandlers() : void
      {
         _gameServiceConnection.removeEventListener(SFSEvent.onExtensionResponse,this.handleExtensionResponse);
         _gameServiceConnection.removeEventListener(SFSEvent.onBuddyListError,this.onBuddyListError);
         _gameServiceConnection.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("[SMARTFOX BUDDY LIST]    " + param1,_userProfile.screenname);
      }
      
      private function handleBuddyInvitationRequest(param1:String) : void
      {
         var _loc2_:IBuddyInvitationRequestHandler = null;
         for each(_loc2_ in _handlers[IBuddyInvitationRequestHandler])
         {
            _loc2_.handleBuddyInvitationRequest(param1);
         }
      }
      
      public function addBuddyListUpdatedHandler(param1:IBuddyListUpdatedHandler) : void
      {
         addHandler(IBuddyListUpdatedHandler,param1);
      }
      
      public function loadRecentlyPlayedList() : void
      {
         if(!this._loadingRecentlyPlayedList)
         {
            this._loadingRecentlyPlayedList = true;
            sendRequestToServer(REQUEST_RECENTLY_PLAYED_LIST,{"n":"n"});
         }
      }
      
      public function get recentlyPlayedList() : Array
      {
         return this._recentlyPlayedList;
      }
      
      public function handleBattleStarted(param1:Object = null) : void
      {
         this.log("handleBattleStarted()");
         sendRequestToServer(REQUEST_RECENTLY_PLAYED_LIST,{"n":"n"});
      }
      
      public function deleteBuddy(param1:int) : Boolean
      {
         if(this._buddyListLoaded)
         {
            if(param1 > -1)
            {
               sendRequestToServer("removeBuddy",{"buddyRefId":param1});
               return true;
            }
            this.debugTrace("Buddy name is blank");
         }
         return false;
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         this.debugTrace("I/O Error: " + param1.text);
      }
      
      public function removeRecentlyPlayedStatusChangedHandler(param1:IRecentlyPlayedStatusChangedHandler) : void
      {
         removeHandler(IRecentlyPlayedStatusChangedHandler,param1);
      }
      
      private function updateRPUser(param1:Object) : void
      {
         var _loc2_:IRecentlyPlayedStatusChangedHandler = null;
         this.log("updateRPUser: " + param1.username + " (" + param1.status + ")");
         param1.status = convertStatus(param1.status);
         for each(_loc2_ in _handlers[IRecentlyPlayedStatusChangedHandler])
         {
            _loc2_.handleRecentlyPlayedStatusChanged(param1);
         }
      }
      
      public function removeRecentlyPlayedListUpdatedHandler(param1:IRecentlyPlayedListUpdatedHandler) : void
      {
         removeHandler(IRecentlyPlayedListUpdatedHandler,param1);
      }
      
      private function processOfflineInvitations(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         this.log("  @@ processOfflineInvitations...");
         if(param1 == null)
         {
            this.log("     .. no pending invitations");
         }
         else
         {
            this.log("     .. " + param1.length + " pending invitation(s)");
            _loc5_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(param1[_loc4_] != null)
               {
                  _loc5_.push(param1[_loc4_].username);
               }
               _loc4_++;
            }
            while(_loc5_.length > 0)
            {
               this.handleBuddyInvitationRequest(_loc5_.shift());
            }
         }
         if(param2 == null)
         {
            this.log("     .. no rejected invitations");
         }
         else
         {
            this.log("     .. " + param2.length + " rejected invitation(s)");
            _loc6_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(Boolean(param2[_loc4_].username))
               {
                  _loc6_.push({
                     "username":param2[_loc4_].username,
                     "responseCode":4
                  });
               }
               _loc4_++;
            }
            while(Boolean(_loc6_.length))
            {
               this.handleBuddyAddFailed(_loc6_.shift());
            }
         }
         if(param3 == null)
         {
            this.log("     .. no accepted invitations");
         }
         else
         {
            this.log("     .. " + param3.length + " accepted invitation(s)");
            _loc7_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               if(Boolean(param3[_loc4_].username))
               {
                  _loc7_.push({
                     "username":param3[_loc4_].username,
                     "userRefId":param3[_loc4_].userRefId
                  });
               }
               _loc4_++;
            }
            while(_loc7_.length > 0)
            {
               this.handleBuddyAdd(_loc7_.shift());
            }
         }
      }
      
      private function handleBuddyAddFailed(param1:Object) : void
      {
         var _loc2_:IBuddyAddFailedHandler = null;
         for each(_loc2_ in _handlers[IBuddyAddFailedHandler])
         {
            _loc2_.handleBuddyAddFailed(param1);
         }
      }
      
      public function addBuddyAddFailedHandler(param1:IBuddyAddFailedHandler) : void
      {
         addHandler(IBuddyAddFailedHandler,param1);
      }
      
      public function addBuddyAddHandler(param1:IBuddyAddHandler) : void
      {
         addHandler(IBuddyAddHandler,param1);
      }
      
      public function removeBuddyInvitationRequestHandler(param1:IBuddyInvitationRequestHandler) : void
      {
         removeHandler(IBuddyInvitationRequestHandler,param1);
      }
      
      public function addBuddyDeleteHandler(param1:IBuddyDeleteHandler) : void
      {
         addHandler(IBuddyDeleteHandler,param1);
      }
   }
}

