package com.arkadium.virmon.evotree.ui.evolvebutton
{
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol35")]
   public class EvolveButtonRequirements extends MovieClip
   {
      
      private static var cantEvolveFilter:BitmapFilter;
      
      private static const FRAME_LABEL_CLOSED:String = "Closed";
      
      private static const FRAME_LABEL_OPEN:String = "Open";
      
      private static const FRAME_LABEL_CLOSE:String = "Close";
      
      public function EvolveButtonRequirements()
      {
         super();
         addFrameScript(0,frame1,19,frame20,27,frame28);
         this.stop();
         createCantEvolveFilter();
      }
      
      internal function frame28() : *
      {
         gotoAndStop("Closed");
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      private function createCantEvolveFilter() : void
      {
         var _loc1_:AdjustColor = null;
         if(null == cantEvolveFilter)
         {
            _loc1_ = new AdjustColor();
            _loc1_.brightness = -70;
            _loc1_.contrast = 0;
            _loc1_.saturation = 20;
            _loc1_.hue = 155;
            cantEvolveFilter = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         }
      }
      
      public function close() : void
      {
         this.gotoAndPlay(FRAME_LABEL_CLOSE);
      }
      
      public function open() : void
      {
         this.gotoAndPlay(FRAME_LABEL_OPEN);
      }
      
      public function setCanEvolve(param1:Boolean) : void
      {
         if(param1)
         {
         }
      }
   }
}

