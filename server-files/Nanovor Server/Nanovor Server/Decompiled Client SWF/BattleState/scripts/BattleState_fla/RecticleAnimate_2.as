package BattleState_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public dynamic class RecticleAnimate_2 extends MovieClip
   {
      
      public var mcRecticle:MovieClip;
      
      public function RecticleAnimate_2()
      {
         super();
         addFrameScript(69,frame70);
      }
      
      internal function frame70() : *
      {
         gotoAndPlay(6);
      }
   }
}

