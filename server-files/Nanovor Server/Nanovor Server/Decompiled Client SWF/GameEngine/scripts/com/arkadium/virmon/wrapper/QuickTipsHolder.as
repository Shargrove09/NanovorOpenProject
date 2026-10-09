package com.arkadium.virmon.wrapper
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public class QuickTipsHolder extends MovieClip implements IQuickTipsHolder
   {
      
      public var mcQuickTipsStub:MovieClip;
      
      public function QuickTipsHolder()
      {
         super();
      }
      
      public function get QuickTipsStub() : MovieClip
      {
         return mcQuickTipsStub;
      }
   }
}

