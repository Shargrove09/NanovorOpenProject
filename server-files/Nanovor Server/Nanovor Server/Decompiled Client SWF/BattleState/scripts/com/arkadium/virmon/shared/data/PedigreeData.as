package com.arkadium.virmon.shared.data
{
   public class PedigreeData implements IPedigreeData
   {
      
      private var _ems:Array;
      
      private var _badges:Array;
      
      private var _sourceName:String;
      
      private var _destName:String;
      
      private var _sourceId:int;
      
      private var _destId:int;
      
      private var _accountBadges:Array;
      
      public function PedigreeData(param1:int, param2:int, param3:String, param4:String, param5:Array, param6:Array, param7:Array)
      {
         super();
         _sourceId = param1;
         _destId = param2;
         _sourceName = _sourceName;
         _destName = param4;
         _badges = param5;
         _accountBadges = param6;
         _ems = param7;
      }
      
      public function get sourceName() : String
      {
         return _sourceName;
      }
      
      public function get ems() : Array
      {
         return _ems;
      }
      
      public function get destName() : String
      {
         return _destName;
      }
      
      public function get sourceId() : int
      {
         return _sourceId;
      }
      
      public function get destId() : int
      {
         return _destId;
      }
      
      public function get badges() : Array
      {
         return _badges;
      }
      
      public function get accountBadges() : Array
      {
         return _accountBadges;
      }
   }
}

