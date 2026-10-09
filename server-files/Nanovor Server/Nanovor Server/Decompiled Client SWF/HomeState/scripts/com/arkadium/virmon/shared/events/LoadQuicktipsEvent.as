package com.arkadium.virmon.shared.events
{
   import flash.events.Event;
   
   public class LoadQuicktipsEvent extends Event
   {
      
      public static const LOAD_QUICKTIPS:String = "loadQuicktipsEvent::loadQuicktips";
      
      private var _quicktipsUrl:String;
      
      public function LoadQuicktipsEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         _quicktipsUrl = param2;
         super(param1,param3,param4);
      }
      
      public function get quicktipsUrl() : String
      {
         return _quicktipsUrl;
      }
      
      override public function clone() : Event
      {
         return new LoadQuicktipsEvent(type,_quicktipsUrl,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("LoadQuicktipsEvent","type","quicktipsUrl","bubbles","cancelable","eventPhase");
      }
   }
}

