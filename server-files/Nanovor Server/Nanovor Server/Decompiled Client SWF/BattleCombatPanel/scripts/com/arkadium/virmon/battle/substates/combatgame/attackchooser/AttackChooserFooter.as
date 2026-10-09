package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.SoundClip;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol92")]
   public class AttackChooserFooter extends Sprite
   {
      
      public static const TIMER_HIT_ZERO:String = "getReadyToRumble";
      
      private var _tickSoundClip:SoundClip;
      
      private var _timer:Timer;
      
      private var _secondsLeft:int;
      
      public var tfCounter:TextField;
      
      private var _startTime:int;
      
      public function AttackChooserFooter()
      {
         super();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AttackChooserFooter: " + param1);
      }
      
      private function secondsToTimeFormat(param1:int) : String
      {
         var _loc2_:String = String("0" + int(param1 / 60)).substr(-2);
         var _loc3_:String = String("0" + param1 % 60).substr(-2);
         return _loc2_ + ":" + _loc3_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** AttackChooserFooter: " + param1);
      }
      
      public function pauseTimer() : void
      {
         if(!_timer)
         {
            return;
         }
         _timer.stop();
      }
      
      public function startTimer() : void
      {
         if(!_timer)
         {
            return;
         }
         _timer.start();
      }
      
      public function initTimer(param1:int) : void
      {
         tfCounter.text = "--:--";
         if(param1 > 0)
         {
            tfCounter.textColor = 0;
            tfCounter.alpha = 1;
            _startTime = param1;
            _secondsLeft = _startTime;
            tfCounter.text = secondsToTimeFormat(_secondsLeft);
            _timer = new Timer(1000,_startTime);
            _timer.addEventListener(TimerEvent.TIMER,onTimer,false,0,true);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete,false,0,true);
            _tickSoundClip = Managers.soundManager.attachSoundInLibrary("UI_Attack_AttackClockLp",SoundManagerConst.TYPE_FX,100,SoundManagerConst.soundApplicationDomain);
         }
      }
      
      public function stopTimer() : void
      {
         if(!_timer)
         {
            return;
         }
         if(Boolean(_tickSoundClip))
         {
            _tickSoundClip.stopSound();
            _tickSoundClip = null;
         }
         _timer.reset();
         _timer.removeEventListener(TimerEvent.TIMER,onTimer);
         _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --_secondsLeft;
         if(_secondsLeft == 10)
         {
            tfCounter.textColor = 16711680;
            if(Boolean(_tickSoundClip))
            {
               if(!_tickSoundClip.isPlaying)
               {
                  _tickSoundClip.playSound(-1,10);
               }
            }
         }
         tfCounter.text = secondsToTimeFormat(_secondsLeft);
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(Boolean(_tickSoundClip))
         {
            _tickSoundClip.stopSound();
            _tickSoundClip = null;
         }
         dispatchEvent(new Event(TIMER_HIT_ZERO));
      }
   }
}

