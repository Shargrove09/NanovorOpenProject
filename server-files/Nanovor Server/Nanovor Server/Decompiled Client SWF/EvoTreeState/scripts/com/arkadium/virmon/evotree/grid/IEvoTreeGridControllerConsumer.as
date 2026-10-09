package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.positioner.IEvoTreeGridPositioner;
   
   public interface IEvoTreeGridControllerConsumer
   {
      
      function handleNodeSelected(param1:IEvoTreeGridNode, param2:Boolean, param3:IEvoTreeGridPositioner) : void;
   }
}

