package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class ScrollBar extends MovieClip
   {
      
      public static const MOUSE_DOWN:String = "scrollBarMouseDown";
      
      public static const MOUSE_UP:String = "scrollBarMouseUp";
      
      private var scrollObjStartY:int;
      
      public var mcScrollHead:MovieClip;
      
      private var headSpan:int;
      
      private var headMin:int;
      
      private var scrollHeadBounds:Rectangle;
      
      private var scrollObj:MovieClip;
      
      private var headMax:int;
      
      public var mcLine:MovieClip;
      
      private var iVisScrollHeight:int;
      
      private var scrollSpan:int;
      
      private var updateTimer:Timer;
      
      private var _bRoundPixel:Boolean;
      
      public function ScrollBar()
      {
         super();
      }
      
      private function updateScroll(param1:TimerEvent) : void
      {
         var _loc2_:Number = (mcScrollHead.y - headMin) / headSpan;
         var _loc3_:Number = scrollObjStartY - scrollSpan * _loc2_;
         Tweener.removeTweens(scrollObj,y);
         Tweener.addTween(scrollObj,{
            "y":_loc3_,
            "time":0.15,
            "transition":"easeOutQuad",
            "rounded":(_bRoundPixel ? true : false)
         });
      }
      
      public function jumpToRatio(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         param1 = param1 > 1 ? 1 : param1;
         mcScrollHead.y = headMin + param1 * headSpan;
         updateScroll(null);
      }
      
      public function reset() : void
      {
         mcScrollHead.y = headMin;
         stopScroll();
      }
      
      public function init(param1:MovieClip, param2:int, param3:Boolean = false) : void
      {
         iVisScrollHeight = param2;
         mcLine.height = iVisScrollHeight;
         _bRoundPixel = param3;
         scrollObj = param1;
         scrollObjStartY = scrollObj.y;
         scrollSpan = scrollObj.height - iVisScrollHeight;
         updateTimer = new Timer(33,0);
         updateTimer.addEventListener(TimerEvent.TIMER,updateScroll,false,0,true);
         headMin = mcScrollHead.y;
         headMax = headMin + (mcLine.height - mcScrollHead.height + 10);
         headSpan = headMax - headMin;
         scrollHeadBounds = new Rectangle(mcScrollHead.x,headMin,0,headMax);
         mcScrollHead.useHandCursor = true;
         mcScrollHead.buttonMode = true;
         mcScrollHead.mouseChildren = false;
         mcScrollHead.addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         mcScrollHead.stopDrag();
         stopScroll();
         stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
         dispatchEvent(new Event(MOUSE_UP));
      }
      
      private function startScroll() : void
      {
         updateTimer.start();
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         mcScrollHead.startDrag(false,scrollHeadBounds);
         startScroll();
         stage.addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
         dispatchEvent(new Event(MOUSE_DOWN));
      }
      
      private function stopScroll() : void
      {
         updateTimer.reset();
      }
   }
}

