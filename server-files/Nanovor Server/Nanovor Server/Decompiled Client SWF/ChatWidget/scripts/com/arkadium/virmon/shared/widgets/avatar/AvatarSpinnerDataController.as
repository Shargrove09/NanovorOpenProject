package com.arkadium.virmon.shared.widgets.avatar
{
   import com.arkadium.virmon.framework.BuddyManager;
   import com.arkadium.virmon.framework.BuddyRPManager;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.events.BuddyEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class AvatarSpinnerDataController
   {
      
      private var _playerName:String;
      
      private var _spinnner:AvatarWidgetAvatarSpinner;
      
      private var _status:int;
      
      private var _nmp:int;
      
      private var _avatarId:int;
      
      private var _isBuddy:Boolean;
      
      public function AvatarSpinnerDataController()
      {
         super();
         this._playerName = "";
         this._status = 0;
         this._avatarId = 0;
         this._nmp = -1;
         this._isBuddy = false;
         BuddyManager.getInstance().addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,this.onBuddyStatusChange);
         BuddyRPManager.getInstance().addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,this.onBuddyStatusChange);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AvatarSpinnerDataController>>\t" + param1);
      }
      
      public function set avatarId(param1:int) : void
      {
         this._avatarId = param1;
      }
      
      private function onBuddyStatusChange(param1:BuddyEvent) : void
      {
         this.log("onBuddyStatusChange()");
         var _loc2_:IBuddyData = param1.buddyData;
         if(_loc2_.Name.toLowerCase() != this._playerName.toLowerCase())
         {
            return;
         }
         this.log("onBuddyStatusChange(): BuddyStatus: " + _loc2_.Status);
         this._spinnner.isBuddy = true;
         this.updateSpinner(_loc2_.Name,_loc2_.Status,_loc2_.NMP);
         this.log("onBuddyStatusChange(): nmp" + _loc2_.NMP);
      }
      
      public function set status(param1:int) : void
      {
         this._status = param1;
      }
      
      public function set nmp(param1:int) : void
      {
         this._nmp = param1;
      }
      
      private function updateSpinner(param1:String, param2:int, param3:int) : void
      {
         this._spinnner.updateName(param1);
         this._spinnner.updateNMP(param3);
         this._spinnner.updateButtons(param2);
      }
      
      public function set playerName(param1:String) : void
      {
         this._playerName = param1;
      }
      
      public function associateSpinner(param1:AvatarWidgetAvatarSpinner) : void
      {
         this._spinnner = param1;
         this._spinnner.isBuddy = false;
         var _loc2_:IBuddyData = BuddyManager.getInstance().getBuddyByName(this._playerName);
         if(null != _loc2_)
         {
            this._spinnner.isBuddy = true;
            this.updateSpinner(this._playerName,_loc2_.Status,this._nmp);
         }
         else
         {
            this.updateSpinner(this._playerName,0,this._nmp);
         }
      }
   }
}

