package com.arkadium.virmon.framework.application
{
   public class ApplicationDownloadItem implements IApplicationDownloadItem
   {
      
      private var _priority:int;
      
      private var _packageList:IApplicationPackageList;
      
      private var _file:IApplicationFile;
      
      public function ApplicationDownloadItem(param1:IApplicationFile, param2:IApplicationPackageList)
      {
         super();
         _file = param1;
         _packageList = param2;
         _priority = int.MAX_VALUE;
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function set priority(param1:int) : void
      {
         _priority = param1;
      }
      
      public function get packageList() : IApplicationPackageList
      {
         return _packageList;
      }
      
      public function get file() : IApplicationFile
      {
         return _file;
      }
   }
}

