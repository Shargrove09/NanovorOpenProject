package com.arkadium.virmon.downloadovor.client.sender
{
   import com.arkadium.virmon.downloadovor.shared.DownloadovorConst;
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class DownloadovorClientSender
   {
      
      private static const STATUS_ERROR:String = "error";
      
      private static const RETRY_COUNT:int = 3;
      
      private var _currentRetryCount:int;
      
      private var _bypassTempFolder:Boolean;
      
      private var _currentFileSource:String;
      
      private var _sender:LocalConnection;
      
      private var _consumer:IDownloadovorClientSenderConsumer;
      
      private var _currentFileDestination:String;
      
      private var _serverKey:String;
      
      public function DownloadovorClientSender(param1:String, param2:IDownloadovorClientSenderConsumer)
      {
         super();
         _serverKey = param1;
         _consumer = param2;
         _sender = new LocalConnection();
         _sender.addEventListener(StatusEvent.STATUS,handleSenderStatus);
         _sender.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing);
         _sender.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing);
      }
      
      public function requestFile(param1:String, param2:String, param3:Boolean = false) : void
      {
         _currentFileSource = param1;
         _currentFileDestination = param2;
         _bypassTempFolder = param3;
         _currentRetryCount = 0;
         _sender.send(_serverKey,DownloadovorConst.SERVER_FUNCTION_REQUEST_FILE,_currentFileSource,_currentFileDestination,_bypassTempFolder);
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      public function abortFile(param1:String) : void
      {
         _sender.send(_serverKey,DownloadovorConst.SERVER_FUNCTION_ABORT_FILE,param1);
      }
      
      private function handleSenderStatus(param1:StatusEvent) : void
      {
         if(STATUS_ERROR == param1.level)
         {
            _consumer.handleRequestFileError(_currentFileSource);
         }
      }
   }
}

