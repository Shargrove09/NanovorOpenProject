package com.arkadium.virmon.shared.final.components.infowindow
{
   import com.arkadium.virmon.shared.utils.Utils;
   
   internal class TweenProp
   {
      
      private var _ui:InfoWindowStats;
      
      public function TweenProp(param1:InfoWindowStats)
      {
         super();
         this._ui = param1;
      }
      
      public function get strength() : int
      {
         return this._ui.calcStrength;
      }
      
      public function set strength(param1:int) : void
      {
         this._ui.calcStrength = param1;
         this._ui.tfStrength.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(this._ui.baseStrength,int(param1));
      }
      
      public function set speed(param1:int) : void
      {
         this._ui.calcSpeed = param1;
         this._ui.tfSpeed.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(this._ui.baseSpeed,int(param1));
      }
      
      public function get speed() : int
      {
         return this._ui.calcSpeed;
      }
      
      public function set armor(param1:int) : void
      {
         this._ui.calcArmor = param1;
         this._ui.tfArmor.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS) + InfoWindowStats.getDeltaString(this._ui.baseArmor,int(param1));
      }
      
      public function get armor() : int
      {
         return this._ui.calcArmor;
      }
   }
}

