package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface IEvoTreeGridController
   {
      
      function init(param1:IEvoTreeGridControllerConsumer) : void;
      
      function selectNanovor(param1:int, param2:int, param3:INanovor = null) : void;
      
      function selectTree(param1:int) : void;
   }
}

