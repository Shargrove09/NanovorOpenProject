package com.arkadium.virmon.framework.asset
{
   import flash.utils.Dictionary;
   
   public interface IAssetManifest
   {
      
      function get fileName() : String;
      
      function get manifestType() : ManifestType;
      
      function get parent() : IAssetManifest;
      
      function get name() : String;
      
      function get assetManifestMetadata() : IAssetManifestMetadata;
      
      function getGroupByName(param1:String) : IAssetGroup;
      
      function get CRC() : String;
      
      function get superManifestName() : String;
      
      function getFullFolderPath() : String;
      
      function get groupList() : Dictionary;
      
      function addGroup(param1:IAssetGroup) : void;
   }
}

