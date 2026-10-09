package com.arkadium.virmon.evotree.grid.positioner
{
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import flash.geom.Point;
   
   public interface IEvoTreeGridPositioner
   {
      
      function getCalculatedPosition(param1:IEvoTreeGridNode) : Point;
   }
}

