package Tutorial_Nanomall_fla
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
      
      public var txPrice:TextField;
      
      public var btn_s2:SimpleButton;
      
      public var btn_s4:SimpleButton;
      
      public var mcDropArea:MovieClip;
      
      public var mcBuyCancelBtn:MovieClip;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,15,frame16,314,frame315,675,frame676,990,frame991,1264,frame1265);
      }
      
      internal function frame315() : *
      {
         stop();
      }
      
      internal function frame1265() : *
      {
         stop();
      }
      
      internal function frame676() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame16() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      public function onBtnClick(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         gotoAndPlay(String(_loc2_[1]));
      }
      
      internal function frame991() : *
      {
         stop();
      }
   }
}

