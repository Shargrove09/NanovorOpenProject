package Tutorial_DeviceManager_fla
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
      
      public var btn_s2:SimpleButton;
      
      public var btn_s4:SimpleButton;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,77,frame78,562,frame563,711,frame712,714,frame715,1052,frame1053,1055,frame1056,1213,frame1214,1216,frame1217,1279,frame1280);
      }
      
      internal function frame563() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1053() : *
      {
         stop();
      }
      
      public function onBtnClick(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         gotoAndPlay(String(_loc2_[1]));
      }
      
      internal function frame1056() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame78() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1214() : *
      {
         stop();
      }
      
      internal function frame712() : *
      {
         stop();
      }
      
      internal function frame1217() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame715() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame1280() : *
      {
         stop();
      }
   }
}

