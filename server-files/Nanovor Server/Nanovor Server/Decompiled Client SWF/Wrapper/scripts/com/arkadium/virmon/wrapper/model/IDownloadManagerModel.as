package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusProvider;
   
   public interface IDownloadManagerModel extends IDownloadManagerStatusProvider
   {
      
      function addDownloadManagerLoadErrorHandler(param1:IDownloadManagerLoadErrorHandler) : void;
      
      function executeUpdateFinisher() : void;
      
      function loadDownloadManager() : void;
      
      function addDownloadManagerLoadCompleteHandler(param1:IDownloadManagerLoadCompleteHandler) : void;
   }
}

