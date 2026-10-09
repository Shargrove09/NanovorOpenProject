package com.arkadium.virmon.help.attackchooser.attackselect
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.substates.combatgame.attackchooser.IActionPickerAutomation;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpAttackChooserAttackSelect extends MovieClip
   {
      
      public static const ALERT_X:int = 150;
      
      public static const ALERT_Y:int = 150;
      
      public static const ACTION_TEXT_X:int = 285;
      
      public static const ACTION_TEXT_Y:int = 135;
      
      public static const ACTION_TEXT:String = "Click on an attack to see what it will do to the target.";
      
      private var _actionPicker:IActionPickerAutomation;
      
      private var _attackSlotCount:int;
      
      private var _attackHideCount:int = 0;
      
      private var _attackRevealTimer:Timer;
      
      private var _attackRevealCount:int = 0;
      
      private var _actionText:EuroStileBoldExtended2Text;
      
      private var _bg:HelpAttackChooserAttackSelectBG;
      
      private var _startTimer:Timer;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      public function HelpAttackChooserAttackSelect(param1:IActionPickerAutomation)
      {
         super();
         _actionPicker = param1;
         setBG();
         setAlertSpinner();
         setActionText();
      }
      
      private function setActionText() : void
      {
         _actionText = new EuroStileBoldExtended2Text(ACTION_TEXT,18,16777215);
         addChild(_actionText);
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionText.filters = _loc1_;
         _actionText.x = ACTION_TEXT_X;
         _actionText.y = ACTION_TEXT_Y;
         _actionText.alpha = 0;
      }
      
      private function startHelp(param1:TimerEvent) : void
      {
         _startTimer.removeEventListener(TimerEvent.TIMER,startHelp);
         Tweener.addTween(_bg,{
            "alpha":0.8,
            "time":1,
            "transition":"linear"
         });
         startActionText();
         _alertSpinner.start(100);
      }
      
      private function revealNextAttack(param1:TimerEvent) : void
      {
         if(_attackRevealCount < _attackSlotCount)
         {
            _actionPicker.autoSlotRollOver(_attackRevealCount);
         }
         ++_attackRevealCount;
         if(_attackRevealCount > 1)
         {
            hideLastAttack();
         }
         if(_attackRevealCount == _attackSlotCount + 1)
         {
            Tweener.addTween(_bg["mcCutOut" + _attackRevealCount],{
               "alpha":0,
               "time":0.5,
               "transition":"linear",
               "onComplete":hideLastAttack
            });
            endHelp(1);
         }
         else
         {
            Tweener.addTween(_bg["mcCutOut" + _attackRevealCount],{
               "alpha":0,
               "time":0.5,
               "transition":"linear"
            });
         }
      }
      
      private function startAttackReveals() : void
      {
         _attackSlotCount = _actionPicker.getSlotCount();
         revealNextAttack(null);
         _attackRevealTimer = new Timer(1500,_attackSlotCount);
         _attackRevealTimer.addEventListener(TimerEvent.TIMER,revealNextAttack);
         _attackRevealTimer.start();
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionText,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear",
            "onComplete":hideActionText
         });
      }
      
      private function endHelp(param1:Number) : void
      {
         Tweener.addTween(_bg,{
            "alpha":0,
            "time":1,
            "delay":param1,
            "transition":"linear"
         });
      }
      
      private function setAlertSpinner() : void
      {
         _alertSpinner = new HelpAlertSpinner();
         addChild(_alertSpinner);
         _alertSpinner.x = ALERT_X;
         _alertSpinner.y = ALERT_Y;
      }
      
      private function hideLastAttack() : void
      {
         if(_attackHideCount < _attackSlotCount)
         {
            _actionPicker.autoSlotRollOut(_attackHideCount);
         }
         ++_attackHideCount;
         Tweener.addTween(_bg["mcCutOut" + _attackHideCount],{
            "alpha":1,
            "time":0.5,
            "transition":"linear"
         });
      }
      
      private function hideActionText() : void
      {
         Tweener.addTween(_actionText,{
            "alpha":0,
            "delay":3,
            "time":0.5,
            "transition":"linear",
            "onComplete":startAttackReveals
         });
      }
      
      private function setBG() : void
      {
         _bg = new HelpAttackChooserAttackSelectBG();
         addChild(_bg);
         _bg.alpha = 0;
      }
      
      public function start(param1:int = 0) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startHelp);
         _startTimer.start();
      }
      
      public function destroy() : void
      {
         if(Boolean(_alertSpinner))
         {
            _alertSpinner.destroy();
         }
         if(Boolean(_startTimer))
         {
            _startTimer.stop();
            _startTimer.removeEventListener(TimerEvent.TIMER,startHelp);
            _startTimer = null;
         }
         if(Boolean(_attackRevealTimer))
         {
            _attackRevealTimer.stop();
            _attackRevealTimer.removeEventListener(TimerEvent.TIMER,revealNextAttack);
            _attackRevealTimer = null;
         }
      }
   }
}

