package com.arkadium.virmon.evotree.grid.treebuilder
{
   import com.arkadium.virmon.evotree.grid.IEvoTreeGridNodeController;
   import com.arkadium.virmon.evotree.grid.node.EvoTreeGridRootIntermediaryNode;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   
   public class EvoTreeGridSubTreeController extends AbstractEvoTreeGridSubTreeController
   {
      
      private static const CENTER_INDEX:int = 4;
      
      private static const ROOT_SELECT_OFFSET:int = 3;
      
      private var _intermediaryRoot:EvoTreeGridRootIntermediaryNode;
      
      public function EvoTreeGridSubTreeController(param1:int, param2:Array, param3:IEvoTreeGridNodeController, param4:IEvoTreeGridColorProvider)
      {
         super(param1,param2,param3,param4);
         createIntermediaryNode(param4);
      }
      
      private function selectRootNode(param1:INanovorEvoTreeGridNode) : void
      {
         var _loc2_:IEvoTreeGridNode = null;
         var _loc3_:INanovorEvoTreeGridNode = null;
         var _loc4_:IEvoTreeGridNode = null;
         _root.setOffset(ROOT_SELECT_OFFSET);
         for each(_loc2_ in _intermediaryRoot.destinations)
         {
            _loc3_ = _loc2_ as INanovorEvoTreeGridNode;
            if(null != _loc3_)
            {
               _loc3_.setOffset(CENTER_INDEX + 1);
            }
            else
            {
               for each(_loc4_ in _loc2_.destinations)
               {
                  _loc4_.setOffset(CENTER_INDEX + 1);
               }
            }
         }
      }
      
      private function selectNonRootNode(param1:INanovorEvoTreeGridNode) : void
      {
         var _loc2_:IEvoTreeGridNode = null;
         var _loc3_:INanovorEvoTreeGridNode = null;
         var _loc4_:IEvoTreeGridNode = null;
         param1.setOffset(CENTER_INDEX - param1.positionX);
         for each(_loc2_ in param1.destinations)
         {
            _loc3_ = _loc2_ as INanovorEvoTreeGridNode;
            if(null != _loc3_)
            {
               _loc3_.setOffset(CENTER_INDEX - param1.positionX + 1);
            }
            else
            {
               for each(_loc4_ in _loc2_.destinations)
               {
                  _loc4_.setOffset(CENTER_INDEX + 2 - _loc4_.positionX);
               }
            }
         }
         fixNodeCollisions(param1,_intermediaryRoot);
      }
      
      override public function reset() : void
      {
         _intermediaryRoot.hideNode();
         super.reset();
      }
      
      override public function selectNodeByNanovor(param1:int) : void
      {
         _root.setOffset(0);
         var _loc2_:INanovorEvoTreeGridNode = _evoTreeGridNodes[param1];
         if(_loc2_ == null)
         {
            throw new Error("Selected Node (" + param1 + ") is null");
         }
         if(_loc2_ !== _root)
         {
            selectNonRootNode(_loc2_);
         }
         else
         {
            selectRootNode(_loc2_);
         }
         setLineColors(_loc2_);
      }
      
      private function fixNodeCollisions(param1:INanovorEvoTreeGridNode, param2:IEvoTreeGridNode) : void
      {
         var _loc4_:IEvoTreeGridNode = null;
         var _loc5_:IEvoTreeGridNode = null;
         var _loc3_:Array = new Array();
         recursiveCheckCollision(param1,param2,_loc3_);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.source;
            _loc5_.setOffset(CENTER_INDEX);
         }
      }
      
      private function recursiveCheckCollision(param1:INanovorEvoTreeGridNode, param2:IEvoTreeGridNode, param3:Array) : void
      {
         var _loc4_:IEvoTreeGridNode = null;
         if(param2 === param1)
         {
            return;
         }
         if(1 != param1.positionY && param2.positionY == param1.positionY && param2.positionX > param1.positionX)
         {
            param3.push(param2);
            return;
         }
         for each(_loc4_ in param2.destinations)
         {
            recursiveCheckCollision(param1,_loc4_,param3);
         }
      }
      
      private function createIntermediaryNode(param1:IEvoTreeGridColorProvider) : void
      {
         var _loc3_:IEvoTreeGridNode = null;
         var _loc4_:IEvoTreeGridNode = null;
         var _loc2_:int = int(INanovorEvoTreeGridNode(_root).assetTypeId);
         delete _evoTreeGridNodes[_loc2_];
         _intermediaryRoot = new EvoTreeGridRootIntermediaryNode(0,1,param1);
         for each(_loc3_ in _root.destinations)
         {
            _intermediaryRoot.setDestination(_loc3_);
            _loc3_.setSource(_intermediaryRoot);
         }
         _loc4_ = _nodeController.createEvoTreeGridNode(_loc2_,true,-1,1);
         _loc4_.setDestination(_intermediaryRoot);
         _intermediaryRoot.setSource(_loc4_);
         _root = _loc4_;
         _evoTreeGridNodes[_loc2_] = _root;
      }
   }
}

