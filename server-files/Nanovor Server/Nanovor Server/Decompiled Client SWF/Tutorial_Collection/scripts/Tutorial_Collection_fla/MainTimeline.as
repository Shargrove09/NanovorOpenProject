package Tutorial_Collection_fla
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
         addFrameScript(0,frame1,79,frame80,562,frame563,1133,frame1134,1136,frame1137,1285,frame1286,1288,frame1289,1612,frame1613,1615,frame1616,1696,frame1697,1700,frame1701,1803,frame1804);
      }
      
      internal function frame80() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1701() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1134() : *
      {
         stop();
      }
      
      internal function frame1289() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1697() : *
      {
         stop();
      }
      
      internal function frame1137() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      public function onBtnClick(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         gotoAndPlay(String(_loc2_[1]));
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame563() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1613() : *
      {
         stop();
      }
      
      internal function frame1616() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1804() : *
      {
         stop();
      }
      
      internal function frame1286() : *
      {
         stop();
      }
   }
}

