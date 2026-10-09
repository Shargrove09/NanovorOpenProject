package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol207")]
   public class Clips extends MovieClip
   {
      
      public function Clips()
      {
         super();
         addFrameScript(0,frame1,4,frame5,13,frame14,22,frame23,38,frame39);
      }
      
      internal function frame14() : *
      {
         stop();
      }
      
      internal function frame39() : *
      {
         stop();
      }
      
      public function cock() : void
      {
         gotoAndPlay("cock");
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      public function zap() : void
      {
         gotoAndPlay("zap");
      }
      
      public function reinit() : void
      {
         gotoAndPlay("reinit");
      }
      
      public function lock() : void
      {
         gotoAndPlay("lock");
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         stop();
      }
      
      public function reset() : void
      {
         gotoAndStop(1);
      }
   }
}

