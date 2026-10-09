package com.arkadium.virmon.shared.elements.quicktips
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol16")]
   public class QuickTipExitBtn extends MovieClip
   {
      
      public function QuickTipExitBtn()
      {
         super();
         addFrameScript(43,frame44,111,frame112,149,frame150);
         buttonMode = true;
         mouseEnabled = true;
         useHandCursor = true;
         addEventListener(MouseEvent.ROLL_OVER,onMouseOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,onMouseOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onMouseClick,false,0,true);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("CLOSE_QUICKTIPS",true,false));
      }
      
      internal function frame112() : *
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
      
      internal function frame44() : *
      {
         stop();
      }
      
      internal function frame150() : *
      {
         gotoAndPlay("up");
      }
   }
}

