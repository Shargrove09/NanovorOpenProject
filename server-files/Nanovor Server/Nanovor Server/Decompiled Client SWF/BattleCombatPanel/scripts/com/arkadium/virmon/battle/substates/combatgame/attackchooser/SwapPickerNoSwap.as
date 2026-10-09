package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol51")]
   public class SwapPickerNoSwap extends Sprite
   {
      
      public var mcChaser:MovieClip;
      
      private var _bChaserPlaying:Boolean = true;
      
      private var _tmrAttentionIn:Timer;
      
      private var _tmrAttentionOut:Timer;
      
      public var mcIcon:MovieClip;
      
      public var mcHit:MovieClip;
      
      public function SwapPickerNoSwap()
      {
         super();
         stopAttention();
      }
      
      private function startAttentionOutTimer(param1:int) : void
      {
         clearAttentionInTimer();
         clearAttentionOutTimer();
         _tmrAttentionOut = new Timer(param1,1);
         _tmrAttentionOut.addEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerOutComplete,false,0,true);
         _tmrAttentionOut.start();
      }
      
      public function startAttentionInTimer(param1:int) : void
      {
         clearAttentionInTimer();
         clearAttentionOutTimer();
         _tmrAttentionIn = new Timer(param1,1);
         _tmrAttentionIn.addEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerInComplete,false,0,true);
         _tmrAttentionIn.start();
      }
      
      public function clearAttentionOutTimer() : void
      {
         if(Boolean(_tmrAttentionOut))
         {
            _tmrAttentionOut.removeEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerOutComplete);
            _tmrAttentionOut.stop();
            _tmrAttentionOut = null;
         }
      }
      
      private function onAttentionTimerInComplete(param1:TimerEvent) : void
      {
         clearAttentionInTimer();
         playAttention();
         startAttentionOutTimer(950);
      }
      
      private function onAttentionTimerOutComplete(param1:TimerEvent) : void
      {
         clearAttentionOutTimer();
         stopAttention();
      }
      
      public function playAttention(param1:Boolean = false) : void
      {
         if(!param1 && _bChaserPlaying)
         {
            return;
         }
         _bChaserPlaying = true;
         Tweener.removeTweens(mcIcon);
         Tweener.addTween(mcIcon,{
            "_DropShadow_strength":1.8,
            "time":0.2,
            "transition":"easeOutQuad"
         });
         mcChaser.visible = true;
         mcChaser.gotoAndPlay(1);
      }
      
      public function clearAttentionInTimer() : void
      {
         if(Boolean(_tmrAttentionIn))
         {
            _tmrAttentionIn.removeEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerInComplete);
            _tmrAttentionIn.stop();
            _tmrAttentionIn = null;
         }
      }
      
      public function stopAttention() : void
      {
         if(!_bChaserPlaying)
         {
            return;
         }
         _bChaserPlaying = false;
         Tweener.removeTweens(mcIcon);
         Tweener.addTween(mcIcon,{
            "_DropShadow_strength":0.4,
            "time":0.2,
            "transition":"easeOutQuad"
         });
         mcChaser.visible = false;
         mcChaser.gotoAndStop(1);
      }
   }
}

