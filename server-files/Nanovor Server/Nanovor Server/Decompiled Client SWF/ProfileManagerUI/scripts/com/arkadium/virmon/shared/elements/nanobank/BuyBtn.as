package com.arkadium.virmon.shared.elements.nanobank
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuyBtn extends MovieClip
   {
      
      public static const EVENT_CLICK:String = "nanoBankBuyBtnClickEvent";
      
      public var mcGlow:MovieClip;
      
      public function BuyBtn()
      {
         super();
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         mcGlow.gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_CLICK));
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.CLICK,onClick);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         mcGlow.gotoAndPlay("over");
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         mcGlow.gotoAndStop(1);
      }
   }
}

