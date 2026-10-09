package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   public class Asset
   {
      
      protected var _assetTypeCategory:String;
      
      protected var _assetId:String;
      
      public function Asset()
      {
         super();
      }
      
      public function setAssetId(param1:String) : void
      {
         _assetId = param1;
      }
      
      public function getAssetTypeCategory() : String
      {
         return _assetTypeCategory;
      }
      
      public function getAssetId() : String
      {
         return _assetId;
      }
      
      public function setAssetTypeCategory(param1:String) : void
      {
         _assetTypeCategory = param1;
      }
   }
}

