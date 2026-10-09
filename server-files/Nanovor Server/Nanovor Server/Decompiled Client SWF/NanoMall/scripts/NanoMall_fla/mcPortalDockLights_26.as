package NanoMall_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol232")]
   public dynamic class mcPortalDockLights_26 extends MovieClip
   {
      
      public function mcPortalDockLights_26()
      {
         super();
         addFrameScript(0,frame1,28,frame29,41,frame42);
      }
      
      internal function frame42() : *
      {
         gotoAndPlay("alt_strobe");
      }
      
      internal function frame29() : *
      {
         gotoAndPlay("cw_strobe");
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

