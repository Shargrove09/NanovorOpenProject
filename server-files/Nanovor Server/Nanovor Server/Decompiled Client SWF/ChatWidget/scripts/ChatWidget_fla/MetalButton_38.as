package ChatWidget_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol144")]
   public dynamic class MetalButton_38 extends MovieClip
   {
      
      public var btnToggle:SimpleButton;
      
      public function MetalButton_38()
      {
         super();
         addFrameScript(0,this.frame1,16,this.frame17,34,this.frame35);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame17() : *
      {
         stop();
      }
      
      internal function frame35() : *
      {
         gotoAndStop(1);
      }
   }
}

