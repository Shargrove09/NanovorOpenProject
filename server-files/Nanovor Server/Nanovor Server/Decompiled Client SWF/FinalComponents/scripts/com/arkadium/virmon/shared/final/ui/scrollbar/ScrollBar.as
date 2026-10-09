package com.arkadium.virmon.shared.final.ui.scrollbar
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6")]
   public class ScrollBar extends MovieClip
   {
      
      private var _scrollHeadBounds:Rectangle;
      
      public var mcScrollHead:MovieClip;
      
      private var _scrollObjStartY:int;
      
      private var _headMin:int;
      
      private var _scrollSpan:int;
      
      private var _headMax:int;
      
      private var _visibleScrollHeight:int;
      
      private var _headSpan:int;
      
      public var mcLine:MovieClip;
      
      private var _scrollObj:MovieClip;
      
      private var _scrollUpdateTimer:Timer;
      
      private var _flipScroll:Boolean;
      
      public function ScrollBar()
      {
         super();
      }
      
      public function reset() : void
      {
         this.mcScrollHead.y = this._headMin;
         this.stopScroll();
         if(this._scrollUpdateTimer != null)
         {
            this._scrollUpdateTimer.removeEventListener(TimerEvent.TIMER,this.updateScroll);
            this._scrollUpdateTimer.reset();
         }
         this.mcScrollHead.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
      }
      
      public function init(param1:MovieClip, param2:int, param3:int, param4:Boolean = false) : void
      {
         this._flipScroll = param4;
         this._visibleScrollHeight = param3;
         this.mcLine.height = this._visibleScrollHeight;
         this._scrollObj = param1;
         this._scrollObjStartY = this._scrollObj.y;
         this._scrollSpan = param2 - this._visibleScrollHeight;
         this._scrollUpdateTimer = new Timer(100,0);
         this._scrollUpdateTimer.addEventListener(TimerEvent.TIMER,this.updateScroll,false,0,true);
         this._headMin = this.mcScrollHead.y;
         this._headMax = this._headMin + (this.mcLine.height - this.mcScrollHead.height + 10);
         this._headSpan = this._headMax - this._headMin;
         this._scrollHeadBounds = new Rectangle(this.mcScrollHead.x,this._headMin,0,this._headMax);
         if(this._flipScroll)
         {
            this.mcScrollHead.y = this._headMax;
         }
         this.mcScrollHead.useHandCursor = true;
         this.mcScrollHead.buttonMode = true;
         this.mcScrollHead.mouseChildren = false;
         this.mcScrollHead.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         this.mcScrollHead.stopDrag();
         this.stopScroll();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function startScroll() : void
      {
         this._scrollUpdateTimer.start();
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         this.mcScrollHead.startDrag(false,this._scrollHeadBounds);
         this.startScroll();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function stopScroll() : void
      {
         this._scrollUpdateTimer.reset();
      }
      
      private function updateScroll(param1:TimerEvent) : void
      {
         var _loc2_:Number = 0;
         if(this._flipScroll)
         {
            _loc2_ = (this.mcScrollHead.y - this._headMax) / this._headSpan;
         }
         else
         {
            _loc2_ = (this.mcScrollHead.y - this._headMin) / this._headSpan;
         }
         this._scrollObj.y = this._scrollObjStartY - this._scrollSpan * _loc2_;
      }
      
      public function destroy() : void
      {
         if(this._scrollUpdateTimer != null)
         {
            this._scrollUpdateTimer.stop();
            this._scrollUpdateTimer.removeEventListener(TimerEvent.TIMER,this.updateScroll);
         }
         this.mcScrollHead.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
      }
   }
}

