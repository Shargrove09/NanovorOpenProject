package com.arkadium.virmon.shared.final.components.infowindow
{
   import com.arkadium.virmon.shared.utils.Utils;
   
   internal class TweenProp
   {
      
      private var _ui:InfoWindowStats;
      
      public function TweenProp(param1:InfoWindowStats)
      {
         super();
         _ui = param1;
      }
      
      public function get strength() : int
      {
         return _ui.calcStrength;
      }
      
      public function set strength(param1:int) : void
      {
         _ui.calcStrength = param1;
         _ui.tfStrength.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(_ui.baseStrength,int(param1));
      }
      
      public function set speed(param1:int) : void
      {
         _ui.calcSpeed = param1;
         _ui.tfSpeed.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(_ui.baseSpeed,int(param1));
      }
      
      public function get speed() : int
      {
         return _ui.calcSpeed;
      }
      
      public function set armor(param1:int) : void
      {
         _ui.calcArmor = param1;
         _ui.tfArmor.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(_ui.baseArmor,int(param1));
      }
      
      public function get armor() : int
      {
         return _ui.calcArmor;
      }
   }
}

