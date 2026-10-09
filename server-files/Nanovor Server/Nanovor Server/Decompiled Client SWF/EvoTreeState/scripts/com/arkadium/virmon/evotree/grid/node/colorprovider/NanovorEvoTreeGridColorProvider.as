package com.arkadium.virmon.evotree.grid.node.colorprovider
{
   import fl.motion.AdjustColor;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   
   public class NanovorEvoTreeGridColorProvider implements IEvoTreeGridColorProvider
   {
      
      private static var _cantEvolveFilter:BitmapFilter;
      
      private static const LINE_COLOR_CAN_EVOLVE:uint = 10087423;
      
      private static const LINE_COLOR_CANT_EVOLVE:uint = 3355443;
      
      private static const LINE_COLOR_INACTIVE:uint = 801369;
      
      private static const LINE_COLOR_ACTIVE:uint = 10087423;
      
      public function NanovorEvoTreeGridColorProvider()
      {
         var _loc1_:AdjustColor = null;
         super();
         if(null == _cantEvolveFilter)
         {
            _loc1_ = new AdjustColor();
            _loc1_.brightness = 0;
            _loc1_.contrast = 0;
            _loc1_.saturation = -100;
            _loc1_.hue = 0;
            _cantEvolveFilter = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         }
      }
      
      public function get lineColorInactive() : uint
      {
         return LINE_COLOR_INACTIVE;
      }
      
      public function get puckCantEvolveFilter() : BitmapFilter
      {
         return _cantEvolveFilter;
      }
      
      public function get lineColorCantevolve() : uint
      {
         return LINE_COLOR_CANT_EVOLVE;
      }
      
      public function get lineColorDefault() : uint
      {
         return LINE_COLOR_INACTIVE;
      }
      
      public function get lineColorActive() : uint
      {
         return LINE_COLOR_ACTIVE;
      }
      
      public function get lineColorCanEvolve() : uint
      {
         return LINE_COLOR_CAN_EVOLVE;
      }
   }
}

