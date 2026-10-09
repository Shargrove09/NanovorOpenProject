package com.arkadium.virmon.shared.widgets.avatar
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class AvatarSpinnerButtonWire extends MovieClip
   {
      
      public static const TEXT_POSITION_TOP:String = "top";
      
      public static const TEXT_POSITION_BOTTOM:String = "bottom";
      
      private static const FRAME_LABEL_OPEN:String = "open";
      
      private static const FRAME_LABEL_CLOSE:String = "close";
      
      private static const TEXT_BASELINE:Number = 28;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      public var mcMask:MovieClip;
      
      private var _currentTextPosition:String;
      
      public var tfText:TextField;
      
      public function AvatarSpinnerButtonWire()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         _currentTextPosition = TEXT_POSITION_TOP;
         tfText.alpha = 0;
         tfText.autoSize = TextFieldAutoSize.LEFT;
         tfText.width = 60;
         tfText.multiline = true;
         tfText.text = "TESTING";
      }
      
      private function startOpenAnimationChain() : void
      {
         Tweener.removeTweens(mcMask);
         Tweener.addTween(mcMask,{
            "base":TWEEN_BASE,
            "time":0.1,
            "x":-28.65,
            "y":-27
         });
         Tweener.addTween(mcMask,{
            "base":TWEEN_BASE,
            "time":0.1,
            "x":-28.65,
            "y":2.75,
            "delay":0.1
         });
         Tweener.addTween(mcMask,{
            "base":TWEEN_BASE,
            "time":0.1,
            "x":28.1,
            "y":2.75,
            "delay":0.2
         });
         Tweener.addTween(mcMask,{
            "base":TWEEN_BASE,
            "time":0.1,
            "x":28.1,
            "y":6.25,
            "delay":0.3
         });
      }
      
      public function open() : void
      {
         startOpenAnimationChain();
         Tweener.addTween(tfText,{
            "base":TWEEN_BASE,
            "alpha":1
         });
      }
      
      private function startCloseAnimationChain() : void
      {
         Tweener.removeTweens(mcMask);
         Tweener.addTween(mcMask,{
            "base":TWEEN_BASE,
            "time":0.1,
            "x":138.1,
            "y":6.25
         });
      }
      
      public function set textPosition(param1:String) : void
      {
         _currentTextPosition = param1;
      }
      
      public function close() : void
      {
         startCloseAnimationChain();
         Tweener.addTween(tfText,{
            "base":TWEEN_BASE,
            "alpha":0
         });
      }
      
      public function set text(param1:String) : void
      {
         tfText.text = param1;
         if(_currentTextPosition == TEXT_POSITION_BOTTOM)
         {
            tfText.y = TEXT_BASELINE;
         }
         else
         {
            tfText.y = TEXT_BASELINE - tfText.height;
         }
      }
   }
}

