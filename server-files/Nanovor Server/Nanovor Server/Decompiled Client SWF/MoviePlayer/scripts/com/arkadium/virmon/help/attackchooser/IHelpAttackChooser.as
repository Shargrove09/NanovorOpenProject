package com.arkadium.virmon.help.attackchooser
{
   import com.arkadium.virmon.battle.substates.combatgame.attackchooser.IActionPickerAutomation;
   
   public interface IHelpAttackChooser
   {
      
      function showSwapHelp(param1:int = 0) : void;
      
      function showAttackSelectHelp(param1:IActionPickerAutomation, param2:int = 0) : void;
      
      function showTargetConfirmHelp(param1:Array, param2:int, param3:Boolean, param4:int = 0) : void;
      
      function showNanovorSelectHelp(param1:int = 0) : void;
      
      function destroy() : void;
      
      function showTargetSelectHelp(param1:Array, param2:Boolean, param3:int = 0) : void;
   }
}

