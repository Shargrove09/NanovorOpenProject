package com.arkadium.virmon.evotree.grid.gridinfo
{
   import com.arkadium.virmon.battle.control.INanovor;
   import flash.display.Sprite;
   
   public interface IEvoTreeGridInfo
   {
      
      function selectNanovor(param1:INanovor) : void;
      
      function toggle(param1:Boolean) : void;
      
      function get sprite() : Sprite;
   }
}

