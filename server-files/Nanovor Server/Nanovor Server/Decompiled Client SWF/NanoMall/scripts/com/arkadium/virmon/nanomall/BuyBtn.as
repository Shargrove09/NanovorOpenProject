package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.shared.utils.Utils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol152")]
   public class BuyBtn extends MovieClip
   {
      
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
         this.mcGlow.gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("BUYBTN_CLICK"));
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.CLICK,onClick);
         Utils.clearAllChildren(this);
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

