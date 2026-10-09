package ProfileManagerUI_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol46")]
   public dynamic class ExitBtn_mc_53 extends MovieClip
   {
      
      public var btnHit:SimpleButton;
      
      public function ExitBtn_mc_53()
      {
         super();
         addFrameScript(7,frame8,14,frame15,22,frame23,61,frame62);
      }
      
      internal function frame15() : *
      {
         stop();
      }
      
      internal function frame62() : *
      {
         gotoAndPlay("attention");
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         stop();
      }
   }
}

