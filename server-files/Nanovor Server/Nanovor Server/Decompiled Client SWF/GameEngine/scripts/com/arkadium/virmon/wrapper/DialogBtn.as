package com.arkadium.virmon.wrapper
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol11")]
   public class DialogBtn extends MovieClip
   {
      
      public var txLabel:TextField;
      
      public function DialogBtn(param1:String = null)
      {
         super();
         addFrameScript(3,frame4,8,frame9);
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver);
         addEventListener(MouseEvent.MOUSE_OUT,onOut);
         addEventListener(MouseEvent.CLICK,onClick);
         txLabel.text = param1;
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         gotoAndPlay("over");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("DIALOGBTN_CLICK"));
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         gotoAndPlay("up");
      }
   }
}

