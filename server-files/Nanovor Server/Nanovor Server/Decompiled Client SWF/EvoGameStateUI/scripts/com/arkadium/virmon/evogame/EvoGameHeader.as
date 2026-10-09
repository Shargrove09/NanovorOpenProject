package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol593")]
   public class EvoGameHeader extends MovieClip
   {
      
      private const STEAM_MIN_INTERVAL:int = 5;
      
      private var _rightTimer:Timer;
      
      public var smokeRight:MovieClip;
      
      private const STEAM_RANDOM_INTERVAL:int = 10;
      
      public var damaged:MovieClip;
      
      public var smokeLeft:MovieClip;
      
      private var _leftTimer:Timer;
      
      public function EvoGameHeader()
      {
         super();
         startLeft();
         startRight();
         mouseEnabled = false;
         mouseChildren = false;
         damaged.stop();
      }
      
      private function fireRight(param1:Event) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"SteamJet" + Math.round(1 + Math.random()),true,SoundManagerConst.soundApplicationDomain));
         smokeRight.gotoAndPlay(2);
         clearRight();
         startRight();
      }
      
      public function destroy() : void
      {
         clearLeft();
         clearRight();
      }
      
      private function startLeft() : void
      {
         _leftTimer = new Timer((STEAM_MIN_INTERVAL + Math.random() * STEAM_RANDOM_INTERVAL) * 1000);
         _leftTimer.addEventListener(TimerEvent.TIMER,fireLeft,false,0,true);
         _leftTimer.start();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoGameHeader>>\t" + param1);
      }
      
      private function clearRight() : void
      {
         if(_rightTimer != null)
         {
            _rightTimer.stop();
            _rightTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,fireRight);
         }
         _rightTimer = null;
      }
      
      private function clearLeft() : void
      {
         if(_leftTimer != null)
         {
            _leftTimer.stop();
            _leftTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,fireLeft);
         }
         _leftTimer = null;
      }
      
      public function showDamage() : void
      {
         damaged.gotoAndPlay(2);
         clearLeft();
         clearRight();
      }
      
      private function startRight() : void
      {
         _rightTimer = new Timer((STEAM_MIN_INTERVAL + Math.random() * STEAM_RANDOM_INTERVAL) * 1000);
         _rightTimer.addEventListener(TimerEvent.TIMER,fireRight,false,0,true);
         _rightTimer.start();
      }
      
      private function fireLeft(param1:Event) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"SteamJet" + Math.round(1 + Math.random()),true,SoundManagerConst.soundApplicationDomain));
         smokeLeft.gotoAndPlay(2);
         clearLeft();
         startLeft();
      }
   }
}

