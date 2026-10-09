package com.arkadium.virmon.downloadovor.client.keyrequester
{
   import com.arkadium.virmon.downloadovor.shared.DownloadovorConst;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.utils.Timer;
   
   public class DownloadovorClientKeyRequester
   {
      
      private static const INTERVAL_MILLISECONDS:int = 500;
      
      private static const REQUEST_TRIES:int = 8;
      
      private static const PREFIX_CLIENT:String = "client";
      
      private static const PREFIX_SERVER:String = "server";
      
      private var _consumer:IDownloadovorClientKeyRequesterConsumer;
      
      private var _clientKey:String;
      
      private var _keyRequestTimer:Timer;
      
      private var _serverKey:String;
      
      private var _keyConnection:LocalConnection;
      
      public function DownloadovorClientKeyRequester(param1:IDownloadovorClientKeyRequesterConsumer)
      {
         super();
         _consumer = param1;
         _keyConnection = new LocalConnection();
         _keyConnection.addEventListener(StatusEvent.STATUS,handleKeyConnectionStatus);
         _keyConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing);
         _keyConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing);
         _keyRequestTimer = new Timer(INTERVAL_MILLISECONDS,REQUEST_TRIES);
         _keyRequestTimer.addEventListener(TimerEvent.TIMER,handleRequestTimer);
         _keyRequestTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleRequestTimerComplete);
         _serverKey = PREFIX_CLIENT + new Date().time;
         _clientKey = PREFIX_SERVER + new Date().time;
         _keyRequestTimer.start();
      }
      
      public function destroy() : void
      {
         log("destroy()");
         _keyConnection = null;
         _keyRequestTimer.stop();
         _keyRequestTimer = null;
      }
      
      private function handleRequestTimer(param1:TimerEvent) : void
      {
         log("handleRequestTimer()");
         _keyConnection.send(DownloadovorConst.KEY_PROVIDER_CONNECTION,DownloadovorConst.SERVER_FUNCTION_REQUEST_CONNECTION,_serverKey,_clientKey);
      }
      
      private function handleKeyConnectionStatus(param1:StatusEvent) : void
      {
         if(null != _keyConnection && StatusEvent.STATUS == param1.level.toLowerCase())
         {
            log("handleKeyConnectionStatus() - Connection successful");
            _keyRequestTimer.stop();
            _consumer.handleServerConnectionSuccess(_serverKey,_clientKey);
         }
      }
      
      public function sendClientConnectionsReady() : void
      {
         log("sendClientConnectionsReady()");
         _keyConnection.send(DownloadovorConst.KEY_PROVIDER_CONNECTION,DownloadovorConst.SERVER_FUNCTION_CLIENT_READY,_clientKey);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadovorClientKeyRequester>>\t" + param1);
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      private function handleRequestTimerComplete(param1:TimerEvent) : void
      {
         log("handleRequestTimerComplete()");
         _consumer.handleServerConnectionFailure();
      }
   }
}

