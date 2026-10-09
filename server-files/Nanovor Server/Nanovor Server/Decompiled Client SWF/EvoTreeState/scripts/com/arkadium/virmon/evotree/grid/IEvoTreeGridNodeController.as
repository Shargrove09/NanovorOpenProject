package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   
   public interface IEvoTreeGridNodeController
   {
      
      function createConnectingEvoTreeGridNode(param1:int, param2:int) : IEvoTreeGridNode;
      
      function gotoCollection(param1:INanovor) : void;
      
      function createEvoTreeGridNode(param1:int, param2:Boolean, param3:int, param4:int) : IEvoTreeGridNode;
      
      function selectNanovor(param1:int, param2:INanovor) : void;
      
      function reset() : void;
   }
}

