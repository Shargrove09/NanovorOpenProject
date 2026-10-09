package com.arkadium.virmon.downloadovor.client.receiver
{
   import flash.events.AsyncErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class DownloadovorClientReceiver
   {
      
      private var _receiver:LocalConnection;
      
      private var _consumer:IDownloadovorClientReceiverConsumer;
      
      public function DownloadovorClientReceiver(param1:String, param2:IDownloadovorClientReceiverConsumer)
      {
         var clientKey:String = param1;
         var consumer:IDownloadovorClientReceiverConsumer = param2;
         super();
         _consumer = consumer;
         _receiver = new LocalConnection();
         _receiver.client = this;
         _receiver.addEventListener(StatusEvent.STATUS,handleReceiverStatus,false,0,true);
         _receiver.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleAsyncError,false,0,true);
         try
         {
            _receiver.connect(clientKey);
         }
         catch(e:Error)
         {
            throw e;
         }
      }
      
      public function fileComplete(param1:String) : void
      {
         _consumer.handleFileComplete(param1);
      }
      
      public function serverConnected() : void
      {
         _consumer.handleServerConnected();
      }
      
      private function handleReceiverStatus(param1:StatusEvent) : void
      {
      }
      
      public function fileError(param1:String, param2:String) : void
      {
         _consumer.handleFileError(param1,param2);
      }
      
      public function fileUpdateProgress(param1:String, param2:int, param3:int) : void
      {
         _consumer.handleFileProgress(param1,param2,param3);
      }
      
      private function handleAsyncError(param1:AsyncErrorEvent) : void
      {
      }
      
      public function destroy() : void
      {
         try
         {
            _receiver.removeEventListener(StatusEvent.STATUS,handleReceiverStatus);
            _receiver.close();
            _receiver = null;
            _consumer = null;
         }
         catch(e:Error)
         {
         }
      }
      
      public function fileAbort(param1:String) : void
      {
         _consumer.handleFileAbort(param1);
      }
   }
}

