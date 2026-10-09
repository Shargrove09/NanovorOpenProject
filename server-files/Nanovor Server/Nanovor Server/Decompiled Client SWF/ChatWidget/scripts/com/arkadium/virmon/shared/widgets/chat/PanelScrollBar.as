package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public class PanelScrollBar extends Sprite
   {
      
      private var _scrollBounds:Rectangle;
      
      public var mcScrollTrack:MovieClip;
      
      public var mcUp:MovieClip;
      
      public var tweenOverride:Object;
      
      public var mcDown:MovieClip;
      
      public var mcSlider:MovieClip;
      
      private var _scrollSliderPercentage:Number = 1;
      
      private var _isScrolling:Boolean = false;
      
      private var _defaultTop:Boolean = true;
      
      private var _target:DisplayObject;
      
      private var _scrollTimer:Timer;
      
      private var _scrollDirection:String = "";
      
      private var _scrollSpeed:int = 1;
      
      private var _targetMask:DisplayObject;
      
      public function PanelScrollBar(param1:DisplayObject, param2:DisplayObject)
      {
         super();
         DebugLog.instance.log("<<PanelScrollBar>> ctor -- target: " + param1 + ", targetmask: " + param2);
         this._target = param1;
         this._targetMask = param2;
         this._scrollTimer = new Timer(20);
         this._scrollTimer.addEventListener(TimerEvent.TIMER,this.onTime);
         this.initializeScrollbar();
      }
      
      private function scrollTo(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         this._scrollSliderPercentage = (this.mcSlider.y - this._scrollBounds.top) / this._scrollBounds.height;
         if(this._target.height > this._targetMask.height || param1.type == "INITIALIZING")
         {
            _loc2_ = this._targetMask.y - this._scrollSliderPercentage * (this._target.height - this._targetMask.height);
            if(param1.type == "INITIALIZING")
            {
               if(this._defaultTop)
               {
                  Tweener.addTween(this._target,{
                     "y":this._targetMask.y,
                     "time":0.75,
                     "transition":"easeOutQuad"
                  });
               }
               else
               {
                  Tweener.addTween(this._target,{
                     "y":_loc2_,
                     "time":0.75,
                     "transition":"easeOutQuad"
                  });
               }
            }
            else
            {
               this._target.y = _loc2_;
            }
         }
      }
      
      private function initializeScrollbar() : void
      {
         this.mcSlider.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this.mcUp.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this.mcDown.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._target.addEventListener(MouseEvent.MOUSE_WHEEL,this.beginScroll);
         this.recalculateScrolling();
      }
      
      private function scrubListeners() : void
      {
         this.mcSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this.mcUp.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this.mcDown.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._target.removeEventListener(MouseEvent.MOUSE_WHEEL,this.beginScroll);
      }
      
      private function onTime(param1:TimerEvent) : void
      {
         var _loc2_:Number = this._scrollDirection == "down" ? this._scrollSpeed * -1 : this._scrollSpeed;
         if(this.mcSlider.y - _loc2_ <= this._scrollBounds.bottom && this.mcSlider.y - _loc2_ >= this._scrollBounds.top)
         {
            this.mcSlider.y -= _loc2_;
         }
      }
      
      public function reset() : void
      {
         var _loc1_:int = this.mcUp.y + this.mcUp.height + this.mcSlider.height / 2;
         var _loc2_:int = this.mcScrollTrack.height - this.mcSlider.height;
         if(this._defaultTop)
         {
            this.mcSlider.y = _loc1_;
            this._target.y = this._targetMask.y;
         }
         else
         {
            this.mcSlider.y = _loc1_ + _loc2_;
            this._target.y = this._targetMask.y - this._target.height + this._targetMask.height;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         this.mcScrollTrack.height = param1 - this.mcUp.height - this.mcDown.height;
         this.mcDown.y = param1;
         this.recalculateScrolling();
      }
      
      private function beginScroll(param1:MouseEvent) : void
      {
         if(this._target.height < this._targetMask.height)
         {
            return;
         }
         if(param1.type == MouseEvent.MOUSE_WHEEL)
         {
            if(this.mcSlider.y - param1.delta <= this._scrollBounds.bottom && this.mcSlider.y - param1.delta >= this._scrollBounds.top)
            {
               this.mcSlider.y -= param1.delta;
               this.scrollTo(param1);
            }
            return;
         }
         this.mcSlider.stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.mcSlider.addEventListener(Event.ENTER_FRAME,this.scrollTo);
         if(param1.currentTarget == this.mcSlider)
         {
            this._isScrolling = true;
            this.mcSlider.startDrag(true,this._scrollBounds);
         }
         else
         {
            this._scrollDirection = param1.currentTarget.name == "mcUp" ? "up" : "down";
            this._scrollTimer.start();
         }
      }
      
      public function refresh() : void
      {
         this.mcSlider.visible = this._target.height < this._targetMask.height ? false : true;
      }
      
      public function set defaultTop(param1:Boolean) : void
      {
         this._defaultTop = param1;
      }
      
      private function recalculateScrolling() : void
      {
         var _loc1_:int = this.mcUp.y + this.mcUp.height + this.mcSlider.height / 2;
         var _loc2_:int = this.mcScrollTrack.height - this.mcSlider.height;
         var _loc3_:int = this.mcUp.width / 2;
         this._scrollBounds = new Rectangle(_loc3_,_loc1_,0,_loc2_);
         this.scrollTo(new MouseEvent("INITIALIZING"));
         this.mcSlider.y = this._defaultTop ? _loc1_ : _loc1_ + _loc2_;
      }
      
      public function get isScrolling() : Boolean
      {
         return this._isScrolling;
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this._isScrolling = false;
         this.mcSlider.stopDrag();
         this.mcSlider.removeEventListener(Event.ENTER_FRAME,this.scrollTo);
         this._scrollTimer.reset();
         this.mcSlider.stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
      }
      
      private function addChatMessage(param1:String, param2:String, param3:* = null) : void
      {
      }
   }
}

