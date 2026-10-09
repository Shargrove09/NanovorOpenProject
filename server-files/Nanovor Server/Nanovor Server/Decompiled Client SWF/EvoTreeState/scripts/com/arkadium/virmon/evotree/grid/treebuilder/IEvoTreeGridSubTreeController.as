package com.arkadium.virmon.evotree.grid.treebuilder
{
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   
   public interface IEvoTreeGridSubTreeController
   {
      
      function getRoot() : IEvoTreeGridNode;
      
      function reset() : void;
      
      function selectNodeByNanovor(param1:int) : void;
   }
}

