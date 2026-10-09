package com.arkadium.virmon.evotree.grid.positioner
{
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class EvoTreeGridPositioner implements IEvoTreeGridPositioner
   {
      
      private var _positions:Dictionary;
      
      public function EvoTreeGridPositioner()
      {
         super();
         _positions = new Dictionary();
         _positions[-1] = 50;
         _positions[0] = 95;
         _positions[1] = 185;
         _positions[2] = 275;
         _positions[3] = 365;
         _positions[4] = 512;
         _positions[5] = 659;
         _positions[6] = 749;
         _positions[7] = 839;
         _positions[8] = 929;
         _positions[9] = 1019;
         _positions[10] = 1019;
      }
      
      public function getCalculatedPosition(param1:IEvoTreeGridNode) : Point
      {
         var _loc2_:int = param1.positionX + param1.xOffset;
         var _loc3_:int = null == _positions[_loc2_] ? 0 : int(_positions[_loc2_]);
         var _loc4_:int = param1.positionY * 140 + 130;
         return new Point(_loc3_,_loc4_);
      }
   }
}

