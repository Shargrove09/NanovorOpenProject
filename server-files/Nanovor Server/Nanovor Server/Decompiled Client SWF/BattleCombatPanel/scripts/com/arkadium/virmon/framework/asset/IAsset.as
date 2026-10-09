package com.arkadium.virmon.framework.asset
{
   public interface IAsset
   {
      
      function get fileName() : String;
      
      function get isPreMinSet() : Boolean;
      
      function updateAssetInManifestMetadata() : void;
      
      function get assetGroup() : IAssetGroup;
      
      function get fullFilePath() : String;
      
      function get isOutdated() : Boolean;
      
      function get CRC() : String;
      
      function get superId() : String;
      
      function get isDefault() : Boolean;
      
      function get type() : uint;
      
      function get id() : String;
   }
}

