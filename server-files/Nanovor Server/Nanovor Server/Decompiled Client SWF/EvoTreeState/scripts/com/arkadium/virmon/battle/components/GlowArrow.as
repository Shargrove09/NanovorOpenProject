package com.arkadium.virmon.battle.components
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol67")]
   public class GlowArrow extends MovieClip
   {
      
      public static const WIDTH:int = 40;
      
      public static const HEIGHT:int = 46;
      
      private static const FADE_TWEEN_SECONDS:Number = 0.5;
      
      private static const STATE_OPEN:String = "open";
      
      private static const STATE_CLOSE:String = "close";
      
      private var _closedAlpha:Number;
      
      private var _arrowState:String;
      
      public var mcArrow:SimpleButton;
      
      public function GlowArrow(param1:Number = 0)
      {
         super();
         _closedAlpha = param1;
         _arrowState = STATE_CLOSE;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.alpha = _closedAlpha;
         this.buttonMode = true;
         if(0 == _closedAlpha)
         {
            removeArrow();
         }
      }
      
      public function open() : void
      {
         if(_arrowState == STATE_OPEN)
         {
            return;
         }
         _arrowState = STATE_OPEN;
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.addChild(mcArrow);
         Tweener.removeTweens(this,alpha);
         Tweener.addTween(this,{
            "alpha":1,
            "time":FADE_TWEEN_SECONDS
         });
      }
      
      private function removeArrow() : void
      {
         if(null != mcArrow.parent)
         {
            mcArrow.parent.removeChild(mcArrow);
         }
      }
      
      public function close() : void
      {
         if(_arrowState == STATE_CLOSE)
         {
            return;
         }
         _arrowState = STATE_CLOSE;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         Tweener.removeTweens(this,alpha);
         Tweener.addTween(this,{
            "alpha":_closedAlpha,
            "time":FADE_TWEEN_SECONDS
         });
      }
   }
}

