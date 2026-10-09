package com.arkadium.virmon.shared.final.components.actionslot
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   
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
         _nMinWidth = param1;
         _nMaxWidth = param2;
         mcStrip.x = -1 * ROLLOUT_OFFSET;
         mcStripMask.width = param2;
         mcLine.width = _nMinWidth;
         mcStrip.width = 0;
         mcArrowChaser.x = CHASER_END_POSITION;
         hideChaser();
      }
      
      private function onChaserTweenComplete() : void
      {
         dispatchEvent(new Event(CHASER_TWEEN_COMPLETED));
         hideChaser();
      }
      
      public function open(param1:Boolean = false, param2:Number = -Infinity) : void
      {
         if(_isOpening)
         {
            return;
         }
         if(param2 === Number.NEGATIVE_INFINITY)
         {
            param2 = ROLLOUT_OPEN_SECONDS + ROLLOUT_STRIP_LINE_DELAY_SECONDS;
         }
         _isOpening = true;
         Tweener.removeTweens(mcLine,"width");
         Tweener.removeTweens(mcStrip,"width");
         if(!param1)
         {
            Tweener.removeTweens(mcChaser,"x");
            Tweener.addTween(mcLine,{
               "width":_nMaxWidth,
               "time":ROLLOUT_OPEN_SECONDS
            });
            Tweener.addTween(mcStrip,{
               "width":_nMaxWidth + ROLLOUT_OFFSET,
               "time":ROLLOUT_OPEN_SECONDS,
               "delay":ROLLOUT_STRIP_LINE_DELAY_SECONDS
            });
            startChaser(false,param2);
         }
         else
         {
            mcLine.width = _nMaxWidth;
            mcStrip.width = _nMaxWidth;
         }
      }
      
      public function startChaser(param1:Boolean = false, param2:Number = 0) : void
      {
         _isOpening = true;
         if(param1)
         {
            showChaser();
            Tweener.removeTweens(mcChaser,"x");
            mcChaser.x = CHASER_END_POSITION;
            Tweener.addTween(mcChaser,{
               "x":CHASER_START_POSITION,
               "time":CHASER_TWEEN_SECONDS,
               "delay":param2,
               "transition":"linear",
               "onStart":onChaserTweenStart,
               "onComplete":onChaserTweenComplete
            });
         }
         else
         {
            showChaser();
            Tweener.removeTweens(mcChaser,"x");
            mcChaser.x = CHASER_START_POSITION;
            Tweener.addTween(mcChaser,{
               "x":CHASER_END_POSITION,
               "time":CHASER_TWEEN_SECONDS,
               "delay":param2,
               "transition":"linear",
               "onStart":onChaserTweenStart,
               "onComplete":hideChaser
            });
         }
      }
      
      private function onChaserTweenStart() : void
      {
         if(!_isOpening)
         {
            hideChaser();
            Tweener.removeTweens(mcChaser,"x");
         }
         else
         {
            _isOpening = false;
            dispatchEvent(new Event(CHASER_TWEEN_STARTED));
         }
      }
      
      public function showStrip() : void
      {
         mcStrip.visible = true;
      }
      
      private function showChaser() : void
      {
         mcChaser.visible = true;
      }
      
      private function hideChaser() : void
      {
         mcChaser.visible = false;
      }
      
      public function set stayOpen(param1:Boolean) : void
      {
         _bStayOpen = param1;
      }
      
      public function startArrowChaser() : void
      {
         if(Tweener.isTweening(mcArrowChaser))
         {
            return;
         }
         Tweener.removeTweens(mcArrowChaser,"x");
         mcArrowChaser.x = CHASER_END_POSITION;
         mcArrowChaser.alpha = 1;
         Tweener.addTween(mcArrowChaser,{
            "x":CHASER_START_POSITION,
            "time":ARROW_CHASER_TWEEN_SECONDS,
            "transition":"linear"
         });
         Tweener.addTween(mcArrowChaser,{
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
         mcStrip.visible = false;
      }
      
      public function close(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(_bStayOpen)
         {
            return;
         }
         _isOpening = false;
         var _loc3_:Number = param2 ? 0 : _nMinWidth;
         Tweener.removeTweens(mcLine,"width");
         Tweener.removeTweens(mcStrip,"width");
         hideChaser();
         if(!param1)
         {
            Tweener.addTween(mcLine,{
               "width":_loc3_,
               "time":ROLLOUT_OPEN_SECONDS
            });
            Tweener.addTween(mcStrip,{
               "width":0,
               "time":ROLLOUT_OPEN_SECONDS,
               "delay":ROLLOUT_STRIP_LINE_DELAY_SECONDS,
               "onComplete":onCloseTweenComplete
            });
         }
         else
         {
            mcLine.width = _loc3_;
            mcStrip.width = 0;
         }
      }
      
      public function set color(param1:uint) : void
      {
         Tweener.removeTweens(mcStrip,"_color");
         Tweener.removeTweens(mcStripMask,"_color");
         Tweener.removeTweens(mcChaser,"_color");
         Tweener.removeTweens(mcLine,"_color");
         Tweener.addTween(mcStrip,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(mcStripMask,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(mcChaser,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(mcLine,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
      }
   }
}

