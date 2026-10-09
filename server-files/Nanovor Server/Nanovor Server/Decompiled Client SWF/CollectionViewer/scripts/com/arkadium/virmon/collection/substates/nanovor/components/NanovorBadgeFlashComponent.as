package com.arkadium.virmon.collection.substates.nanovor.components
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol9")]
   public class NanovorBadgeFlashComponent extends MovieClip
   {
      
      public static const LABEL_OPEN:String = "opening";
      
      public static const LABEL_CLOSE:String = "closing";
      
      public function NanovorBadgeFlashComponent()
      {
         super();
         addFrameScript(0,frame1,7,frame8,15,frame16);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function close() : void
      {
         this.gotoAndPlay(LABEL_CLOSE);
      }
      
      internal function frame16() : *
      {
         stop();
      }
      
      public function open() : void
      {
         this.gotoAndPlay(LABEL_OPEN);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         stop();
      }
   }
}

