package com.arkadium.virmon.help.attackchooser.targetconfirm
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.attackchooser.targetselect.HelpAttackChooserTargetSelectBG;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpAttackChooserTargetConfirm extends MovieClip
   {
      
      public static const ALERT_X:int = 317;
      
      public static const ALERT_Y:int = 377;
      
      public static const ALERT_X_Self:int = 150;
      
      public static const ALERT_Y_Self:int = 450;
      
      public static const ACTION_TEXT_X:int = 300;
      
      public static const ACTION_TEXT_Y:int = 365;
      
      public static const ACTION_TEXT_X_Self:int = 260;
      
      public static const ACTION_TEXT_Y_Self:int = 440;
      
      public static const ACTION_TEXT:String = "Confirm your target and get ready to watch the action.";
      
      public static const ACTION_TEXT_Self:String = "Confirm your target and get ready to watch the action.";
      
      private var _actionText:EuroStileBoldExtended2Text;
      
      private var _enemyPickers:Array;
      
      private var _isSelfTarget:Boolean;
      
      private var _enemyIndex:int;
      
      private var _bg:HelpAttackChooserTargetSelectBG;
      
      private var _enemyCount:int;
      
      private var _startTimer:Timer;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      public function HelpAttackChooserTargetConfirm(param1:Array, param2:int, param3:Boolean)
      {
         super();
         _enemyPickers = param1;
         _enemyIndex = param2;
         _isSelfTarget = param3;
         _enemyCount = param1.length;
         setBG();
         setAlertSpinner();
         setActionText();
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
      
      private function setBG() : void
      {
         _bg = new HelpAttackChooserTargetSelectBG(_enemyCount,_isSelfTarget);
         addChild(_bg);
         _bg.alpha = 0;
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
      
      public function start(param1:int = 0) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startHelp);
         _startTimer.start();
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
            _bg.revealCutOut(0,0);
            _bg.hideCutOut(0,3);
         }
         else
         {
            _bg.revealCutOut(_enemyIndex,0);
            _bg.hideCutOut(_enemyIndex,3);
         }
         endHelp(3);
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
   }
}

