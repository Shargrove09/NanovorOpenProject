package AvatarWidget_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol24")]
   public dynamic class SpinnerNameWire_16 extends MovieClip
   {
      
      public var tfTopTop:TextField;
      
      public var tfTop:TextField;
      
      public var mcWire:MovieClip;
      
      public var tfBottom:TextField;
      
      public function SpinnerNameWire_16()
      {
         super();
         addFrameScript(12,frame13);
      }
      
      internal function frame13() : *
      {
         stop();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

