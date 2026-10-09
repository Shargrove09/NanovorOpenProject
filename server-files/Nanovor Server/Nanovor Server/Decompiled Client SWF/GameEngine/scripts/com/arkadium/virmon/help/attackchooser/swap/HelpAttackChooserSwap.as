package com.arkadium.virmon.help.attackchooser.swap
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpAttackChooserSwap extends MovieClip
   {
      
      public static const ALERT_X:int = 360;
      
      public static const ALERT_Y:int = 420;
      
      public static const ACTION_TEXT_X_1:int = 375;
      
      public static const ACTION_TEXT_Y_1:int = 375;
      
      public static const ACTION_TEXT_X_2:int = 337;
      
      public static const ACTION_TEXT_Y_2:int = 450;
      
      public static const ACTION_TEXT_1:String = "Choose a Nanovor to battle with next.";
      
      public static const ACTION_TEXT_2:String = "Choose to leave the same nanovor in next turn.";
      
      private var _bg:HelpAttackChooserSwapBG;
      
      private var _startTimer:Timer;
      
      private var _actionText1:EuroStileBoldExtended2Text;
      
      private var _actionText2:EuroStileBoldExtended2Text;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      public function HelpAttackChooserSwap()
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
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionText1 = new EuroStileBoldExtended2Text(ACTION_TEXT_1,18,16777215);
         addChild(_actionText1);
         _actionText1.filters = _loc1_;
         _actionText1.x = ACTION_TEXT_X_1;
         _actionText1.y = ACTION_TEXT_Y_1;
         _actionText1.alpha = 0;
         _actionText2 = new EuroStileBoldExtended2Text(ACTION_TEXT_2,18,16777215);
         addChild(_actionText2);
         _actionText2.filters = _loc1_;
         _actionText2.x = ACTION_TEXT_X_2;
         _actionText2.y = ACTION_TEXT_Y_2;
         _actionText2.alpha = 0;
      }
      
      private function setBG() : void
      {
         _bg = new HelpAttackChooserSwapBG();
         addChild(_bg);
         _bg.alpha = 0;
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionText1,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear"
         });
         Tweener.addTween(_actionText2,{
            "alpha":1,
            "delay":1,
            "time":0.5,
            "transition":"linear",
            "onComplete":endHelp
         });
      }
      
      private function endActionText(param1:Number) : void
      {
         Tweener.addTween(_actionText1,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
            "transition":"linear"
         });
         Tweener.addTween(_actionText2,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
            "transition":"linear"
         });
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
      
      private function setAlertSpinner() : void
      {
         _alertSpinner = new HelpAlertSpinner();
         addChild(_alertSpinner);
         _alertSpinner.x = ALERT_X;
         _alertSpinner.y = ALERT_Y;
      }
   }
}

