package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CollectionPanelUIBtn extends MovieClip
   {
      
      private var bDisabled:Boolean = false;
      
      public function CollectionPanelUIBtn()
      {
         super();
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      public function clearListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.CLICK,onClick);
      }
      
      public function enable() : void
      {
         bDisabled = false;
         useHandCursor = true;
      }
      
      public function disable() : void
      {
         bDisabled = true;
         useHandCursor = false;
         gotoAndPlay("up");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("over");
            dispatchEvent(new Event("BTN_CLICK"));
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("over");
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(!bDisabled)
         {
            gotoAndPlay("up");
         }
      }
   }
}

