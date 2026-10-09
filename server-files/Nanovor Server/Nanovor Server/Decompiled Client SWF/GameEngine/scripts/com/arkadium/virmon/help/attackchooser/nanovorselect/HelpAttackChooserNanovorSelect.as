package com.arkadium.virmon.help.attackchooser.nanovorselect
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpAttackChooserNanovorSelect extends MovieClip
   {
      
      public static const ALERT_X:int = 280;
      
      public static const ALERT_Y:int = 420;
      
      public static const ACTION_TEXT_X:int = 340;
      
      public static const ACTION_TEXT_Y:int = 370;
      
      public static const ACTION_TEXT:String = "Click on a nanovor to start the battle.";
      
      private var _actionText:EuroStileBoldExtended2Text;
      
      private var _bg:HelpAttackChooserNanovorSelectBG;
      
      private var _startTimer:Timer;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      public function HelpAttackChooserNanovorSelect()
      {
         super();
         setBG();
         setAlertSpinner();
         setActionText();
      }
      
      public function start(param1:int = 0) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startHelp);
         _startTimer.start();
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
         _actionText = new EuroStileBoldExtended2Text(ACTION_TEXT,18,16777215);
         addChild(_actionText);
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionText.filters = _loc1_;
         _actionText.x = ACTION_TEXT_X;
         _actionText.y = ACTION_TEXT_Y;
         _actionText.alpha = 0;
      }
      
      private function setBG() : void
      {
         _bg = new HelpAttackChooserNanovorSelectBG();
         addChild(_bg);
         _bg.alpha = 0;
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionText,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear",
            "onComplete":endHelp
         });
      }
      
      private function endActionText(param1:Number) : void
      {
         Tweener.addTween(_actionText,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
            "transition":"linear"
         });
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
      
      private function endHelp() : void
      {
         endActionText(3);
         Tweener.addTween(_bg,{
            "alpha":0,
            "time":1,
            "delay":3,
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
   }
}

