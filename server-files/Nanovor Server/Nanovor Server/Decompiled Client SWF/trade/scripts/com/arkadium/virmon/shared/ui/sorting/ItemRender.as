package com.arkadium.virmon.shared.ui.sorting
{
   import flash.display.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol70")]
   public class ItemRender extends MovieClip
   {
      
      private static const _HIT_WIDTH:int = 81;
      
      private static const _HIT_HEIGHT:int = 16;
      
      private static const _HIT_X:int = 3;
      
      private static const _HIT_Y:int = 4;
      
      public var _tfLabel:TextField;
      
      private var _uiID:uint = 0;
      
      public var _mcCell:MovieClip;
      
      public var mcHit:MovieClip;
      
      public function ItemRender()
      {
         super();
         makeHitArea();
         _mcCell.mouseEnabled = false;
         _mcCell.mouseChildren = false;
         _tfLabel.mouseEnabled = false;
      }
      
      public function enableHitArea() : void
      {
         mcHit.useHandCursor = true;
         mcHit.buttonMode = true;
         _mcCell.mouseEnabled = false;
         _mcCell.mouseChildren = false;
         _tfLabel.mouseEnabled = false;
      }
      
      override public function get height() : Number
      {
         return _mcCell.height;
      }
      
      private function makeHitArea() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(65535,0);
         _loc1_.graphics.drawRect(_HIT_X,_HIT_Y,_HIT_WIDTH,_HIT_HEIGHT);
         _loc1_.graphics.endFill();
         mcHit = new MovieClip();
         mcHit.addChildAt(_loc1_,0);
         mcHit.id = _uiID;
         addChild(mcHit);
         enableHitArea();
      }
      
      public function set id(param1:uint) : void
      {
         _uiID = param1;
      }
      
      public function disableHitArea() : void
      {
         mcHit.useHandCursor = false;
         mcHit.buttonMode = false;
      }
      
      public function set text(param1:String) : void
      {
         _tfLabel.htmlText = param1;
      }
      
      public function get id() : uint
      {
         return _uiID;
      }
   }
}

