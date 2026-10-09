package com.arkadium.virmon.evotree.grid.gridinfo.view
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.grid.gridinfo.controller.IEvoTreeGridInfoController;
   import com.arkadium.virmon.evotree.grid.gridinfo.model.IEvoTreeGridInfoModelConsumer;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconPedigree;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowTitle;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol135")]
   public class EvoTreeGridInfoView extends Sprite implements IEvoTreeGridInfoView, IEvoTreeGridInfoModelConsumer
   {
      
      private static const ARROW_POINT_LEFT:Point = new Point(-108,-54);
      
      private static const ARROW_POINT_RIGHT:Point = new Point(124,-54);
      
      private static const INFO_WINDOW_POINT:Point = new Point(-200,-6);
      
      private static const COLLECTION_POINT:Point = new Point(-44,-69);
      
      private static const TWEEN_DISTANCE:int = 120;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeOutExpo
      };
      
      public var tfTitle:TextField;
      
      private var _currentTfCurrent:TextField;
      
      private var _currentInfoWindow:InfoWindowTitle;
      
      private var _tempTfOfX:int;
      
      public var mcSeeInCollection:Sprite;
      
      private var _tempTfCurrentX:int;
      
      private var _arrowLeft:GlowArrow;
      
      private var _currentNest:Sprite;
      
      public var tfCurrentMask:Sprite;
      
      private var _arrowRight:GlowArrow;
      
      private var _controller:IEvoTreeGridInfoController;
      
      private var _currentTfOf:TextField;
      
      private var _collectionButton:SpinningButtonComponent;
      
      public var mcBG:Sprite;
      
      public var tfOf:TextField;
      
      public var tfCurrent1:TextField;
      
      public var tfCurrent2:TextField;
      
      private var _infoWindow1:InfoWindowTitle;
      
      private var _infoWindow2:InfoWindowTitle;
      
      public var tfTotal:TextField;
      
      public function EvoTreeGridInfoView(param1:IEvoTreeGridInfoController, param2:String, param3:int)
      {
         super();
         _controller = param1;
         createGlowArrows();
         createInfoWindows();
         createCollectionButton();
         _tempTfCurrentX = tfCurrent1.x;
         _tempTfOfX = tfOf.x;
         _currentNest = new Sprite();
         _currentNest.cacheAsBitmap = true;
         this.addChild(_currentNest);
         _currentNest.addChild(tfCurrent1);
         _currentNest.addChild(tfCurrent2);
         tfCurrentMask.cacheAsBitmap = true;
         _currentNest.mask = tfCurrentMask;
         _currentInfoWindow = _infoWindow1;
         _currentTfCurrent = tfCurrent1;
         _infoWindow2.visible = false;
         tfCurrent2.visible = false;
         mcSeeInCollection.mouseEnabled = false;
         this.mouseEnabled = false;
         mcBG.mouseEnabled = false;
         mcBG.mouseChildren = false;
         _infoWindow1.nanovorName = param2;
         _infoWindow1.nanovorNickName = "";
         tfCurrent1.text = "";
         tfCurrent2.text = "";
         tfTitle.text = "";
      }
      
      private function toggleNanovorScroller(param1:Boolean) : void
      {
         toggleArrows(param1);
         _infoWindow1.visible = param1;
         _currentTfCurrent.visible = param1;
         tfOf.visible = param1;
      }
      
      private function createGlowArrows() : void
      {
         _arrowLeft = new GlowArrow();
         _arrowLeft.x = ARROW_POINT_LEFT.x;
         _arrowLeft.y = ARROW_POINT_LEFT.y;
         _arrowLeft.open();
         this.addChild(_arrowLeft);
         _arrowRight = new GlowArrow();
         _arrowRight.scaleX = -1;
         _arrowRight.x = ARROW_POINT_RIGHT.x;
         _arrowRight.y = ARROW_POINT_RIGHT.y;
         _arrowRight.open();
         this.addChild(_arrowRight);
         _arrowLeft.addEventListener(MouseEvent.CLICK,onLeftArrowClick);
         _arrowRight.addEventListener(MouseEvent.CLICK,onRightArrowClick);
      }
      
      private function createCollectionButton() : void
      {
         _collectionButton = new SpinningButtonComponent(new SpinnerIconPedigree());
         _collectionButton.x = COLLECTION_POINT.x;
         _collectionButton.y = COLLECTION_POINT.y;
         this.addChild(_collectionButton);
         _collectionButton.addEventListener(MouseEvent.CLICK,handleCollectionButtonClick);
         _collectionButton.open();
      }
      
      public function handleNanovorSelected(param1:INanovor, param2:int, param3:int) : void
      {
         tfTotal.text = param3.toString();
         if(null == param1)
         {
            toggleNanovorScroller(false);
            toggleArrows(false);
            _infoWindow1.visible = true;
            _collectionButton.close();
            mcSeeInCollection.visible = false;
            return;
         }
         var _loc4_:InfoWindowTitle = _currentInfoWindow === _infoWindow1 ? _infoWindow2 : _infoWindow1;
         var _loc5_:TextField = _currentTfCurrent === tfCurrent1 ? tfCurrent2 : tfCurrent1;
         Tweener.removeTweens(_loc5_);
         _loc5_.visible = true;
         _loc5_.x = _tempTfCurrentX - TWEEN_DISTANCE;
         _loc5_.text = int(param2 + 1).toString();
         Tweener.removeTweens(_loc4_);
         _loc4_.x = INFO_WINDOW_POINT.x - TWEEN_DISTANCE;
         _loc4_.alpha = 0;
         _loc4_.nanovorName = param1.name;
         _loc4_.nanovorNickName = param1.nickName;
         _loc4_.scaleX = _loc4_.scaleY = 0.1;
         _loc4_.y = INFO_WINDOW_POINT.y + 16;
         Tweener.addTween(_currentInfoWindow,{
            "_autoAlpha":0,
            "x":INFO_WINDOW_POINT.x + TWEEN_DISTANCE,
            "_scale":0.1,
            "y":INFO_WINDOW_POINT.y + 16,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_loc4_,{
            "_scale":1,
            "y":INFO_WINDOW_POINT.y,
            "time":0.45,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_loc4_,{
            "_autoAlpha":1,
            "x":INFO_WINDOW_POINT.x,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_currentTfCurrent,{
            "x":_tempTfCurrentX + TWEEN_DISTANCE,
            "rounded":true,
            "_scale":0.1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_loc5_,{
            "_scale":1,
            "time":0.4,
            "base":TWEEN_BASE,
            "transition":Equations.easeOutBack,
            "transitionParams":{"overshoot":3}
         });
         Tweener.addTween(_loc5_,{
            "x":_tempTfCurrentX,
            "rounded":true,
            "base":TWEEN_BASE
         });
         _currentInfoWindow = _loc4_;
         _currentTfCurrent = _loc5_;
         toggleNanovorScroller(true);
         toggleArrows(Boolean(param3 > 1));
      }
      
      private function onLeftArrowClick(param1:MouseEvent) : void
      {
         _controller.handleLeftArrowClick();
      }
      
      public function handleTreeSelected(param1:int, param2:String) : void
      {
         tfTitle.text = param2.toUpperCase() + " TREE";
         toggleNanovorScroller(false);
      }
      
      private function handleCollectionButtonClick(param1:MouseEvent) : void
      {
         _controller.handleCollectionButtonClick();
      }
      
      private function createInfoWindows() : void
      {
         _infoWindow1 = new InfoWindowTitle();
         _infoWindow1.x = INFO_WINDOW_POINT.x;
         _infoWindow1.y = INFO_WINDOW_POINT.y;
         _infoWindow1.hideSV();
         this.addChild(_infoWindow1);
         _infoWindow2 = new InfoWindowTitle();
         _infoWindow2.x = INFO_WINDOW_POINT.x;
         _infoWindow2.y = INFO_WINDOW_POINT.y;
         _infoWindow2.hideSV();
         this.addChild(_infoWindow2);
      }
      
      private function onRightArrowClick(param1:MouseEvent) : void
      {
         _controller.handleRightArrowClick();
      }
      
      private function toggleArrows(param1:Boolean) : void
      {
         if(param1)
         {
            _arrowLeft.open();
            _arrowRight.open();
         }
         else
         {
            _arrowLeft.close();
            _arrowRight.close();
         }
      }
   }
}

