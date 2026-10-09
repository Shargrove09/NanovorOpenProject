package com.arkadium.virmon.shared.utils
{
   public interface IDownloaderConsumer
   {
      
      function handleDownloadError(param1:String) : void;
      
      function handleDownloadComplete(param1:String, param2:String) : void;
      
      function handleDownloadProgress(param1:Number, param2:Number) : void;
   }
}

