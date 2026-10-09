package com.arkadium.virmon.evotree.grid.node
{
   import com.arkadium.virmon.framework.EvoData;
   import flash.display.Sprite;
   
   public class EvoTreeGridNode implements IEvoTreeGridNode
   {
      
      protected var _destinations:Array;
      
      protected var _positionX:int;
      
      protected var _positionY:int;
      
      protected var _lineColor:uint;
      
      protected var _sprite:Sprite;
      
      protected var _evoData:EvoData;
      
      protected var _xOffset:int;
      
      protected var _source:IEvoTreeGridNode;
      
      public function EvoTreeGridNode(param1:int, param2:int, param3:uint = 16777215)
      {
         super();
         _destinations = new Array();
         _xOffset = 0;
         _positionX = param1;
         _positionY = param2;
         _lineColor = param3;
         _sprite = new Sprite();
         _sprite.mouseEnabled = false;
      }
      
      public function get sprite() : Sprite
      {
         return _sprite;
      }
      
      public function setLineColor(param1:uint) : void
      {
         _lineColor = param1;
      }
      
      public function setDestination(param1:IEvoTreeGridNode) : void
      {
         _destinations.push(param1);
      }
      
      public function setOffset(param1:int) : void
      {
         var _loc2_:IEvoTreeGridNode = null;
         _xOffset = param1;
         for each(_loc2_ in _destinations)
         {
            _loc2_.setOffset(param1);
         }
      }
      
      public function get positionX() : int
      {
         return _positionX;
      }
      
      public function setSource(param1:IEvoTreeGridNode) : void
      {
         _source = param1;
      }
      
      public function get destinations() : Array
      {
         return _destinations;
      }
      
      public function setEvoData(param1:EvoData) : void
      {
         _evoData = param1;
      }
      
      public function get positionY() : int
      {
         return _positionY;
      }
      
      public function get source() : IEvoTreeGridNode
      {
         return _source;
      }
      
      public function get xOffset() : int
      {
         return _xOffset;
      }
      
      public function drawLineToParent(param1:Number = 1) : void
      {
         if(null == _source)
         {
            return;
         }
         var _loc2_:Sprite = _source.sprite;
         if(null != _loc2_ && null != _sprite)
         {
            _sprite.graphics.clear();
            _sprite.graphics.lineStyle(4,_lineColor,param1);
            _sprite.graphics.lineTo(_loc2_.x - _sprite.x,_loc2_.y - _sprite.y);
         }
      }
      
      public function getEvoData() : EvoData
      {
         return _evoData;
      }
   }
}

