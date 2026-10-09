package com.arkadium.virmon.framework.asset
{
   public interface IManifestComparator
   {
      
      function get preMinSetDownloadList() : IAssetDownloadItemList;
      
      function get requiredDownloadList() : IAssetDownloadItemList;
      
      function get optionalDownloadList() : IAssetDownloadItemList;
      
      function compareManifests(param1:IManifestList, param2:IManifestList) : void;
   }
}

