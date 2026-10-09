package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class ApplicationManifestMetadata implements IApplicationManifestMetadata
   {
      
      private static const LAST_UPDATE_TOKEN:String = "{LastUpdate}";
      
      private static const FILES_TOKEN:String = "{Files}";
      
      private static const METADATA_TEMPLATE:String = "<AppManifestMetadata lastUpdate=\"" + LAST_UPDATE_TOKEN + "\">\n\t<Files>\n" + FILES_TOKEN + "\t</Files>\n</AppManifestMetadata>";
      
      private var _posixFilePath:String;
      
      private var _requiredDownloadCount:int;
      
      private var _files:Dictionary;
      
      private var _fileList:IApplicationFileList;
      
      private var _lastUpdate:Date;
      
      private var _fileOperator:IFileOperator;
      
      public function ApplicationManifestMetadata(param1:IFileOperator, param2:String, param3:IApplicationFileList, param4:Date)
      {
         super();
         _fileOperator = param1;
         _posixFilePath = param2;
         _fileList = param3;
         _lastUpdate = param4;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManifestMetadata: " + param1);
      }
      
      private function generateFilesXMLString() : String
      {
         var _loc2_:IApplicationFile = null;
         var _loc1_:String = "";
         for each(_loc2_ in _fileList.files)
         {
            _loc1_ += "\t\t<File id=\"" + _loc2_.id + "\" CRC=\"" + _loc2_.CRC + "\" />\n";
         }
         return _loc1_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManifestMetadata: " + param1);
      }
      
      private function createXMLString() : String
      {
         var _loc1_:String = METADATA_TEMPLATE.replace(LAST_UPDATE_TOKEN,_lastUpdate.toLocaleString());
         return _loc1_.replace(FILES_TOKEN,generateFilesXMLString());
      }
      
      public function updateFileCRC(param1:String, param2:String) : void
      {
         if(null == param1 || "" == param1)
         {
            throw new Error("UH-OH: fileID = null");
         }
         _lastUpdate = new Date();
         _fileList.files[param1] = new ApplicationFile(null,param1,null,param2);
         log("updated CRC: " + _fileList.files[param1]);
      }
      
      public function writeToFile() : void
      {
         log("writeToFile(): " + _posixFilePath);
         _fileOperator.saveFile(_posixFilePath,createXMLString(),false);
      }
      
      public function get fileList() : IApplicationFileList
      {
         return _fileList;
      }
   }
}

