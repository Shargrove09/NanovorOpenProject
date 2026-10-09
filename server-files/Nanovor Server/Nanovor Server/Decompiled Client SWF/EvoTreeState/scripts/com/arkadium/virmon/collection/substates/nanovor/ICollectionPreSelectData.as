package com.arkadium.virmon.collection.substates.nanovor
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface ICollectionPreSelectData
   {
      
      function get preSelectAssetTypeId() : int;
      
      function get preSelectNanovor() : INanovor;
   }
}

