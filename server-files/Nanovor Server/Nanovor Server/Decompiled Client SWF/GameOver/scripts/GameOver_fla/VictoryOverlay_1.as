package GameOver_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class VictoryOverlay_1 extends MovieClip
   {
      
      public function VictoryOverlay_1()
      {
         super();
         addFrameScript(149,frame150);
      }
      
      internal function frame150() : *
      {
         stop();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

