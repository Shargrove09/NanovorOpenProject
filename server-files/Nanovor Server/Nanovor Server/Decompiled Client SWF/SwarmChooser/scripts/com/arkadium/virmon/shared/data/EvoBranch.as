package com.arkadium.virmon.shared.data
{
   internal class EvoBranch
   {
      
      private var _assetBadges:Array;
      
      private var _destID:int;
      
      private var _ems:Array;
      
      private var _sourceID:int;
      
      private var _accountBadges:Array;
      
      public function EvoBranch(param1:int, param2:int, param3:Array, param4:Array, param5:Array)
      {
         super();
         _sourceID = param1;
         _destID = param2;
         _assetBadges = param3;
         _accountBadges = param4;
         _ems = param5;
      }
      
      public function get assetBadges() : Array
      {
         return _assetBadges;
      }
      
      public function get accountBadges() : Array
      {
         return _accountBadges;
      }
      
      public function get ems() : Array
      {
         return _ems;
      }
      
      public function get sourceID() : int
      {
         return _sourceID;
      }
      
      public function get destID() : int
      {
         return _destID;
      }
   }
}

