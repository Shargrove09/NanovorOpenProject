package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SpinningNanoscopeLarge extends MovieClip
   {
      
      public var mcContents:MovieClip;
      
      public var mcSolid:MovieClip;
      
      public var mcWire:MovieClip;
      
      public var mcColor:MovieClip;
      
      public function SpinningNanoscopeLarge()
      {
         super();
         this.scaleX = this.scaleY = 0.01;
      }
      
      public function open() : void
      {
         Tweener.addTween(this,{
            "scaleX":1,
            "scaleY":1,
            "time":1,
            "transition":Equations.easeInOutQuad
         });
         Tweener.addTween(mcColor,{
            "_autoAlpha":0,
            "time":3,
            "delay":1,
            "delay":3,
            "transition":Equations.easeInOutQuad
         });
      }
      
      public function applyFilter(param1:Array) : void
      {
         mcSolid.filters = param1;
         mcWire.filters = param1;
      }
      
      public function getContents() : Sprite
      {
         return mcContents.mcContents;
      }
   }
}

