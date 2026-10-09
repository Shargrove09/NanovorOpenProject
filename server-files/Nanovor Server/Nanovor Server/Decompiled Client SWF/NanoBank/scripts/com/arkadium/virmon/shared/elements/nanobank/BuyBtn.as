package com.arkadium.virmon.shared.elements.nanobank
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8")]
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
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.mcGlow.gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_CLICK));
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.mcGlow.gotoAndPlay("over");
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.mcGlow.gotoAndStop(1);
      }
   }
}

