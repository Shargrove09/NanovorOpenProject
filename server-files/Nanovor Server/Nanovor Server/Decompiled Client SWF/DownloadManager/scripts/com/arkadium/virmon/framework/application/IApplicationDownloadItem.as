package com.arkadium.virmon.framework.application
{
   public interface IApplicationDownloadItem
   {
      
      function set priority(param1:int) : void;
      
      function get file() : IApplicationFile;
      
      function get priority() : int;
      
      function get packageList() : IApplicationPackageList;
   }
}

