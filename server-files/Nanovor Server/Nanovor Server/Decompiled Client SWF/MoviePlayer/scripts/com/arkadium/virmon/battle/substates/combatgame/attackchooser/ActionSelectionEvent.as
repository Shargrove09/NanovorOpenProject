package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.events.Event;
   
   public class ActionSelectionEvent extends Event
   {
      
      public static const ACTION_PICKER_ATTACK_SELECTED:String = "ActionSelectionEvent::attackSelected";
      
      public static const ACTION_PICKER_ATTACK_DESELECTED:String = "ActionSelectionEvent::attackDeselected";
      
      private var _iActionId:int;
      
      public function ActionSelectionEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         _iActionId = param2;
         super(param1,param3,param4);
      }
      
      public function get ActionID() : int
      {
         return _iActionId;
      }
   }
}

