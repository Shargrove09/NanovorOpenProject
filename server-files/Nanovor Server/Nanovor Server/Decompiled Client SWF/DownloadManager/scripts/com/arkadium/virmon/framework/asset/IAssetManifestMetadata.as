package com.arkadium.virmon.framework.asset
{
   public interface IAssetManifestMetadata
   {
      
      function set requiredDownloadCount(param1:int) : void;
      
      function writeToFile() : void;
      
      function updateAsset(param1:String, param2:String, param3:String) : void;
      
      function updateManifest(param1:String, param2:String) : void;
      
      function get hasAllRequiredAssets() : Boolean;
      
      function getAssetCRC(param1:String, param2:String) : String;
      
      function getManifestReferenceCRC(param1:String) : String;
   }
}

