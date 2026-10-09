package com.arkadium.virmon.downloadovor.client.keyrequester
{
   public interface IDownloadovorClientKeyRequesterConsumer
   {
      
      function handleServerConnectionFailure() : void;
      
      function handleServerConnectionSuccess(param1:String, param2:String) : void;
   }
}

