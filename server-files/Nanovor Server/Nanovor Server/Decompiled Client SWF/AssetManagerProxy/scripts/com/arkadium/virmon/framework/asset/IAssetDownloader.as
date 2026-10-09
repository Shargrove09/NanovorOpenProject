package com.arkadium.virmon.framework.asset
{
   public interface IAssetDownloader
   {
      
      function downloadBackgroundAssets() : void;
      
      function downloadRequiredAssets() : void;
      
      function downloadPreMinSetAssets() : void;
   }
}

