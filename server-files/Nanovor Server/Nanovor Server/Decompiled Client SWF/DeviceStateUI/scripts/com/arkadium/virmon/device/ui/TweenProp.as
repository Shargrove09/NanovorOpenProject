package com.arkadium.virmon.device.ui
{
   import com.arkadium.virmon.shared.utils.Utils;
   
   internal class TweenProp
   {
      
      private static const JOLTS_VALUE_LENGTH:int = 6;
      
      private var _joltsSpeed:int;
      
      private var _joltsHealth:int;
      
      private var _joltsStrength:int;
      
      private var _ui:DeviceJoltsAwards;
      
      private var _joltsArmor:int;
      
      public function TweenProp(param1:DeviceJoltsAwards)
      {
         super();
         _ui = param1;
      }
      
      public function get joltsSpeed() : int
      {
         return _joltsSpeed;
      }
      
      public function get joltsHealth() : int
      {
         return _joltsHealth;
      }
      
      public function set joltsHealth(param1:int) : void
      {
         _joltsHealth = param1;
         _ui.tfHealthJolts.text = Utils.zeroPreFill(param1,JOLTS_VALUE_LENGTH);
      }
      
      public function set joltsSpeed(param1:int) : void
      {
         _joltsSpeed = param1;
         _ui.tfSpeedJolts.text = Utils.zeroPreFill(param1,JOLTS_VALUE_LENGTH);
      }
      
      public function get joltsStrength() : int
      {
         return _joltsStrength;
      }
      
      public function set joltsArmor(param1:int) : void
      {
         _joltsArmor = param1;
         _ui.tfArmorJolts.text = Utils.zeroPreFill(param1,JOLTS_VALUE_LENGTH);
      }
      
      public function set joltsStrength(param1:int) : void
      {
         _joltsStrength = param1;
         _ui.tfStrengthJolts.text = Utils.zeroPreFill(param1,JOLTS_VALUE_LENGTH);
      }
      
      public function get joltsArmor() : int
      {
         return _joltsArmor;
      }
   }
}

