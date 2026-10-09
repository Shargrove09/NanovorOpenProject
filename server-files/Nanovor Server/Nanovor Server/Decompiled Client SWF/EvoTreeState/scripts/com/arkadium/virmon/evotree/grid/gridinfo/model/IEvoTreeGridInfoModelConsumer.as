package com.arkadium.virmon.evotree.grid.gridinfo.model
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface IEvoTreeGridInfoModelConsumer
   {
      
      function handleNanovorSelected(param1:INanovor, param2:int, param3:int) : void;
      
      function handleTreeSelected(param1:int, param2:String) : void;
   }
}

