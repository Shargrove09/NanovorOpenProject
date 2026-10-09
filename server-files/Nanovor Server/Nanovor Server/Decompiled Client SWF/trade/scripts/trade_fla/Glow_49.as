package trade_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol122")]
   public dynamic class Glow_49 extends MovieClip
   {
      
      public function Glow_49()
      {
         super();
         addFrameScript(5,frame6,30,frame31);
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame31() : *
      {
         gotoAndPlay("on");
      }
   }
}

