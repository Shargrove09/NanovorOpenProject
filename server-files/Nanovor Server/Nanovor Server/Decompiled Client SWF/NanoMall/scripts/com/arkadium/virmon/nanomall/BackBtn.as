package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol293")]
   public class BackBtn extends MovieClip
   {
      
      private var bDisabled:Boolean = false;
      
      public function BackBtn()
      {
         super();
         addFrameScript(7,frame8,14,frame15,22,frame23,61,frame62);
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("down");
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("over");
         }
      }
      
      public function enable() : void
      {
         bDisabled = false;
         useHandCursor = true;
      }
      
      public function disable() : void
      {
         bDisabled = true;
         gotoAndPlay("up");
         useHandCursor = false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("over");
            dispatchEvent(new Event("BACK_TO_WAVELIST",true));
         }
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         stop();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("up");
         }
      }
      
      internal function frame62() : *
      {
         gotoAndPlay("attention");
      }
      
      internal function frame15() : *
      {
         stop();
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
         removeEventListener(MouseEvent.CLICK,onClick);
      }
   }
}

