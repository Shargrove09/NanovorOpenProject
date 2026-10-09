package ProfileManagerUI_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol78")]
   public dynamic class re_58 extends MovieClip
   {
      
      public var keepPlaying:Boolean;
      
      public function re_58()
      {
         super();
         addFrameScript(0,frame1,8,frame9,21,frame22);
      }
      
      internal function frame1() : *
      {
         keepPlaying = false;
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame22() : *
      {
         if(keepPlaying)
         {
            gotoAndPlay("on");
         }
         else
         {
            gotoAndPlay("off");
         }
      }
   }
}

