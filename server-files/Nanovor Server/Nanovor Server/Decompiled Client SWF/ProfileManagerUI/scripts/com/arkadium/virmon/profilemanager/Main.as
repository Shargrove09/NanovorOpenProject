package com.arkadium.virmon.profilemanager
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol319")]
   public class Main extends MovieClip
   {
      
      public var _smcGUIManager:ProfileGUIManager;
      
      public function Main()
      {
         super();
         onInitialize();
      }
      
      public function onInitialize() : *
      {
         _smcGUIManager.onInitialize();
      }
   }
}

