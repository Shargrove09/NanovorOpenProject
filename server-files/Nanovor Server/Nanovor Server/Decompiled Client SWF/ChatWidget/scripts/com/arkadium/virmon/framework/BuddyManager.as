package com.arkadium.virmon.framework
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.framework.events.*;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class BuddyManager extends EventDispatcher implements IBuddyManager
   {
      
      private static var _oInstance:IBuddyManager;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _aBuddyList:Array = new Array();
      
      private var _bLoaded:Boolean = false;
      
      private var _buddyPersistConn:IBuddyPersistConn;
      
      private var _bLoading:Boolean = false;
      
      private var _myUserName:String;
      
      private var _dictIds:Dictionary = new Dictionary();
      
      private var _dialogBox:CommonDialogBox;
      
      public function BuddyManager()
      {
         super();
         this.log("BuddyManager(): first constructed here: " + new Error("JUST A  STACK TRACE").getStackTrace());
      }
      
      public static function getInstance() : IBuddyManager
      {
         if(!_oInstance)
         {
            _oInstance = new BuddyManager();
         }
         return _oInstance;
      }
      
      private function acceptAddBuddyOffer(param1:Object) : void
      {
         this._buddyPersistConn.replyToBuddyInvitation(param1.name,true);
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_YES);
      }
      
      private function onMsgTimeOutGeneric(param1:Object) : void
      {
         if(Boolean(param1.callingCDB) && Boolean(param1.callingCDB as CommonDialogBox))
         {
            (param1.callingCDB as CommonDialogBox).kill();
         }
      }
      
      private function onBuddyAdded(param1:BuddyEvent) : void
      {
         if(this.addBuddy(param1.buddyData))
         {
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Accepted","User " + param1.buddyData.Name.toUpperCase() + " is now on your Friends list.",10,null,null,null,this.onMsgTimeOutGeneric);
            dispatchEvent(new BuddyEvent(BuddyEvent.ADD,param1.buddyData));
            this._analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_ADDED);
         }
      }
      
      public function requestRemoveBuddy(param1:String) : void
      {
         this.log("requestRemoveBuddy: " + param1);
         var _loc2_:IBuddyData = this.getBuddyByName(param1);
         var _loc3_:Object = new Object();
         _loc3_.buddy = _loc2_;
         this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Remove Buddy","Are you sure you want to remove buddy " + _loc2_.Name.toUpperCase() + "?",10,this.acceptRemoveBuddy,null,null,_loc3_,this.onMsgTimeOutGeneric);
      }
      
      public function getList() : Array
      {
         return this._aBuddyList.slice();
      }
      
      private function onListReceived(param1:BuddyListEvent) : void
      {
         var _loc2_:Error = null;
         if(this._bLoaded)
         {
            _loc2_ = new Error("NOT an error, just tracing...");
            this.logError("onListReceived: buddy list should only be received _once_!  ignoring new list.\n" + _loc2_.getStackTrace());
            return;
         }
         this.log("onListReceived: length = " + param1.Buddylist.length);
         this._bLoaded = true;
         this._aBuddyList = param1.Buddylist;
         this.fixStackDict();
         dispatchEvent(new BuddyListEvent(BuddyListEvent.BUDDY_LIST_RECEIVED,this._aBuddyList.slice()));
      }
      
      public function initialize(param1:IAnalyticsManager, param2:String, param3:IBuddyPersistConn) : void
      {
         this.log("initialize(): myUserName=" + param2);
         this._analyticsManager = param1;
         this._myUserName = param2;
         this._buddyPersistConn = param3;
         this._buddyPersistConn.addEventListener(BuddyListEvent.BUDDY_LIST_RECEIVED,this.onListReceived,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.ADD,this.onBuddyAdded,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.REQUEST_RECEIVED,this.onBuddyRequestReceived,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.ADD_FAILED,this.onBuddyAddFailed,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.REMOVE_RECEIVED,this.onBuddyRemoved,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.REMOVE_SENT_RECEIVED,this.onBuddyIRemoved,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,this.onStatusChange,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.ONLINE_STATUS_CHANGE,this.onOnlineChange,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.AVATAR_CHANGE,this.onAvatarChange,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.FLAG_CHANGE,this.onFlagChange,false,0,true);
      }
      
      public function sendBuddyListRequest() : void
      {
         this.log("BuddyManager.sendBuddyListRequest()");
         if(this._bLoading || this._bLoaded)
         {
            return;
         }
         this._bLoading = true;
         this._buddyPersistConn.sendBuddyListRequest();
      }
      
      private function removeBuddyById(param1:int) : String
      {
         var _loc2_:String = null;
         if(this.buddyExistsById(param1))
         {
            _loc2_ = this._aBuddyList[this._dictIds[param1]].Name;
            this.stackSplice(this._aBuddyList[this._dictIds[param1]] as IBuddyData);
            return _loc2_;
         }
         return null;
      }
      
      private function stackSplice(param1:IBuddyData) : int
      {
         this.log("stackSplice(): " + param1.Name);
         var _loc2_:int = int(this._dictIds[param1.UserId]);
         this._aBuddyList.splice(_loc2_,1);
         this._dictIds[param1.UserId] = null;
         this.fixStackDict();
         return this._aBuddyList.length;
      }
      
      private function addBuddy(param1:IBuddyData) : Boolean
      {
         if(!this.buddyExistsById(param1.UserId))
         {
            this.log("addBuddy: " + param1.toString());
            this.stackPush(param1);
            return true;
         }
         this.updateBuddy(param1);
         return false;
      }
      
      private function setOnlineStatus(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(this.buddyExistsById(param1))
         {
            _loc3_ = this.getBuddy(param1);
            if(_loc3_.Online != param2)
            {
               _loc3_.Online = param2;
               this.updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      public function get Loaded() : Boolean
      {
         return this._bLoaded;
      }
      
      private function onBuddyRemoveFailed(param1:BuddyEvent) : void
      {
         dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_FAILED,param1.buddyData,param1.responseCode));
      }
      
      public function getBuddyByName(param1:String) : IBuddyData
      {
         this.log("getBuddyByName(): " + param1);
         param1 = param1.toLowerCase();
         var _loc2_:Array = this._aBuddyList.slice();
         this.log("buddyList.length: " + _loc2_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(IBuddyData(_loc2_[_loc3_]).Name.toLowerCase() == param1)
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         this.log("getBuddyByName(): buddy not found: " + param1);
         return null;
      }
      
      private function acceptSendBuddyRequest(param1:Object) : void
      {
         this._buddyPersistConn.inviteBuddy(param1.name);
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_FRIEND);
      }
      
      private function buddyExistsById(param1:int) : Boolean
      {
         return this._dictIds[param1] !== undefined && this._dictIds[param1] !== null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyManager: " + param1);
      }
      
      public function getBuddy(param1:int) : IBuddyData
      {
         if(!this.buddyExistsById(param1))
         {
            return null;
         }
         return this._aBuddyList[this._dictIds[param1]] as IBuddyData;
      }
      
      private function onBuddyRemoved(param1:BuddyEvent) : void
      {
         var _loc2_:String = this.removeBuddyById(param1.buddyData.UserId);
         if(_loc2_ !== null)
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_SENT_RECEIVED,param1.buddyData));
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Removed","User " + _loc2_.toUpperCase() + " has removed you from their buddy list.",10,null,null,null,this.onMsgTimeOutGeneric);
            this._analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_REMOVED);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyManager: " + param1);
      }
      
      private function clear() : *
      {
         this.log("clear()");
         var _loc1_:int = 0;
         while(_loc1_ < this._aBuddyList.length)
         {
            this._dictIds[this._aBuddyList[_loc1_].UserId] = null;
            this._aBuddyList[_loc1_] = null;
            _loc1_++;
         }
         this._aBuddyList = new Array();
         this._dictIds = new Dictionary();
      }
      
      private function onStatusChange(param1:BuddyEvent) : void
      {
         if(false == this.buddyExistsById(param1.buddyData.UserId))
         {
            return;
         }
         if(false == this.setChatStatus(param1.buddyData.UserId,param1.buddyData.Status))
         {
            this.log("onStatusChange(): WARNING: server is sending status change when it actually hasn\'t--user: " + param1.buddyData.Name + ", status: " + param1.buddyData.Status);
         }
         dispatchEvent(new BuddyEvent(BuddyEvent.CHAT_STATUS_CHANGE,param1.buddyData));
      }
      
      private function stackPush(param1:IBuddyData) : int
      {
         var _loc2_:int = this._aBuddyList.push(param1) - 1;
         this._dictIds[param1.UserId] = _loc2_;
         return _loc2_;
      }
      
      private function timeoutAddBuddyOffer(param1:Object) : void
      {
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_TIMEOUT);
         this.onMsgTimeOutGeneric(param1);
      }
      
      private function onBuddyAddFailed(param1:BuddyEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:IBuddyData = param1.buddyData;
         var _loc3_:int = param1.responseCode;
         var _loc4_:String = CommonDialogBox.TYPE_INFO;
         switch(_loc3_)
         {
            case 1:
               _loc5_ = "Not Permitted";
               _loc6_ = "User " + _loc2_.Name.toUpperCase() + " is already on your buddy list.";
               break;
            case 2:
               _loc5_ = "Invalid Username";
               _loc6_ = "Could not find user with name " + _loc2_.Name.toUpperCase() + ".";
               break;
            case 4:
               _loc5_ = "Declined";
               _loc6_ = "User " + _loc2_.Name.toUpperCase() + " declined to be your buddy.";
               break;
            case 5:
               _loc5_ = "Not Online";
               _loc6_ = "User " + _loc2_.Name.toUpperCase() + " is not online right now, and will see your request upon next login.";
               break;
            default:
               _loc4_ = CommonDialogBox.TYPE_ALERT;
               _loc5_ = "Unknown Server Response";
               _loc6_ = "Response code: " + _loc3_.toString();
         }
         this._dialogBox = CommonDialogBox.MakeAndQueue(_loc4_,_loc5_,_loc6_);
         var _loc7_:String = Action.HOME_FRIENDS_ADD_FRIEND_FAILED.name.replace("%REASON%",_loc5_.toLowerCase().replace(" ","-"));
         this._analyticsManager.trackAction(Action.createDynamic(_loc7_));
      }
      
      private function fixStackDict() : void
      {
         this.log("fixStackDict()");
         var _loc1_:int = 0;
         while(_loc1_ < this._aBuddyList.length)
         {
            this._dictIds[this._aBuddyList[_loc1_].UserId] = _loc1_;
            _loc1_++;
         }
      }
      
      private function stackShift() : IBuddyData
      {
         var _loc1_:IBuddyData = null;
         _loc1_ = this._aBuddyList.shift();
         this.log("stackShift(): " + _loc1_.Name);
         this._dictIds[_loc1_.UserId] = null;
         this.fixStackDict();
         return _loc1_;
      }
      
      public function requestAddBuddy(param1:String) : void
      {
         var _loc3_:Object = null;
         this.log("requestAddBuddy(): " + param1);
         var _loc2_:String = param1;
         this._myUserName;
         if(null != this.getBuddyByName(_loc2_))
         {
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Permitted","User " + _loc2_.toUpperCase() + " is already on your buddy list.",10,null,null,null,this.onMsgTimeOutGeneric);
         }
         else if(this._myUserName.toLowerCase() == _loc2_.toLowerCase())
         {
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Permitted","You can not add yourself as a buddy.",10,null,null,null,this.onMsgTimeOutGeneric);
         }
         else
         {
            this.log("requestAddBuddy()");
            _loc3_ = new Object();
            _loc3_.name = _loc2_;
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Send Buddy Request","Are you sure you want to add " + _loc2_.toUpperCase() + " to your Friends list?",0,this.acceptSendBuddyRequest,null,null,_loc3_,this.onMsgTimeOutGeneric);
         }
      }
      
      private function setBlockFlag(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(this.buddyExistsById(param1))
         {
            _loc3_ = this.getBuddy(param1);
            if(_loc3_.Block != param2)
            {
               _loc3_.Block = param2;
               this.updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function setAvatar(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(this.buddyExistsById(param1))
         {
            _loc3_ = this.getBuddy(param1);
            if(_loc3_.Avatar != param2)
            {
               _loc3_.Avatar = param2;
               this.updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function declineAddBuddyOffer(param1:Object) : void
      {
         this._buddyPersistConn.replyToBuddyInvitation(param1.name,false);
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_NO);
      }
      
      private function onBuddyRequestReceived(param1:BuddyEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.name = param1.buddyData.Name;
         this._dialogBox = CommonDialogBox.MakeAndQueue("confirm","Buddy Offer",param1.buddyData.Name.toUpperCase() + " wants to be your friend.  Do you want to add " + param1.buddyData.Name.toUpperCase() + " to your Friends list?",0,this.acceptAddBuddyOffer,this.declineAddBuddyOffer,this.declineAddBuddyOffer,_loc2_,this.timeoutAddBuddyOffer);
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_REQUEST_RECEIVED);
      }
      
      private function setChatStatus(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(this.buddyExistsById(param1))
         {
            _loc3_ = this.getBuddy(param1);
            if(_loc3_.Status != param2)
            {
               _loc3_.Status = param2;
               this.updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function onAvatarChange(param1:BuddyEvent) : void
      {
         if(this.setAvatar(param1.buddyData.UserId,param1.buddyData.Avatar))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.AVATAR_CHANGE,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function stackUnshift(param1:IBuddyData) : int
      {
         var _loc2_:int = int(this._aBuddyList.unshift(param1));
         this.fixStackDict();
         return _loc2_;
      }
      
      private function onOnlineChange(param1:BuddyEvent) : void
      {
         if(this.setOnlineStatus(param1.buddyData.UserId,param1.buddyData.Online))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.ONLINE_STATUS_CHANGE,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function acceptRemoveBuddy(param1:Object) : void
      {
         this._buddyPersistConn.deleteBuddy(param1.buddy);
         this._analyticsManager.trackAction(Action.HOME_FRIENDS_REMOVE_FRIEND);
      }
      
      private function onFlagChange(param1:BuddyEvent) : void
      {
         if(this.setBlockFlag(param1.buddyData.UserId,param1.buddyData.Block))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.FLAG_CHANGE,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function updateBuddy(param1:IBuddyData) : void
      {
         this._aBuddyList[this._dictIds[param1.UserId]] = param1;
      }
      
      private function onBuddyIRemoved(param1:BuddyEvent) : void
      {
         var _loc2_:String = this.removeBuddyById(param1.buddyData.UserId);
         if(_loc2_ !== null)
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_SENT_RECEIVED,param1.buddyData));
            this._dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Removed","User " + _loc2_.toUpperCase() + " has been removed from your buddy list.",10,null,null,null,this.onMsgTimeOutGeneric);
            this._analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_REMOVED);
         }
      }
   }
}

