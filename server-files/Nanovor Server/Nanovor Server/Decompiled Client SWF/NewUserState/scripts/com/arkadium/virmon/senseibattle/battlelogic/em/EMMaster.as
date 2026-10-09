package com.arkadium.virmon.senseibattle.battlelogic.em
{
   public class EMMaster
   {
      
      private var _assetValue:int;
      
      private var _assetTypeId:int;
      
      public function EMMaster()
      {
         super();
      }
      
      public function setAssetTypeId(param1:int) : void
      {
         _assetTypeId = param1;
      }
      
      public function setAssetValue(param1:int) : void
      {
         _assetValue = param1;
      }
      
      public function parseEM(param1:XML) : void
      {
         _assetTypeId = Number(param1.child("asset-type-id"));
         _assetValue = Number(param1.child("asset-value"));
      }
      
      public function getAssetValue() : int
      {
         return _assetValue;
      }
      
      public function getAssetTypeId() : int
      {
         return _assetTypeId;
      }
   }
}

