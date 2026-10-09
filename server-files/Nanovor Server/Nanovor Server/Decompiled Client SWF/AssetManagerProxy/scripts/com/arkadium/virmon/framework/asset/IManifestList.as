package com.arkadium.virmon.framework.asset
{
   public interface IManifestList
   {
      
      function addManifest(param1:IAssetManifest) : void;
      
      function getManifest(param1:String) : IAssetManifest;
      
      function get length() : uint;
   }
}

