package com.arkadium.virmon.shared.ui.gameOptions
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol52")]
   public class CVolumeScroller extends MovieClip
   {
      
      private var _nValue:Number;
      
      public var _mcScroll:MovieClip;
      
      private var _strType:String;
      
      public var _mcLine:MovieClip;
      
      private var _consumer:ICGameOptionsConsumer;
      
      private var _nValuePrevious:Number = -1;
      
      private var _nScrollerWidth:Number;
      
      public function CVolumeScroller()
      {
         super();
         _nScrollerWidth = _mcScroll.width - 6;
      }
      
      private function entrFr(param1:Event) : void
      {
         _nValue = 100 * (_mcScroll.x - (_nScrollerWidth / 2 - 1)) / (_mcLine.width - _nScrollerWidth);
         _nValue = _nValue < 0 ? 0 : (_nValue > 100 ? 100 : Math.round(_nValue));
         if(_nValuePrevious == -1 || _nValue != _nValuePrevious)
         {
            DebugLog.instance.log("CVolumeScroller [" + _strType + "] entrFr: " + _nValue + "!=" + _nValuePrevious + "... will dispatch event");
            _nValuePrevious = _nValue;
            var _loc2_:Object = new Object();
            var _loc3_:String = "";
            _loc2_.value = _nValue;
            _loc2_.type = _strType;
            if(null != _consumer)
            {
               _consumer.handleGameOptionsVolumeChanged(_nValue,_strType);
            }
            return;
         }
      }
      
      private function mdHand(param1:MouseEvent) : void
      {
         _mcScroll.startDrag(true,new Rectangle(_nScrollerWidth / 2 - 1,_mcScroll.y,_mcLine.width - _nScrollerWidth,0));
         _mcScroll.removeEventListener(MouseEvent.MOUSE_DOWN,mdHand);
         stage.addEventListener(MouseEvent.MOUSE_UP,muHand,false,0,true);
         addEventListener(Event.ENTER_FRAME,entrFr,false,0,true);
      }
      
      public function set position(param1:Number) : *
      {
         var _loc2_:Number = param1 > 1 ? param1 / 100 : param1;
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         _mcScroll.x = _nScrollerWidth / 2 - 1 + (_mcLine.width - _nScrollerWidth) * _loc2_;
      }
      
      public function get position() : Number
      {
         return _mcScroll.x;
      }
      
      private function muHand(param1:MouseEvent) : void
      {
         _mcScroll.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,muHand);
         _mcScroll.addEventListener(MouseEvent.MOUSE_DOWN,mdHand,false,0,true);
         removeEventListener(Event.ENTER_FRAME,entrFr);
      }
      
      public function setType(param1:String) : *
      {
         _strType = param1;
         _mcScroll.addEventListener(MouseEvent.MOUSE_DOWN,mdHand,false,0,true);
      }
      
      public function setConsumer(param1:ICGameOptionsConsumer) : void
      {
         _consumer = param1;
      }
   }
}

