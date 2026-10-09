package com.arkadium.virmon.help.common
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol60")]
   public class HelpTreeTileOutline extends MovieClip
   {
      
      private var timedROTimer:Timer;
      
      public function HelpTreeTileOutline()
      {
         super();
         stop();
      }
      
      private function stopTimedRollOver(param1:TimerEvent) : void
      {
         timedROTimer.stop();
         timedROTimer.removeEventListener(TimerEvent.TIMER,stopTimedRollOver);
         this.gotoAndStop(1);
      }
      
      public function startTimedRollOver(param1:int) : void
      {
         this.gotoAndStop(2);
         if(!timedROTimer)
         {
            timedROTimer = new Timer(param1,1);
         }
         timedROTimer.addEventListener(TimerEvent.TIMER,stopTimedRollOver);
         timedROTimer.start();
      }
   }
}

