package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol37")]
   public class GameOverSlotBadgesEmpty extends Sprite
   {
      
      public static const HEIGHT:int = 100;
      
      public static const LINE_WIDTH_START:Number = 0;
      
      private var _slider:GameOverSlotBadgesSlider;
      
      public var mcLine:MovieClip;
      
      public var mcHitArea:MovieClip;
      
      private var _openWidth:Number;
      
      public function GameOverSlotBadgesEmpty(param1:Number = 800)
      {
         super();
         _openWidth = param1;
         mcLine.mouseEnabled = false;
         mcLine.y = HEIGHT - 1;
         mcLine.width = LINE_WIDTH_START;
         _slider = new GameOverSlotBadgesSlider();
         _slider.x = GameOverSlot.WIDTH;
         _slider.width = _openWidth - GameOverSlot.WIDTH;
         this.addChild(_slider);
      }
      
      public function get slider() : GameOverSlotBadgesSlider
      {
         return _slider;
      }
      
      public function close() : void
      {
         Tweener.addTween(mcLine,{
            "width":LINE_WIDTH_START,
            "time":0.5
         });
         slider.close();
      }
      
      public function open() : void
      {
         Tweener.addTween(mcLine,{
            "width":_openWidth - GameOverSlotBadgesSlider.ARROW_SPACE_WIDTH,
            "time":0.5,
            "onComplete":slider.open
         });
      }
      
      public function destroy() : void
      {
         _slider.destroy();
      }
   }
}

