package Tutorial_EvolutionGame_fla
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
      
      public var connector2:MovieClip;
      
      public var connector3:MovieClip;
      
      public var connector4:MovieClip;
      
      public var connector6:MovieClip;
      
      public var connector1:MovieClip;
      
      public var connector5:MovieClip;
      
      public var circuitflow:MovieClip;
      
      public var btn_s1:SimpleButton;
      
      public var btn_s2:SimpleButton;
      
      public var btn_s3:SimpleButton;
      
      public var btn_s4:SimpleButton;
      
      public var btn_s5:SimpleButton;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1,17,frame18,561,frame562,796,frame797,1127,frame1128,2148,frame2149,2384,frame2385);
      }
      
      internal function frame1128() : *
      {
         stop();
      }
      
      internal function frame18() : *
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
      
      internal function frame797() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame2149() : *
      {
         stop();
      }
      
      internal function frame2385() : *
      {
         stop();
      }
      
      internal function frame562() : *
      {
         stop();
      }
   }
}

