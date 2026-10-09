package Tutorial_MyProfile_fla
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
      
      public var btn_s6:SimpleButton;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,15,frame16,393,frame394,681,frame682,904,frame905,1097,frame1098,1238,frame1239,1465,frame1466);
      }
      
      internal function frame394() : *
      {
         stop();
      }
      
      internal function frame905() : *
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
      
      internal function frame1239() : *
      {
         stop();
      }
      
      internal function frame1466() : *
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
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1098() : *
      {
         stop();
      }
      
      internal function frame682() : *
      {
         stop();
      }
   }
}

