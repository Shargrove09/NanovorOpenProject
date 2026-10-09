package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol8")]
   public class GameOverSlotBadges extends Sprite
   {
      
      public static const HEIGHT:int = 100;
      
      public static const LINE_WIDTH_START:Number = GameOverSlot.WIDTH;
      
      private var _slider:GameOverSlotBadgesSlider;
      
      public var mcHitArea:MovieClip;
      
      private var _isOpen:Boolean;
      
      private var _alert:AlertBubble;
      
      private var _openWidth:Number;
      
      public var mcLine:MovieClip;
      
      public var tfTextGlow:TextField;
      
      public var tfText:TextField;
      
      public function GameOverSlotBadges(param1:String = "", param2:Number = 800)
      {
         super();
         _openWidth = param2;
         mcLine.mouseEnabled = false;
         _isOpen = false;
         tfTextGlow.visible = false;
         mcLine.y = HEIGHT - 1;
         tfText.text = param1;
         tfTextGlow.text = param1;
         mcHitArea.buttonMode = true;
         mcHitArea.useHandCursor = true;
         mcHitArea.addEventListener(MouseEvent.CLICK,onHitAreaClick);
         _slider = new GameOverSlotBadgesSlider();
         _slider.x = GameOverSlot.WIDTH;
         _slider.width = _openWidth - GameOverSlot.WIDTH;
         this.addChild(_slider);
         _alert = new AlertBubble();
         _alert.x = -1 * _alert.width / 2 - 8;
         _alert.y = HEIGHT / 2 - _alert.height / 2;
         _alert.visible = false;
         this.addChild(_alert);
      }
      
      public function destroy() : void
      {
         mcHitArea.removeEventListener(MouseEvent.CLICK,onHitAreaClick);
         _slider.destroy();
      }
      
      public function addBadge(param1:GameOverBadge, param2:Boolean = false) : void
      {
         _slider.addBadge(param1,param2);
      }
      
      public function open() : void
      {
         _isOpen = true;
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_BadgeEntry",true,SoundManagerConst.soundApplicationDomain,true));
         Tweener.addTween(mcLine,{
            "width":_openWidth - GameOverSlotBadgesSlider.ARROW_SPACE_WIDTH,
            "time":0.5,
            "onComplete":_slider.open
         });
      }
      
      public function set alertNumber(param1:int) : void
      {
         if(param1 > 0)
         {
            _alert.visible = true;
            _alert.number = param1;
         }
         else
         {
            _alert.visible = false;
         }
      }
      
      public function get slider() : GameOverSlotBadgesSlider
      {
         return _slider;
      }
      
      private function onHitAreaClick(param1:MouseEvent) : void
      {
         dispatchEvent(new GameOverSlotColumnEvent(GameOverSlotColumnEvent.PLAYER_BADGES_CLICK));
      }
      
      public function set textGlow(param1:Boolean) : void
      {
         tfTextGlow.visible = param1;
      }
      
      public function close() : void
      {
         _isOpen = false;
         Tweener.addTween(mcLine,{
            "width":LINE_WIDTH_START,
            "time":0.5
         });
         _slider.close();
      }
   }
}

