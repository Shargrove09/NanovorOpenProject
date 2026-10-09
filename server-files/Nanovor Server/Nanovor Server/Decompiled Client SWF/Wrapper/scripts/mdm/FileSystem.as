package mdm
{
   public final class FileSystem
   {
      
      private static var resolver:mdm_FileSystem = null;
      
      public function FileSystem()
      {
         super();
      }
      
      public static function getFileDate(pathToFile:String) : String
      {
         return internal_resolver().getFileDate(pathToFile);
      }
      
      public static function makeFolderUnicode(folderPath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().makeFolderUnicode(folderPath);
      }
      
      public static function loadFile(filePath:String) : String
      {
         return internal_resolver().loadFile(filePath);
      }
      
      public static function copyFolder(copyFrom:String, copyTo:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().copyFolder(copyFrom,copyTo);
      }
      
      public static function saveFileUnicode(filePath:String, dataToSave:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().saveFileUnicode(filePath,dataToSave);
      }
      
      public static function fileExistsUnicode(filePath:String) : Boolean
      {
         return internal_resolver().fileExistsUnicode(filePath);
      }
      
      public static function appendFileUnicode(filePath:String, dataToAdd:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().appendFileUnicode(filePath,dataToAdd);
      }
      
      private static function internal_resolver() : mdm_FileSystem
      {
         if(resolver == null)
         {
            resolver = new mdm_FileSystem();
         }
         return resolver;
      }
      
      public static function saveFileHEX(filePath:String, dataToSave:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().saveFileHEX(filePath,dataToSave);
      }
      
      public static function getCurrentDir() : String
      {
         var s:String = null;
         var myPattern:RegExp = null;
         s = internal_resolver().getCurrentDir();
         myPattern = /\\\\/g;
         return s.replace(myPattern,"\\");
      }
      
      public static function getAssociation(extension:String) : String
      {
         return internal_resolver().getAssociation(extension);
      }
      
      public static function copyFileUnicode(copyFrom:String, copyTo:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().copyFileUnicode(copyFrom,copyTo);
      }
      
      public static function deleteFile(pathToFile:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().deleteFile(pathToFile);
      }
      
      public static function copyFile(copyFrom:String, copyTo:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().copyFile(copyFrom,copyTo);
      }
      
      public static function setFileAttribs(filePath:String, attribute:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setFileAttribs(filePath,attribute);
      }
      
      public static function getFolderSize(folderPath:String) : Number
      {
         return internal_resolver().getFolderSize(folderPath);
      }
      
      public static function findFile(searchCriteria:String) : String
      {
         return internal_resolver().findFile(searchCriteria);
      }
      
      public static function deleteFileUnicode(pathToFile:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().deleteFileUnicode(pathToFile);
      }
      
      public static function getFileAttribs(filePath:String) : Array
      {
         return internal_resolver().getFileAttribs(filePath);
      }
      
      public static function saveFile(filePath:String, dataToSave:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().saveFile(filePath,dataToSave);
      }
      
      public static function getFileCreator(filename:String) : String
      {
         return internal_resolver().getFileCreator(filename);
      }
      
      public static function getFileType(filename:String) : String
      {
         return internal_resolver().getFileType(filename);
      }
      
      public static function nativePathToUnixPath(nativePath:String) : String
      {
         return internal_resolver().nativePathToUnixPath(nativePath);
      }
      
      public static function getFileTime(pathToFile:String) : String
      {
         return internal_resolver().getFileTime(pathToFile);
      }
      
      public static function get BinaryFile() : mdm_BinaryFile
      {
         return internal_resolver().BinaryFile;
      }
      
      public static function deleteFolderUnicode(dir:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().deleteFolderUnicode(dir,syncFlag);
      }
      
      public static function setCurrentDir(newPath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setCurrentDir(newPath);
      }
      
      public static function loadFileHEX(filePath:String) : String
      {
         return internal_resolver().loadFileHEX(filePath);
      }
      
      public static function setCurrentDirUnicode(newPath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setCurrentDirUnicode(newPath);
      }
      
      public static function createShortcut(targetPath:String, startInFolder:String, description:String, iconFilePath:String, iconId:Number, shorcutLinkPath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().createShortcut(targetPath,startInFolder,description,iconFilePath,iconId,shorcutLinkPath);
      }
      
      public static function folderExists(folder:String) : Boolean
      {
         return internal_resolver().folderExists(folder);
      }
      
      public static function folderExistsUnicode(folder:String) : Boolean
      {
         return internal_resolver().folderExistsUnicode(folder);
      }
      
      public static function getFileList(folderPath:String, searchMask:String) : Array
      {
         return internal_resolver().getFileList(folderPath,searchMask);
      }
      
      public static function getFolderList(folderPath:String) : Array
      {
         return internal_resolver().getFolderList(folderPath);
      }
      
      public static function getCurrentDirUnicode() : String
      {
         var s:String = null;
         var myPattern:RegExp = null;
         s = internal_resolver().getCurrentDirUnicode();
         myPattern = /\\\\/g;
         return s.replace(myPattern,"\\");
      }
      
      public static function getFileSize(pathToFile:String) : Number
      {
         return internal_resolver().getFileSize(pathToFile);
      }
      
      public static function appendFile(filePath:String, dataToAdd:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().appendFile(filePath,dataToAdd);
      }
      
      public static function fileExists(filePath:String) : Boolean
      {
         return internal_resolver().fileExists(filePath);
      }
      
      public static function deleteFolder(dir:String, prompt:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().deleteFolder(dir,prompt);
      }
      
      public static function getLongPathName(path:String) : String
      {
         return internal_resolver().getLongPathName(path);
      }
      
      public static function loadFileUnicode(filePath:String) : String
      {
         return internal_resolver().loadFileUnicode(filePath);
      }
      
      public static function makeFolder(folderPath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().makeFolder(folderPath);
      }
      
      public static function getShortPathName(path:String) : String
      {
         return internal_resolver().getShortPathName(path);
      }
      
      public function mdm_FileSystem() : void
      {
      }
   }
}

