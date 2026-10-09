package com.arkadium.virmon.shared.utils
{
   import flash.utils.ByteArray;
   
   public interface IFileOperator
   {
      
      function saveFile(param1:String, param2:String, param3:Boolean = true) : void;
      
      function deleteAllFiles(param1:String, param2:Function) : void;
      
      function doesFileExist(param1:String) : Boolean;
      
      function copyFolder(param1:String, param2:String, param3:Function, param4:String = "") : void;
      
      function getFolderSize(param1:String) : Number;
      
      function deleteFile(param1:String, param2:Function = null) : void;
      
      function loadFile(param1:String) : String;
      
      function moveFile(param1:String, param2:String, param3:Function = null) : void;
      
      function doesFolderExist(param1:String) : Boolean;
      
      function copyFile(param1:String, param2:String, param3:Function) : void;
      
      function writeByteArray(param1:ByteArray, param2:String) : void;
      
      function destroy() : void;
      
      function getFileList(param1:String, param2:String) : Array;
      
      function deleteFolder(param1:String, param2:Function = null) : void;
      
      function concatenateFiles(param1:String, param2:String, param3:String, param4:Boolean = false, param5:Function = null) : void;
      
      function makeFolder(param1:String, param2:Function = null) : void;
      
      function appendByteArray(param1:ByteArray, param2:String) : void;
   }
}

