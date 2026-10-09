package com.arkadium.virmon.senseiselect.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol18")]
   public class SenseiSelectionButton extends Sprite
   {
      
      private var _senseiName:String;
      
      public var tfTitle:TextField;
      
      public var mcHitArea:Sprite;
      
      public var mcClamps:Sprite;
      
      private var _spinningNanovor:MovieClip;
      
      public var mcComingSoon:MovieClip;
      
      private var _senseiId:int;
      
      public var mcInnerSpinner:MovieClip;
      
      public var mcBG:Sprite;
      
      public var mcOuterSpinner:MovieClip;
      
      private var _selected:Boolean;
      
      public function SenseiSelectionButton(param1:String, param2:int)
      {
         super();
         _senseiName = param1;
         _senseiId = param2;
         _spinningNanovor = new UnknownNanovorSpinner();
         scaleAndPositionNanovorSpinner(0.35);
         stopAndResetNanovorSpinner();
         this.mouseChildren = false;
         this.buttonMode = true;
         this.hitArea = mcHitArea;
         tfTitle.text = _senseiName;
         tfTitle.cacheAsBitmap = true;
         mcInnerSpinner.cacheAsBitmap = true;
         mcInnerSpinner.alpha = 0;
         mcInnerSpinner.scaleX = mcInnerSpinner.scaleY = 0.1;
         mcOuterSpinner.cacheAsBitmap = true;
         mcOuterSpinner.alpha = 0;
         mcClamps.alpha = 0;
         tfTitle.alpha = 0;
         mcComingSoon.alpha = 0;
         mcComingSoon.mouseEnabled = false;
         mcComingSoon.mouseChildren = false;
         mcComingSoon.scaleX = mcComingSoon.scaleY = 2;
      }
      
      public function deselect() : void
      {
         _selected = false;
         stopAndResetNanovorSpinner();
         scaleAndPositionNanovorSpinner(0.35);
         Tweener.addTween(mcInnerSpinner,{
            "_autoAlpha":0,
            "_scale":0.1,
            "time":0.5,
            "transition":Equations.easeOutQuad
         });
      }
      
      private function playNanovorSpinner() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _spinningNanovor.numChildren)
         {
            if(null != _spinningNanovor.getChildAt(_loc1_) as MovieClip)
            {
               MovieClip(_spinningNanovor.getChildAt(_loc1_)).play();
            }
            _loc1_++;
         }
      }
      
      private function handleButtonRollOver(param1:MouseEvent) : void
      {
         if(_selected)
         {
            return;
         }
         Tweener.addTween(mcInnerSpinner,{
            "_autoAlpha":1,
            "_scale":1,
            "time":1,
            "transition":Equations.easeOutElastic
         });
      }
      
      public function open(param1:Boolean, param2:BitmapFilter = null) : void
      {
         var _loc3_:ColorTransform = null;
         this.addChild(_spinningNanovor);
         Tweener.addTween(mcOuterSpinner,{
            "_autoAlpha":1,
            "time":1
         });
         Tweener.addTween(mcClamps,{
            "_autoAlpha":1,
            "time":1
         });
         if(param1)
         {
            this.addEventListener(MouseEvent.ROLL_OVER,handleButtonRollOver);
            this.addEventListener(MouseEvent.ROLL_OUT,handleButtonRollOut);
            Tweener.addTween(tfTitle,{
               "_autoAlpha":1,
               "time":1
            });
         }
         else
         {
            this.setChildIndex(mcComingSoon,this.numChildren - 1);
            stopAndResetNanovorSpinner();
            scaleAndPositionNanovorSpinner(0.3);
            _loc3_ = new ColorTransform();
            _loc3_.color = 5295069;
            _spinningNanovor.transform.colorTransform = _loc3_;
            _spinningNanovor.stop();
            Tweener.addTween(tfTitle,{
               "_autoAlpha":0.5,
               "time":1
            });
            Tweener.addTween(mcComingSoon,{
               "_autoAlpha":1,
               "_scale":1,
               "time":1
            });
         }
         if(null != param2)
         {
            mcInnerSpinner.filters = [param2];
            mcOuterSpinner.filters = [param2];
            mcClamps.filters = [param2];
            _spinningNanovor.filters = [param2];
         }
      }
      
      public function get senseiName() : String
      {
         return _senseiName;
      }
      
      private function scaleAndPositionNanovorSpinner(param1:Number) : void
      {
         var _loc2_:Number = (96 - 150 * param1) / 2;
         var _loc3_:Number = (96 - 122 * param1) / 2;
         Tweener.addTween(_spinningNanovor,{
            "_scale":param1,
            "x":_loc2_,
            "y":_loc3_,
            "time":1
         });
      }
      
      private function stopAndResetNanovorSpinner() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _spinningNanovor.numChildren)
         {
            if(null != _spinningNanovor.getChildAt(_loc1_) as MovieClip)
            {
               MovieClip(_spinningNanovor.getChildAt(_loc1_)).gotoAndStop(0);
            }
            _loc1_++;
         }
      }
      
      private function handleButtonRollOut(param1:MouseEvent) : void
      {
         if(_selected)
         {
            return;
         }
         Tweener.addTween(mcInnerSpinner,{
            "_autoAlpha":0,
            "_scale":0.1,
            "time":0.5,
            "transition":Equations.easeOutQuad
         });
      }
      
      public function select() : void
      {
         _selected = true;
         playNanovorSpinner();
         scaleAndPositionNanovorSpinner(0.5);
         Tweener.addTween(mcInnerSpinner,{
            "_autoAlpha":1,
            "_scale":0.8,
            "time":1,
            "transition":Equations.easeOutElastic
         });
      }
      
      public function get senseiId() : int
      {
         return _senseiId;
      }
   }
}

