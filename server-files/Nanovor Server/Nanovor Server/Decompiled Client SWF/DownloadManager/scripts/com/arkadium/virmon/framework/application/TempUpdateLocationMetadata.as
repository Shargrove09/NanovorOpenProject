package com.arkadium.virmon.framework.application
{
   import com.adobe.utils.DictionaryUtil;
   import com.arkadium.virmon.framework.application.enum.ApplicationLocation;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class TempUpdateLocationMetadata implements ITempUpdateLocationMetadata
   {
      
      private static const FILES_TOKEN:String = "{Files}";
      
      private static const METADATA_TEMPLATE:String = "<Updates>\n\t<Files>\n" + FILES_TOKEN + "\t</Files>\n</Updates>";
      
      private var _fileList:IApplicationFileList;
      
      private var _fileOperator:IFileOperator;
      
      public function TempUpdateLocationMetadata(param1:IFileOperator)
      {
         super();
         _fileOperator = param1;
         _fileList = new ApplicationFileList();
      }
      
      public function parseMetadata() : void
      {
         var _loc2_:XML = null;
         if(false == _fileOperator.doesFileExist(_metadataFilePath))
         {
            logError("parseMetadata(): metadata file not found.");
            return;
         }
         var _loc1_:XML = new XML(_fileOperator.loadFile(_metadataFilePath));
         for each(_loc2_ in _loc1_..File)
         {
            _fileList.addFile(new ApplicationFile(null,String(_loc2_.@id),String(_loc2_.@filename),String(_loc2_.@CRC)));
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> TempUpdateLocationMetadata: " + param1);
      }
      
      private function generateFilesXMLString() : String
      {
         var _loc2_:IApplicationFile = null;
         var _loc1_:String = "";
         for each(_loc2_ in _fileList.files)
         {
            _loc1_ += "\t\t<File id=\"" + _loc2_.id + "\" CRC=\"" + _loc2_.CRC + "\" filename=\"" + _loc2_.filename + "\" />\r\n";
         }
         return _loc1_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** TempUpdateLocationMetadata: " + param1);
      }
      
      private function createXMLString() : String
      {
         var _loc1_:String = METADATA_TEMPLATE;
         return _loc1_.replace(FILES_TOKEN,generateFilesXMLString());
      }
      
      private function get _metadataFilePath() : String
      {
         return Environment.posixToLocalPath(ApplicationLocation.TEMP_DIRECTORY + "/" + ApplicationLocation.TEMP_METADATA_FILE_NAME);
      }
      
      public function get fileList() : IApplicationFileList
      {
         return _fileList;
      }
      
      public function writeToDisk() : void
      {
         if(DictionaryUtil.getValues(_fileList.files).length == 0)
         {
            _fileOperator.deleteFile(_metadataFilePath);
            return;
         }
         _fileOperator.saveFile(_metadataFilePath,createXMLString(),false);
      }
   }
}

