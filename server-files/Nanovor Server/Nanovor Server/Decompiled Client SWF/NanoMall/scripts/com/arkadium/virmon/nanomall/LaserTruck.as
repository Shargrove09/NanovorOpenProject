package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol202")]
   public class LaserTruck extends MovieClip
   {
      
      public function LaserTruck()
      {
         super();
         addFrameScript(0,frame1,23,frame24,155,frame156,221,frame222);
      }
      
      internal function frame222() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame156() : *
      {
         dispatchEvent(new Event("LIGHTNING_ZAP"));
      }
      
      internal function frame24() : *
      {
         stop();
      }
   }
}

