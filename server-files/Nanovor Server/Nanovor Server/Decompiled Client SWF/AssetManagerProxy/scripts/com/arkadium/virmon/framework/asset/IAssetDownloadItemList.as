package com.arkadium.virmon.framework.asset
{
   public interface IAssetDownloadItemList
   {
      
      function pop() : IAssetDownloadItem;
      
      function concat(param1:IAssetDownloadItemList) : void;
      
      function get supersededItemsCount() : int;
      
      function get length() : uint;
      
      function removeItem(param1:IAssetDownloadItem) : void;
      
      function getItem(param1:int) : IAssetDownloadItem;
      
      function push(param1:IAssetDownloadItem) : void;
      
      function sort(param1:Function) : Array;
   }
}

