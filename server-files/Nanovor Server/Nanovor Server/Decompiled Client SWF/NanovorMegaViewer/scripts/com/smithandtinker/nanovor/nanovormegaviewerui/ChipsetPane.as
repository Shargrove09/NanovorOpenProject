package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.arkadium.virmon.shared.utils.*;
   import flash.display.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol98")]
   public class ChipsetPane extends ArkMc
   {
      
      public var GrabberClip:MovieClip;
      
      public var ChipHolderClip:MovieClip;
      
      public var LaserClip:MovieClip;
      
      public function ChipsetPane()
      {
         addFrameScript(0,frame1,228,frame229);
         super();
         GrabberClip.stop();
         ChipHolderClip = GrabberClip.ChipHolderClip;
      }
      
      public function PlayCoilAnimation() : void
      {
         LaserClip.stop();
         LaserClip.visible = false;
         gotoAndPlayAnimationBeforeFrame("Open","Stop");
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame229() : *
      {
         stop();
      }
   }
}

