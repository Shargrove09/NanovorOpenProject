package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   
   public interface IApplicationDownloadItemList
   {
      
      function pop() : IApplicationDownloadItem;
      
      function concat(param1:IApplicationDownloadItemList) : void;
      
      function getItemsByPriority(param1:PackagePriority) : IApplicationDownloadItemList;
      
      function get length() : uint;
      
      function removeItem(param1:IApplicationDownloadItem) : void;
      
      function hasDownloadItemsWithPriority(param1:PackagePriority) : Boolean;
      
      function getItem(param1:int) : IApplicationDownloadItem;
      
      function push(param1:IApplicationDownloadItem) : void;
      
      function getItemByFile(param1:IApplicationFile) : IApplicationDownloadItem;
      
      function sort() : Array;
   }
}

