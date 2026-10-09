package com.arkadium.virmon.collection.substates.ems.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.collection.substates.ems.EMNanovorStageEvent;
   import com.arkadium.virmon.collection.substates.ems.EMNanovorView;
   import com.arkadium.virmon.collection.substates.ems.elements.NoNanovorElement;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol98")]
   public class EMNanovorStageComponent extends Sprite
   {
      
      private static const ARROW_SPACE_WIDTH:Number = 80;
      
      private static const BASE_POSITION:int = 100;
      
      private static const OFFSET:int = 50;
      
      private static const NO_NANOVOR_POSITION:Point = new Point(430,70);
      
      public var mcRightArrow:GlowArrow;
      
      private var _height:int = 400;
      
      private var _width:int = 1024;
      
      private var _perPage:int = 4;
      
      public var mcLeftArrow:GlowArrow;
      
      private var spContainer:Sprite;
      
      private var spMask:Sprite;
      
      private var _page:int = 1;
      
      public var _noNanovors:NoNanovorElement;
      
      private var _pageWidth:int = _width - 2 * BASE_POSITION;
      
      public function EMNanovorStageComponent()
      {
         super();
         mcRightArrow.x = _width - mcLeftArrow.x;
         mcLeftArrow.x = OFFSET;
         spContainer = new Sprite();
         addChild(spContainer);
         _noNanovors = new NoNanovorElement();
         _noNanovors.x = NO_NANOVOR_POSITION.x;
         _noNanovors.y = NO_NANOVOR_POSITION.y;
         addChild(_noNanovors);
         makeMask();
         refresh();
         mcLeftArrow.addEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown,false,0,true);
         mcRightArrow.addEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown,false,0,true);
      }
      
      private function onLeftMouseDown(param1:MouseEvent) : void
      {
         mcRightArrow.open();
         --_page;
         if(_page <= 1)
         {
            mcLeftArrow.close();
         }
         var _loc2_:Number = OFFSET + BASE_POSITION - (_page - 1) * _pageWidth;
         Tweener.addTween(spContainer,{
            "x":_loc2_,
            "time":0.25,
            "transition":"linear"
         });
      }
      
      public function addNanovor(param1:EMNanovorView) : void
      {
         spContainer.addChild(param1);
         refresh();
         param1.addEventListener(EMNanovorView.CLICK,onNanovorClick,false,0,true);
      }
      
      public function destroy() : void
      {
         mcLeftArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown);
         mcRightArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown);
         clearEMNanovorViews();
      }
      
      public function clear() : void
      {
         clearEMNanovorViews();
         refresh();
         _page = 1;
      }
      
      public function refresh() : void
      {
         spContainer.x = spMask.x + OFFSET;
         _noNanovors.visible = false;
         var _loc1_:int = spContainer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            spContainer.getChildAt(_loc2_).x = _loc2_ * _pageWidth / _perPage;
            _loc2_++;
         }
         if(_page >= spContainer.numChildren / _perPage)
         {
            mcRightArrow.close();
            mcLeftArrow.close();
         }
         else
         {
            mcRightArrow.open();
            mcLeftArrow.close();
         }
      }
      
      private function clearEMNanovorViews() : void
      {
         var _loc1_:EMNanovorView = null;
         while(spContainer.numChildren > 0)
         {
            _loc1_ = EMNanovorView(spContainer.getChildAt(0));
            spContainer.removeChild(_loc1_);
            _loc1_.destroy();
            _loc1_.removeEventListener(EMNanovorView.CLICK,onNanovorClick);
         }
      }
      
      private function onNanovorClick(param1:Event) : void
      {
         var _loc2_:EMNanovorView = EMNanovorView(param1.target);
         dispatchEvent(new EMNanovorStageEvent(EMNanovorStageEvent.NANOVOR_CLICKED,_loc2_.assetTypeId,true));
      }
      
      public function showNoNanovor() : void
      {
         _noNanovors.visible = true;
         _noNanovors.gotoAndPlay(15);
      }
      
      private function onRightMouseDown(param1:MouseEvent) : void
      {
         mcLeftArrow.open();
         ++_page;
         if(_page >= spContainer.numChildren / _perPage)
         {
            mcRightArrow.close();
         }
         var _loc2_:Number = OFFSET + BASE_POSITION - (_page - 1) * _pageWidth;
         Tweener.addTween(spContainer,{
            "x":_loc2_,
            "time":0.25,
            "transition":"linear"
         });
      }
      
      private function makeMask() : void
      {
         spMask = new Sprite();
         spMask.graphics.beginFill(0);
         spMask.graphics.drawRect(0,-100,_pageWidth,_height + 100);
         spMask.x = BASE_POSITION;
         addChild(spMask);
         spContainer.mask = spMask;
      }
   }
}

