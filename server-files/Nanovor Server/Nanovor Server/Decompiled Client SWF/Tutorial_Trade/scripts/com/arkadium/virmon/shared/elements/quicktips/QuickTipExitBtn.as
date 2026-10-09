package com.arkadium.virmon.shared.elements.quicktips
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8")]
   public class QuickTipExitBtn extends MovieClip
   {
      
      public var mcHA:MovieClip;
      
      public function QuickTipExitBtn()
      {
         super();
         addFrameScript(3,frame4,6,frame7,9,frame10);
         buttonMode = true;
         mouseEnabled = true;
         useHandCursor = true;
         addEventListener(MouseEvent.ROLL_OVER,onMouseOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,onMouseOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onMouseClick,false,0,true);
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("CLOSE_QUICKTIPS",true,false));
      }
      
      internal function frame4() : *
      {
         stop();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         gotoAndPlay("out");
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
      
      internal function frame10() : *
      {
         gotoAndPlay("up");
      }
   }
}

