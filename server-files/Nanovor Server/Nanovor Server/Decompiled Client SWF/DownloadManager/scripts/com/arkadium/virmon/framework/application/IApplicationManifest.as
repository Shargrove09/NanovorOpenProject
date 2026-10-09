package com.arkadium.virmon.framework.application
{
   public interface IApplicationManifest
   {
      
      function get fileList() : IApplicationFileList;
      
      function get packageList() : IApplicationPackageList;
   }
}

