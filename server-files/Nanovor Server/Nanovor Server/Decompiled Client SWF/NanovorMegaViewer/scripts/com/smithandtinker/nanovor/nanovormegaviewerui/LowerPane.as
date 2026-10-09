package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol130")]
   public class LowerPane extends MovieClip
   {
      
      public static const MaxDeltaCount:int = 10;
      
      public static const MaxClickDelta:int = 500;
      
      public static const DamageClickAverage:int = 180;
      
      public static const DamageClickMinDeltas:int = 7;
      
      private var _lastClickTime:int;
      
      public var HealthText:TextField;
      
      public var SpeedLabel:TextField;
      
      public var StrengthLabel:TextField;
      
      public var ShockButton:SimpleButton;
      
      public var ArmorLabel:TextField;
      
      public var mcHealthBar:MovieClip;
      
      private var _clickDeltas:Array;
      
      public var ArmorText:TextField;
      
      public var StrengthText:TextField;
      
      public var SpeedText:TextField;
      
      public function LowerPane()
      {
         super();
         ShockButton.addEventListener(MouseEvent.CLICK,shockButtonClickHandler,false,0,true);
         _clickDeltas = new Array();
         _lastClickTime = 0;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> LowerPane: " + param1);
      }
      
      public function resetHealthBar() : void
      {
         mcHealthBar.gotoAndPlay("fade");
      }
      
      public function showHealthBar() : void
      {
         mcHealthBar.visible = true;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> LowerPane: ** " + param1 + " **");
      }
      
      public function startHealthBar() : void
      {
         mcHealthBar.gotoAndPlay("startup");
      }
      
      public function enableShockButton() : void
      {
         ShockButton.addEventListener(MouseEvent.CLICK,shockButtonClickHandler,false,0,true);
         ShockButton.enabled = true;
         Tweener.addTween(ShockButton,{
            "_tintBrightness":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      public function hideHealthBar() : void
      {
         mcHealthBar.visible = false;
      }
      
      private function shockButtonClickHandler(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - _lastClickTime;
         if(_loc3_ < LowerPane.MaxClickDelta)
         {
            _clickDeltas.push(_loc3_);
            if(_clickDeltas.length > LowerPane.MaxDeltaCount)
            {
               _clickDeltas.shift();
            }
            _loc4_ = 0;
            for each(_loc5_ in _clickDeltas)
            {
               _loc4_ += _loc5_;
            }
            _loc4_ /= _clickDeltas.length;
            if(_clickDeltas.length > LowerPane.DamageClickMinDeltas && _loc4_ < LowerPane.DamageClickAverage)
            {
               _clickDeltas = new Array();
               NanovorMegaViewer(parent).PlayDeath();
            }
         }
         else
         {
            _clickDeltas = new Array();
            NanovorMegaViewer(parent).PlayDamage();
         }
         _lastClickTime = _loc2_;
      }
      
      public function disableShockButton() : void
      {
         ShockButton.removeEventListener(MouseEvent.CLICK,shockButtonClickHandler);
         ShockButton.enabled = false;
         Tweener.addTween(ShockButton,{
            "_tintBrightness":-0.5,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
   }
}

