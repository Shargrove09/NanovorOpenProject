package com.arkadium.virmon.downloadmanager.handlers
{
   public interface IFileDownloadProgressHandler
   {
      
      function handleDownloadFileProgress(param1:Number, param2:Number) : void;
      
      function handleApplicationCheckStarted() : void;
      
      function handleAssetsCheckStarted() : void;
      
      function handleDownloadFileStarted(param1:uint, param2:uint) : void;
      
      function handleAssetsCheckComplete(param1:uint) : void;
      
      function handleDownloadError() : void;
      
      function handleApplicationCheckComplete(param1:uint) : void;
      
      function handleDownloadFileCompleted() : void;
      
      function handleManifestParsed(param1:uint) : void;
   }
}

