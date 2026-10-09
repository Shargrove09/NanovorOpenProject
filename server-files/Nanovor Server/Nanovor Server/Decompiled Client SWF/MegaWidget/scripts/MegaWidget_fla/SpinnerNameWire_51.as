package MegaWidget_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol24")]
   public dynamic class SpinnerNameWire_51 extends MovieClip
   {
      
      public var tfTopTop:TextField;
      
      public var tfTop:TextField;
      
      public var mcWire:MovieClip;
      
      public var tfBottom:TextField;
      
      public function SpinnerNameWire_51()
      {
         super();
         addFrameScript(19,frame20);
      }
      
      internal function frame20() : *
      {
         stop();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

