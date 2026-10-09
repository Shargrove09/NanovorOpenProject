package com.arkadium.virmon.nanomall
{
   import flash.events.Event;
   
   public class BoosterItemEvent extends Event
   {
      
      public static const WAVELIST_BUYBTN_CLICK:String = "WAVELIST_BUYBTN_CLICK";
      
      private var _boosterItemData:IBoosterItemData;
      
      public function BoosterItemEvent(param1:String, param2:IBoosterItemData, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _boosterItemData = param2;
      }
      
      public function get boosterItemData() : IBoosterItemData
      {
         return _boosterItemData;
      }
      
      override public function toString() : String
      {
         return formatToString("BoosterItemEvent","boosterItemData","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new BoosterItemEvent(type,_boosterItemData,bubbles,cancelable);
      }
   }
}

