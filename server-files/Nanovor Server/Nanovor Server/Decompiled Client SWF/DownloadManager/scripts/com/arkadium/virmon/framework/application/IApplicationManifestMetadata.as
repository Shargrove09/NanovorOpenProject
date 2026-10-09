package com.arkadium.virmon.framework.application
{
   public interface IApplicationManifestMetadata
   {
      
      function get fileList() : IApplicationFileList;
      
      function writeToFile() : void;
      
      function updateFileCRC(param1:String, param2:String) : void;
   }
}

