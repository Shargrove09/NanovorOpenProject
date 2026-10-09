package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   
   internal class PlacementSlot extends GameOverSlot
   {
      
      public static const HEIGHT:int = 70;
      
      public static const COLOR_RED:uint = 14949918;
      
      public static const COLOR_BLUE:uint = 1602739;
      
      private static const PLACEMENT_ALLOTED_SPACE:int = -150;
      
      private static const PLACEMENT_OFFSET:int = -50;
      
      private static const GLOW_BLUE:GlowFilter = new GlowFilter(COLOR_BLUE,1,8,8);
      
      private static const GLOW_RED:GlowFilter = new GlowFilter(COLOR_RED,1,6,6);
      
      private static const OPEN_ANIMATION_OFFSET:Number = 50;
      
      private var _placement:int = 0;
      
      private var _glow:GlowFilter;
      
      private var _spotlight:Spotlight;
      
      private var _placementImage:DisplayObject;
      
      public function PlacementSlot(param1:DisplayObject = null, param2:Number = 0)
      {
         super();
         tfText.visible = false;
         mcLine.y = HEIGHT - 1;
         mcLine.alpha = 0;
         _placement = param2;
         this.placementImage = param1;
         this.color = COLOR_BLUE;
      }
      
      private function opened() : void
      {
         this.dispatchEvent(new GameOverSlotColumnEvent(GameOverSlotColumnEvent.COLUMN_PLACEMENT_OPENED,true));
      }
      
      override public function set color(param1:uint) : void
      {
         switch(param1)
         {
            case COLOR_BLUE:
               _glow = GLOW_BLUE;
               super.color = GameOverSlot.COLOR_BLUE;
               break;
            case COLOR_RED:
               _glow = GLOW_RED;
               super.color = GameOverSlot.COLOR_RED;
         }
         _placementImage.filters = [_glow];
      }
      
      public function set place(param1:int) : void
      {
         _placement = param1;
      }
      
      public function slidePlacement() : void
      {
         var _loc1_:Number = PLACEMENT_ALLOTED_SPACE - _placement * PLACEMENT_OFFSET + (HEIGHT - _placementImage.height) / 2;
         Tweener.addTween(_placementImage,{
            "alpha":1,
            "y":_loc1_,
            "time":1,
            "transition":"easeInOutQuad"
         });
      }
      
      public function open() : void
      {
         var _loc1_:int = (HEIGHT - _placementImage.height) / 2;
         _placementImage.y = _loc1_ + OPEN_ANIMATION_OFFSET;
         Tweener.addTween(_placementImage,{
            "alpha":1,
            "y":_loc1_,
            "time":1,
            "transition":"easeInOutQuad",
            "onComplete":opened
         });
         Tweener.addTween(mcLine,{
            "delay":1,
            "alpha":1,
            "time":1,
            "delay":0.25,
            "transition":"easeInOutQuad"
         });
      }
      
      public function set placementImage(param1:DisplayObject) : void
      {
         if(_placementImage != null)
         {
            this.removeChild(_placementImage);
         }
         _placementImage = param1;
         _placementImage.x = (GameOverSlot.WIDTH - _placementImage.width) / 2;
         _placementImage.y = (HEIGHT - _placementImage.height) / 2;
         _placementImage.alpha = 0;
         this.addChild(_placementImage);
         if(_glow != null)
         {
            _placementImage.filters = [_glow];
         }
      }
   }
}

