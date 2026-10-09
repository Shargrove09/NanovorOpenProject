package com.arkadium.virmon.framework.asset
{
   public interface IAssetManagerProxy
   {
      
      function addManifest(param1:IAssetManifest) : void;
      
      function downloadBackgroundAssets() : void;
      
      function downloadRequiredAssets() : void;
      
      function loadNextManifest(param1:Array) : void;
   }
}

