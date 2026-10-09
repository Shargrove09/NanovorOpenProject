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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
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
         _target = param1;
         _targetMask = param2;
         _scrollTimer = new Timer(20);
         _scrollTimer.addEventListener(TimerEvent.TIMER,onTime);
         initializeScrollbar();
      }
      
      private function scrollTo(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _scrollSliderPercentage = (mcSlider.y - _scrollBounds.top) / _scrollBounds.height;
         if(_target.height > _targetMask.height || param1.type == "INITIALIZING")
         {
            _loc2_ = _targetMask.y - _scrollSliderPercentage * (_target.height - _targetMask.height);
            if(param1.type == "INITIALIZING")
            {
               if(_defaultTop)
               {
                  Tweener.addTween(_target,{
                     "y":_targetMask.y,
                     "time":0.75,
                     "transition":"easeOutQuad"
                  });
               }
               else
               {
                  Tweener.addTween(_target,{
                     "y":_loc2_,
                     "time":0.75,
                     "transition":"easeOutQuad"
                  });
               }
            }
            else
            {
               _target.y = _loc2_;
            }
         }
      }
      
      private function initializeScrollbar() : void
      {
         mcSlider.addEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         mcUp.addEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         mcDown.addEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         _target.addEventListener(MouseEvent.MOUSE_WHEEL,beginScroll);
         recalculateScrolling();
      }
      
      private function scrubListeners() : void
      {
         mcSlider.removeEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         mcUp.removeEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         mcDown.removeEventListener(MouseEvent.MOUSE_DOWN,beginScroll);
         _target.removeEventListener(MouseEvent.MOUSE_WHEEL,beginScroll);
      }
      
      private function onTime(param1:TimerEvent) : void
      {
         var _loc2_:Number = _scrollDirection == "down" ? _scrollSpeed * -1 : _scrollSpeed;
         if(mcSlider.y - _loc2_ <= _scrollBounds.bottom && mcSlider.y - _loc2_ >= _scrollBounds.top)
         {
            mcSlider.y -= _loc2_;
         }
      }
      
      public function reset() : void
      {
         var _loc1_:int = mcUp.y + mcUp.height + mcSlider.height / 2;
         var _loc2_:int = mcScrollTrack.height - mcSlider.height;
         if(_defaultTop)
         {
            mcSlider.y = _loc1_;
            _target.y = _targetMask.y;
         }
         else
         {
            mcSlider.y = _loc1_ + _loc2_;
            _target.y = _targetMask.y - _target.height + _targetMask.height;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         mcScrollTrack.height = param1 - mcUp.height - mcDown.height;
         mcDown.y = param1;
         recalculateScrolling();
      }
      
      private function beginScroll(param1:MouseEvent) : void
      {
         if(_target.height < _targetMask.height)
         {
            return;
         }
         if(param1.type == MouseEvent.MOUSE_WHEEL)
         {
            if(mcSlider.y - param1.delta <= _scrollBounds.bottom && mcSlider.y - param1.delta >= _scrollBounds.top)
            {
               mcSlider.y -= param1.delta;
               scrollTo(param1);
            }
            return;
         }
         mcSlider.stage.addEventListener(MouseEvent.MOUSE_UP,stopScroll);
         mcSlider.addEventListener(Event.ENTER_FRAME,scrollTo);
         if(param1.currentTarget == mcSlider)
         {
            _isScrolling = true;
            mcSlider.startDrag(true,_scrollBounds);
         }
         else
         {
            _scrollDirection = param1.currentTarget.name == "mcUp" ? "up" : "down";
            _scrollTimer.start();
         }
      }
      
      public function refresh() : void
      {
         mcSlider.visible = _target.height < _targetMask.height ? false : true;
      }
      
      public function set defaultTop(param1:Boolean) : void
      {
         _defaultTop = param1;
      }
      
      private function recalculateScrolling() : void
      {
         var _loc1_:int = mcUp.y + mcUp.height + mcSlider.height / 2;
         var _loc2_:int = mcScrollTrack.height - mcSlider.height;
         var _loc3_:int = mcUp.width / 2;
         _scrollBounds = new Rectangle(_loc3_,_loc1_,0,_loc2_);
         scrollTo(new MouseEvent("INITIALIZING"));
         mcSlider.y = _defaultTop ? _loc1_ : _loc1_ + _loc2_;
      }
      
      public function get isScrolling() : Boolean
      {
         return _isScrolling;
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         _isScrolling = false;
         mcSlider.stopDrag();
         mcSlider.removeEventListener(Event.ENTER_FRAME,scrollTo);
         _scrollTimer.reset();
         mcSlider.stage.removeEventListener(MouseEvent.MOUSE_UP,stopScroll);
      }
      
      private function addChatMessage(param1:String, param2:String, param3:* = null) : void
      {
      }
   }
}

