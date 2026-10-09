package com.arkadium.virmon.evotree.grid
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.positioner.IEvoTreeGridPositioner;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class EvoTreeGrid extends Sprite implements IEvoTreeGrid, IEvoTreeGridControllerConsumer
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.2,
         "transition":Equations.easeInOutQuad
      };
      
      private var _evoTreeGridController:IEvoTreeGridController;
      
      public function EvoTreeGrid(param1:IEvoTreeGridController)
      {
         super();
         _evoTreeGridController = param1;
         _evoTreeGridController.init(IEvoTreeGridControllerConsumer(this));
      }
      
      private function recursiveAnimateNodes(param1:IEvoTreeGridNode, param2:IEvoTreeGridPositioner) : void
      {
         var _loc6_:IEvoTreeGridNode = null;
         var _loc3_:Point = param2.getCalculatedPosition(param1);
         Tweener.addTween(param1.sprite,{
            "x":_loc3_.x,
            "y":_loc3_.y,
            "base":TWEEN_BASE,
            "transition":Equations.easeNone,
            "onUpdate":param1.drawLineToParent
         });
         var _loc4_:Array = param1.destinations;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            recursiveAnimateNodes(_loc6_,param2);
            _loc5_++;
         }
      }
      
      private function recrusivePlaceNodesFromLeaves(param1:IEvoTreeGridNode, param2:IEvoTreeGridPositioner) : void
      {
         var _loc4_:IEvoTreeGridNode = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Sprite = null;
         var _loc8_:Point = null;
         var _loc9_:IEvoTreeGridNode = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1.destinations)
         {
            _loc3_.push([_loc4_.positionY,_loc4_]);
         }
         _loc3_.sortOn("0",Array.NUMERIC | Array.DESCENDING);
         _loc5_ = new Array();
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = _loc6_[1] as IEvoTreeGridNode;
            if(_loc4_.positionX == param1.positionX && _loc4_.positionY == param1.positionY)
            {
               _loc5_.push(_loc4_);
            }
            recrusivePlaceNodesFromLeaves(_loc4_,param2);
         }
         _loc7_ = param1.sprite;
         _loc8_ = param2.getCalculatedPosition(param1);
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         this.addChild(_loc7_);
         for each(_loc9_ in _loc5_)
         {
            if(this.contains(_loc9_.sprite))
            {
               this.swapChildren(_loc7_,_loc9_.sprite);
            }
         }
      }
      
      private function placeNodes(param1:IEvoTreeGridNode, param2:IEvoTreeGridPositioner) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         recrusivePlaceNodesFromLeaves(param1,param2);
      }
      
      public function handleNodeSelected(param1:IEvoTreeGridNode, param2:Boolean, param3:IEvoTreeGridPositioner) : void
      {
         if(param2)
         {
            placeNodes(param1,param3);
         }
         recursiveAnimateNodes(param1,param3);
      }
   }
}

