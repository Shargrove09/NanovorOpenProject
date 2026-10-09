package com.arkadium.virmon.shared.ui.dropdownmenu
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol33")]
   public class DropDownMenuListBox extends MovieClip
   {
      
      public static const ITEMS_ORIGIN_X:int = 6;
      
      public static const ITEMS_ORIGIN_Y:int = 8;
      
      public static const SCROLL_SPEED:int = 3;
      
      private var _scrollTimer:Timer;
      
      private var _items:Array;
      
      public var btnUpArrow:SimpleButton;
      
      private var _handler:IDropDownMenuHandler;
      
      public var btnDownArrow:SimpleButton;
      
      public var mcListBoxBG:MovieClip;
      
      public var mcMask:MovieClip;
      
      private var _itemContainer:MovieClip;
      
      private var _curScrollSpeed:int;
      
      public function DropDownMenuListBox()
      {
         super();
      }
      
      public function init(param1:IDropDownMenuHandler, param2:Array) : void
      {
         this._handler = param1;
         this._scrollTimer = new Timer(1,0);
         this._scrollTimer.addEventListener(TimerEvent.TIMER,this.updateScroll,false,0,true);
         this.makeItems(param2);
         if(this._itemContainer.height > this.mcMask.height)
         {
            this.btnUpArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpArrowDown,false,0,true);
            this.btnDownArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownArrowDown,false,0,true);
            this.btnUpArrow.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,false,0,true);
            this.btnDownArrow.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,false,0,true);
         }
         else
         {
            this.btnUpArrow.enabled = false;
            this.btnDownArrow.enabled = false;
         }
      }
      
      private function onUpArrowDown(param1:MouseEvent) : void
      {
         this._curScrollSpeed = SCROLL_SPEED;
         this._scrollTimer.start();
      }
      
      private function makeItems(param1:Array) : void
      {
         var _loc5_:DropDownMenuListBoxItem = null;
         this._itemContainer = new MovieClip();
         addChild(this._itemContainer);
         this._itemContainer.x = ITEMS_ORIGIN_X;
         this._itemContainer.y = ITEMS_ORIGIN_Y;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = new DropDownMenuListBoxItem(this._handler,_loc4_,param1[_loc4_].name,!param1[_loc4_].full);
            this._itemContainer.addChild(_loc5_);
            _loc5_.x = _loc2_;
            _loc5_.y = _loc3_;
            _loc3_ += _loc5_.height;
            _loc4_++;
         }
         this._itemContainer.mask = this.mcMask;
      }
      
      private function onDownArrowDown(param1:MouseEvent) : void
      {
         this._curScrollSpeed = -SCROLL_SPEED;
         this._scrollTimer.start();
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this._scrollTimer.stop();
      }
      
      public function resetScroll() : void
      {
         this._itemContainer.y = ITEMS_ORIGIN_Y;
      }
      
      private function updateScroll(param1:TimerEvent) : void
      {
         this._itemContainer.y += this._curScrollSpeed;
         if(this._curScrollSpeed > 0)
         {
            if(this._itemContainer.y >= ITEMS_ORIGIN_Y)
            {
               this._itemContainer.y = ITEMS_ORIGIN_Y;
               this.stopScroll(null);
            }
         }
         else if(this._itemContainer.y <= ITEMS_ORIGIN_Y - this._itemContainer.height + this.mcMask.height - 20)
         {
            this.stopScroll(null);
            this._itemContainer.y = ITEMS_ORIGIN_Y - this._itemContainer.height + this.mcMask.height - 20;
         }
      }
   }
}

