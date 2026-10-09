package com.arkadium.virmon.framework.application
{
   public interface ITempUpdateLocationMetadata
   {
      
      function parseMetadata() : void;
      
      function get fileList() : IApplicationFileList;
      
      function writeToDisk() : void;
   }
}

