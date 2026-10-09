package com.arkadium.virmon.evotree.grid.node
{
   import com.arkadium.virmon.framework.EvoData;
   
   public interface INanovorEvoTreeGridNodeConsumer
   {
      
      function handleNanovorNodeClick(param1:INanovorEvoTreeGridNode, param2:EvoData) : void;
   }
}

