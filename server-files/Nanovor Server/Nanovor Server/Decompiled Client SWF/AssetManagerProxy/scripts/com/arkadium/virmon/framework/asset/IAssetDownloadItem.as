package com.arkadium.virmon.framework.asset
{
   public interface IAssetDownloadItem
   {
      
      function set priority(param1:int) : void;
      
      function get priority() : int;
      
      function get asset() : IAsset;
   }
}

