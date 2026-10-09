package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol36")]
   public class GameOverSlotBadgesSlider extends Sprite
   {
      
      public static const ARROW_SPACE_WIDTH:Number = 80;
      
      public static const HEIGHT:Number = 100;
      
      public static const PIXELS_PER_SECOND:Number = 300;
      
      private static const PADDING:Number = 10;
      
      public var mcRightArrow:GlowArrow;
      
      public var mcContainer:MovieClip;
      
      public var mcLeftArrow:GlowArrow;
      
      public var mcContainerMask:MovieClip;
      
      private var _numBadges:int = 0;
      
      public var mcBG:MovieClip;
      
      public var mcText:MovieClip;
      
      private var xOffset:Number = 10;
      
      public function GameOverSlotBadgesSlider()
      {
         super();
         mcText.alpha = 0;
         mcContainer.y = mcBG.y = HEIGHT;
         mcLeftArrow.addEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown);
         mcRightArrow.addEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown);
      }
      
      private function onLeftMouseDown(param1:MouseEvent) : void
      {
         mcRightArrow.open();
         mcLeftArrow.addEventListener(MouseEvent.MOUSE_UP,release);
         mcLeftArrow.addEventListener(MouseEvent.ROLL_OUT,release);
         var _loc2_:Number = Math.abs(mcContainer.x - mcContainerMask.x) / PIXELS_PER_SECOND;
         Tweener.addTween(mcContainer,{
            "x":mcContainerMask.x,
            "time":_loc2_,
            "transition":"linear",
            "onComplete":mcLeftArrow.close
         });
      }
      
      public function addBadge(param1:GameOverBadge, param2:Boolean = false) : void
      {
         param1.x = xOffset;
         param1.y = 15;
         mcContainer.addChild(param1);
         xOffset += GameOverBadge.WIDTH + PADDING;
         param1.useHandCursor = false;
         param1.addEventListener(MouseEvent.ROLL_OVER,onBadgeRollOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,onBadgeRollOut);
         ++_numBadges;
         if(param2)
         {
            param1.x = PADDING;
            shiftBadges(param1);
         }
      }
      
      private function release(param1:MouseEvent) : void
      {
         Tweener.removeTweens(mcContainer,x);
         mcLeftArrow.removeEventListener(MouseEvent.MOUSE_UP,release);
         mcLeftArrow.removeEventListener(MouseEvent.ROLL_OUT,release);
         mcRightArrow.removeEventListener(MouseEvent.MOUSE_UP,release);
         mcRightArrow.removeEventListener(MouseEvent.ROLL_OUT,release);
      }
      
      public function open() : void
      {
         refresh();
         Tweener.addTween(mcContainer,{
            "y":0,
            "time":0.5
         });
         Tweener.addTween(mcBG,{
            "y":0,
            "time":0.5
         });
      }
      
      private function shiftBadges(param1:GameOverBadge) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < mcContainer.numChildren)
         {
            if(mcContainer.getChildAt(_loc2_) is GameOverBadge && mcContainer.getChildAt(_loc2_) != param1)
            {
               mcContainer.getChildAt(_loc2_).x = mcContainer.getChildAt(_loc2_).x + (GameOverBadge.WIDTH + PADDING);
            }
            _loc2_++;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         mcBG.width = mcContainerMask.width = param1 - ARROW_SPACE_WIDTH * 2;
         mcRightArrow.x = param1 - (ARROW_SPACE_WIDTH - mcRightArrow.width) / 2;
         mcBG.x = mcContainerMask.x = ARROW_SPACE_WIDTH;
      }
      
      private function onBadgeRollOver(param1:MouseEvent) : void
      {
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_BadgeReveal",true,SoundManagerConst.soundApplicationDomain,true));
         var _loc2_:GameOverBadge = param1.target as GameOverBadge;
         var _loc3_:IBadgeData = _loc2_.badgeData;
         mcText.tfTitle.text = _loc3_.sName;
         mcText.tfDescription.text = _loc3_.sLongDescription;
         var _loc4_:Number = mcContainer.x + _loc2_.x + GameOverBadge.WIDTH / 2 - 80;
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
      
      public function refresh() : void
      {
         if(PADDING + _numBadges * (GameOverBadge.WIDTH + PADDING) < mcContainerMask.width)
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
      }
      
      public function clearBadges() : void
      {
         var _loc1_:GameOverBadge = null;
         while(mcContainer.numChildren > 0)
         {
            _loc1_ = mcContainer.getChildAt(0) as GameOverBadge;
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,onBadgeRollOver);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,onBadgeRollOut);
            mcContainer.removeChildAt(0);
         }
         xOffset = PADDING;
         _numBadges = 0;
      }
      
      private function onRightMouseDown(param1:MouseEvent) : void
      {
         mcLeftArrow.open();
         mcRightArrow.addEventListener(MouseEvent.MOUSE_UP,release);
         mcRightArrow.addEventListener(MouseEvent.ROLL_OUT,release);
         var _loc2_:Number = mcContainerMask.x + mcContainerMask.width - mcContainer.width - PADDING * 2;
         var _loc3_:Number = Math.abs(mcContainer.x - _loc2_) / PIXELS_PER_SECOND;
         Tweener.addTween(mcContainer,{
            "x":_loc2_,
            "time":_loc3_,
            "transition":"linear",
            "onComplete":mcRightArrow.close
         });
      }
      
      private function onBadgeRollOut(param1:MouseEvent) : void
      {
         Tweener.addTween(mcText,{
            "_autoAlpha":0,
            "time":1
         });
         var _loc2_:GameOverBadge = param1.target as GameOverBadge;
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
         Tweener.addTween(mcBG,{
            "y":HEIGHT,
            "time":0.5
         });
      }
      
      public function destroy() : void
      {
         mcLeftArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown);
         mcRightArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown);
         clearBadges();
      }
   }
}

