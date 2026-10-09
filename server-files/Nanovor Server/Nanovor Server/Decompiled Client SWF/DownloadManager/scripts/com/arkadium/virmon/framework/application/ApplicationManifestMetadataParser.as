package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public class ApplicationManifestMetadataParser implements IApplicationManifestMetadataParser
   {
      
      private var _metadataPosixFilePath:String;
      
      private var _fileOperator:IFileOperator;
      
      public function ApplicationManifestMetadataParser(param1:IFileOperator, param2:String)
      {
         super();
         _fileOperator = param1;
         _metadataPosixFilePath = param2;
      }
      
      public function parseMetadata(param1:XML) : IApplicationManifestMetadata
      {
         var _loc3_:XML = null;
         var _loc4_:IApplicationFile = null;
         var _loc2_:ApplicationFileList = new ApplicationFileList();
         if(_fileOperator.doesFileExist(Environment.posixToLocalPath(_metadataPosixFilePath)))
         {
            for each(_loc3_ in param1.Files.File)
            {
               _loc4_ = new ApplicationFile(null,String(_loc3_.@id),null,String(_loc3_.@CRC));
               _loc2_.addFile(_loc4_);
            }
         }
         return new ApplicationManifestMetadata(_fileOperator,_metadataPosixFilePath,_loc2_,new Date());
      }
   }
}

