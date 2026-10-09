package com.arkadium.virmon.evotree
{
   public class EvoTreeCanEvolveResponse implements IEvoTreeCanEvolveResponse
   {
      
      private var _requiredEMs:Array;
      
      private var _aquiredAccountBadges:Array;
      
      private var _aquiredAssetBadges:Array;
      
      private var _requiredAccountBadges:Array;
      
      private var _requiredAssetBadges:Array;
      
      private var _destinationTypeId:int;
      
      private var _destinationName:String;
      
      private var _aquiredEMs:Array;
      
      public function EvoTreeCanEvolveResponse(param1:int, param2:String, param3:Array, param4:Array, param5:Array, param6:Array, param7:Array, param8:Array)
      {
         super();
         _destinationTypeId = param1;
         _destinationName = param2;
         _aquiredAssetBadges = null != param3 ? param3 : [];
         _requiredAssetBadges = null != param4 ? param4 : [];
         _aquiredAccountBadges = null != param5 ? param5 : [];
         _requiredAccountBadges = null != param6 ? param6 : [];
         _aquiredEMs = null != param7 ? param7 : [];
         _requiredEMs = null != param8 ? param8 : [];
      }
      
      public function get destinationName() : String
      {
         return _destinationName;
      }
      
      public function get aquiredAssetBadges() : Array
      {
         return _aquiredAssetBadges;
      }
      
      public function get requiredEMs() : Array
      {
         return _requiredEMs;
      }
      
      public function get destinationTypeId() : int
      {
         return _destinationTypeId;
      }
      
      public function get requiredAccountBadges() : Array
      {
         return _requiredAccountBadges;
      }
      
      public function get requiredAssetBadges() : Array
      {
         return _requiredAssetBadges;
      }
      
      public function get aquiredAccountBadges() : Array
      {
         return _aquiredAccountBadges;
      }
      
      public function get aquiredEMs() : Array
      {
         return _aquiredEMs;
      }
      
      public function canEvolve() : Boolean
      {
         return 0 == _requiredAssetBadges.length && 0 == _requiredAccountBadges.length && 0 == _requiredEMs.length;
      }
   }
}

