package com.arkadium.virmon.trade.events
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TabEvent extends Event
   {
      
      public static var SCALE_CONTENT_UP_COMPLETE:String = "SCALE_CONTENT_UP_COMPLETE";
      
      public static var SCALE_CONTENT_DOWN_COMPLETE:String = "SCALE_CONTENT_DOWN_COMPLETE";
      
      public static var CHANGE_CONTENT:String = "CHANGE_CONTENT";
      
      public static var SHOW_CONTENT:String = "SHOW_CONTENT";
      
      private var _mcContent:MovieClip;
      
      private var _iIndex:int;
      
      public function TabEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function set content(param1:MovieClip) : *
      {
         _mcContent = param1;
      }
      
      public function get index() : int
      {
         return _iIndex;
      }
      
      public function get content() : MovieClip
      {
         return _mcContent;
      }
      
      public function set index(param1:int) : *
      {
         _iIndex = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("TabEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new TabEvent(type,bubbles,cancelable);
      }
   }
}

