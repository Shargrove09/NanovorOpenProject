package com.arkadium.virmon.framework.application
{
   public class ApplicationFile implements IApplicationFile
   {
      
      private var _filename:String;
      
      private var _applicationManifestMetadata:IApplicationManifestMetadata;
      
      private var _CRC:String;
      
      private var _id:String;
      
      public function ApplicationFile(param1:IApplicationManifestMetadata, param2:String, param3:String, param4:String)
      {
         super();
         _applicationManifestMetadata = param1;
         _id = param2;
         _filename = param3;
         _CRC = param4;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get CRC() : String
      {
         return _CRC;
      }
      
      public function get filename() : String
      {
         return _filename;
      }
      
      public function set CRC(param1:String) : void
      {
         _CRC = CRC;
      }
      
      public function toString() : String
      {
         return "[ApplicationFile:IDependency | id=" + id + " | filename=" + filename + " | CRC=" + CRC + "]";
      }
      
      public function get isOutdated() : Boolean
      {
         if(_applicationManifestMetadata == null)
         {
            throw new Error("Cannot check if application file is outdated without a metadata object reference");
         }
         if(_applicationManifestMetadata.fileList.getFile(_id) == null)
         {
            return true;
         }
         return Boolean(_CRC != _applicationManifestMetadata.fileList.getFile(_id).CRC);
      }
   }
}

