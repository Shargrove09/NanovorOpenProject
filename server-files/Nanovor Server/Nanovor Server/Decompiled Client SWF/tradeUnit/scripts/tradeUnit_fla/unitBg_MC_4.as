package tradeUnit_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol22")]
   public dynamic class unitBg_MC_4 extends MovieClip
   {
      
      public var _stfName:TextField;
      
      public var _stfNick:TextField;
      
      public var _stfParams:TextField;
      
      public var _stfMarketValue:TextField;
      
      public function unitBg_MC_4()
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

