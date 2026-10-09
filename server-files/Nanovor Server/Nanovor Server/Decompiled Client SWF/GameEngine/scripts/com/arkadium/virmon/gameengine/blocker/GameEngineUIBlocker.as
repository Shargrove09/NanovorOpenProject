package com.arkadium.virmon.gameengine.blocker
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class GameEngineUIBlocker extends Sprite
   {
      
      public function GameEngineUIBlocker(param1:IEventDispatcher, param2:int, param3:int)
      {
         super();
         param1.addEventListener("SHOW_BLOCKER",showBlocker,false,0,true);
         param1.addEventListener("HIDE_BLOCKER",hideBlocker,false,0,true);
         createBlocker(param2,param3);
         hideBlocker(null);
      }
      
      private function hideBlocker(param1:Event) : void
      {
         this.visible = false;
      }
      
      private function showBlocker(param1:Event) : void
      {
         this.visible = true;
      }
      
      private function createBlocker(param1:int, param2:int) : void
      {
         this.graphics.beginFill(16711680,0);
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
      }
   }
}

