package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol256")]
   public class Portal extends MovieClip
   {
      
      public var mcDropArea:MovieClip;
      
      public function Portal()
      {
         super();
         addFrameScript(0,frame1,19,frame20,25,frame26,40,frame41);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      internal function frame26() : *
      {
         mcDropArea.gotoAndStop(1);
      }
      
      public function close() : void
      {
         gotoAndPlay("close");
      }
      
      private function onOpen() : void
      {
         dispatchEvent(new Event("PORTAL_OPENED",true));
      }
      
      public function open() : void
      {
         gotoAndPlay("open");
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame41() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
         this.onOpen();
      }
   }
}

