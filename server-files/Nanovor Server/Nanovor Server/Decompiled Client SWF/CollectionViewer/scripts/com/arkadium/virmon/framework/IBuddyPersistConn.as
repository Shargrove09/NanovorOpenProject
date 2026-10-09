package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IBuddyPersistConn extends IEventDispatcher
   {
      
      function replyToBuddyInvitation(param1:String, param2:Boolean) : void;
      
      function sendRPListRequest() : void;
      
      function sendBuddyListRequest() : void;
      
      function deleteBuddy(param1:IBuddyData) : void;
      
      function inviteBuddy(param1:String) : void;
   }
}

