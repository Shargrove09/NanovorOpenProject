package com.arkadium.virmon.device
{
   public class BattleLogUpdateData
   {
      
      private var _successfulUpdates:int;
      
      private var _deltaNMP:int;
      
      public function BattleLogUpdateData(param1:int, param2:int)
      {
         super();
         _deltaNMP = param1;
         _successfulUpdates = param2;
      }
      
      public function get successfulUpdates() : int
      {
         return _successfulUpdates;
      }
      
      public function get deltaNMP() : int
      {
         return _deltaNMP;
      }
   }
}

