package com.arkadium.virmon.shared.widgets.avatar
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   
   public class SpinnerBGBlockController
   {
      
      private var _base:MovieClip;
      
      public function SpinnerBGBlockController(param1:*)
      {
         super();
         this._base = param1;
         this._base.height = 0;
         this._base.stop();
         this._base.visible = false;
      }
      
      public function get base() : MovieClip
      {
         return this._base;
      }
      
      public function close() : void
      {
         this._base.stop();
         Tweener.removeTweens(this._base);
         Tweener.addTween(this._base,{
            "height":0,
            "time":0.25,
            "transition":Equations.easeInQuad,
            "onComplete":function():*
            {
               _base.visible = false;
            }
         });
      }
      
      public function open() : void
      {
         this._base.play();
         this._base.visible = true;
         Tweener.removeTweens(this._base);
         Tweener.addTween(this._base,{
            "height":200,
            "time":0.25,
            "transition":Equations.easeInQuad
         });
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         this._base.x = param1;
         this._base.y = param2;
      }
   }
}

