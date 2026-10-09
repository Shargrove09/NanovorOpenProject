package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNodeConsumer;
   import com.arkadium.virmon.evotree.substates.home.IEvoTreeNanovorSelector;
   import com.arkadium.virmon.framework.EvoData;
   
   public class EvoTreeGridNodeConsumerSelect implements INanovorEvoTreeGridNodeConsumer
   {
      
      private var _selector:IEvoTreeNanovorSelector;
      
      public function EvoTreeGridNodeConsumerSelect(param1:IEvoTreeNanovorSelector)
      {
         super();
         _selector = param1;
      }
      
      public function handleNanovorNodeClick(param1:INanovorEvoTreeGridNode, param2:EvoData) : void
      {
         _selector.selectNanovorByAssetTypeId(param1.assetTypeId);
      }
   }
}

