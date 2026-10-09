package com.arkadium.virmon.shared.elements.viewer.opponentattackaccordion
{
   import fl.transitions.*;
   import flash.display.*;
   import flash.events.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol167")]
   public class OpponentAccordion extends MovieClip
   {
      
      private var _items:Array;
      
      private var _isEmpty:Boolean = true;
      
      private var _nStartY:Number = 0;
      
      private var dx:Number = 0;
      
      private var _nDelay:Number = 0.2;
      
      private var _arrTween:Array;
      
      private var _dp:Array;
      
      private var _nEndY:Number = 0;
      
      private var _indSelect:int = -1;
      
      public function OpponentAccordion()
      {
         var i:uint;
         _dp = [];
         _items = [];
         _arrTween = [];
         super();
         i = 0;
         while(i < numChildren)
         {
            try
            {
               removeChildAt(i);
            }
            catch(e:Error)
            {
            }
            i++;
         }
      }
      
      private function reinit() : void
      {
         var _loc2_:ItemAccordion = null;
         var _loc3_:Tween = null;
         var _loc1_:uint = 0;
         while(_loc1_ < _items.length)
         {
            _loc2_ = _items[_loc1_];
            _loc3_ = new Tween(_loc2_,"y",null,_loc2_.y,_loc1_ * _loc2_.height,_nDelay,true);
            _loc3_.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
            _arrTween.push(_loc3_);
            _loc1_++;
         }
         _indSelect = -1;
      }
      
      private function changeState(param1:uint) : void
      {
         var _loc3_:Tween = null;
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < _arrTween.length)
         {
            _arrTween[_loc2_].stop();
            _arrTween[_loc2_].removeEventListener(TweenEvent.MOTION_FINISH,onFinishMotion);
            _loc2_++;
         }
         _arrTween = [];
         _loc2_ = 0;
         while(_loc2_ < _items.length)
         {
            if(_loc2_ <= param1)
            {
               _loc3_ = new Tween(_items[_loc2_],"y",null,_items[_loc2_].y,_items[0].y + _loc2_ * _items[_loc2_].offset,_nDelay,true);
            }
            else
            {
               _loc3_ = new Tween(_items[_loc2_],"y",null,_items[_loc2_].y,_nEndY - (_items.length - _loc2_ - 1) * _items[_loc2_].offset,_nDelay,true);
            }
            _loc2_++;
         }
         _loc3_.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _arrTween.push(_loc3_);
      }
      
      public function onPressItem(param1:MouseEvent) : void
      {
         var _loc2_:uint = uint(param1.currentTarget.parent.id);
         if(_indSelect != -1)
         {
            _items[_indSelect].open();
         }
         if(_indSelect == _loc2_)
         {
            reinit();
         }
         else
         {
            _indSelect = _loc2_;
            _items[_indSelect].open();
            changeState(_indSelect);
         }
      }
      
      public function clearAll() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _arrTween.length)
         {
            _arrTween[_loc1_].stop();
            _arrTween[_loc1_].removeEventListener(TweenEvent.MOTION_FINISH,onFinishMotion);
            _arrTween[_loc1_] = null;
            _loc1_++;
         }
         _arrTween = [];
      }
      
      private function onFinishMotion(param1:TweenEvent) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _arrTween.length)
         {
            if(!_arrTween[_loc2_].isPlaying)
            {
               _arrTween[_loc2_].removeEventListener(TweenEvent.MOTION_FINISH,onFinishMotion);
               _arrTween.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function set dataProvider(param1:Array) : void
      {
         _dp = param1;
         _indSelect = -1;
         _isEmpty = true;
         updateDisplayList();
      }
      
      protected function updateDisplayList() : void
      {
         var item:ItemAccordion = null;
         var tw:Tween = null;
         var i:uint = 0;
         dx = 0;
         i = 0;
         while(i < _items.length)
         {
            _items[i]._sbtInfo.removeEventListener(MouseEvent.CLICK,onPressItem);
            try
            {
               removeChild(_items[i]);
            }
            catch(e:Error)
            {
            }
            i++;
         }
         _items = new Array();
         i = 0;
         while(i < _dp.length)
         {
            item = new ItemAccordion();
            item.id = i;
            item.delay = _nDelay;
            item.title = String(_dp[i].title).toUpperCase();
            item.energy = String(_dp[i].energy).toUpperCase();
            item.detail = String(_dp[i].text);
            item.faction = String(_dp[i].faction);
            item.icon = String(_dp[i].icon);
            tw = new Tween(item,"y",null,item.y,i * item.height,_nDelay,true);
            tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
            _arrTween.push(tw);
            addChild(item);
            _items[i] = item;
            item._sbtInfo.addEventListener(MouseEvent.CLICK,onPressItem,false,0,true);
            i++;
         }
         _nStartY = _items[0].y;
         _nEndY = _nStartY + (_items.length - 1) * _items[0].offset + _items[0].fieldHeight;
      }
   }
}

