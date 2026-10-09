package com.arkadium.virmon.collection.substates.nanovor.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.collection.substates.nanovor.NanovorBadge;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public class NanovorBadgesSliderComponent extends Sprite
   {
      
      public static const ARROW_SPACE_WIDTH:Number = 80;
      
      public static const HEIGHT:Number = 100;
      
      public static const PIXELS_PER_SECOND:Number = 300;
      
      private static const PADDING:Number = 10;
      
      private var _badgesWide:int = 0;
      
      public var mcRightArrow:GlowArrow;
      
      private var _width:int;
      
      public var mcContainer:MovieClip;
      
      public var mcLeftArrow:GlowArrow;
      
      public var mcContainerMask:MovieClip;
      
      public var mcBG:MovieClip;
      
      private var _numBadges:int = 0;
      
      public var mcNoBadges:MovieClip;
      
      public var mcText:MovieClip;
      
      private var xOffset:Number = 10;
      
      private var _page:int = 1;
      
      public function NanovorBadgesSliderComponent()
      {
         super();
         log("NanovorBadgesSliderComponent() Creating");
         mcText.alpha = 0;
         mcContainer.y = HEIGHT;
         mcLeftArrow.addEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown,false,0,true);
         mcRightArrow.addEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown,false,0,true);
         mcNoBadges.alpha = 0;
         mcNoBadges.visible = false;
      }
      
      private function onLeftMouseDown(param1:MouseEvent) : void
      {
         mcRightArrow.open();
         --_page;
         if(_page <= 1)
         {
            mcLeftArrow.close();
         }
         var _loc2_:Number = ARROW_SPACE_WIDTH - (_page - 1) * _width;
         Tweener.addTween(mcContainer,{
            "x":_loc2_,
            "time":0.25,
            "transition":"easeOutQuad",
            "rounded":true
         });
      }
      
      public function addBadge(param1:NanovorBadge) : void
      {
         param1.x = xOffset;
         param1.y = 15 + param1.height;
         mcContainer.addChild(param1);
         xOffset += NanovorBadge.WIDTH + PADDING;
         param1.addEventListener(MouseEvent.ROLL_OVER,onBadgeRollOver,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,onBadgeRollOut,false,0,true);
         ++_numBadges;
         Tweener.addTween(param1,{
            "y":15,
            "time":0.5
         });
         if(param1.isNewBadge)
         {
            param1.x = PADDING;
            shiftBadges(param1);
         }
      }
      
      public function open() : void
      {
         refresh();
         Tweener.addTween(mcContainer,{
            "y":0,
            "time":0.5
         });
      }
      
      private function shiftBadges(param1:NanovorBadge) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < mcContainer.numChildren)
         {
            if(mcContainer.getChildAt(_loc2_) is NanovorBadge && mcContainer.getChildAt(_loc2_) != param1)
            {
               mcContainer.getChildAt(_loc2_).x = mcContainer.getChildAt(_loc2_).x + (NanovorBadge.WIDTH + PADDING);
            }
            _loc2_++;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         _badgesWide = param1;
         _width = param1 * (NanovorBadge.WIDTH + PADDING);
         var _loc2_:* = _width + ARROW_SPACE_WIDTH * 2;
         mcBG.width = _loc2_ + ARROW_SPACE_WIDTH;
         mcContainerMask.width = _loc2_ - ARROW_SPACE_WIDTH * 2 + PADDING;
         mcRightArrow.x = _loc2_ - (ARROW_SPACE_WIDTH - mcRightArrow.width) / 2;
      }
      
      public function refresh() : void
      {
         if(_page >= _numBadges / _badgesWide)
         {
            mcRightArrow.close();
            mcLeftArrow.close();
            mcContainer.x = mcContainerMask.x;
         }
         else
         {
            mcContainer.x = mcContainerMask.x;
            mcRightArrow.open();
            mcLeftArrow.close();
         }
         Tweener.addTween(mcNoBadges,{
            "_autoAlpha":(_numBadges == 0 ? 1 : 0),
            "time":1
         });
      }
      
      private function onBadgeRollOver(param1:MouseEvent) : void
      {
         var _loc2_:NanovorBadge = param1.target as NanovorBadge;
         var _loc3_:IBadgeData = _loc2_.badgeData;
         mcText.tfTitle.text = _loc3_.sName;
         mcText.tfDescription.text = _loc3_.sLongDescription;
         var _loc4_:Number = mcContainer.x + _loc2_.x + NanovorBadge.WIDTH / 2 - 80;
         if(mcText.alpha == 0)
         {
            mcText.x = _loc4_ - 10;
         }
         Tweener.addTween(mcText,{
            "_autoAlpha":1,
            "x":_loc4_,
            "time":1
         });
         _loc2_.open();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorBadgesSliderComponent: " + param1);
      }
      
      private function onRightMouseDown(param1:MouseEvent) : void
      {
         mcLeftArrow.open();
         ++_page;
         if(_page >= _numBadges / _badgesWide)
         {
            mcRightArrow.close();
         }
         var _loc2_:Number = ARROW_SPACE_WIDTH - (_page - 1) * _width;
         Tweener.addTween(mcContainer,{
            "x":_loc2_,
            "time":0.25,
            "transition":"easeOutQuad",
            "rounded":true
         });
      }
      
      public function clearBadges() : void
      {
         var _loc1_:NanovorBadge = null;
         while(mcContainer.numChildren > 0)
         {
            _loc1_ = mcContainer.getChildAt(0) as NanovorBadge;
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,onBadgeRollOver);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,onBadgeRollOut);
            mcContainer.removeChildAt(0);
         }
         _page = 1;
         xOffset = PADDING;
         _numBadges = 0;
      }
      
      private function onBadgeRollOut(param1:MouseEvent) : void
      {
         Tweener.addTween(mcText,{
            "_autoAlpha":0,
            "time":1
         });
         var _loc2_:NanovorBadge = param1.target as NanovorBadge;
         _loc2_.close();
      }
      
      public function close() : void
      {
         mcLeftArrow.close();
         mcRightArrow.close();
         Tweener.addTween(mcContainer,{
            "y":HEIGHT,
            "time":0.5
         });
      }
      
      public function destroy() : void
      {
         clearBadges();
         mcLeftArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown);
         mcRightArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorBadgesSliderComponent: " + param1);
      }
   }
}

