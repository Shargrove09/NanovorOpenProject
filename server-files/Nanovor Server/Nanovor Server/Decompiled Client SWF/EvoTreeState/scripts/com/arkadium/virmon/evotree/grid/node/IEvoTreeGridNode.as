package com.arkadium.virmon.evotree.grid.node
{
   import com.arkadium.virmon.framework.EvoData;
   import flash.display.Sprite;
   
   public interface IEvoTreeGridNode
   {
      
      function setSource(param1:IEvoTreeGridNode) : void;
      
      function get sprite() : Sprite;
      
      function setEvoData(param1:EvoData) : void;
      
      function get xOffset() : int;
      
      function setDestination(param1:IEvoTreeGridNode) : void;
      
      function setLineColor(param1:uint) : void;
      
      function get positionX() : int;
      
      function get positionY() : int;
      
      function getEvoData() : EvoData;
      
      function get destinations() : Array;
      
      function setOffset(param1:int) : void;
      
      function get source() : IEvoTreeGridNode;
      
      function drawLineToParent(param1:Number = 1) : void;
   }
}

