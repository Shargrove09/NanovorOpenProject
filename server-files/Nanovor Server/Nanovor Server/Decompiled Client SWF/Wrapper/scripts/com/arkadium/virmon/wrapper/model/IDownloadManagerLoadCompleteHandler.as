package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.virmon.downloadmanager.IDownloadManager;
   
   public interface IDownloadManagerLoadCompleteHandler
   {
      
      function handleDownloadManagerLoadComplete(param1:IDownloadManager) : void;
   }
}

