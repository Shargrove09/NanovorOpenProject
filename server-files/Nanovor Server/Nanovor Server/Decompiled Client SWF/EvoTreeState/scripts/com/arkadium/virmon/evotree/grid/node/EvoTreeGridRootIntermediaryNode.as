package com.arkadium.virmon.evotree.grid.node
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import flash.display.Sprite;
   
   public class EvoTreeGridRootIntermediaryNode extends EvoTreeGridNode
   {
      
      private const CIRLCE_DIAMETER:int = 16;
      
      private var _colorProvider:IEvoTreeGridColorProvider;
      
      private var _circle:Sprite;
      
      public function EvoTreeGridRootIntermediaryNode(param1:int, param2:int, param3:IEvoTreeGridColorProvider)
      {
         super(param1,param2,param3.lineColorDefault);
         _colorProvider = param3;
         _circle = new Sprite();
         _circle.graphics.beginFill(_colorProvider.lineColorActive);
         _circle.graphics.drawEllipse(CIRLCE_DIAMETER / -2,CIRLCE_DIAMETER / -2,CIRLCE_DIAMETER,CIRLCE_DIAMETER);
         _circle.graphics.endFill();
         _sprite.addChild(_circle);
         _circle.visible = false;
      }
      
      override public function drawLineToParent(param1:Number = 1) : void
      {
         super.drawLineToParent(param1);
      }
      
      public function hideNode() : void
      {
         Tweener.addTween(_circle,{
            "_autoAlpha":0,
            "time":0.5
         });
      }
      
      override public function setLineColor(param1:uint) : void
      {
         var _loc2_:Number = param1 == _colorProvider.lineColorInactive ? 0 : 1;
         Tweener.addTween(_circle,{
            "_autoAlpha":_loc2_,
            "time":0.5
         });
      }
   }
}

