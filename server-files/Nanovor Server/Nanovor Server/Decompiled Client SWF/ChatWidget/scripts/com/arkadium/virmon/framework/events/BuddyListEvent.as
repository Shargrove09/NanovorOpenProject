package com.arkadium.virmon.framework.events
{
   import flash.events.Event;
   
   public class BuddyListEvent extends Event
   {
      
      public static const BUDDY_LIST_RECEIVED:String = "BuddyListEvent::buddyListReceived";
      
      public static const RP_LIST_RECEIVED:String = "BuddyListEvent::rpListReceived";
      
      private var _aBuddyList:Array;
      
      public function BuddyListEvent(param1:String, param2:Array, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._aBuddyList = param2;
      }
      
      public function get Buddylist() : Array
      {
         return this._aBuddyList;
      }
   }
}

