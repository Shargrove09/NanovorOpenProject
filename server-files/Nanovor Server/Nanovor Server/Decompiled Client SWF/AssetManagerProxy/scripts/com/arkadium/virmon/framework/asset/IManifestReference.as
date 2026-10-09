package com.arkadium.virmon.framework.asset
{
   public interface IManifestReference
   {
      
      function get isPreMinSet() : Boolean;
      
      function get isOutdated() : Boolean;
      
      function get CRC() : String;
      
      function get superManifestName() : String;
      
      function get fileName() : String;
      
      function get manifestType() : ManifestType;
      
      function get name() : String;
      
      function get parentAssetManifest() : IAssetManifest;
      
      function updateManifestReferenceInMetadata() : void;
   }
}

