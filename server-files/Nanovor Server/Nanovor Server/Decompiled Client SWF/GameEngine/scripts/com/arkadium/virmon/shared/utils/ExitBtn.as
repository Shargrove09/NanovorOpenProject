package com.arkadium.virmon.shared.utils
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public class ExitBtn extends MovieClip
   {
      
      public var mcHA:MovieClip;
      
      public function ExitBtn()
      {
         super();
         addFrameScript(7,frame8,14,frame15,22,frame23,61,frame62);
         mcHA.useHandCursor = true;
         mcHA.buttonMode = true;
         mcHA.mouseChildren = false;
         mcHA.addEventListener(MouseEvent.MOUSE_OVER,onOver);
         mcHA.addEventListener(MouseEvent.MOUSE_OUT,onOut);
         mcHA.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
         mcHA.addEventListener(MouseEvent.CLICK,onClick);
      }
      
      internal function frame62() : *
      {
         gotoAndPlay("attention");
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         gotoAndPlay("down");
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
      
      internal function frame23() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         stop();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("EXITBTN_CLICK"));
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         gotoAndPlay("up");
      }
   }
}

