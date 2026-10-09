package Tutorial_Trade_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var btn_s1:SimpleButton;
      
      public var btn_s3:SimpleButton;
      
      public var btn_s5:SimpleButton;
      
      public var btn_s2:SimpleButton;
      
      public var btn_s4:SimpleButton;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,15,frame16,454,frame455,1069,frame1070,1256,frame1257,1448,frame1449,1698,frame1699);
      }
      
      internal function frame455() : *
      {
         stop();
      }
      
      internal function frame1070() : *
      {
         stop();
      }
      
      internal function frame1257() : *
      {
         stop();
      }
      
      public function onBtnClick(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         gotoAndPlay(String(_loc2_[1]));
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame1699() : *
      {
         stop();
      }
      
      internal function frame1449() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
   }
}

