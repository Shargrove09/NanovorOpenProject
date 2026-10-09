package emUnit_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var _mcHolder:MovieClip;
      
      public var _sbtUnit:SimpleButton;
      
      public var _smcUnitBg:MovieClip;
      
      public var _spContent:MovieClip;
      
      public var _mcCellBack:MovieClip;
      
      public function MainTimeline()
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

