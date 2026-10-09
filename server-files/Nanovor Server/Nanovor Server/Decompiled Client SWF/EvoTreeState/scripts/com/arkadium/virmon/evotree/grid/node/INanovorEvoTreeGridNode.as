package com.arkadium.virmon.evotree.grid.node
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import com.arkadium.virmon.evotree.ui.EvoTreeGridNodePuckModes;
   import flash.display.Sprite;
   
   public interface INanovorEvoTreeGridNode extends IEvoTreeGridNode
   {
      
      function lineBackToSource(param1:Boolean) : void;
      
      function toggleClick(param1:Boolean) : void;
      
      function get assetTypeId() : int;
      
      function clearEvolveButtons() : void;
      
      function setConsumer(param1:INanovorEvoTreeGridNodeConsumer) : void;
      
      function preselectSpecificNanovor(param1:INanovor) : void;
      
      function setCantEvolveReasons(param1:IEvoTreeCanEvolveResponse) : void;
      
      function setIconMode(param1:EvoTreeGridNodePuckModes) : void;
      
      function setEvolutionButtons(param1:INanovorEvoTreeGridNode, param2:Sprite) : void;
   }
}

