package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol324")]
   public class News extends MovieClip
   {
      
      public function News()
      {
         super();
         addFrameScript(0,frame1,16,frame17,33,frame34);
      }
      
      public function open() : void
      {
         gotoAndPlay("open");
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame17() : *
      {
         stop();
      }
      
      internal function frame34() : *
      {
         stop();
      }
   }
}

