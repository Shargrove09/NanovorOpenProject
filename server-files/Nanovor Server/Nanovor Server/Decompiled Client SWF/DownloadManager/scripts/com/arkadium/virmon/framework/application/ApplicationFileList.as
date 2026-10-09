package com.arkadium.virmon.framework.application
{
   import flash.utils.Dictionary;
   
   public class ApplicationFileList implements IApplicationFileList
   {
      
      private var _files:Dictionary;
      
      public function ApplicationFileList()
      {
         super();
         _files = new Dictionary();
      }
      
      public function getFile(param1:String) : IApplicationFile
      {
         return _files[param1] as IApplicationFile;
      }
      
      public function addFile(param1:IApplicationFile) : void
      {
         _files[param1.id] = param1;
      }
      
      public function get files() : Dictionary
      {
         return _files;
      }
      
      public function updateCRC(param1:String, param2:String) : Boolean
      {
         if(_files[param1] == null)
         {
            return false;
         }
         (_files[param1] as IApplicationFile).CRC = param2;
         return true;
      }
   }
}

