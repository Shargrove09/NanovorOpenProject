package com.arkadium.virmon.shared.widgets.wait
{
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol86")]
   public class WaitWidget extends MovieClip
   {
      
      public function WaitWidget()
      {
         super();
         addFrameScript(67,frame68);
         var _loc1_:UnknownNanovorSpinner = new UnknownNanovorSpinner();
         _loc1_.x = -75;
         _loc1_.y = -61;
         this.addChild(_loc1_);
      }
      
      internal function frame68() : *
      {
         stop();
      }
   }
}

