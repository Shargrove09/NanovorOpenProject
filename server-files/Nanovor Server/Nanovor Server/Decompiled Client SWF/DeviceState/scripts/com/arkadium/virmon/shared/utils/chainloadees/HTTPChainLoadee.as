package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HTTPChainLoadee implements IChainLoadee, IDownloaderConsumer
   {
      
      public static const NAME:String = "HTTPChainLoadee";
      
      private static const TIMEOUT_INTERVAL:Number = 30000;
      
      private var _timeoutTimer:Timer;
      
      private var _destination:String;
      
      private var _downloader:IDownloader;
      
      private var _consumer:IHTTPChainLoadeeConsumer;
      
      private var _url:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _lastBytesTransferred:int;
      
      public function HTTPChainLoadee(param1:String, param2:String, param3:IDownloader, param4:IHTTPChainLoadeeConsumer)
      {
         super();
         _url = param1;
         _destination = param2;
         _downloader = param3;
         _consumer = param4;
         _timeoutTimer = new Timer(TIMEOUT_INTERVAL);
         _timeoutTimer.addEventListener(TimerEvent.TIMER,handleTimeout);
         log("HTTPChainLoadee() - \n\t\t URL: " + _url + "\n\t\t DESTINATION: " + _destination);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<HTTPChainLoadee>>\t" + param1);
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function handleTimeout(param1:TimerEvent) : void
      {
         _timeoutTimer.removeEventListener(TimerEvent.TIMER,handleTimeout);
         _timeoutTimer.reset();
         onHTTPError();
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
         onHTTPProgress(int(param1),int(param2));
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleDownloadError(): " + param1);
         onHTTPError();
      }
      
      private function onHTTPError() : void
      {
         _consumer.handleHTTPError();
      }
      
      public function load() : void
      {
         try
         {
            _downloader.downloadFile(IDownloaderConsumer(this),_url,_destination);
         }
         catch(error:Error)
         {
            log("Failed to getFile: from " + _url + " to " + _destination);
            onHTTPError();
         }
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         log("handleDownloadComplete():\n\t" + param1 + " --> " + param2);
         onHTTPBinaryTransferComplete(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** HTTPChainLoadee: " + param1);
      }
      
      private function onHTTPBinaryTransferComplete(param1:String) : void
      {
         _consumer.handleHTTPComplete(param1);
         _timeoutTimer.removeEventListener(TimerEvent.TIMER,handleTimeout);
         _timeoutTimer.reset();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function onHTTPProgress(param1:int, param2:int) : void
      {
         if(_lastBytesTransferred == param1)
         {
            _timeoutTimer.start();
            return;
         }
         _timeoutTimer.reset();
         _lastBytesTransferred = param1;
         _consumer.handleHTTPProgress(param1,param2);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

