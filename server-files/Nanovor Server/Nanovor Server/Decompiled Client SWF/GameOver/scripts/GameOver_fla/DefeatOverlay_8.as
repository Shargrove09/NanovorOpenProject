package GameOver_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol67")]
   public dynamic class DefeatOverlay_8 extends MovieClip
   {
      
      public function DefeatOverlay_8()
      {
         super();
         addFrameScript(94,frame95,150,frame151);
      }
      
      internal function frame151() : *
      {
         stop();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      internal function frame95() : *
      {
         dispatchEvent(new Event("WIPE_UP_START"));
      }
   }
}

