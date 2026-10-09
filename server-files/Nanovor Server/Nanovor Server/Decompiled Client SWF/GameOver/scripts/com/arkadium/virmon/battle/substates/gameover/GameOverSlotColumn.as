package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class GameOverSlotColumn extends Sprite
   {
      
      public static const PLACEMENT_1ST:String = "placement1st";
      
      public static const PLACEMENT_2ND:String = "placement2nd";
      
      public static const PLACEMENT_3RD:String = "placement3rd";
      
      public static const PLACEMENT_4TH:String = "placement4th";
      
      public static const PLACEMENT_NONE:String = "placementNone";
      
      private static const TOP_PADDING:int = 150;
      
      private static const ENEMY_PLACEMENT_SCALE:Number = 0.55;
      
      private var _killsSlot:GameOverSlot;
      
      private var _placementSlot:PlacementSlot;
      
      private var _isEnemy:*;
      
      private var _spotlight:Spotlight;
      
      private var _slotContainer:Sprite;
      
      private var _damageSlot:GameOverSlot;
      
      private var _yOffset:Number = 0;
      
      private var _nmpSlot:GameOverSlot;
      
      public function GameOverSlotColumn(param1:Spotlight, param2:Boolean = false)
      {
         super();
         _isEnemy = param2;
         _spotlight = param1;
         _slotContainer = new Sprite();
         _slotContainer.y = TOP_PADDING;
         this.addChild(_slotContainer);
         _placementSlot = new PlacementSlot(new Sprite());
         _placementSlot.y = TOP_PADDING;
         this.addChild(_placementSlot);
         _yOffset += PlacementSlot.HEIGHT;
         if(_isEnemy)
         {
            _placementSlot.color = PlacementSlot.COLOR_RED;
         }
      }
      
      public function open() : void
      {
         Tweener.addTween(this,{
            "alpha":1,
            "time":1
         });
         cascadeOpenSlots();
      }
      
      public function set placementImage(param1:DisplayObject) : void
      {
         param1.visible = true;
         if(_isEnemy)
         {
            param1.scaleX = ENEMY_PLACEMENT_SCALE;
            param1.scaleY = ENEMY_PLACEMENT_SCALE;
         }
         _placementSlot.placementImage = param1;
      }
      
      private function hideSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _slotContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.addTween(_slotContainer.getChildAt(_loc1_),{
               "alpha":0,
               "time":1,
               "delay":0.1 * _loc1_
            });
            _loc1_++;
         }
      }
      
      public function get spotlight() : Spotlight
      {
         return _spotlight;
      }
      
      public function set placementPosition(param1:int) : void
      {
         _placementSlot.place = param1;
      }
      
      private function opened() : void
      {
         dispatchEvent(new GameOverSlotColumnEvent(GameOverSlotColumnEvent.COLUMN_OPENED));
      }
      
      private function closed() : void
      {
         dispatchEvent(new GameOverSlotColumnEvent(GameOverSlotColumnEvent.COLUMN_CLOSED));
      }
      
      public function slidePlacement() : void
      {
         _placementSlot.slidePlacement();
      }
      
      public function cascadeOpenSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _slotContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.addTween(_slotContainer.getChildAt(_loc1_),{
               "alpha":1,
               "time":1,
               "delay":0.1 * _loc1_,
               "transition":"linear"
            });
            _loc1_++;
         }
      }
      
      public function close() : void
      {
         Tweener.addTween(this,{
            "alpha":0,
            "time":1,
            "onComplete":closed
         });
         hideSlots();
      }
      
      public function openPlacement() : void
      {
         _placementSlot.open();
      }
      
      public function addSlot(param1:String) : void
      {
         var _loc2_:GameOverSlot = new GameOverSlot(param1);
         _loc2_.y = _yOffset;
         _loc2_.alpha = 0;
         _slotContainer.addChild(_loc2_);
         _yOffset += GameOverSlot.HEIGHT;
         if(_isEnemy)
         {
            _loc2_.color = GameOverSlot.COLOR_RED;
         }
      }
   }
}

