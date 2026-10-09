package com.arkadium.virmon.framework.asset
{
   public interface IAssetGroup
   {
      
      function getDefaultAsset() : IAsset;
      
      function get manifest() : IAssetManifest;
      
      function get name() : String;
      
      function getAssetById(param1:String) : IAsset;
      
      function get redundant() : Boolean;
      
      function get assetList() : Array;
      
      function addAsset(param1:IAsset) : void;
   }
}

