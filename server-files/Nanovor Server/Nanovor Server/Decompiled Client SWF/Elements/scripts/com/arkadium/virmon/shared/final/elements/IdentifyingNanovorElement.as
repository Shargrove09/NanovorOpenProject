package com.arkadium.virmon.shared.final.elements
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol600")]
   public class IdentifyingNanovorElement extends MovieClip
   {
      
      public var mcIdentifyingText:MovieClip;
      
      public function IdentifyingNanovorElement(param1:Boolean = true)
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         if(param1)
         {
            stop();
         }
      }
      
      override public function stop() : void
      {
         if(mcIdentifyingText != null)
         {
            mcIdentifyingText.stop();
         }
         super.stop();
      }
      
      override public function play() : void
      {
         if(mcIdentifyingText != null)
         {
            mcIdentifyingText.play();
         }
         super.play();
      }
   }
}

