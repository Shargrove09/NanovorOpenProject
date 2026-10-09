package Tutorial_GenerateSwarm_fla
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
      
      public var btn_s2:SimpleButton;
      
      public var btn_s3:SimpleButton;
      
      public var btn_s4:SimpleButton;
      
      public var btn_s5:SimpleButton;
      
      public var btn_s6:SimpleButton;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,82,frame83,559,frame560,567,frame568,1647,frame1648,1654,frame1655,2478,frame2479,2486,frame2487,3508,frame3509,3516,frame3517,3954,frame3955,3963,frame3964,4373,frame4374,4381,frame4382,5053,frame5054);
      }
      
      internal function frame4374() : *
      {
         stop();
      }
      
      public function onBtnClick(param1:Event) : void
      {
         var _loc2_:Array = String(param1.target.name).split("_");
         gotoAndPlay(String(_loc2_[1]));
      }
      
      internal function frame3964() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1648() : *
      {
         stop();
      }
      
      internal function frame2479() : *
      {
         stop();
      }
      
      internal function frame3509() : *
      {
         stop();
      }
      
      internal function frame5054() : *
      {
         stop();
      }
      
      internal function frame83() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame560() : *
      {
         stop();
      }
      
      internal function frame568() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame4382() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame2487() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame1655() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
      
      internal function frame3955() : *
      {
         stop();
      }
      
      internal function frame3517() : *
      {
         btn_s1.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s2.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s3.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s4.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s5.addEventListener(MouseEvent.CLICK,onBtnClick);
         btn_s6.addEventListener(MouseEvent.CLICK,onBtnClick);
      }
   }
}

