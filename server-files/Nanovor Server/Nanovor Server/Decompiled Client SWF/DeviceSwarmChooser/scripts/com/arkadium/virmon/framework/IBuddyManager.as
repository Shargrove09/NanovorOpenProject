package com.arkadium.virmon.framework
{
   import com.arkadium.analytics.IAnalyticsManager;
   import flash.events.IEventDispatcher;
   
   public interface IBuddyManager extends IEventDispatcher
   {
      
      function initialize(param1:IAnalyticsManager, param2:String, param3:IBuddyPersistConn) : void;
      
      function getBuddyByName(param1:String) : IBuddyData;
      
      function requestRemoveBuddy(param1:String) : void;
      
      function requestAddBuddy(param1:String) : void;
      
      function get Loaded() : Boolean;
      
      function getBuddy(param1:int) : IBuddyData;
      
      function sendBuddyListRequest() : void;
      
      function getList() : Array;
   }
}

