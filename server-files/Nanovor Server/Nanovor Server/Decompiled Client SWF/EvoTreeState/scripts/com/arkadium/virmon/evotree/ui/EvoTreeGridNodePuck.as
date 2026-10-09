package com.arkadium.virmon.evotree.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol108")]
   public class EvoTreeGridNodePuck extends Sprite implements IEvoTreeGridNodePuckNanovorLoaderConsumer
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const SELECTED_FILTER:DropShadowFilter = new DropShadowFilter(4,45,1394533,1,10,10,2.5);
      
      private static const DESELECTED_FILTER:GlowFilter = new GlowFilter(0,0.8,6,6,2);
      
      private static const EVOLVE_FILTER:GlowFilter = new GlowFilter(6710886,0.5,6,6,2);
      
      private static const PUCK_INACTIVE_ALPHA:Number = 0.5;
      
      public var mcUnderlay:Sprite;
      
      public var tfCount:TextField;
      
      private var _assetTypeId:int;
      
      private var _tankWalker3D:MovieClip;
      
      private var _nanovorLoader:EvoTreeGridNodePuckNanovorLoader;
      
      public var mcOverlay:Sprite;
      
      public var mcBG:Sprite;
      
      public var mcCountBG:Sprite;
      
      public var mcBackCover:Sprite;
      
      public var mcSpinner:MovieClip;
      
      private var _tintColor:uint;
      
      public var mcFlat:Sprite;
      
      public var mcCanEvolve:MovieClip;
      
      private var _cantEvolveFilter:BitmapFilter;
      
      private var _nanovorContainer:Sprite;
      
      private var _currentMode:EvoTreeGridNodePuckModes;
      
      public function EvoTreeGridNodePuck(param1:String, param2:Boolean, param3:Boolean, param4:int, param5:Boolean, param6:int, param7:IEvoTreeGridColorProvider)
      {
         super();
         _tintColor = param7.lineColorDefault;
         tfCount.text = param6.toString();
         _assetTypeId = param4;
         _cantEvolveFilter = param7.puckCantEvolveFilter;
         mcOverlay.mouseEnabled = false;
         mcOverlay.mouseChildren = false;
         mcCanEvolve.mouseEnabled = false;
         mcCanEvolve.mouseChildren = false;
         this.removeChild(mcOverlay);
         this.removeChild(mcUnderlay);
         this.removeChild(mcBackCover);
         this.removeChild(mcCanEvolve);
         this.removeChild(mcSpinner);
         _nanovorContainer = new Sprite();
         _nanovorContainer.mouseEnabled = false;
         _nanovorContainer.mouseChildren = false;
         this.addChild(_nanovorContainer);
         if(!param2)
         {
            this.removeChild(mcFlat);
            this.removeChild(mcBG);
         }
         this.buttonMode = true;
         _nanovorLoader = new EvoTreeGridNodePuckNanovorLoader(param4,param1,param2,param3,param5,IEvoTreeGridNodePuckNanovorLoaderConsumer(this));
         setMode(EvoTreeGridNodePuckModes.MODE_INACTIVE);
      }
      
      public function setMode(param1:EvoTreeGridNodePuckModes) : void
      {
         var _loc2_:int = 0;
         if(_currentMode == param1)
         {
            return;
         }
         if(null != _tankWalker3D && null != _tankWalker3D.parent)
         {
            _tankWalker3D.parent.removeChild(_tankWalker3D);
            _tankWalker3D = null;
            _loc2_ = 0;
            while(_loc2_ < _nanovorContainer.numChildren)
            {
               _nanovorContainer.getChildAt(_loc2_).visible = true;
               _loc2_++;
            }
         }
         toggleCount(true);
         mcCountBG.filters = [];
         this.removeEventListener(MouseEvent.ROLL_OVER,onPuckRollOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,onPuckRollOut);
         switch(param1)
         {
            case EvoTreeGridNodePuckModes.MODE_SELECTED:
               showOverlay();
               Tweener.addTween(mcFlat,{
                  "_autoAlpha":0.67,
                  "base":TWEEN_BASE
               });
               Tweener.removeTweens(_nanovorContainer);
               _nanovorContainer.scaleX = _nanovorContainer.scaleY = 1.5;
               hideCanEvolve();
               toggleCount(false);
               _nanovorContainer.filters = [SELECTED_FILTER];
               break;
            case EvoTreeGridNodePuckModes.MODE_ACTIVE:
               hideOverlay();
               showUnderlay();
               Tweener.addTween(mcFlat,{
                  "_autoAlpha":0.67,
                  "base":TWEEN_BASE
               });
               Tweener.addTween(_nanovorContainer,{
                  "_scale":1,
                  "base":TWEEN_BASE
               });
               hideCanEvolve();
               _nanovorContainer.filters = [DESELECTED_FILTER];
               break;
            case EvoTreeGridNodePuckModes.MODE_INACTIVE:
               Tweener.addTween(mcFlat,{
                  "_color":_tintColor,
                  "_autoAlpha":PUCK_INACTIVE_ALPHA,
                  "base":TWEEN_BASE
               });
               Tweener.addTween(_nanovorContainer,{
                  "_scale":1,
                  "base":TWEEN_BASE
               });
               hideOverlay();
               hideUnderlay();
               hideCanEvolve();
               _nanovorContainer.filters = [DESELECTED_FILTER];
               break;
            case EvoTreeGridNodePuckModes.MODE_CAN_EVOLVE:
               Tweener.addTween(mcFlat,{
                  "_autoAlpha":PUCK_INACTIVE_ALPHA,
                  "base":TWEEN_BASE
               });
               Tweener.addTween(_nanovorContainer,{
                  "_scale":1,
                  "base":TWEEN_BASE
               });
               hideOverlay();
               hideUnderlay();
               showCanEvolve(true);
               _nanovorContainer.filters = [EVOLVE_FILTER];
               break;
            case EvoTreeGridNodePuckModes.MODE_CANT_EVOLVE:
               Tweener.addTween(mcFlat,{
                  "_autoAlpha":PUCK_INACTIVE_ALPHA,
                  "base":TWEEN_BASE
               });
               Tweener.addTween(_nanovorContainer,{
                  "_scale":1,
                  "base":TWEEN_BASE
               });
               hideOverlay();
               hideUnderlay();
               showCanEvolve(false);
               _nanovorContainer.filters = [EVOLVE_FILTER];
         }
         this.addChild(_nanovorContainer);
      }
      
      private function removePiece(param1:DisplayObject) : void
      {
         if(null != param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function hideCanEvolve() : void
      {
         Tweener.addTween(mcCanEvolve,{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":removePiece,
            "onCompleteParams":[mcCanEvolve]
         });
      }
      
      private function hideBacker() : void
      {
         Tweener.addTween(mcBackCover,{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":removePiece,
            "onCompleteParams":[mcBackCover]
         });
      }
      
      private function onPuckRollOut(param1:MouseEvent) : void
      {
      }
      
      private function onPuckRollOver(param1:MouseEvent) : void
      {
      }
      
      public function setFlatTint(param1:uint) : void
      {
         _tintColor = param1;
      }
      
      private function showUnderlay() : void
      {
         this.addChild(mcUnderlay);
         Tweener.addTween(mcUnderlay,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      private function toggleCount(param1:Boolean) : void
      {
         tfCount.visible = param1;
         mcCountBG.visible = param1;
      }
      
      private function hideOverlay() : void
      {
         Tweener.addTween(mcOverlay,{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":removePiece,
            "onCompleteParams":[mcOverlay]
         });
      }
      
      public function handleNanovorIconLoaded(param1:MovieClip) : void
      {
         if(null != _nanovorContainer && null != param1)
         {
            _nanovorContainer.addChild(param1);
         }
      }
      
      private function showOverlay() : void
      {
         this.addChild(mcOverlay);
         Tweener.addTween(mcOverlay,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      public function setCantEvolveReasons(param1:IEvoTreeCanEvolveResponse) : void
      {
      }
      
      private function showBacker() : void
      {
         this.addChild(mcBackCover);
         Tweener.addTween(mcBackCover,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      private function hideUnderlay() : void
      {
         Tweener.addTween(mcUnderlay,{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":removePiece,
            "onCompleteParams":[mcUnderlay]
         });
      }
      
      private function placeNanovorIcon(param1:Boolean) : void
      {
         var _loc2_:UnknownNanovorSpinner = null;
         if(!param1)
         {
            _loc2_ = new UnknownNanovorSpinner();
            _loc2_.x = _loc2_.width / -2;
            _loc2_.y = _loc2_.height / -2;
            _nanovorContainer.addChild(_loc2_);
         }
      }
      
      private function showCanEvolve(param1:Boolean) : void
      {
         this.addChild(mcCanEvolve);
         Tweener.addTween(mcCanEvolve,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         if(!param1)
         {
            mcCanEvolve.mcEvolveSpinner.stop();
         }
         else
         {
            mcCanEvolve.mcEvolveSpinner.play();
         }
      }
   }
}

