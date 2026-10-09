package com.arkadium.virmon.collection.substates.nanovor
{
   import flash.events.Event;
   
   public class NanovorStatsPanelEvent extends Event
   {
      
      public static const BUFF_UP:String = "buffUp";
      
      public static const BUFF_DOWN:String = "buffDown";
      
      public static const CONFIRM_SPEND:String = "confirmSpend";
      
      private var _szStat:String;
      
      public function NanovorStatsPanelEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         _szStat = param2;
         super(param1,param3,param4);
      }
      
      public function get stat() : String
      {
         return _szStat;
      }
      
      override public function toString() : String
      {
         return formatToString("NanovorStatsPanelEvent","type","stat","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new NanovorStatsPanelEvent(type,_szStat,bubbles,cancelable);
      }
   }
}

