package com.arkadium.virmon.downloadovor.client
{
   public interface IDownloadovorClient
   {
      
      function connect() : void;
      
      function requestFile(param1:String, param2:String, param3:Boolean = false) : void;
      
      function abortFile(param1:String) : void;
   }
}

