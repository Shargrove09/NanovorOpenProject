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
         log("BuddyManager(): first constructed here: " + new Error("JUST A  STACK TRACE").getStackTrace());
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
         _buddyPersistConn.replyToBuddyInvitation(param1.name,true);
         _analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_YES);
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
         if(addBuddy(param1.buddyData))
         {
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Accepted","User " + param1.buddyData.Name.toUpperCase() + " is now on your Friends list.",10,null,null,null,onMsgTimeOutGeneric);
            dispatchEvent(new BuddyEvent(BuddyEvent.ADD,param1.buddyData));
            _analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_ADDED);
         }
      }
      
      public function requestRemoveBuddy(param1:String) : void
      {
         log("requestRemoveBuddy: " + param1);
         var _loc2_:IBuddyData = getBuddyByName(param1);
         var _loc3_:Object = new Object();
         _loc3_.buddy = _loc2_;
         _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Remove Buddy","Are you sure you want to remove buddy " + _loc2_.Name.toUpperCase() + "?",10,acceptRemoveBuddy,null,null,_loc3_,onMsgTimeOutGeneric);
      }
      
      public function getList() : Array
      {
         return _aBuddyList.slice();
      }
      
      private function onListReceived(param1:BuddyListEvent) : void
      {
         var _loc2_:Error = null;
         if(_bLoaded)
         {
            _loc2_ = new Error("NOT an error, just tracing...");
            logError("onListReceived: buddy list should only be received _once_!  ignoring new list.\n" + _loc2_.getStackTrace());
            return;
         }
         log("onListReceived: length = " + param1.Buddylist.length);
         _bLoaded = true;
         _aBuddyList = param1.Buddylist;
         fixStackDict();
         dispatchEvent(new BuddyListEvent(BuddyListEvent.BUDDY_LIST_RECEIVED,_aBuddyList.slice()));
      }
      
      public function initialize(param1:IAnalyticsManager, param2:String, param3:IBuddyPersistConn) : void
      {
         log("initialize(): myUserName=" + param2);
         _analyticsManager = param1;
         _myUserName = param2;
         _buddyPersistConn = param3;
         _buddyPersistConn.addEventListener(BuddyListEvent.BUDDY_LIST_RECEIVED,onListReceived,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.ADD,onBuddyAdded,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.REQUEST_RECEIVED,onBuddyRequestReceived,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.ADD_FAILED,onBuddyAddFailed,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.REMOVE_RECEIVED,onBuddyRemoved,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.REMOVE_SENT_RECEIVED,onBuddyIRemoved,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,onStatusChange,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.ONLINE_STATUS_CHANGE,onOnlineChange,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.AVATAR_CHANGE,onAvatarChange,false,0,true);
         _buddyPersistConn.addEventListener(BuddyEvent.FLAG_CHANGE,onFlagChange,false,0,true);
      }
      
      public function sendBuddyListRequest() : void
      {
         log("BuddyManager.sendBuddyListRequest()");
         if(_bLoading || _bLoaded)
         {
            return;
         }
         _bLoading = true;
         _buddyPersistConn.sendBuddyListRequest();
      }
      
      private function removeBuddyById(param1:int) : String
      {
         var _loc2_:String = null;
         if(buddyExistsById(param1))
         {
            _loc2_ = _aBuddyList[_dictIds[param1]].Name;
            stackSplice(_aBuddyList[_dictIds[param1]] as IBuddyData);
            return _loc2_;
         }
         return null;
      }
      
      private function stackSplice(param1:IBuddyData) : int
      {
         log("stackSplice(): " + param1.Name);
         var _loc2_:int = int(_dictIds[param1.UserId]);
         _aBuddyList.splice(_loc2_,1);
         _dictIds[param1.UserId] = null;
         fixStackDict();
         return _aBuddyList.length;
      }
      
      private function addBuddy(param1:IBuddyData) : Boolean
      {
         if(!buddyExistsById(param1.UserId))
         {
            log("addBuddy: " + param1.toString());
            stackPush(param1);
            return true;
         }
         updateBuddy(param1);
         return false;
      }
      
      private function setOnlineStatus(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(buddyExistsById(param1))
         {
            _loc3_ = getBuddy(param1);
            if(_loc3_.Online != param2)
            {
               _loc3_.Online = param2;
               updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      public function get Loaded() : Boolean
      {
         return _bLoaded;
      }
      
      private function onBuddyRemoveFailed(param1:BuddyEvent) : void
      {
         dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_FAILED,param1.buddyData,param1.responseCode));
      }
      
      public function getBuddyByName(param1:String) : IBuddyData
      {
         log("getBuddyByName(): " + param1);
         param1 = param1.toLowerCase();
         var _loc2_:Array = _aBuddyList.slice();
         log("buddyList.length: " + _loc2_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(IBuddyData(_loc2_[_loc3_]).Name.toLowerCase() == param1)
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         log("getBuddyByName(): buddy not found: " + param1);
         return null;
      }
      
      private function acceptSendBuddyRequest(param1:Object) : void
      {
         _buddyPersistConn.inviteBuddy(param1.name);
         _analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_FRIEND);
      }
      
      private function buddyExistsById(param1:int) : Boolean
      {
         return _dictIds[param1] !== undefined && _dictIds[param1] !== null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyManager: " + param1);
      }
      
      public function getBuddy(param1:int) : IBuddyData
      {
         if(!buddyExistsById(param1))
         {
            return null;
         }
         return _aBuddyList[_dictIds[param1]] as IBuddyData;
      }
      
      private function onBuddyRemoved(param1:BuddyEvent) : void
      {
         var _loc2_:String = removeBuddyById(param1.buddyData.UserId);
         if(_loc2_ !== null)
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_SENT_RECEIVED,param1.buddyData));
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Removed","User " + _loc2_.toUpperCase() + " has removed you from their buddy list.",10,null,null,null,onMsgTimeOutGeneric);
            _analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_REMOVED);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyManager: " + param1);
      }
      
      private function clear() : *
      {
         log("clear()");
         var _loc1_:int = 0;
         while(_loc1_ < _aBuddyList.length)
         {
            _dictIds[_aBuddyList[_loc1_].UserId] = null;
            _aBuddyList[_loc1_] = null;
            _loc1_++;
         }
         _aBuddyList = new Array();
         _dictIds = new Dictionary();
      }
      
      private function onStatusChange(param1:BuddyEvent) : void
      {
         if(false == buddyExistsById(param1.buddyData.UserId))
         {
            return;
         }
         if(false == setChatStatus(param1.buddyData.UserId,param1.buddyData.Status))
         {
            log("onStatusChange(): WARNING: server is sending status change when it actually hasn\'t--user: " + param1.buddyData.Name + ", status: " + param1.buddyData.Status);
         }
         dispatchEvent(new BuddyEvent(BuddyEvent.CHAT_STATUS_CHANGE,param1.buddyData));
      }
      
      private function stackPush(param1:IBuddyData) : int
      {
         var _loc2_:int = _aBuddyList.push(param1) - 1;
         _dictIds[param1.UserId] = _loc2_;
         return _loc2_;
      }
      
      private function timeoutAddBuddyOffer(param1:Object) : void
      {
         _analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_TIMEOUT);
         onMsgTimeOutGeneric(param1);
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
         _dialogBox = CommonDialogBox.MakeAndQueue(_loc4_,_loc5_,_loc6_);
         var _loc7_:String = Action.HOME_FRIENDS_ADD_FRIEND_FAILED.name.replace("%REASON%",_loc5_.toLowerCase().replace(" ","-"));
         _analyticsManager.trackAction(Action.createDynamic(_loc7_));
      }
      
      private function fixStackDict() : void
      {
         log("fixStackDict()");
         var _loc1_:int = 0;
         while(_loc1_ < _aBuddyList.length)
         {
            _dictIds[_aBuddyList[_loc1_].UserId] = _loc1_;
            _loc1_++;
         }
      }
      
      private function stackShift() : IBuddyData
      {
         var _loc1_:IBuddyData = null;
         _loc1_ = _aBuddyList.shift();
         log("stackShift(): " + _loc1_.Name);
         _dictIds[_loc1_.UserId] = null;
         fixStackDict();
         return _loc1_;
      }
      
      public function requestAddBuddy(param1:String) : void
      {
         var _loc3_:Object = null;
         log("requestAddBuddy(): " + param1);
         var _loc2_:String = param1;
         _myUserName;
         if(null != getBuddyByName(_loc2_))
         {
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Permitted","User " + _loc2_.toUpperCase() + " is already on your buddy list.",10,null,null,null,onMsgTimeOutGeneric);
         }
         else if(_myUserName.toLowerCase() == _loc2_.toLowerCase())
         {
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Permitted","You can not add yourself as a buddy.",10,null,null,null,onMsgTimeOutGeneric);
         }
         else
         {
            log("requestAddBuddy()");
            _loc3_ = new Object();
            _loc3_.name = _loc2_;
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Send Buddy Request","Are you sure you want to add " + _loc2_.toUpperCase() + " to your Friends list?",0,acceptSendBuddyRequest,null,null,_loc3_,onMsgTimeOutGeneric);
         }
      }
      
      private function setBlockFlag(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(buddyExistsById(param1))
         {
            _loc3_ = getBuddy(param1);
            if(_loc3_.Block != param2)
            {
               _loc3_.Block = param2;
               updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function setAvatar(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(buddyExistsById(param1))
         {
            _loc3_ = getBuddy(param1);
            if(_loc3_.Avatar != param2)
            {
               _loc3_.Avatar = param2;
               updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function declineAddBuddyOffer(param1:Object) : void
      {
         _buddyPersistConn.replyToBuddyInvitation(param1.name,false);
         _analyticsManager.trackAction(Action.HOME_FRIENDS_ADD_RESPOND_NO);
      }
      
      private function onBuddyRequestReceived(param1:BuddyEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.name = param1.buddyData.Name;
         _dialogBox = CommonDialogBox.MakeAndQueue("confirm","Buddy Offer",param1.buddyData.Name.toUpperCase() + " wants to be your friend.  Do you want to add " + param1.buddyData.Name.toUpperCase() + " to your Friends list?",0,acceptAddBuddyOffer,declineAddBuddyOffer,declineAddBuddyOffer,_loc2_,timeoutAddBuddyOffer);
         _analyticsManager.trackAction(Action.HOME_FRIENDS_REQUEST_RECEIVED);
      }
      
      private function setChatStatus(param1:int, param2:int) : Boolean
      {
         var _loc3_:IBuddyData = null;
         if(buddyExistsById(param1))
         {
            _loc3_ = getBuddy(param1);
            if(_loc3_.Status != param2)
            {
               _loc3_.Status = param2;
               updateBuddy(_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function onAvatarChange(param1:BuddyEvent) : void
      {
         if(setAvatar(param1.buddyData.UserId,param1.buddyData.Avatar))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.AVATAR_CHANGE,getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function stackUnshift(param1:IBuddyData) : int
      {
         var _loc2_:int = int(_aBuddyList.unshift(param1));
         fixStackDict();
         return _loc2_;
      }
      
      private function onOnlineChange(param1:BuddyEvent) : void
      {
         if(setOnlineStatus(param1.buddyData.UserId,param1.buddyData.Online))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.ONLINE_STATUS_CHANGE,getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function acceptRemoveBuddy(param1:Object) : void
      {
         _buddyPersistConn.deleteBuddy(param1.buddy);
         _analyticsManager.trackAction(Action.HOME_FRIENDS_REMOVE_FRIEND);
      }
      
      private function onFlagChange(param1:BuddyEvent) : void
      {
         if(setBlockFlag(param1.buddyData.UserId,param1.buddyData.Block))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.FLAG_CHANGE,getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function updateBuddy(param1:IBuddyData) : void
      {
         _aBuddyList[_dictIds[param1.UserId]] = param1;
      }
      
      private function onBuddyIRemoved(param1:BuddyEvent) : void
      {
         var _loc2_:String = removeBuddyById(param1.buddyData.UserId);
         if(_loc2_ !== null)
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_SENT_RECEIVED,param1.buddyData));
            _dialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Removed","User " + _loc2_.toUpperCase() + " has been removed from your buddy list.",10,null,null,null,onMsgTimeOutGeneric);
            _analyticsManager.trackAction(Action.HOME_FRIENDS_FRIEND_REMOVED);
         }
      }
   }
}

