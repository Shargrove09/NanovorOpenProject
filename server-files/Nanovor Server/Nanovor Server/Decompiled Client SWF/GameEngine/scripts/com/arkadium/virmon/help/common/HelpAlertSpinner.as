package com.arkadium.virmon.help.common
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HelpAlertSpinner extends MovieClip
   {
      
      public var mcTarget:MovieClip;
      
      private var _startTimer:Timer;
      
      public function HelpAlertSpinner()
      {
         super();
         mcTarget.stop();
         visible = false;
      }
      
      public function start(param1:int) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startSpinner);
         _startTimer.start();
      }
      
      private function startSpinner(param1:TimerEvent) : void
      {
         _startTimer.removeEventListener(TimerEvent.TIMER,startSpinner);
         visible = true;
         mcTarget.play();
      }
      
      public function destroy() : void
      {
         if(Boolean(_startTimer))
         {
            _startTimer.stop();
            _startTimer.removeEventListener(TimerEvent.TIMER,startSpinner);
            _startTimer = null;
         }
      }
   }
}

