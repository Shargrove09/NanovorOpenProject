package com.arkadium.virmon.downloadovor.client.receiver
{
   public interface IDownloadovorClientReceiverConsumer
   {
      
      function handleFileProgress(param1:String, param2:int, param3:int) : void;
      
      function handleFileError(param1:String, param2:String) : void;
      
      function handleFileAbort(param1:String) : void;
      
      function handleFileComplete(param1:String) : void;
      
      function handleServerConnected() : void;
   }
}

