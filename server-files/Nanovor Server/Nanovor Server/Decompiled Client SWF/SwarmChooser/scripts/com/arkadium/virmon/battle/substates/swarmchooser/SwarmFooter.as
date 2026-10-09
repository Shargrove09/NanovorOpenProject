package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.soundmanager.SoundClip;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol102")]
   public class SwarmFooter extends MovieClip
   {
      
      private var _tickSoundClip:SoundClip;
      
      private var timer:Timer;
      
      private var secondsLeft:int;
      
      public var btnRedButton:SimpleButton;
      
      public var tfCounter:TextField;
      
      private var startTime:int;
      
      public function SwarmFooter()
      {
         super();
         btnRedButton.addEventListener(MouseEvent.CLICK,onStartBattleClick,false,0,true);
      }
      
      private function secondsToTimeFormat(param1:int) : String
      {
         var _loc2_:String = Utils.zeroPreFill(int(param1 / 60),2);
         var _loc3_:String = Utils.zeroPreFill(param1 % 60,2);
         return _loc2_ + ":" + _loc3_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SwarmChooser/SwarmFooter: " + param1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         --secondsLeft;
         if(secondsLeft == 10)
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
         tfCounter.text = secondsToTimeFormat(secondsLeft);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** SwarmChooser/SwarmFooter: " + param1);
      }
      
      public function startTimer() : void
      {
         if(null != timer)
         {
            timer.start();
         }
      }
      
      public function initTimer(param1:int) : void
      {
         startTime = param1;
         tfCounter.text = "--:--";
         if(startTime > 0)
         {
            secondsLeft = startTime;
            tfCounter.text = secondsToTimeFormat(secondsLeft);
            timer = new Timer(1000,startTime);
            timer.addEventListener(TimerEvent.TIMER,onTimer);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
            _tickSoundClip = Managers.soundManager.attachSoundInLibrary("UI_Attack_AttackClockLp",SoundManagerConst.TYPE_FX,100,SoundManagerConst.soundApplicationDomain);
         }
      }
      
      public function pauseTimer() : void
      {
         if(null != timer)
         {
            timer.stop();
         }
      }
      
      public function destroy() : void
      {
         if(null != timer)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
            timer = null;
         }
         btnRedButton.removeEventListener(MouseEvent.CLICK,onStartBattleClick);
      }
      
      public function stopTimer() : void
      {
         if(Boolean(_tickSoundClip))
         {
            _tickSoundClip.stopSound();
            _tickSoundClip = null;
         }
         if(null != timer)
         {
            timer.reset();
            tfCounter.text = "00:00";
            timer.removeEventListener(TimerEvent.TIMER,onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
         }
      }
      
      private function onStartBattleClick(param1:MouseEvent) : void
      {
         dispatchEvent(new SwarmFooterEvent(SwarmFooterEvent.STARTBATTLE_CLICK));
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(Boolean(_tickSoundClip))
         {
            _tickSoundClip.stopSound();
            _tickSoundClip = null;
         }
         dispatchEvent(new SwarmFooterEvent(SwarmFooterEvent.TIMER_COMPLETE));
      }
   }
}

