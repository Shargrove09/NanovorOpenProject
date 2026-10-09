package com.arkadium.virmon.shared.final.components.spinningbutton
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.utils.LoopHelper;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol22")]
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
         this.mcIcon.alpha = 0;
         this.mcIcon.scaleX = ICON_SCALE_START;
         this.mcIcon.scaleY = ICON_SCALE_START;
         this._spinnerBlue = this.mcSpinner.mcBlue;
         this._spinnerRed = this.mcSpinner.mcRed;
         this._spinnerRed.visible = false;
         this.mcHitArea.alpha = 0;
         this.hitArea = this.mcHitArea;
         this.useHandCursor = true;
         this.buttonMode = true;
         this.mcSpinner.mouseEnabled = false;
         this.mcHolder.mouseEnabled = false;
         this.mcHolder.stop();
         this.mcBG.mouseEnabled = false;
         this.mcIcon.mouseEnabled = false;
         this.mcIcon.mouseChildren = false;
         this._spinnerHelper = new LoopHelper(this.mcSpinner);
         this._spinnerHelper.speed = 3;
         this._spinnerHelper.stop();
         this.mcHolder.alpha = 0;
         this.mcHolder.scaleX = this.mcHolder.scaleY = HOLDER_SCALE_START;
         this.mcBG.alpha = 0;
         this.mcSpinner.scaleX = this.mcSpinner.scaleY = SPINNER_SCALE_START;
         this.mcSpinner.alpha = 0;
         this.mcHitArea.addEventListener(MouseEvent.ROLL_OVER,this.onButtonRollover,false,0,true);
         this.mcHitArea.addEventListener(MouseEvent.ROLL_OUT,this.onButtonRollout,false,0,true);
      }
      
      public function destroy() : void
      {
         this.mcHitArea.removeEventListener(MouseEvent.ROLL_OVER,this.onButtonRollover);
         this.mcHitArea.removeEventListener(MouseEvent.ROLL_OUT,this.onButtonRollout);
         this.mcIcon.stop();
         this.mcSpinner.stop();
         this.mcHolder.stop();
         this.mcBG.stop();
         this.killAllTweens();
         this._spinnerHelper.destroy();
      }
      
      private function onButtonRollout(param1:MouseEvent) : void
      {
         if(this._isClosing)
         {
            return;
         }
         var _loc2_:int = int(this._spinnerHelper.currentFrame / 30) * 30 + 30;
         this._spinnerHelper.stop(_loc2_);
         Tweener.removeTweens(this.mcSpinner,rotation);
         var _loc3_:Number = (int(this.mcSpinner.rotation / 90) + 1) * 90 + 45;
         Tweener.addTween(this.mcSpinner,{
            "scaleX":SPINNER_SCALE_START,
            "scaleY":SPINNER_SCALE_START,
            "rotation":_loc3_,
            "time":2
         });
      }
      
      public function set color(param1:String) : void
      {
         Tweener.removeTweens(this.mcHolder,"_color");
         Tweener.removeTweens(this.mcBG,"_color");
         switch(param1)
         {
            case COLOR_RED:
               Tweener.addTween(this.mcHolder,{
                  "_color":13369344,
                  "time":0
               });
               Tweener.addTween(this.mcBG,{
                  "_color":13369344,
                  "time":0
               });
               this._spinnerBlue.visible = false;
               this._spinnerRed.visible = true;
               break;
            default:
               Tweener.addTween(this.mcHolder,{
                  "_color":null,
                  "time":0
               });
               Tweener.addTween(this.mcBG,{
                  "_color":null,
                  "time":0
               });
               this._spinnerBlue.visible = true;
               this._spinnerRed.visible = false;
         }
      }
      
      public function open() : void
      {
         this.mcHolder.play();
         this._bOpened = true;
         this.killAllTweens();
         this._isClosing = false;
         Tweener.addTween(this.mcIcon,{
            "scaleX":ICON_SCALE_END,
            "scaleY":ICON_SCALE_END,
            "alpha":1,
            "delay":0.5,
            "time":1,
            "transition":"easeOutElastic"
         });
         Tweener.addTween(this.mcBG,{
            "rotation":135,
            "alpha":1,
            "time":2
         });
         Tweener.addTween(this.mcHolder,{
            "rotation":-180,
            "scaleX":HOLDER_SCALE_END,
            "scaleY":HOLDER_SCALE_END,
            "alpha":1,
            "time":2
         });
         Tweener.addTween(this.mcSpinner,{
            "rotation":-135,
            "alpha":1,
            "time":2,
            "onComplete":this.opened
         });
         if(!this._isDisabled)
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
         Tweener.removeTweens(this.mcIcon);
         Tweener.removeTweens(this.mcBG);
         Tweener.removeTweens(this.mcHolder);
         Tweener.removeTweens(this.mcSpinner);
      }
      
      private function onButtonRollover(param1:MouseEvent) : void
      {
         this._spinnerHelper.play();
         Tweener.addTween(this.mcSpinner,{
            "scaleX":SPINNER_SCALE_END,
            "scaleY":SPINNER_SCALE_END,
            "time":2
         });
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         while(this.mcIcon.numChildren > 0)
         {
            this.mcIcon.removeChildAt(0);
         }
         this.mcIcon.addChild(param1);
      }
      
      public function disable(param1:Boolean) : void
      {
         this._isDisabled = param1;
         if(param1)
         {
            this.alpha = 0.2;
            this.mcHitArea.mouseEnabled = false;
            this.mcHitArea.mouseChildren = false;
            this.useHandCursor = false;
            this.buttonMode = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.mcHitArea.removeEventListener(MouseEvent.ROLL_OVER,this.onButtonRollover);
            this.mcHitArea.removeEventListener(MouseEvent.ROLL_OUT,this.onButtonRollout);
         }
         else
         {
            this.alpha = 1;
            this.mcHitArea.mouseEnabled = true;
            this.mcHitArea.mouseChildren = true;
            this.useHandCursor = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.mcHitArea.addEventListener(MouseEvent.ROLL_OVER,this.onButtonRollover,false,0,true);
            this.mcHitArea.addEventListener(MouseEvent.ROLL_OUT,this.onButtonRollout,false,0,true);
         }
      }
      
      public function close() : void
      {
         this._bOpened = false;
         this.killAllTweens();
         this._isClosing = true;
         Tweener.addTween(this.mcIcon,{
            "scaleX":HOLDER_SCALE_START,
            "scaleY":HOLDER_SCALE_START,
            "alpha":0,
            "time":0.5,
            "transition":"easeOutElastic"
         });
         Tweener.addTween(this.mcBG,{
            "rotation":135,
            "alpha":0,
            "time":2
         });
         Tweener.addTween(this.mcHolder,{
            "rotation":-180,
            "scaleX":HOLDER_SCALE_END,
            "scaleY":HOLDER_SCALE_END,
            "alpha":0,
            "time":1,
            "onComplete":this.closed
         });
         Tweener.addTween(this.mcSpinner,{
            "rotation":-135,
            "alpha":0,
            "time":1,
            "onComplete":this._spinnerHelper.stop
         });
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.mcHolder.stop();
      }
      
      public function get isOpened() : Boolean
      {
         return this._bOpened;
      }
      
      private function closed() : void
      {
         this._isClosing = false;
      }
   }
}

