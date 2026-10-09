package com.arkadium.virmon.battle.substates.swarmchooser
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol123")]
   public class SwarmMeter extends MovieClip
   {
      
      public static const SV_NUM_DIGITS:int = 3;
      
      public static const MODE_FILLING:String = "filling";
      
      public static const MODE_GO_TO_BATTLE:String = "goToBattle";
      
      private static const GO_TO_BATTLE_X:Number = 300;
      
      private static const GENERAL_TWEEN_SECONDS:Number = 1;
      
      private static const GENERAL_TWEEN_EASING:String = "easeInOutQuad";
      
      private static const CHASER_CYCLE_ALPHA:Number = 0.5;
      
      private static const BATTLE_TWEEN_SECONDS:Number = 0.5;
      
      private static const CHASER_STARY_X:Number = 78;
      
      private static const CHASER_END_X:Number = 650;
      
      private static const CHASER_PERCENT_DELTA_X:Number = 625 - 78;
      
      private static const LABEL_CONTAINER_MIN_X:Number = 130;
      
      private static const LABEL_CONTAINER_MAX_X:Number = 500;
      
      private var _currentSwarmValue:int = 0;
      
      private var _labelContainer:Sprite;
      
      public var tfSV:TextField;
      
      public var mcSVToGo:MovieClip;
      
      public var mcTrackMask:MovieClip;
      
      private var _allottedSwarmValue:int;
      
      public var tfGoToBattle:TextField;
      
      private var _tweenProp:TweenProp;
      
      public var mcChaser:MovieClip;
      
      private var _currentMode:String;
      
      public function SwarmMeter(param1:int)
      {
         super();
         _tweenProp = new TweenProp(this);
         _allottedSwarmValue = param1;
         createLabelContainer();
         tfGoToBattle.x = GO_TO_BATTLE_X;
         this.mode = MODE_FILLING;
      }
      
      public function set sv(param1:int) : void
      {
         _currentSwarmValue = param1;
         updateSV();
      }
      
      public function hide() : void
      {
         visible = false;
      }
      
      public function set mode(param1:String) : void
      {
         if(_currentMode == param1)
         {
            return;
         }
         if(_currentMode == null)
         {
            Tweener.addTween(_labelContainer,{
               "alpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
         }
         _currentMode = param1;
         switch(param1)
         {
            case MODE_FILLING:
               Tweener.removeTweens(tfGoToBattle,"alpha");
               Tweener.removeTweens(mcChaser,"x");
               tfGoToBattle.alpha = 0;
               mcChaser.alpha = 1;
               mcChaser.x = CHASER_STARY_X;
               _labelContainer.visible = true;
               Tweener.addTween(_labelContainer,{
                  "alpha":1,
                  "time":GENERAL_TWEEN_SECONDS,
                  "transition":GENERAL_TWEEN_EASING
               });
               updateSV();
               break;
            case MODE_GO_TO_BATTLE:
               mcChaser.alpha = CHASER_CYCLE_ALPHA;
               tfGoToBattle.alpha = 0;
               mcChaser.x = CHASER_STARY_X;
               Tweener.addTween(mcChaser,{
                  "x":CHASER_END_X,
                  "time":GENERAL_TWEEN_SECONDS,
                  "transition":GENERAL_TWEEN_EASING
               });
               Tweener.addTween(mcTrackMask,{
                  "x":CHASER_END_X,
                  "time":GENERAL_TWEEN_SECONDS,
                  "transition":GENERAL_TWEEN_EASING,
                  "onComplete":onTrackFilled
               });
         }
      }
      
      public function createLabelContainer() : void
      {
         _labelContainer = new Sprite();
         _labelContainer.x = 1000;
         _labelContainer.alpha = 0;
         _labelContainer.addChild(tfSV);
         _labelContainer.addChild(mcSVToGo);
         this.addChild(_labelContainer);
      }
      
      private function labelContainerClampX(param1:Number) : Number
      {
         if(param1 < LABEL_CONTAINER_MIN_X)
         {
            return LABEL_CONTAINER_MIN_X;
         }
         if(param1 > LABEL_CONTAINER_MAX_X)
         {
            return LABEL_CONTAINER_MAX_X;
         }
         return param1;
      }
      
      public function destroy() : void
      {
         mcChaser.stop();
         mcTrackMask.stop();
         mcSVToGo.stop();
         _tweenProp = null;
      }
      
      private function repositionSVText() : void
      {
         tfSV.x = 0;
         Tweener.addTween(_tweenProp,{
            "sv":String(_allottedSwarmValue - _currentSwarmValue),
            "time":GENERAL_TWEEN_SECONDS,
            "transition":GENERAL_TWEEN_EASING
         });
         Tweener.addTween(mcSVToGo,{
            "x":tfSV.width,
            "time":GENERAL_TWEEN_SECONDS,
            "transition":GENERAL_TWEEN_EASING
         });
      }
      
      private function cycleChaser() : void
      {
         mcChaser.x = CHASER_STARY_X;
         Tweener.addTween(mcChaser,{
            "x":CHASER_END_X,
            "time":BATTLE_TWEEN_SECONDS,
            "delay":GENERAL_TWEEN_SECONDS,
            "transition":GENERAL_TWEEN_EASING,
            "onComplete":cycleChaser
         });
      }
      
      private function cycleText() : void
      {
         if(tfGoToBattle.alpha == 0)
         {
            Tweener.addTween(tfGoToBattle,{
               "alpha":1,
               "time":GENERAL_TWEEN_SECONDS,
               "transition":"easeOutQuad",
               "onComplete":cycleText
            });
         }
         else
         {
            Tweener.addTween(tfGoToBattle,{
               "alpha":0,
               "time":GENERAL_TWEEN_SECONDS,
               "transition":"easeInQuad",
               "onComplete":cycleText
            });
         }
      }
      
      private function updateSV(param1:Boolean = false) : void
      {
         var _loc2_:Number = Number(_currentSwarmValue) / Number(_allottedSwarmValue);
         var _loc3_:Number = CHASER_STARY_X + _loc2_ * CHASER_PERCENT_DELTA_X;
         if(param1)
         {
            tfSV.x = 0;
            tfSV.text = String(_currentSwarmValue);
            mcSVToGo.x = tfSV.width;
            _labelContainer.x = labelContainerClampX(_loc3_);
         }
         else
         {
            repositionSVText();
            Tweener.addTween(mcChaser,{
               "x":_loc3_,
               "time":GENERAL_TWEEN_SECONDS,
               "transition":GENERAL_TWEEN_EASING
            });
            Tweener.addTween(_labelContainer,{
               "x":labelContainerClampX(_loc3_),
               "time":GENERAL_TWEEN_SECONDS,
               "transition":GENERAL_TWEEN_EASING,
               "onComplete":repositionSVText
            });
            Tweener.addTween(mcTrackMask,{
               "x":_loc3_,
               "time":GENERAL_TWEEN_SECONDS,
               "transition":GENERAL_TWEEN_EASING
            });
         }
      }
      
      private function onTrackFilled() : void
      {
         cycleText();
         cycleChaser();
      }
   }
}

class TweenProp
{
   
   private var _ui:SwarmMeter;
   
   public function TweenProp(param1:SwarmMeter)
   {
      super();
      _ui = param1;
   }
   
   public function set sv(param1:String) : void
   {
      _ui.tfSV.text = String(parseInt(param1));
   }
   
   public function get sv() : String
   {
      return _ui.tfSV.text;
   }
}
