package com.arkadium.virmon.framework.application
{
   public interface IApplicationDownloaderConsumer
   {
      
      function handleDownloadComplete(param1:IApplicationDownloadItem) : void;
      
      function handleAllApplicationDownloadsComplete(param1:Boolean, param2:Boolean) : void;
   }
}

