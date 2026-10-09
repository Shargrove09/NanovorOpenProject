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
         _base = param1;
         _base.height = 0;
         _base.stop();
         _base.visible = false;
      }
      
      public function get base() : MovieClip
      {
         return _base;
      }
      
      public function close() : void
      {
         _base.stop();
         Tweener.removeTweens(_base);
         Tweener.addTween(_base,{
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
         _base.play();
         _base.visible = true;
         Tweener.removeTweens(_base);
         Tweener.addTween(_base,{
            "height":200,
            "time":0.25,
            "transition":Equations.easeInQuad
         });
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         _base.x = param1;
         _base.y = param2;
      }
   }
}