import flash.utils.ByteArray;
import flash.utils.Proxy;

dynamic class mdm_FileSystem extends mdm_resolver
{
   
   public function mdm_FileSystem()
   {
      super();
      SetClassName("mdm.FileSystem");
      AddObject("BinaryFile",new mdm_BinaryFile());
   }
}

dynamic class internalBinaryFile extends mdm_resolver
{
   
   public function internalBinaryFile()
   {
      super();
      SetClassName("mdm.FileSystem.BinaryFile");
   }
}

dynamic class mdm_BinaryFile extends mdm_resolver
{
   
   private static var resolver:internalBinaryFile = null;
   
   public function mdm_BinaryFile()
   {
      super();
   }
   
   private static function internal_resolver() : internalBinaryFile
   {
      if(resolver == null)
      {
         resolver = new internalBinaryFile();
      }
      return resolver;
   }
   
   public function appendDataBA(filePath:String) : void
   {
      internal_resolver().appendDataBA(filePath);
   }
   
   public function appendData(filePath:String) : void
   {
      internal_resolver().appendData(filePath);
   }
   
   public function writeDataBA(filePath:String) : void
   {
      internal_resolver().writeDataBA(filePath);
   }
   
   public function writeData(filePath:String) : void
   {
      internal_resolver().writeData(filePath);
   }
   
   public function setData(dataToAppend:String) : void
   {
      internal_resolver().setData(dataToAppend);
   }
   
   public function setDataBA(dataToAppend:ByteArray) : void
   {
      var base64:String = null;
      base64 = Base64.encodeByteArray(dataToAppend);
      internal_resolver().setDataBA(base64);
   }
}

final class Base64
{
   
   private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
   
   public function Base64()
   {
      super();
      throw new Error("Base64 class is static container only");
   }
   
   public static function encode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = new ByteArray();
      bytes.writeUTFBytes(data);
      return encodeByteArray(bytes);
   }
   
   public static function decodeToByteArray(data:String) : ByteArray
   {
      var output:ByteArray = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = new ByteArray();
      dataBuffer = new Array(4);
      outputBuffer = new Array(3);
      for(i = 0; i < data.length; i += 4)
      {
         j = 0;
         while(j < 4 && i + j < data.length)
         {
            dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
            j++;
         }
         outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
         outputBuffer[1] = ((dataBuffer[1] & 0x0F) << 4) + ((dataBuffer[2] & 0x3C) >> 2);
         outputBuffer[2] = ((dataBuffer[2] & 3) << 6) + dataBuffer[3];
         for(k = 0; k < outputBuffer.length; k++)
         {
            if(dataBuffer[k + 1] == 64)
            {
               break;
            }
            output.writeByte(outputBuffer[k]);
         }
      }
      output.position = 0;
      return output;
   }
   
   public static function encodeByteArray(data:ByteArray) : String
   {
      var output:String = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = "";
      outputBuffer = new Array(4);
      data.position = 0;
      while(data.bytesAvailable > 0)
      {
         dataBuffer = new Array();
         i = 0;
         while(i < 3 && data.bytesAvailable > 0)
         {
            dataBuffer[i] = data.readUnsignedByte();
            i++;
         }
         outputBuffer[0] = (dataBuffer[0] & 0xFC) >> 2;
         outputBuffer[1] = (dataBuffer[0] & 3) << 4 | dataBuffer[1] >> 4;
         outputBuffer[2] = (dataBuffer[1] & 0x0F) << 2 | dataBuffer[2] >> 6;
         outputBuffer[3] = dataBuffer[2] & 0x3F;
         for(j = dataBuffer.length; j < 3; j++)
         {
            outputBuffer[j + 1] = 64;
         }
         for(k = 0; k < outputBuffer.length; k++)
         {
            output += BASE64_CHARS.charAt(outputBuffer[k]);
         }
      }
      return output;
   }
   
   public static function decode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = decodeToByteArray(data);
      return bytes.readUTFBytes(bytes.length);
   }
}
