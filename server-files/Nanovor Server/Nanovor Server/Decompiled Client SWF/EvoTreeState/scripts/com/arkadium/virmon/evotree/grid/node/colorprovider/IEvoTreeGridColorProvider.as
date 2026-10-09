package com.arkadium.virmon.evotree.grid.node.colorprovider
{
   import flash.filters.BitmapFilter;
   
   public interface IEvoTreeGridColorProvider
   {
      
      function get lineColorCantevolve() : uint;
      
      function get lineColorDefault() : uint;
      
      function get lineColorActive() : uint;
      
      function get puckCantEvolveFilter() : BitmapFilter;
      
      function get lineColorInactive() : uint;
      
      function get lineColorCanEvolve() : uint;
   }
}

