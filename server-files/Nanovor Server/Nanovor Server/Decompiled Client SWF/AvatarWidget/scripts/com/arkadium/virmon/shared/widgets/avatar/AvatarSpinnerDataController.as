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
         _playerName = "";
         _status = 0;
         _avatarId = 0;
         _nmp = -1;
         _isBuddy = false;
         BuddyManager.getInstance().addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,onBuddyStatusChange);
         BuddyRPManager.getInstance().addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,onBuddyStatusChange);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AvatarSpinnerDataController>>\t" + param1);
      }
      
      public function set avatarId(param1:int) : void
      {
         _avatarId = param1;
      }
      
      private function onBuddyStatusChange(param1:BuddyEvent) : void
      {
         log("onBuddyStatusChange()");
         var _loc2_:IBuddyData = param1.buddyData;
         if(_loc2_.Name.toLowerCase() != _playerName.toLowerCase())
         {
            return;
         }
         log("onBuddyStatusChange(): BuddyStatus: " + _loc2_.Status);
         _spinnner.isBuddy = true;
         updateSpinner(_loc2_.Name,_loc2_.Status,_loc2_.NMP);
         log("onBuddyStatusChange(): nmp" + _loc2_.NMP);
      }
      
      public function set status(param1:int) : void
      {
         _status = param1;
      }
      
      public function set nmp(param1:int) : void
      {
         _nmp = param1;
      }
      
      private function updateSpinner(param1:String, param2:int, param3:int) : void
      {
         _spinnner.updateName(param1);
         _spinnner.updateNMP(param3);
         _spinnner.updateButtons(param2);
      }
      
      public function set playerName(param1:String) : void
      {
         _playerName = param1;
      }
      
      public function associateSpinner(param1:AvatarWidgetAvatarSpinner) : void
      {
         _spinnner = param1;
         _spinnner.isBuddy = false;
         var _loc2_:IBuddyData = BuddyManager.getInstance().getBuddyByName(_playerName);
         if(null != _loc2_)
         {
            _spinnner.isBuddy = true;
            updateSpinner(_playerName,_loc2_.Status,_nmp);
         }
         else
         {
            updateSpinner(_playerName,0,_nmp);
         }
      }
   }
}

