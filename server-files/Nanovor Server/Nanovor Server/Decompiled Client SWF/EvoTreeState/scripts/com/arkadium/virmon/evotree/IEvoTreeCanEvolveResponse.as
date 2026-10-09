package com.arkadium.virmon.evotree
{
   public interface IEvoTreeCanEvolveResponse
   {
      
      function get aquiredAccountBadges() : Array;
      
      function get requiredAssetBadges() : Array;
      
      function get aquiredAssetBadges() : Array;
      
      function get aquiredEMs() : Array;
      
      function get destinationName() : String;
      
      function get destinationTypeId() : int;
      
      function get requiredEMs() : Array;
      
      function canEvolve() : Boolean;
      
      function get requiredAccountBadges() : Array;
   }
}

