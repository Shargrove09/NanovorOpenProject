package com.arkadium.virmon.framework.application
{
   public class ApplicationManifest implements IApplicationManifest
   {
      
      private var _packageList:ApplicationPackageList;
      
      private var _fileList:ApplicationFileList;
      
      public function ApplicationManifest(param1:IApplicationManifestMetadata)
      {
         super();
         _packageList = new ApplicationPackageList();
         _fileList = new ApplicationFileList();
      }
      
      public function get fileList() : IApplicationFileList
      {
         return _fileList;
      }
      
      public function get packageList() : IApplicationPackageList
      {
         return _packageList;
      }
   }
}

