package com.arkadium.virmon.battle.components
{
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8")]
   public class TargetReticle extends MovieClip
   {
      
      public static const TARGET_RETICLE_COLOR_BLUE:uint = 2340070;
      
      public static const TARGET_RETICLE_COLOR_RED:uint = 16711680;
      
      public static const CTA_ATTACK:String = "ATTACK!";
      
      public static const CTA_SELECT:String = "SELECT!";
      
      public static const CTA_CONFIRM:String = "CONFIRM!";
      
      public static const CTA_REMOVE:String = "REMOVE!";
      
      private var _glowFilter:GlowFilter;
      
      public var tfCTAVariable:TextField;
      
      public var mcReticle:MovieClip;
      
      public function TargetReticle()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         _glowFilter = new GlowFilter(TARGET_RETICLE_COLOR_BLUE,1,12,12,1.46);
         mcReticle.filters = [_glowFilter];
         tfCTAVariable.filters = [_glowFilter];
      }
      
      public function stopAnimation() : void
      {
         mcReticle.stop();
      }
      
      public function set ctaMessage(param1:String) : void
      {
         tfCTAVariable.text = param1;
         tfCTAVariable.autoSize = TextFieldAutoSize.CENTER;
      }
      
      public function set color(param1:uint) : void
      {
         _glowFilter.color = param1;
         mcReticle.filters = [_glowFilter];
         tfCTAVariable.filters = [_glowFilter];
      }
      
      public function reset() : void
      {
         mcReticle.gotoAndPlay(1);
      }
   }
}

