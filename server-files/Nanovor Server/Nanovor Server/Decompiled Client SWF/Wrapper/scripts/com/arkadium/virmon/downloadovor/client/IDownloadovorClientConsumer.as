package com.arkadium.virmon.downloadovor.client
{
   public interface IDownloadovorClientConsumer
   {
      
      function handleFileProgress(param1:String, param2:int, param3:int) : void;
      
      function handleFileAbort(param1:String) : void;
      
      function handleFileError(param1:String, param2:String) : void;
      
      function handleServerConnectionFailure() : void;
      
      function handleServerConnectionSuccess() : void;
      
      function handleFileComplete(param1:String) : void;
      
      function handleServerConnectionLost() : void;
   }
}

