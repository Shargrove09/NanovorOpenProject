package com.arkadium.virmon.battle.substates.gameover
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public class GameOverBadgeFlash extends MovieClip
   {
      
      public static const LABEL_OPEN:String = "opening";
      
      public static const LABEL_CLOSE:String = "closing";
      
      public function GameOverBadgeFlash()
      {
         super();
         addFrameScript(0,frame1,11,frame12,32,frame33);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function close() : void
      {
         this.gotoAndPlay(LABEL_CLOSE);
      }
      
      public function open() : void
      {
         this.gotoAndPlay(LABEL_OPEN);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame33() : *
      {
         stop();
         stop();
      }
      
      internal function frame12() : *
      {
         stop();
      }
   }
}

