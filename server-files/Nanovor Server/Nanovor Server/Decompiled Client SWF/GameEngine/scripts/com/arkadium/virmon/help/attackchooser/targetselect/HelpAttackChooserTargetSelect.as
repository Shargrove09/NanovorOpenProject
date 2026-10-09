package com.arkadium.virmon.help.attackchooser.targetselect
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpAttackChooserTargetSelect extends MovieClip
   {
      
      public static const ALERT_X:int = 380;
      
      public static const ALERT_Y:int = 380;
      
      public static const ALERT_X_Self:int = 150;
      
      public static const ALERT_Y_Self:int = 450;
      
      public static const ACTION_TEXT_X:int = 440;
      
      public static const ACTION_TEXT_Y:int = 365;
      
      public static const ACTION_TEXT_X_Self:int = 260;
      
      public static const ACTION_TEXT_Y_Self:int = 440;
      
      public static const ACTION_TEXT:String = "Click on target you want to attack.";
      
      public static const ACTION_TEXT_Self:String = "Click on yourself.";
      
      private var _enemyCount:int;
      
      private var _enemyPickers:Array;
      
      private var _targetHideCount:int;
      
      private var _actionText:EuroStileBoldExtended2Text;
      
      private var _bg:HelpAttackChooserTargetSelectBG;
      
      private var _isSelfTarget:Boolean;
      
      private var _targetRevealTimer:Timer;
      
      private var _startTimer:Timer;
      
      private var _targetRevealCount:int;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      public function HelpAttackChooserTargetSelect(param1:Array, param2:Boolean)
      {
         super();
         _isSelfTarget = param2;
         _enemyPickers = param1;
         _enemyCount = param1.length;
         setBG();
         setAlertSpinner();
         setActionText();
      }
      
      private function startTargetReveals() : void
      {
         _targetRevealCount = 0;
         _targetHideCount = 0;
         _targetRevealTimer = new Timer(2000,_enemyCount + 1);
         _targetRevealTimer.addEventListener(TimerEvent.TIMER,revealNextTarget);
         _targetRevealTimer.start();
      }
      
      private function startHelp(param1:TimerEvent) : void
      {
         _startTimer.removeEventListener(TimerEvent.TIMER,startHelp);
         Tweener.addTween(_bg,{
            "alpha":0.8,
            "time":1,
            "transition":"linear",
            "onComplete":startActionText
         });
         _alertSpinner.start(100);
      }
      
      private function setActionText() : void
      {
         if(_isSelfTarget)
         {
            _actionText = new EuroStileBoldExtended2Text(ACTION_TEXT_Self,18,16777215);
            _actionText.x = ACTION_TEXT_X_Self;
            _actionText.y = ACTION_TEXT_Y_Self;
         }
         else
         {
            _actionText = new EuroStileBoldExtended2Text(ACTION_TEXT,18,16777215);
            _actionText.x = ACTION_TEXT_X;
            _actionText.y = ACTION_TEXT_Y;
         }
         addChild(_actionText);
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionText.filters = _loc1_;
         _actionText.alpha = 0;
      }
      
      private function revealNextTarget(param1:TimerEvent) : void
      {
         ++_targetRevealCount;
         if(_targetRevealCount > 1)
         {
            hideLastTarget();
         }
         if(_targetRevealCount <= _enemyCount)
         {
            _bg.revealCutOut(_targetRevealCount - 1,0);
            _bg.hideCutOut(_targetRevealCount - 1,2);
            _enemyPickers[_targetRevealCount - 1].autoRollOver();
         }
         else
         {
            endHelp();
         }
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionText,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear"
         });
         if(_isSelfTarget)
         {
            _bg.revealCutOut(_targetRevealCount,0);
            _bg.hideCutOut(_targetRevealCount,3);
            endHelp(3);
         }
         else
         {
            startTargetReveals();
         }
      }
      
      private function endHelp(param1:Number = 0) : void
      {
         Tweener.addTween(_actionText,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
            "transition":"linear"
         });
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
         if(_isSelfTarget)
         {
            _alertSpinner.x = ALERT_X_Self;
            _alertSpinner.y = ALERT_Y_Self;
         }
         else
         {
            _alertSpinner.x = ALERT_X;
            _alertSpinner.y = ALERT_Y;
         }
      }
      
      private function setBG() : void
      {
         _bg = new HelpAttackChooserTargetSelectBG(_enemyCount,_isSelfTarget);
         addChild(_bg);
         _bg.alpha = 0;
      }
      
      private function hideLastTarget() : void
      {
         ++_targetHideCount;
         _enemyPickers[_targetHideCount - 1].autoRollOut();
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
         if(Boolean(_targetRevealTimer))
         {
            _targetRevealTimer.stop();
            _targetRevealTimer.removeEventListener(TimerEvent.TIMER,revealNextTarget);
            _targetRevealTimer = null;
         }
      }
   }
}

