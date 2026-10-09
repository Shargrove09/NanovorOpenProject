package com.arkadium.virmon.shared.final.elements
{
   import flash.display.MovieClip;
   
   public class UnknownNanovorSpinner extends MovieClip
   {
      
      public var mcSpin:MovieClip;
      
      public var mcWire:MovieClip;
      
      public function UnknownNanovorSpinner()
      {
         super();
      }
      
      public function stopAllAnimation() : void
      {
         this.gotoAndStop(1);
         mcWire.gotoAndStop(1);
         mcSpin.gotoAndStop(1);
      }
   }
}

