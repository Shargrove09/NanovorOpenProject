package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol87")]
   public class ReadyForBattleSpinner extends MovieClip
   {
      
      public function ReadyForBattleSpinner()
      {
         super();
         addFrameScript(62,frame63);
         addEventListener(Event.ENTER_FRAME,hackStopOnLastFrame,false,0,true);
      }
      
      internal function frame63() : *
      {
         stop();
      }
      
      private function hackStopOnLastFrame(param1:Event) : void
      {
         if(currentFrame == totalFrames)
         {
            stop();
            removeEventListener(Event.ENTER_FRAME,hackStopOnLastFrame);
         }
      }
   }
}

