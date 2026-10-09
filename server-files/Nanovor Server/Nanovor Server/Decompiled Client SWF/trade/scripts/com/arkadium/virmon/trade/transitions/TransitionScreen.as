package com.arkadium.virmon.trade.transitions
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol246")]
   public class TransitionScreen extends MovieClip
   {
      
      public static var PANEL_CLOSE:String = "panel_close";
      
      public var _mcTopPanel:MovieClip;
      
      public function TransitionScreen()
      {
         super();
         addFrameScript(33,frame34,55,frame56);
      }
      
      internal function frame56() : *
      {
         stop();
      }
      
      private function onCloseTrade(param1:Event) : void
      {
         if(currentLabel == "end")
         {
            _mcTopPanel.stop();
            _mcTopPanel = null;
            stop();
            removeEventListener(Event.ENTER_FRAME,onCloseTrade);
            dispatchEvent(new Event(PANEL_CLOSE));
         }
      }
      
      internal function frame34() : *
      {
         stop();
      }
      
      public function close() : void
      {
         _mcTopPanel.gotoAndPlay("close");
         gotoAndPlay("close");
         addEventListener(Event.ENTER_FRAME,onCloseTrade,false,0,true);
      }
   }
}

