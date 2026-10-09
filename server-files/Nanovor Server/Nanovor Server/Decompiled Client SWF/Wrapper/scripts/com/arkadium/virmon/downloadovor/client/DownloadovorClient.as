package com.arkadium.virmon.downloadovor.client
{
   import com.arkadium.virmon.downloadovor.client.keyrequester.DownloadovorClientKeyRequester;
   import com.arkadium.virmon.downloadovor.client.keyrequester.IDownloadovorClientKeyRequesterConsumer;
   import com.arkadium.virmon.downloadovor.client.receiver.DownloadovorClientReceiver;
   import com.arkadium.virmon.downloadovor.client.receiver.IDownloadovorClientReceiverConsumer;
   import com.arkadium.virmon.downloadovor.client.sender.DownloadovorClientSender;
   import com.arkadium.virmon.downloadovor.client.sender.IDownloadovorClientSenderConsumer;
   
   public class DownloadovorClient implements IDownloadovorClient, IDownloadovorClientKeyRequesterConsumer, IDownloadovorClientSenderConsumer, IDownloadovorClientReceiverConsumer
   {
      
      private var _receiver:DownloadovorClientReceiver;
      
      private var _sender:DownloadovorClientSender;
      
      private var _consumer:IDownloadovorClientConsumer;
      
      private var _keyRequester:DownloadovorClientKeyRequester;
      
      public function DownloadovorClient(param1:IDownloadovorClientConsumer)
      {
         super();
         _consumer = param1;
      }
      
      public function handleServerConnectionSuccess(param1:String, param2:String) : void
      {
         _keyRequester.sendClientConnectionsReady();
         destroyAllConnections();
         _sender = new DownloadovorClientSender(param1,IDownloadovorClientSenderConsumer(this));
         _receiver = new DownloadovorClientReceiver(param2,IDownloadovorClientReceiverConsumer(this));
      }
      
      public function handleServerConnectionFailure() : void
      {
         destroyAllConnections();
         _consumer.handleServerConnectionFailure();
      }
      
      public function abortFile(param1:String) : void
      {
         _sender.abortFile(param1);
      }
      
      public function handleFileProgress(param1:String, param2:int, param3:int) : void
      {
         _consumer.handleFileProgress(param1,param2,param3);
      }
      
      public function handleFileAbort(param1:String) : void
      {
         _consumer.handleFileAbort(param1);
      }
      
      private function requestKey() : void
      {
         destroyAllConnections();
         _keyRequester = new DownloadovorClientKeyRequester(IDownloadovorClientKeyRequesterConsumer(this));
      }
      
      public function handleFileComplete(param1:String) : void
      {
         _consumer.handleFileComplete(param1);
      }
      
      public function handleFileError(param1:String, param2:String) : void
      {
         _consumer.handleFileError(param1,param2);
      }
      
      public function handleRequestFileError(param1:String) : void
      {
         _consumer.handleServerConnectionLost();
         requestKey();
      }
      
      private function destroyAllConnections() : void
      {
         if(null != _receiver)
         {
            _receiver.destroy();
            _receiver = null;
         }
         if(null != _sender)
         {
            _sender = null;
         }
         if(null != _keyRequester)
         {
            _keyRequester.destroy();
            _keyRequester = null;
         }
      }
      
      public function connect() : void
      {
         requestKey();
      }
      
      public function requestFile(param1:String, param2:String, param3:Boolean = false) : void
      {
         _sender.requestFile(param1,param2,param3);
      }
      
      public function handleServerConnected() : void
      {
         _consumer.handleServerConnectionSuccess();
      }
   }
}

