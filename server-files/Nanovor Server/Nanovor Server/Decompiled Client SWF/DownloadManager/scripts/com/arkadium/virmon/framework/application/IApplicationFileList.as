package com.arkadium.virmon.framework.application
{
   import flash.utils.Dictionary;
   
   public interface IApplicationFileList
   {
      
      function getFile(param1:String) : IApplicationFile;
      
      function updateCRC(param1:String, param2:String) : Boolean;
      
      function addFile(param1:IApplicationFile) : void;
      
      function get files() : Dictionary;
   }
}

