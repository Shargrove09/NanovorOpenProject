package NanoBank_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5")]
   public dynamic class mcGlow_2 extends MovieClip
   {
      
      public function mcGlow_2()
      {
         super();
         addFrameScript(24,this.frame25);
      }
      
      internal function frame25() : *
      {
         gotoAndPlay("over");
      }
   }
}

