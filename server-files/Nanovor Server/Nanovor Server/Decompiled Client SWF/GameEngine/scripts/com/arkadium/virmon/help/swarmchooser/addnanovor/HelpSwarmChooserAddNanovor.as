package com.arkadium.virmon.help.swarmchooser.addnanovor
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.help.common.HelpAlertSpinner;
   import com.arkadium.virmon.shared.final.elements.EuroStileBoldExtended2Text;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class HelpSwarmChooserAddNanovor extends MovieClip
   {
      
      public static const ALERT_X:int = 220;
      
      public static const ALERT_Y:int = 670;
      
      public static const ACTION_TEXT_X:int = 270;
      
      public static const ACTION_TEXT_Y:int = 655;
      
      public static const ACTION_TEXT:String = "Add more Nanovor to your Swarm.";
      
      private var _startTimer:Timer;
      
      private var _bg:HelpSwarmChooserAddNanovorBG;
      
      private var _alertSpinner:HelpAlertSpinner;
      
      private var _actionNanovorText:EuroStileBoldExtended2Text;
      
      public function HelpSwarmChooserAddNanovor()
      {
         super();
         setBG();
         setAlertSpinner();
         setActionText();
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
         _actionNanovorText = new EuroStileBoldExtended2Text(ACTION_TEXT,18,16777215);
         addChild(_actionNanovorText);
         var _loc1_:Array = new Array();
         _loc1_.push(new GlowFilter(52223,1,10,10,2,3));
         _actionNanovorText.filters = _loc1_;
         _actionNanovorText.x = ACTION_TEXT_X;
         _actionNanovorText.y = ACTION_TEXT_Y;
         _actionNanovorText.alpha = 0;
      }
      
      private function setBG() : void
      {
         _bg = new HelpSwarmChooserAddNanovorBG();
         addChild(_bg);
         _bg.alpha = 0;
      }
      
      public function start(param1:int = 0) : void
      {
         _startTimer = new Timer(param1,1);
         _startTimer.addEventListener(TimerEvent.TIMER,startHelp);
         _startTimer.start();
      }
      
      private function startActionText() : void
      {
         Tweener.addTween(_actionNanovorText,{
            "alpha":1,
            "delay":0.5,
            "time":0.5,
            "transition":"linear"
         });
         endHelp();
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
      
      private function endActionText(param1:Number) : void
      {
         Tweener.addTween(_actionNanovorText,{
            "alpha":0,
            "delay":param1,
            "time":0.5,
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

