package com.arkadium.virmon.framework
{
   import com.arkadium.virmon.framework.events.BuddyEvent;
   import com.arkadium.virmon.framework.events.BuddyListEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class BuddyRPManager extends EventDispatcher implements IBuddyRPManager
   {
      
      private static var _oInstance:IBuddyRPManager;
      
      private var _aBuddyList:Array = new Array();
      
      private var _bLoaded:Boolean = false;
      
      private var _buddyPersistConn:IBuddyPersistConn;
      
      private var _bLoading:Boolean = false;
      
      private var _dictIds:Dictionary = new Dictionary();
      
      public function BuddyRPManager()
      {
         super();
      }
      
      public static function getInstance() : IBuddyRPManager
      {
         if(!_oInstance)
         {
            _oInstance = new BuddyRPManager();
         }
         return _oInstance;
      }
      
      private function onBuddyRemoved(param1:BuddyEvent) : void
      {
         if(this.removeBuddyById(param1.buddyData.UserId))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_RECEIVED,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function buddyExistsById(param1:int) : Boolean
      {
         return this._dictIds[param1] !== undefined && this._dictIds[param1] !== null;
      }
      
      public function updateAvatar(param1:IBuddyData) : void
      {
         if(this.setAvatar(param1.UserId,param1.Avatar))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.AVATAR_CHANGE,this.getBuddy(param1.UserId)));
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyRPManager: " + param1);
      }
      
      private function updateBuddy(param1:IBuddyData) : void
      {
         this.log("updateBuddy: " + param1.toString());
         this._aBuddyList[this._dictIds[param1.UserId]] = param1;
      }
      
      private function clear() : *
      {
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
      
      public function getList() : Array
      {
         return this._aBuddyList.slice();
      }
      
      private function onAvatarChange(param1:BuddyEvent) : void
      {
         if(this.setAvatar(param1.buddyData.UserId,param1.buddyData.Avatar))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.AVATAR_CHANGE,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function fixStackDict() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._aBuddyList.length)
         {
            this._dictIds[this._aBuddyList[_loc1_].UserId] = _loc1_;
            _loc1_++;
         }
      }
      
      private function stackPush(param1:IBuddyData) : int
      {
         this.log("BuddyRPManager.stackPush(): " + new Error("stackTrace").getStackTrace());
         var _loc2_:int = this._aBuddyList.push(param1) - 1;
         this._dictIds[param1.UserId] = _loc2_;
         return _loc2_;
      }
      
      private function onListReceived(param1:BuddyListEvent) : void
      {
         this._bLoaded = true;
         this._aBuddyList = param1.Buddylist;
         this.fixStackDict();
         dispatchEvent(new BuddyListEvent(BuddyListEvent.RP_LIST_RECEIVED,this._aBuddyList.slice()));
      }
      
      public function addRP(param1:IBuddyData) : void
      {
         this.log("BuddyRPManager.addRP(): " + new Error("stackTrace").getStackTrace());
         if(this.addBuddy(param1))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.ADD,param1));
         }
      }
      
      private function stackShift() : IBuddyData
      {
         var _loc1_:IBuddyData = null;
         _loc1_ = this._aBuddyList.shift();
         this._dictIds[_loc1_.UserId] = null;
         this.fixStackDict();
         return _loc1_;
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
      
      private function stackSplice(param1:IBuddyData) : int
      {
         var _loc2_:int = int(this._dictIds[param1.UserId]);
         this._aBuddyList.splice(_loc2_,1);
         this._dictIds[param1.UserId] = null;
         this.fixStackDict();
         return this._aBuddyList.length;
      }
      
      public function get Loaded() : Boolean
      {
         return this._bLoaded;
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
      
      public function initialize(param1:IBuddyPersistConn) : void
      {
         this._buddyPersistConn = param1;
         this._buddyPersistConn.addEventListener(BuddyListEvent.RP_LIST_RECEIVED,this.onListReceived,false,0,true);
         this._buddyPersistConn.addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,this.onStatusChange,false,0,true);
      }
      
      private function onOnlineChange(param1:BuddyEvent) : void
      {
         if(this.setOnlineStatus(param1.buddyData.UserId,param1.buddyData.Online))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.ONLINE_STATUS_CHANGE,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      public function sendRPListRequest() : void
      {
         var _loc1_:Error = null;
         if(this._bLoading)
         {
            _loc1_ = new Error("NOT an error, just tracing...");
            this.logError("sendRPListRequest: _bLoading=" + (this._bLoading ? "TRUE" : "FALSE") + " || _bLoaded=" + (this._bLoaded ? "TRUE" : "FALSE") + "...\n" + _loc1_.getStackTrace());
            return;
         }
         this._bLoading = true;
         this._buddyPersistConn.sendRPListRequest();
      }
      
      private function onStatusChange(param1:BuddyEvent) : void
      {
         this.log("onStatusChange: " + param1.buddyData.toString());
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
      
      private function onBuddyAddFailed(param1:BuddyEvent) : void
      {
         dispatchEvent(new BuddyEvent(BuddyEvent.ADD_FAILED,param1.buddyData,param1.responseCode));
      }
      
      private function stackUnshift(param1:IBuddyData) : int
      {
         var _loc2_:int = int(this._aBuddyList.unshift(param1));
         this.fixStackDict();
         return _loc2_;
      }
      
      private function onBuddyAdded(param1:BuddyEvent) : void
      {
         if(this.addBuddy(param1.buddyData))
         {
            dispatchEvent(new BuddyEvent(BuddyEvent.ADD,this.getBuddy(param1.buddyData.UserId)));
         }
      }
      
      private function addBuddy(param1:IBuddyData) : Boolean
      {
         if(!this.buddyExists(param1))
         {
            this.stackPush(param1);
            return true;
         }
         return false;
      }
      
      private function buddyExists(param1:IBuddyData) : Boolean
      {
         return this.buddyExistsById(param1.UserId);
      }
      
      private function removeBuddyById(param1:int) : Boolean
      {
         if(this.buddyExistsById(param1))
         {
            this.stackSplice(this._aBuddyList[this._dictIds[param1]] as IBuddyData);
            return true;
         }
         return false;
      }
      
      private function onBuddyRemoveFailed(param1:BuddyEvent) : void
      {
         dispatchEvent(new BuddyEvent(BuddyEvent.REMOVE_FAILED,param1.buddyData,param1.responseCode));
      }
      
      public function getBuddyByName(param1:String) : IBuddyData
      {
         param1 = param1.toLowerCase();
         var _loc2_:int = 0;
         while(_loc2_ < this._aBuddyList.length)
         {
            if(IBuddyData(this._aBuddyList[_loc2_]).Name.toLowerCase() == param1)
            {
               return this._aBuddyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
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
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyRPManager: " + param1);
      }
      
      public function getBuddy(param1:int) : IBuddyData
      {
         if(!this.buddyExistsById(param1))
         {
            return null;
         }
         return this._aBuddyList[this._dictIds[param1]] as IBuddyData;
      }
   }
}

