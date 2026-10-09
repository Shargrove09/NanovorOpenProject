package com.arkadium.virmon.shared.data
{
   public class JoltsInfo
   {
      
      private var _strengthJolts:int;
      
      private var _healthJolts:int;
      
      private var _armorJolts:int;
      
      private var _speedJolts:int;
      
      public function JoltsInfo(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         _healthJolts = param1;
         _armorJolts = param2;
         _strengthJolts = param3;
         _speedJolts = param4;
      }
      
      public function toString() : String
      {
         return "\n" + "Health Jolts: " + _healthJolts + "\n" + "Armor Jolts: " + _armorJolts + "\n" + "Strength Jolts: " + _strengthJolts + "\n" + "Speed Jolts: " + _speedJolts + "\n";
      }
      
      public function get strengthJolts() : int
      {
         return _strengthJolts;
      }
      
      public function get armorJolts() : int
      {
         return _armorJolts;
      }
      
      public function get healthJolts() : int
      {
         return _healthJolts;
      }
      
      public function equals(param1:JoltsInfo) : Boolean
      {
         if(_healthJolts != param1.healthJolts)
         {
            return false;
         }
         if(_armorJolts != param1.armorJolts)
         {
            return false;
         }
         if(_strengthJolts != param1.strengthJolts)
         {
            return false;
         }
         if(_speedJolts != param1.speedJolts)
         {
            return false;
         }
         return true;
      }
      
      public function plus(param1:JoltsInfo) : JoltsInfo
      {
         return new JoltsInfo(_healthJolts + param1.healthJolts,_armorJolts + param1.armorJolts,_strengthJolts + param1.strengthJolts,_speedJolts + param1.speedJolts);
      }
      
      public function get speedJolts() : int
      {
         return _speedJolts;
      }
   }
}

