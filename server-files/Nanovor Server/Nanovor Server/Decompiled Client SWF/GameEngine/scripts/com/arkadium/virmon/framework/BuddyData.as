package com.arkadium.virmon.framework
{
   public class BuddyData implements IBuddyData
   {
      
      private var _iBlock:int;
      
      private var _iNMP:int;
      
      private var _iUserId:int;
      
      private var _iAvatarId:int;
      
      private var _iOnline:int;
      
      private var _szName:String;
      
      private var _iStatus:int;
      
      public function BuddyData(param1:int = -1, param2:String = null, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         _iUserId = param1;
         _szName = param2;
         _iOnline = param3;
         _iStatus = param4;
         _iAvatarId = param5;
         _iBlock = param6;
         _iNMP = param7;
      }
      
      public function set Avatar(param1:int) : void
      {
         _iAvatarId = param1;
      }
      
      public function get Online() : int
      {
         return _iOnline;
      }
      
      public function get NMP() : int
      {
         return _iNMP;
      }
      
      public function set UserId(param1:int) : void
      {
         _iUserId = param1;
      }
      
      public function set Status(param1:int) : void
      {
         _iStatus = param1;
      }
      
      public function get Status() : int
      {
         return _iStatus;
      }
      
      public function get SortStatus() : int
      {
         if(isOffline())
         {
            return 100;
         }
         if(isInActivity())
         {
            return 20;
         }
         return 10;
      }
      
      public function set Block(param1:int) : void
      {
         _iBlock = param1;
      }
      
      public function set Name(param1:String) : void
      {
         _szName = param1;
      }
      
      private function isInActivity() : Boolean
      {
         return Boolean(_iStatus > 0);
      }
      
      public function get UserId() : int
      {
         return _iUserId;
      }
      
      private function isOffline() : Boolean
      {
         return Boolean(_iStatus < 0);
      }
      
      public function set NMP(param1:int) : void
      {
         _iNMP = param1;
      }
      
      public function get Name() : String
      {
         return _szName;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[BuddyData";
         _loc1_ += " user id=" + _iUserId;
         _loc1_ += " name=" + _szName;
         _loc1_ += " online=" + _iOnline;
         _loc1_ += " status=" + _iStatus;
         _loc1_ += " avatar id=" + _iAvatarId;
         _loc1_ += " block=" + _iBlock;
         _loc1_ += " nmp=" + _iNMP;
         return _loc1_ + "]";
      }
      
      public function get Block() : int
      {
         return _iBlock;
      }
      
      public function set Online(param1:int) : void
      {
         _iOnline = param1;
      }
      
      public function get Avatar() : int
      {
         return _iAvatarId;
      }
   }
}

