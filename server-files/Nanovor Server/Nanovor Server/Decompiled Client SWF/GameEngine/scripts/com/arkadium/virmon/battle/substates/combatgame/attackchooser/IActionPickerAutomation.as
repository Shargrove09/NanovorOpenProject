package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   public interface IActionPickerAutomation
   {
      
      function getSlotCount() : int;
      
      function autoSlotRollOut(param1:int) : void;
      
      function autoSlotRollOver(param1:int) : void;
   }
}

