package com.arkadium.virmon.device.deviceswarmchooser.deviceswarmspinner
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol18")]
   public class DeviceSwarmSpinner extends MovieClip
   {
      
      public static const COLOR_GREEN:String = "green";
      
      private static const GREEN_SETTINGS:Object = {
         "brightness":-5,
         "contrast":27,
         "saturation":18,
         "hue":-111
      };
      
      private static const FLASH_TIME_MIN:int = 2000;
      
      private static const FLASH_TIME_MAX:int = 5000;
      
      private static const SPIN_TIME_MIN:int = 5000;
      
      private static const SPIN_TIME_MAX:int = 10000;
      
      public static const LABEL_COLOR:uint = ColorMap.UI_GREEN_3;
      
      public static const TEXT_WIDTH:int = 114;
      
      private var _labelText:TextField;
      
      public var mcTextSpin:MovieClip;
      
      public var mcDevice:MovieClip;
      
      private var _flashTimer:Timer;
      
      private var _spinTimer:Timer;
      
      private var _countdownText:TextField;
      
      public function DeviceSwarmSpinner()
      {
         super();
         _flashTimer = new Timer(1000,0);
         _flashTimer.addEventListener(TimerEvent.TIMER,onFlashTimer);
         _spinTimer = new Timer(1000,0);
         _spinTimer.addEventListener(TimerEvent.TIMER,onSpinTimer);
         this.alpha = 0;
      }
      
      public function set color(param1:String) : void
      {
         var _loc2_:AdjustColor = new AdjustColor();
         switch(param1)
         {
            case COLOR_GREEN:
               _loc2_.brightness = GREEN_SETTINGS.brightness;
               _loc2_.contrast = GREEN_SETTINGS.contrast;
               _loc2_.saturation = GREEN_SETTINGS.saturation;
               _loc2_.hue = GREEN_SETTINGS.hue;
         }
         mcDevice.filters = [new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray())];
      }
      
      public function startAnimation() : void
      {
         setFlashTimer();
         setSpinTimer();
      }
      
      private function onSpinTimer(param1:TimerEvent) : void
      {
         mcTextSpin.gotoAndPlay("spin");
         mcDevice.mcOutline.gotoAndPlay("spin");
         mcDevice.mcBase.gotoAndPlay("spin");
         setSpinTimer();
      }
      
      public function updateCount(param1:int) : void
      {
         _countdownText.text = String(param1);
         if(param1 == 1)
         {
            _labelText.text = "SLOT LEFT";
         }
         else
         {
            _labelText.text = "SLOTS LEFT";
         }
      }
      
      public function init() : void
      {
         _countdownText = createSpinnerText("00",50,LABEL_COLOR);
         _labelText = createSpinnerText("SLOTS LEFT",20,LABEL_COLOR);
         _countdownText.x = 3;
         _countdownText.y = 5;
         _labelText.x = 3;
         _labelText.y = _countdownText.y + _countdownText.textHeight;
         mcTextSpin.mcText.addChild(_countdownText);
         mcTextSpin.mcText.addChild(_labelText);
      }
      
      public function hide() : void
      {
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":0,
            "time":0.25,
            "transition":"easeOutQuad"
         });
      }
      
      private function stopFlashTimer() : void
      {
         _flashTimer.stop();
      }
      
      private function createSpinnerText(param1:String, param2:int, param3:uint) : TextField
      {
         var _loc4_:EuroStileBoldCondensed = new EuroStileBoldCondensed();
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.font = _loc4_.fontName;
         _loc5_.size = param2;
         _loc5_.color = param3;
         _loc5_.bold = true;
         _loc5_.align = TextFormatAlign.CENTER;
         var _loc6_:TextField = new TextField();
         _loc6_.defaultTextFormat = _loc5_;
         _loc6_.embedFonts = true;
         _loc6_.text = param1;
         _loc6_.width = TEXT_WIDTH;
         _loc6_.multiline = false;
         _loc6_.selectable = false;
         _loc6_.antiAliasType = AntiAliasType.NORMAL;
         return _loc6_;
      }
      
      private function setSpinTimer() : void
      {
         var _loc1_:int = Math.floor(Math.random() * (SPIN_TIME_MAX - SPIN_TIME_MIN) + SPIN_TIME_MIN);
         _spinTimer.delay = _loc1_;
         _spinTimer.start();
      }
      
      private function onFlashTimer(param1:TimerEvent) : void
      {
         mcDevice.gotoAndPlay("flash");
         setFlashTimer();
      }
      
      private function setFlashTimer() : void
      {
         var _loc1_:int = Math.floor(Math.random() * (FLASH_TIME_MAX - FLASH_TIME_MIN) + FLASH_TIME_MIN);
         _flashTimer.delay = _loc1_;
         _flashTimer.start();
      }
      
      public function destroy() : void
      {
         stopFlashTimer();
         _spinTimer.stop();
         mcDevice.stop();
      }
      
      public function show() : void
      {
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":1,
            "time":0.25,
            "delay":0.1,
            "transition":"easeOutQuad"
         });
      }
   }
}

