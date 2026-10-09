package com.arkadium.virmon.wrapper.view
{
   import com.arkadium.communications.handlers.IServiceRequestBrokerCompleteHandler;
   import com.arkadium.virmon.common.AbstractCompositeView;
   import com.arkadium.virmon.downloadmanager.handlers.IAllAssetManifestsLoadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.ICopyAndRestartClientHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IFileDownloadProgressHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredAssetDownloadsCompleteHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRestartClientHandler;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.wrapper.controller.IDownloadManagerController;
   import com.arkadium.virmon.wrapper.model.IDownloadManagerLoadErrorHandler;
   import com.arkadium.virmon.wrapper.model.IDownloadManagerModel;
   import com.arkadium.virmon.wrapper.model.ILoginPanelLoadedHandler;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DownloadManagerView extends AbstractCompositeView implements ILoginPanelLoadedHandler, IServiceRequestBrokerCompleteHandler, IDownloadManagerLoadErrorHandler, IFileDownloadProgressHandler, IAllAssetManifestsLoadedHandler, IRequiredAssetDownloadsCompleteHandler, ICopyAndRestartClientHandler, IRestartClientHandler
   {
      
      private static const RESTART_COUNT_SECONDS:int = 5;
      
      private static const RESTART_TEXT_KEY:String = "%s";
      
      private static const RESTART_TEXT_COUNT:String = "Restarting Nanovor in %s seconds.";
      
      private static const RESTART_TEXT:String = "Restarting Nanovor.";
      
      private var _assetFileCount:uint;
      
      private var _waitPanel:IWaitPanel;
      
      private var _model:IDownloadManagerModel;
      
      private var _loginPanel:ILoginPanel;
      
      private var _controller:IDownloadManagerController;
      
      private var _assetFileIndex:uint;
      
      private var _restartTimer:Timer;
      
      public function DownloadManagerView(param1:IDownloadManagerModel, param2:IDownloadManagerController)
      {
         super();
         _model = param1;
         _controller = param2;
         _model.addDownloadManagerLoadErrorHandler(IDownloadManagerLoadErrorHandler(this));
         _model.addFileDownloadProgressHandler(IFileDownloadProgressHandler(this));
         _model.addAllAssetManifestsLoadedHandler(IAllAssetManifestsLoadedHandler(this));
         _model.addRequiredAssetDownloadsCompleteHandler(IRequiredAssetDownloadsCompleteHandler(this));
         _model.addCopyAndRestartClientHandler(ICopyAndRestartClientHandler(this));
         _model.addRestartClientHandler(IRestartClientHandler(this));
      }
      
      public function handleCopyAndRestartClient() : void
      {
         var _loc1_:String = RESTART_TEXT_COUNT.replace(RESTART_TEXT_KEY,RESTART_COUNT_SECONDS);
         _waitPanel.handleStatusMessage(_loc1_);
         _restartTimer = new Timer(1000,RESTART_COUNT_SECONDS);
         _restartTimer.addEventListener(TimerEvent.TIMER,handleRestartTimer);
         _restartTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleCopyRestartTimerComplete);
         _restartTimer.start();
      }
      
      public function handleApplicationCheckStarted() : void
      {
         _loginPanel.addStatusMessage("Checking for updated application files...");
      }
      
      public function handleDownloadManagerLoadError(param1:String) : void
      {
         var _loc2_:IDownloadManagerLoadErrorHandler = null;
         logError("handleDownloadManagerLoadError(): " + param1);
         for each(_loc2_ in getChildrenOfType(IDownloadManagerLoadErrorHandler))
         {
            _loc2_.handleDownloadManagerLoadError(param1);
         }
      }
      
      private function handleRestartTimerComplete(param1:TimerEvent) : void
      {
         _restartTimer.stop();
         _restartTimer.removeEventListener(TimerEvent.TIMER,handleRestartTimer);
         _restartTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,handleRestartTimerComplete);
         _restartTimer = null;
         _waitPanel.handleStatusMessage(RESTART_TEXT);
         _controller.restartClient();
      }
      
      public function handleDownloadError() : void
      {
         logError("handleDownloadError()");
         _loginPanel.addStatusMessage("There was an error downloading files.  Please try again or contact customer service.","",true);
         _loginPanel.initAfterInvalidLogin();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>DownloadManagerView<< " + param1);
      }
      
      private function handleCopyRestartTimerComplete(param1:TimerEvent) : void
      {
         _restartTimer.stop();
         _restartTimer.removeEventListener(TimerEvent.TIMER,handleRestartTimer);
         _restartTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,handleCopyRestartTimerComplete);
         _restartTimer = null;
         _waitPanel.handleStatusMessage(RESTART_TEXT);
         _controller.copyAndRestartClient();
      }
      
      private function formatFileSize(param1:int) : String
      {
         if(param1 >= 1024 * 1024)
         {
            return Number(param1 / (1024 * 1024)).toFixed(1) + "MB";
         }
         if(param1 >= 1024)
         {
            return Number(param1 / 1024).toFixed(1) + "KB";
         }
         return param1 + "Bytes";
      }
      
      private function handleRestartTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = RESTART_COUNT_SECONDS - _restartTimer.currentCount;
         var _loc3_:String = RESTART_TEXT_COUNT.replace(RESTART_TEXT_KEY,_loc2_);
         _waitPanel.handleStatusMessage(_loc3_);
      }
      
      public function handleDownloadFileProgress(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = Math.min(param1 / param2,1);
         var _loc4_:Number = _assetFileIndex + _loc3_;
         _waitPanel.handleUpdateProgress(_loc4_,_assetFileCount);
         log("handleDownloadFileProgress()");
      }
      
      public function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void
      {
         var _loc2_:IAllAssetManifestsLoadedHandler = null;
         log("handleAllAssetManifestsLoaded()");
         for each(_loc2_ in getChildrenOfType(IAllAssetManifestsLoadedHandler))
         {
            _loc2_.handleAllAssetManifestsLoaded(param1);
         }
      }
      
      public function handleServiceRequestBrokerComplete() : void
      {
         var _loc1_:IServiceRequestBrokerCompleteHandler = null;
         for each(_loc1_ in getChildrenOfType(IServiceRequestBrokerCompleteHandler))
         {
            _loc1_.handleServiceRequestBrokerComplete();
         }
         _controller.startDownload();
      }
      
      public function handleAssetsCheckStarted() : void
      {
         _loginPanel.addStatusMessage("Checking for updated assets...");
      }
      
      public function handleDownloadFileCompleted() : void
      {
         _loginPanel.replaceStatusMessage("Downloading file (" + (_assetFileIndex + 1) + "/" + _assetFileCount + ") :  Complete");
         _waitPanel.handleStatusMessage("Downloading file (" + (_assetFileIndex + 1) + "/" + _assetFileCount + ") :  Complete");
      }
      
      private function getEllipsis(param1:uint) : String
      {
         var _loc2_:String = "";
         var _loc3_:uint = 0;
         while(_loc3_ < param1 % 4)
         {
            _loc2_ += ".";
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void
      {
         _loginPanel = param1;
         _waitPanel = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DownloadManagerView>> " + param1);
      }
      
      public function handleAssetsCheckComplete(param1:uint) : void
      {
         _loginPanel.replaceStatusMessage("Checking for updated assets... Complete.");
         _loginPanel.addStatusMessage("Outdated asset files:  " + param1);
         _loginPanel.addStatusMessage("Downloading file (1/" + param1 + ")");
      }
      
      public function handleApplicationCheckComplete(param1:uint) : void
      {
         _loginPanel.replaceStatusMessage("Checking for updated application files... Complete.");
         _loginPanel.addStatusMessage("Outdated application files:  " + param1);
         _loginPanel.addStatusMessage("Downloading file (1/" + param1 + ")");
      }
      
      public function handleManifestParsed(param1:uint) : void
      {
         _loginPanel.replaceStatusMessage("Checking for updated assets" + getEllipsis(param1));
      }
      
      public function handleDownloadFileStarted(param1:uint, param2:uint) : void
      {
         _assetFileIndex = param1;
         _assetFileCount = param2;
         if(0 != _assetFileCount)
         {
            _loginPanel.replaceStatusMessage("Downloading file (" + (_assetFileIndex + 1) + "/" + _assetFileCount + ")");
            _waitPanel.handleStatusMessage("Downloading file (" + (_assetFileIndex + 1) + "/" + _assetFileCount + ")");
            _waitPanel.handleUpdateProgress(_assetFileIndex,_assetFileCount);
         }
      }
      
      public function handleRestartClient() : void
      {
         var _loc1_:String = RESTART_TEXT_COUNT.replace(RESTART_TEXT_KEY,RESTART_COUNT_SECONDS);
         _waitPanel.handleStatusMessage(_loc1_);
         _restartTimer = new Timer(1000,RESTART_COUNT_SECONDS);
         _restartTimer.addEventListener(TimerEvent.TIMER,handleRestartTimer);
         _restartTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleRestartTimerComplete);
         _restartTimer.start();
      }
      
      public function handleRequiredAssetDownloadsComplete() : void
      {
         var _loc1_:IRequiredAssetDownloadsCompleteHandler = null;
         log("handleRequiredAssetDownloadsComplete()");
         _loginPanel.replaceStatusMessage("All required files up to date.");
         for each(_loc1_ in getChildrenOfType(IRequiredAssetDownloadsCompleteHandler))
         {
            _loc1_.handleRequiredAssetDownloadsComplete();
         }
         _model.removeRequiredAssetDownloadsCompleteHandler(IRequiredAssetDownloadsCompleteHandler(this));
         _model.removeFileDownloadProgressHandler(IFileDownloadProgressHandler(this));
      }
   }
}

