package collectionUnit_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol21")]
   public dynamic class RollOverLights_8 extends MovieClip
   {
      
      public var lights:MovieClip;
      
      public function RollOverLights_8()
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

