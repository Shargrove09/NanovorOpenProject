package com.arkadium.virmon.trade.ui.utils
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol160")]
   public class BalanceMeter extends MovieClip
   {
      
      private var _nDuration:Number = 0.5;
      
      public var _mcNeedle:MovieClip;
      
      public var _tfStatus:TextField;
      
      public var _mcStatusBar:MovieClip;
      
      private var MAX_PERCENT:Number = 0.5;
      
      private var _nAngel:Number = 0;
      
      private var _nCurPercent:Number = 0;
      
      private var _tUpdate:Timer;
      
      private var MAX_ANGLE:int = 45;
      
      public function BalanceMeter()
      {
         super();
         _tUpdate = new Timer(_nDuration * 50,20);
         _tUpdate.addEventListener(TimerEvent.TIMER,onBalanceUpdate,false,0,true);
      }
      
      public function balance(param1:Number, param2:Number) : Boolean
      {
         param1 = Math.max(0,param1);
         param2 = Math.max(0,param2);
         if(param1 == 0 && param2 == 0)
         {
            param1 = param2 = 1;
         }
         _nCurPercent = (param1 - param2) / Math.max(param1,param2);
         _nAngel = Math.min(MAX_ANGLE,MAX_ANGLE * _nCurPercent) - _mcNeedle.rotation;
         _tUpdate.reset();
         _tUpdate.start();
         return true;
      }
      
      private function onBalanceUpdate(param1:TimerEvent) : void
      {
         var _loc2_:Number = _nAngel / Timer(param1.target).repeatCount;
         _mcNeedle.rotation += _loc2_;
         var _loc3_:Number = _mcNeedle.rotation;
         _tfStatus.text = Math.abs(_loc3_) < 15 ? "BALANCED" : "UNBALANCED";
         if(_loc3_ < 0)
         {
            _mcStatusBar.rotation = 180;
         }
         else
         {
            _mcStatusBar.rotation = 0;
         }
         var _loc4_:Number = Math.abs(_loc3_ / MAX_ANGLE);
         _mcStatusBar._mcGreenBar.alpha = 1 - _loc4_;
         _mcStatusBar._mcRedBar.alpha = _loc4_;
      }
      
      public function destroy() : void
      {
         _tUpdate.stop();
         _tUpdate.removeEventListener(TimerEvent.TIMER,onBalanceUpdate);
         _tUpdate = null;
      }
   }
}

