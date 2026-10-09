package emUnit_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol23")]
   public dynamic class Base_4 extends MovieClip
   {
      
      public var _stfNum:TextField;
      
      public var _stfShortName:TextField;
      
      public var _stfLongName:TextField;
      
      public var _stfMarketValue:TextField;
      
      public var _stfName:TextField;
      
      public var _stfRary:TextField;
      
      public var _stfWave:TextField;
      
      public function Base_4()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

