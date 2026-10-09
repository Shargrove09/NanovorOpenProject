package com.arkadium.virmon.shared.utils
{
   public interface IDownloader
   {
      
      function abortDownload() : void;
      
      function copyFile(param1:IDownloaderConsumer, param2:String, param3:String, param4:int = 2) : void;
      
      function downloadFile(param1:IDownloaderConsumer, param2:String, param3:String, param4:String = "", param5:int = 2) : void;
   }
}

