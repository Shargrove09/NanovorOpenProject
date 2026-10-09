package com.arkadium.virmon.framework.events
{
   import com.arkadium.virmon.framework.IBuddyData;
   import flash.events.Event;
   
   public class BuddyEvent extends Event
   {
      
      public static const ONLINE_STATUS_CHANGE:String = "BuddyEvent::onlineStatusChange";
      
      public static const CHAT_STATUS_CHANGE:String = "BuddyEvent::chatStatusChange";
      
      public static const FLAG_CHANGE:String = "BuddyEvent::flagChange";
      
      public static const AVATAR_CHANGE:String = "BuddyEvent::avatarChange";
      
      public static const ADD:String = "BuddyEvent::add";
      
      public static const ADD_FAILED:String = "BuddyEvent::addFailed";
      
      public static const REQUEST_RECEIVED:String = "BuddyEvent::requestReceived";
      
      public static const REMOVE_RECEIVED:String = "BuddyEvent::removeReceived";
      
      public static const REMOVE_SENT_RECEIVED:String = "BuddyEvent::removeSentReceived";
      
      public static const REMOVE_FAILED:String = "BuddyEvent::removeFailed";
      
      private var _oBuddyData:IBuddyData;
      
      private var _szErrorMessage:String;
      
      private var _iResponseCode:int;
      
      public function BuddyEvent(param1:String, param2:IBuddyData, param3:* = 0, param4:String = null, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         _oBuddyData = param2;
         _iResponseCode = param3;
         _szErrorMessage = param4;
      }
      
      public function get buddyData() : IBuddyData
      {
         return _oBuddyData;
      }
      
      public function get errorMessage() : String
      {
         return _szErrorMessage;
      }
      
      public function get responseCode() : int
      {
         return _iResponseCode;
      }
   }
}

