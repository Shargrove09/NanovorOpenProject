package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.events.Event;
   
   public class NanovorPickerEvent extends Event
   {
      
      public static const NANOVOR_ICON_SELECTED:String = "NanovorPickerEvent::nanovorSelected";
      
      private var _nanovorIcon:NanovorIcon;
      
      public function NanovorPickerEvent(param1:String, param2:NanovorIcon, param3:Boolean = false, param4:Boolean = false)
      {
         _nanovorIcon = param2;
         super(param1,param3,param4);
      }
      
      public function get nanovorIcon() : NanovorIcon
      {
         return _nanovorIcon;
      }
   }
}

