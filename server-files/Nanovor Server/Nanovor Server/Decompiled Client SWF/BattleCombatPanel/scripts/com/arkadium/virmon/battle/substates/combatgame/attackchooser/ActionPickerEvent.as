package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.events.Event;
   
   public class ActionPickerEvent extends Event
   {
      
      public static const ACTION_PICKER_OPEN:String = "open";
      
      public static const ACTION_PICKER_OPENED:String = "open";
      
      public static const ACTION_PICKER_CLOSE:String = "close";
      
      public static const ACTION_PICKER_CLOSED:String = "closed";
      
      public static const ACTION_PICKER_NANOVOR_ROLL_OVER:String = "nanovorRollOver";
      
      public static const ACTION_PICKER_NANOVOR_ROLL_OUT:String = "nanovorRollOut";
      
      public static const ACTION_PICKER_NANOVOR_CLICK:String = "nanovorClick";
      
      public var actionPicker:ActionPicker;
      
      public function ActionPickerEvent(param1:String, param2:ActionPicker, param3:Boolean = false)
      {
         super(param1,param3);
         actionPicker = param2;
      }
   }
}

