package com.arkadium.virmon.evotree.grid.gridinfo.model
{
   public interface IEvoTreeGridInfoModel
   {
      
      function gotoCollection() : void;
      
      function selectPreviousNanovor() : void;
      
      function selectNextNanovor() : void;
      
      function addConsumer(param1:IEvoTreeGridInfoModelConsumer) : void;
   }
}

