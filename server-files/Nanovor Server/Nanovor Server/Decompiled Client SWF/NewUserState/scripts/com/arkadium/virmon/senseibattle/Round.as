package com.arkadium.virmon.senseibattle
{
   public class Round implements IRound
   {
      
      private var _roundResults:Object;
      
      private var _attackResults:Object;
      
      private var _roundInfo:Object;
      
      public function Round(param1:Object, param2:Object, param3:Object)
      {
         super();
         _roundInfo = param1;
         _attackResults = param2;
         _roundResults = param3;
      }
      
      public function get roundInfo() : Object
      {
         return _roundInfo;
      }
      
      public function get roundResults() : Object
      {
         return _roundResults;
      }
      
      public function get attackResults() : Object
      {
         return _attackResults;
      }
   }
}

