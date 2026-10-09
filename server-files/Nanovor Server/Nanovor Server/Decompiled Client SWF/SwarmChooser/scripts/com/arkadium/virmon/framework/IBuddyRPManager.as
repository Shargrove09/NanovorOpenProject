package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IBuddyRPManager extends IEventDispatcher
   {
      
      function initialize(param1:IBuddyPersistConn) : void;
      
      function updateAvatar(param1:IBuddyData) : void;
      
      function getList() : Array;
      
      function get Loaded() : Boolean;
      
      function getBuddy(param1:int) : IBuddyData;
      
      function getBuddyByName(param1:String) : IBuddyData;
      
      function sendRPListRequest() : void;
      
      function addRP(param1:IBuddyData) : void;
   }
}

