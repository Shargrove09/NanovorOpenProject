package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol45")]
   public class GameOverSlot extends Sprite
   {
      
      public static const WIDTH:int = 180;
      
      public static const HEIGHT:int = 31;
      
      public static const COLOR_BLUE:uint = 2340070;
      
      public static const COLOR_RED:uint = 16711680;
      
      public var mcLine:MovieClip;
      
      public var tfText:TextField;
      
      public function GameOverSlot(param1:String = "")
      {
         super();
         tfText.text = param1;
      }
      
      public function set text(param1:String) : void
      {
         tfText.text = param1;
      }
      
      public function set color(param1:uint) : void
      {
         Tweener.removeTweens(mcLine,"_color");
         Tweener.addTween(mcLine,{
            "_color":param1,
            "time":1
         });
      }
   }
}

