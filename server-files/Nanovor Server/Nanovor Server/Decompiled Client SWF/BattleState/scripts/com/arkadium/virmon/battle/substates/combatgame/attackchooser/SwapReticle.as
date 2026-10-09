package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4")]
   public class SwapReticle extends Sprite
   {
      
      private var _glowFilter:GlowFilter;
      
      public var mcReticle:MovieClip;
      
      public function SwapReticle()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function stopAnimation() : void
      {
         mcReticle.stop();
      }
      
      public function reset() : void
      {
         mcReticle.gotoAndPlay(1);
      }
   }
}

