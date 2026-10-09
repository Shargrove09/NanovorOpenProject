package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ReadyForBattleSpinner extends MovieClip
   {
      
      public function ReadyForBattleSpinner()
      {
         super();
         addEventListener(Event.ENTER_FRAME,hackStopOnLastFrame,false,0,true);
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

