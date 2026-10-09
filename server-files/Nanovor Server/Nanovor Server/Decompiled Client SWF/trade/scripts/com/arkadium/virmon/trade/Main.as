package com.arkadium.virmon.trade
{
   import com.arkadium.virmon.common.EventManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol278")]
   public class Main extends MovieClip
   {
      
      public var _smcGUIManager:TradeGUIManager;
      
      public function Main()
      {
         super();
         trace(" :: TRADE MAIN MADE! :: ");
         onInitialize();
      }
      
      private function clearAll(param1:Event) : void
      {
         EventManager.getInstance().removeEventListener("UNLOAD",clearAll);
         _smcGUIManager = null;
      }
      
      public function onInitialize() : *
      {
         EventManager.getInstance().addEventListener("UNLOAD",clearAll,false,0,true);
         _smcGUIManager.onInitialize();
      }
   }
}

