package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.events.Event;
   
   public class SwapPickerEvent extends Event
   {
      
      public static const NANOVOR_ICON_SELECTED:String = "SwapPickerEvent::nanovorSelected";
      
      public static const NO_SWAP_SELECTED:String = "SwapPickerEvent::noSwapSelected";
      
      public static const BUTTON_CLICK:String = "SwapPickerEvent::buttonClick";
      
      private var _nanovorIcon:NanovorIcon;
      
      public function SwapPickerEvent(param1:String, param2:NanovorIcon, param3:Boolean = false, param4:Boolean = false)
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

