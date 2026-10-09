package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.arkadium.virmon.shared.utils.*;
   import flash.display.*;
   
   public class ChipsetPane extends ArkMc
   {
      
      public var GrabberClip:MovieClip;
      
      public var ChipHolderClip:MovieClip;
      
      public var LaserClip:MovieClip;
      
      public function ChipsetPane()
      {
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
   }
}

