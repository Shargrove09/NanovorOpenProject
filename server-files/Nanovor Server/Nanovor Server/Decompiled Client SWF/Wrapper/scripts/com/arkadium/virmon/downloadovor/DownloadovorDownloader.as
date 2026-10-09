package com.arkadium.virmon.downloadovor
{
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadovor.client.DownloadovorClient;
   import com.arkadium.virmon.downloadovor.client.IDownloadovorClientConsumer;
   import com.arkadium.virmon.downloadovor.shared.DownloadovorConst;
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.wrapper.model.ILoginModel;
   import com.arkadium.virmon.wrapper.model.ILoginPanelLoadedHandler;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DownloadovorDownloader implements IDownloader, IDownloadovorClientConsumer, ILoginPanelLoadedHandler
   {
      
      private static const DOWNLOADAVOR_SERVER:String = "Downloadovor.exe";
      
      private static const CONNECTION_DISCONNECTED:String = "disconnected";
      
      private static const CONNECTION_CONNECTING:String = "connecting";
      
      private static const CONNECTION_CONNECTED:String = "connected";
      
      private var _noResponseTimer:Timer;
      
      private var _downloadovorClient:DownloadovorClient;
      
      private var _fileOperator:IFileOperator;
      
      private var _queuedFile:QueueFile;
      
      private var _mdmManager:IMDMManager;
      
      private var _connectionStatus:String;
      
      private var _downloadCache:Dictionary;
      
      private var _currentFile:QueueFile;
      
      private var _downloadManagerStatusMediator:IDownloadManagerStatusMediator;
      
      private var _failSafeKillTimer:Timer;
      
      public function DownloadovorDownloader(param1:IFileOperator, param2:IMDMManager, param3:IDownloadManagerStatusMediator, param4:ILoginModel)
      {
         super();
         _fileOperator = param1;
         _mdmManager = param2;
         _downloadManagerStatusMediator = param3;
         param4.addLoginPanelLoadedHandler(ILoginPanelLoadedHandler(this));
      }
      
      public function handleServerConnectionFailure() : void
      {
         log("handleServerConnectionFailure()");
         _noResponseTimer.stop();
         _connectionStatus = CONNECTION_DISCONNECTED;
         if(_currentFile == null)
         {
            _currentFile = _queuedFile;
            _queuedFile = null;
         }
         if(_currentFile != null)
         {
            downloadFile(_currentFile.consumer,_currentFile.fileSource,_currentFile.fileDestination,_currentFile.cacheVersion);
            return;
         }
         logError("handleServerConnectionFailure(): _currentFile == null -- why are we here?");
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      public function handleServerConnectionLost() : void
      {
         log("handleServerConnectionLost()");
         _noResponseTimer.stop();
      }
      
      private function launchDownloadovorServer() : void
      {
         _mdmManager.mdmSystem.exec(_mdmManager.mdmApplication.path + DOWNLOADAVOR_SERVER);
      }
      
      private function processDownload(param1:QueueFile) : void
      {
         log("processDownload() - Requesting file " + param1.fileSource);
         _noResponseTimer.reset();
         _noResponseTimer.start();
         _currentFile = param1;
         if(_currentFile.cacheVersion != "")
         {
            _currentFile.fileSource = Utils.appendCacheVersion(_currentFile.fileSource,_currentFile.cacheVersion);
         }
         else
         {
            _currentFile.fileSource = Utils.appendKillCache(_currentFile.fileSource);
         }
         _downloadovorClient.requestFile(_currentFile.fileSource,_currentFile.fileDestination,_currentFile.isLocalFileCopy);
      }
      
      public function copyFile(param1:IDownloaderConsumer, param2:String, param3:String, param4:int = 2) : void
      {
         param2 = param2.indexOf("file://") == -1 ? "file://" + param2 : param2;
         switch(_connectionStatus)
         {
            case CONNECTION_CONNECTED:
               processDownload(new QueueFile(param1,param2,param3,"",param4,true));
               break;
            case CONNECTION_DISCONNECTED:
               _connectionStatus = CONNECTION_CONNECTING;
               launchDownloadovorServer();
               _downloadovorClient.connect();
            default:
               _queuedFile = new QueueFile(param1,param2,param3,"",param4,true);
         }
      }
      
      public function handleFileProgress(param1:String, param2:int, param3:int) : void
      {
         log("handleFileProgress() " + param2 + "/" + param3);
         _noResponseTimer.reset();
         _noResponseTimer.start();
         _currentFile.consumer.handleDownloadProgress(param2,param3);
      }
      
      public function handleFileError(param1:String, param2:String) : void
      {
         logError("handleFileError(): " + _currentFile.fileSource);
         _noResponseTimer.stop();
         if(_currentFile.retryAttempts < _currentFile.maxRetries)
         {
            ++_currentFile.retryAttempts;
            processDownload(_currentFile);
            return;
         }
         _currentFile.consumer.handleDownloadError(param2);
      }
      
      public function downloadFile(param1:IDownloaderConsumer, param2:String, param3:String, param4:String = "", param5:int = 2) : void
      {
         param2 = encodeURI(param2);
         if(null != _downloadCache[Utils.appendCacheVersion(param2,param4)] && "" != param4)
         {
            log("downloadFile(): already downloaded file so skipping: " + param3);
            param1.handleDownloadComplete(param2,param3);
            return;
         }
         switch(_connectionStatus)
         {
            case CONNECTION_CONNECTED:
               processDownload(new QueueFile(param1,param2,param3,param4,param5));
               break;
            case CONNECTION_DISCONNECTED:
               _connectionStatus = CONNECTION_CONNECTING;
               launchDownloadovorServer();
               _downloadovorClient.connect();
            default:
               _queuedFile = new QueueFile(param1,param2,param3,param4,param5);
         }
      }
      
      public function handleFileComplete(param1:String) : void
      {
         log("handleFileComplete(): \'" + _currentFile.fileSource + "\' --> \'" + _currentFile.fileDestination + "\'.");
         _noResponseTimer.stop();
         _downloadCache[_currentFile.fileSource] = _currentFile.fileSource;
         _currentFile.consumer.handleDownloadComplete(_currentFile.fileSource,_currentFile.fileDestination);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadovorDownloader>> " + param1);
      }
      
      private function onFailSafeKillTimerComplete(param1:TimerEvent) : void
      {
         _failSafeKillTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onFailSafeKillTimerComplete);
         _failSafeKillTimer.reset();
         _failSafeKillTimer = null;
         checkServerKilled();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DownloadovorDownloader: " + param1);
      }
      
      public function handleFileAbort(param1:String) : void
      {
         log("handleFileAbort()");
      }
      
      private function checkServerKilled() : void
      {
         var _loc1_:String = _mdmManager.mdmSystem.execStdOut("cmd /C taskkill /f /im Downloadovor* 2>&1");
         if(false == isServerInstanceFound(_loc1_))
         {
            return;
         }
         _downloadManagerStatusMediator.handleRestartClient();
      }
      
      public function abortDownload() : void
      {
         _downloadovorClient.abortFile(_currentFile.fileSource);
      }
      
      private function isServerInstanceFound(param1:String) : Boolean
      {
         return Boolean(param1.indexOf("SUCCESS") != -1);
      }
      
      private function handleNoResponse(param1:TimerEvent) : void
      {
         log("handleNoResponse()");
         if(CONNECTION_CONNECTING != _connectionStatus)
         {
            _connectionStatus = CONNECTION_DISCONNECTED;
            if(_currentFile.isLocalFileCopy)
            {
               copyFile(_currentFile.consumer,_currentFile.fileSource,_currentFile.fileDestination,_currentFile.maxRetries);
               return;
            }
            downloadFile(_currentFile.consumer,_currentFile.fileSource,_currentFile.fileDestination,_currentFile.cacheVersion,_currentFile.maxRetries);
         }
      }
      
      public function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void
      {
         killPreviouslyLaunchedServers();
         _downloadovorClient = new DownloadovorClient(IDownloadovorClientConsumer(this));
         _downloadCache = new Dictionary();
         _connectionStatus = CONNECTION_DISCONNECTED;
         _noResponseTimer = new Timer(30000,0);
         _noResponseTimer.addEventListener(TimerEvent.TIMER,handleNoResponse);
      }
      
      public function handleServerConnectionSuccess() : void
      {
         log("handleServerConnectionSuccess()");
         _noResponseTimer.reset();
         _noResponseTimer.start();
         _connectionStatus = CONNECTION_CONNECTED;
         if(null != _queuedFile)
         {
            processDownload(_queuedFile.clone());
            _queuedFile = null;
         }
      }
      
      private function killPreviouslyLaunchedServers() : void
      {
         var _loc1_:LocalConnection = new LocalConnection();
         _loc1_.addEventListener(StatusEvent.STATUS,handleNothing,false,0,true);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing,false,0,true);
         _loc1_.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing,false,0,true);
         _loc1_.send(DownloadovorConst.KEY_PROVIDER_CONNECTION,"exitGracefully");
         _failSafeKillTimer = new Timer(400,1);
         _failSafeKillTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onFailSafeKillTimerComplete,false,0,true);
         _failSafeKillTimer.start();
      }
   }
}

