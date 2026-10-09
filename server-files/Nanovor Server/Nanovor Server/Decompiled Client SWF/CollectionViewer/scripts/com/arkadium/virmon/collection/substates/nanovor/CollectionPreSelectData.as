package com.arkadium.virmon.collection.substates.nanovor
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public class CollectionPreSelectData implements ICollectionPreSelectData
   {
      
      private var _preSelectAssetTypeId:int;
      
      private var _preSelectNanovor:INanovor;
      
      public function CollectionPreSelectData()
      {
         super();
      }
      
      public function get preSelectNanovor() : INanovor
      {
         return _preSelectNanovor;
      }
      
      public function setPreSelectAssetTypeId(param1:int) : void
      {
         _preSelectAssetTypeId = param1;
      }
      
      public function get preSelectAssetTypeId() : int
      {
         return _preSelectAssetTypeId;
      }
      
      public function setPreSelectNanovor(param1:INanovor) : void
      {
         _preSelectNanovor = param1;
      }
   }
}

