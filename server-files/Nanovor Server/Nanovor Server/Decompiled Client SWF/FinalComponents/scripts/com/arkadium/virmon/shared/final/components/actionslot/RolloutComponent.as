package com.arkadium.virmon.shared.final.components.actionslot
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol61")]
   public class RolloutComponent extends MovieClip
   {
      
      public static const BACKGROUND_COLOR_BLUE:uint = 2340070;
      
      public static const BACKGROUND_COLOR_RED:uint = 16711680;
      
      public static const BACKGROUND_COLOR_GRAY:uint = 6710886;
      
      public static const CHASER_TWEEN_SECONDS:Number = 0.5;
      
      public static const CHASER_START_POSITION:int = -100;
      
      public static const CHASER_END_POSITION:int = 1100;
      
      public static const CHASER_TWEEN_STARTED:String = "RolloutComponent::chaserTweenStarted";
      
      public static const CHASER_TWEEN_COMPLETED:String = "RolloutComponent::chaserTweenCompleted";
      
      public static const ROLLOUT_CLOSE_COMPLETED:String = "RolloutComponent::rolloutCloseCompleted";
      
      private static const ROLLOUT_OPEN_SECONDS:Number = 1;
      
      private static const COLOR_TWEEN_SECONDS:Number = 1;
      
      private static const ARROW_CHASER_TWEEN_SECONDS:Number = 0.5;
      
      private static const ROLLOUT_STRIP_LINE_DELAY_SECONDS:Number = 0.2;
      
      private static const ROLLOUT_OFFSET:Number = 20;
      
      private var _isOpening:Boolean = false;
      
      private var _nMaxWidth:Number;
      
      private var _bStayOpen:Boolean;
      
      public var mcStrip:MovieClip;
      
      private var _nMinWidth:Number;
      
      public var mcLine:MovieClip;
      
      public var mcStripMask:MovieClip;
      
      public var mcArrowChaser:MovieClip;
      
      public var mcChaser:MovieClip;
      
      public function RolloutComponent(param1:Number = 0, param2:Number = 1000)
      {
         super();
         this._nMinWidth = param1;
         this._nMaxWidth = param2;
         this.mcStrip.x = -1 * ROLLOUT_OFFSET;
         this.mcStripMask.width = param2;
         this.mcLine.width = this._nMinWidth;
         this.mcStrip.width = 0;
         this.mcArrowChaser.x = CHASER_END_POSITION;
         this.hideChaser();
      }
      
      private function onChaserTweenComplete() : void
      {
         dispatchEvent(new Event(CHASER_TWEEN_COMPLETED));
         this.hideChaser();
      }
      
      public function open(param1:Boolean = false, param2:Number = -Infinity) : void
      {
         if(this._isOpening)
         {
            return;
         }
         if(param2 === Number.NEGATIVE_INFINITY)
         {
            param2 = ROLLOUT_OPEN_SECONDS + ROLLOUT_STRIP_LINE_DELAY_SECONDS;
         }
         this._isOpening = true;
         Tweener.removeTweens(this.mcLine,"width");
         Tweener.removeTweens(this.mcStrip,"width");
         if(!param1)
         {
            Tweener.removeTweens(this.mcChaser,"x");
            Tweener.addTween(this.mcLine,{
               "width":this._nMaxWidth,
               "time":ROLLOUT_OPEN_SECONDS
            });
            Tweener.addTween(this.mcStrip,{
               "width":this._nMaxWidth + ROLLOUT_OFFSET,
               "time":ROLLOUT_OPEN_SECONDS,
               "delay":ROLLOUT_STRIP_LINE_DELAY_SECONDS
            });
            this.startChaser(false,param2);
         }
         else
         {
            this.mcLine.width = this._nMaxWidth;
            this.mcStrip.width = this._nMaxWidth;
         }
      }
      
      public function startChaser(param1:Boolean = false, param2:Number = 0) : void
      {
         this._isOpening = true;
         if(param1)
         {
            this.showChaser();
            Tweener.removeTweens(this.mcChaser,"x");
            this.mcChaser.x = CHASER_END_POSITION;
            Tweener.addTween(this.mcChaser,{
               "x":CHASER_START_POSITION,
               "time":CHASER_TWEEN_SECONDS,
               "delay":param2,
               "transition":"linear",
               "onStart":this.onChaserTweenStart,
               "onComplete":this.onChaserTweenComplete
            });
         }
         else
         {
            this.showChaser();
            Tweener.removeTweens(this.mcChaser,"x");
            this.mcChaser.x = CHASER_START_POSITION;
            Tweener.addTween(this.mcChaser,{
               "x":CHASER_END_POSITION,
               "time":CHASER_TWEEN_SECONDS,
               "delay":param2,
               "transition":"linear",
               "onStart":this.onChaserTweenStart,
               "onComplete":this.hideChaser
            });
         }
      }
      
      private function onChaserTweenStart() : void
      {
         if(!this._isOpening)
         {
            this.hideChaser();
            Tweener.removeTweens(this.mcChaser,"x");
         }
         else
         {
            this._isOpening = false;
            dispatchEvent(new Event(CHASER_TWEEN_STARTED));
         }
      }
      
      public function showStrip() : void
      {
         this.mcStrip.visible = true;
      }
      
      private function showChaser() : void
      {
         this.mcChaser.visible = true;
      }
      
      private function hideChaser() : void
      {
         this.mcChaser.visible = false;
      }
      
      public function set stayOpen(param1:Boolean) : void
      {
         this._bStayOpen = param1;
      }
      
      public function startArrowChaser() : void
      {
         if(Tweener.isTweening(this.mcArrowChaser))
         {
            return;
         }
         Tweener.removeTweens(this.mcArrowChaser,"x");
         this.mcArrowChaser.x = CHASER_END_POSITION;
         this.mcArrowChaser.alpha = 1;
         Tweener.addTween(this.mcArrowChaser,{
            "x":CHASER_START_POSITION,
            "time":ARROW_CHASER_TWEEN_SECONDS,
            "transition":"linear"
         });
         Tweener.addTween(this.mcArrowChaser,{
            "alpha":0,
            "time":ARROW_CHASER_TWEEN_SECONDS,
            "transition":"easeInOutQuad"
         });
      }
      
      private function onCloseTweenComplete() : void
      {
         dispatchEvent(new Event(ROLLOUT_CLOSE_COMPLETED));
      }
      
      public function hideStrip() : void
      {
         this.mcStrip.visible = false;
      }
      
      public function close(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(this._bStayOpen)
         {
            return;
         }
         this._isOpening = false;
         var _loc3_:Number = param2 ? 0 : this._nMinWidth;
         Tweener.removeTweens(this.mcLine,"width");
         Tweener.removeTweens(this.mcStrip,"width");
         this.hideChaser();
         if(!param1)
         {
            Tweener.addTween(this.mcLine,{
               "width":_loc3_,
               "time":ROLLOUT_OPEN_SECONDS
            });
            Tweener.addTween(this.mcStrip,{
               "width":0,
               "time":ROLLOUT_OPEN_SECONDS,
               "delay":ROLLOUT_STRIP_LINE_DELAY_SECONDS,
               "onComplete":this.onCloseTweenComplete
            });
         }
         else
         {
            this.mcLine.width = _loc3_;
            this.mcStrip.width = 0;
         }
      }
      
      public function set color(param1:uint) : void
      {
         Tweener.removeTweens(this.mcStrip,"_color");
         Tweener.removeTweens(this.mcStripMask,"_color");
         Tweener.removeTweens(this.mcChaser,"_color");
         Tweener.removeTweens(this.mcLine,"_color");
         Tweener.addTween(this.mcStrip,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(this.mcStripMask,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(this.mcChaser,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(this.mcLine,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
      }
   }
}

