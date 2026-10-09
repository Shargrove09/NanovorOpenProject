package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol267")]
   public class ScrollBar extends MovieClip
   {
      
      private var scrollObjStartY:int;
      
      public var mcScrollHead:MovieClip;
      
      private var headSpan:int;
      
      private var headMin:int;
      
      private var scrollHeadBounds:Rectangle;
      
      public var mcLine:MovieClip;
      
      private var headMax:int;
      
      private var scrollObj:MovieClip;
      
      private var iVisScrollHeight:int;
      
      private var scrollSpan:int;
      
      private var updateTimer:Timer;
      
      public function ScrollBar()
      {
         super();
      }
      
      public function reset() : void
      {
         mcScrollHead.y = headMin;
         stopScroll();
         if(updateTimer != null)
         {
            updateTimer.removeEventListener(TimerEvent.TIMER,updateScroll);
            updateTimer.reset();
         }
         mcScrollHead.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
      }
      
      public function init(param1:MovieClip, param2:int) : void
      {
         iVisScrollHeight = param2;
         mcLine.height = iVisScrollHeight;
         scrollObj = param1;
         scrollObjStartY = scrollObj.y;
         scrollSpan = scrollObj.height - iVisScrollHeight;
         updateTimer = new Timer(100,0);
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
      }
      
      private function startScroll() : void
      {
         updateTimer.start();
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         mcScrollHead.startDrag(false,scrollHeadBounds);
         startScroll();
         stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
      }
      
      private function stopScroll() : void
      {
         updateTimer.reset();
      }
      
      private function updateScroll(param1:TimerEvent) : void
      {
         var _loc2_:Number = (mcScrollHead.y - headMin) / headSpan;
         scrollObj.y = scrollObjStartY - scrollSpan * _loc2_;
      }
      
      public function destroy() : void
      {
         if(updateTimer != null)
         {
            updateTimer.stop();
            updateTimer.removeEventListener(TimerEvent.TIMER,updateScroll);
         }
         mcScrollHead.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
      }
   }
}

