package com.arkadium.virmon.shared.final.components.spinningbutton
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.utils.LoopHelper;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SpinningButtonComponent extends Sprite implements ISpinningButtonComponent
   {
      
      public static const COLOR_RED:String = "red";
      
      public static const COLOR_BLUE:String = "blue";
      
      private static const ICON_SCALE_START:Number = 0.1;
      
      private static const ICON_SCALE_END:Number = 1;
      
      private static const HOLDER_SCALE_END:Number = 0.359;
      
      private static const HOLDER_SCALE_START:Number = 0.5;
      
      private static const SPINNER_SCALE_END:Number = 0.28;
      
      private static const SPINNER_SCALE_START:Number = 0.4;
      
      private var _isOpeningOrClosing:Boolean = false;
      
      public var mcHitArea:MovieClip;
      
      private var _spinnerBlue:MovieClip;
      
      private var _spinnerRed:MovieClip;
      
      public var mcHolder:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      private var _isDisabled:Boolean = false;
      
      public var mcBG:MovieClip;
      
      private var _isClosing:Boolean = false;
      
      private var _spinnerHelper:LoopHelper;
      
      private var _bOpened:Boolean = false;
      
      public var mcIcon:MovieClip;
      
      public function SpinningButtonComponent(param1:DisplayObject = null)
      {
         super();
         if(param1 != null)
         {
            this.icon = param1;
         }
         this.mouseEnabled = false;
         this.mouseChildren = false;
         mcIcon.alpha = 0;
         mcIcon.scaleX = ICON_SCALE_START;
         mcIcon.scaleY = ICON_SCALE_START;
         _spinnerBlue = mcSpinner.mcBlue;
         _spinnerRed = mcSpinner.mcRed;
         _spinnerRed.visible = false;
         mcHitArea.alpha = 0;
         this.hitArea = mcHitArea;
         this.useHandCursor = true;
         this.buttonMode = true;
         mcSpinner.mouseEnabled = false;
         mcHolder.mouseEnabled = false;
         mcHolder.stop();
         mcBG.mouseEnabled = false;
         mcIcon.mouseEnabled = false;
         mcIcon.mouseChildren = false;
         _spinnerHelper = new LoopHelper(mcSpinner);
         _spinnerHelper.speed = 3;
         _spinnerHelper.stop();
         mcHolder.alpha = 0;
         mcHolder.scaleX = mcHolder.scaleY = HOLDER_SCALE_START;
         mcBG.alpha = 0;
         mcSpinner.scaleX = mcSpinner.scaleY = SPINNER_SCALE_START;
         mcSpinner.alpha = 0;
         mcHitArea.addEventListener(MouseEvent.ROLL_OVER,onButtonRollover,false,0,true);
         mcHitArea.addEventListener(MouseEvent.ROLL_OUT,onButtonRollout,false,0,true);
      }
      
      public function destroy() : void
      {
         mcHitArea.removeEventListener(MouseEvent.ROLL_OVER,onButtonRollover);
         mcHitArea.removeEventListener(MouseEvent.ROLL_OUT,onButtonRollout);
         mcIcon.stop();
         mcSpinner.stop();
         mcHolder.stop();
         mcBG.stop();
         killAllTweens();
         _spinnerHelper.destroy();
      }
      
      private function onButtonRollout(param1:MouseEvent) : void
      {
         if(_isClosing)
         {
            return;
         }
         var _loc2_:int = int(_spinnerHelper.currentFrame / 30) * 30 + 30;
         _spinnerHelper.stop(_loc2_);
         Tweener.removeTweens(mcSpinner,rotation);
         var _loc3_:Number = (int(mcSpinner.rotation / 90) + 1) * 90 + 45;
         Tweener.addTween(mcSpinner,{
            "scaleX":SPINNER_SCALE_START,
            "scaleY":SPINNER_SCALE_START,
            "rotation":_loc3_,
            "time":2
         });
      }
      
      public function set color(param1:String) : void
      {
         Tweener.removeTweens(mcHolder,"_color");
         Tweener.removeTweens(mcBG,"_color");
         switch(param1)
         {
            case COLOR_RED:
               Tweener.addTween(mcHolder,{
                  "_color":13369344,
                  "time":0
               });
               Tweener.addTween(mcBG,{
                  "_color":13369344,
                  "time":0
               });
               _spinnerBlue.visible = false;
               _spinnerRed.visible = true;
               break;
            default:
               Tweener.addTween(mcHolder,{
                  "_color":null,
                  "time":0
               });
               Tweener.addTween(mcBG,{
                  "_color":null,
                  "time":0
               });
               _spinnerBlue.visible = true;
               _spinnerRed.visible = false;
         }
      }
      
      public function open() : void
      {
         mcHolder.play();
         _bOpened = true;
         killAllTweens();
         _isClosing = false;
         Tweener.addTween(mcIcon,{
            "scaleX":ICON_SCALE_END,
            "scaleY":ICON_SCALE_END,
            "alpha":1,
            "delay":0.5,
            "time":1,
            "transition":"easeOutElastic"
         });
         Tweener.addTween(mcBG,{
            "rotation":135,
            "alpha":1,
            "time":2
         });
         Tweener.addTween(mcHolder,{
            "rotation":-180,
            "scaleX":HOLDER_SCALE_END,
            "scaleY":HOLDER_SCALE_END,
            "alpha":1,
            "time":2
         });
         Tweener.addTween(mcSpinner,{
            "rotation":-135,
            "alpha":1,
            "time":2,
            "onComplete":opened
         });
         if(!_isDisabled)
         {
            this.mouseEnabled = true;
            this.mouseChildren = true;
         }
      }
      
      private function opened() : void
      {
      }
      
      private function killAllTweens() : void
      {
         Tweener.removeTweens(mcIcon);
         Tweener.removeTweens(mcBG);
         Tweener.removeTweens(mcHolder);
         Tweener.removeTweens(mcSpinner);
      }
      
      private function onButtonRollover(param1:MouseEvent) : void
      {
         _spinnerHelper.play();
         Tweener.addTween(mcSpinner,{
            "scaleX":SPINNER_SCALE_END,
            "scaleY":SPINNER_SCALE_END,
            "time":2
         });
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         while(mcIcon.numChildren > 0)
         {
            mcIcon.removeChildAt(0);
         }
         mcIcon.addChild(param1);
      }
      
      public function disable(param1:Boolean) : void
      {
         _isDisabled = param1;
         if(param1)
         {
            this.alpha = 0.2;
            mcHitArea.mouseEnabled = false;
            mcHitArea.mouseChildren = false;
            this.useHandCursor = false;
            this.buttonMode = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            mcHitArea.removeEventListener(MouseEvent.ROLL_OVER,onButtonRollover);
            mcHitArea.removeEventListener(MouseEvent.ROLL_OUT,onButtonRollout);
         }
         else
         {
            this.alpha = 1;
            mcHitArea.mouseEnabled = true;
            mcHitArea.mouseChildren = true;
            this.useHandCursor = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            mcHitArea.addEventListener(MouseEvent.ROLL_OVER,onButtonRollover,false,0,true);
            mcHitArea.addEventListener(MouseEvent.ROLL_OUT,onButtonRollout,false,0,true);
         }
      }
      
      public function close() : void
      {
         _bOpened = false;
         killAllTweens();
         _isClosing = true;
         Tweener.addTween(mcIcon,{
            "scaleX":HOLDER_SCALE_START,
            "scaleY":HOLDER_SCALE_START,
            "alpha":0,
            "time":0.5,
            "transition":"easeOutElastic"
         });
         Tweener.addTween(mcBG,{
            "rotation":135,
            "alpha":0,
            "time":2
         });
         Tweener.addTween(mcHolder,{
            "rotation":-180,
            "scaleX":HOLDER_SCALE_END,
            "scaleY":HOLDER_SCALE_END,
            "alpha":0,
            "time":1,
            "onComplete":closed
         });
         Tweener.addTween(mcSpinner,{
            "rotation":-135,
            "alpha":0,
            "time":1,
            "onComplete":_spinnerHelper.stop
         });
         this.mouseEnabled = false;
         this.mouseChildren = false;
         mcHolder.stop();
      }
      
      public function get isOpened() : Boolean
      {
         return _bOpened;
      }
      
      private function closed() : void
      {
         _isClosing = false;
      }
   }
}

