package com.arkadium.virmon.wrapper
{
   import caurina.transitions.properties.ColorShortcuts;
   import caurina.transitions.properties.DisplayShortcuts;
   import caurina.transitions.properties.FilterShortcuts;
   import caurina.transitions.properties.SoundShortcuts;
   import com.arkadium.analytics.AnalyticsManager;
   import com.arkadium.analytics.GoogleAnalyticsConsumer;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.ServiceRequestBrokerManager;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.IComponentView;
   import com.arkadium.virmon.common.ICompositeView;
   import com.arkadium.virmon.common.MainConfigOptions;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.DownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadovor.DownloadovorDownloader;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.musicmanager.MusicManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.mdm.MDMManager;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderRetry;
   import com.arkadium.virmon.shared.utils.EventHandlerMaster;
   import com.arkadium.virmon.shared.utils.FileOperator;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.soundmanager.SoundManager;
   import com.arkadium.virmon.wrapper.controller.DownloadManagerController;
   import com.arkadium.virmon.wrapper.controller.GameEngineController;
   import com.arkadium.virmon.wrapper.controller.ILoginController;
   import com.arkadium.virmon.wrapper.controller.LoginController;
   import com.arkadium.virmon.wrapper.model.DownloadManagerModel;
   import com.arkadium.virmon.wrapper.model.GameEngineModel;
   import com.arkadium.virmon.wrapper.model.IDownloadManagerModel;
   import com.arkadium.virmon.wrapper.model.IGameEngineModel;
   import com.arkadium.virmon.wrapper.model.ILoginModel;
   import com.arkadium.virmon.wrapper.model.LoginModel;
   import com.arkadium.virmon.wrapper.view.DownloadManagerView;
   import com.arkadium.virmon.wrapper.view.GameEngineView;
   import com.arkadium.virmon.wrapper.view.LoginView;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mdm.*;
   
   public class Wrapper extends MovieClip implements IChainLoaderConsumer, IChainLoaderErrorConsumer
   {
      
      private static const ANALYTICS_ON_BY_DEFAULT:Boolean = false;
      
      public var mcInternalWebBrowser:InternalWebBrowser;
      
      private var _downloadManagerView:ICompositeView;
      
      private var _isMouseEventTrailActive:Boolean;
      
      private var _loginView:ICompositeView;
      
      private var _isKeyCaptureActive:Boolean;
      
      private var _gameEngineView:IComponentView;
      
      private var _ssManager:StoredSettingManager;
      
      private var _chainLoaderRetry:ChainLoaderRetry;
      
      private var _keysCaptured:Array;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _keyCaptureTimer:Timer;
      
      public function Wrapper()
      {
         super();
         DebugLog.instance.debug = true;
         initializeMDM();
         setEnvironmentVars();
         initializeStageInstances();
         initializeManagers();
         startChainLoader();
         if(stage != null)
         {
            onStage(null);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,onStage);
         }
         Managers.mdmManager.setAnalyticsManager(AnalyticsManager.getInstance());
         var _loc1_:String = Managers.mainConfigManager.getSetting(MainConfigOptions.ANALYTICS_ENABLED);
         if(_loc1_ == "")
         {
            AnalyticsManager.getInstance().enabled = ANALYTICS_ON_BY_DEFAULT;
         }
         else
         {
            AnalyticsManager.getInstance().enabled = Boolean(_loc1_.toLowerCase() == "yes");
         }
      }
      
      public function handleChainLoaderError() : void
      {
         error("handleChainLoaderError(): FATAL! \n" + new Error("JUST A STACK TRACE").getStackTrace());
      }
      
      private function startCapture() : void
      {
         _keysCaptured = [];
         _isKeyCaptureActive = true;
         resetKeyCaptureTimer();
      }
      
      private function initializeMDM() : void
      {
         Application.init(this);
         Managers.mdmManager = new MDMManager();
         Managers.mdmManager.mdmApplication = Application;
         Managers.mdmManager.mdmFilesystem = FileSystem;
         Managers.mdmManager.mdmSystem = System;
         Managers.mdmManager.mdmBrowser = Browser;
         Managers.mdmManager.mdmHTTP = HTTP;
         Managers.mdmManager.mdmProcess = Process;
         Managers.mdmManager.mdmMacShell = MacShell;
      }
      
      private function error(param1:String) : void
      {
         DebugLog.instance.error("** Wrapper: " + param1);
      }
      
      private function onKeyCaptureTimerComplete(param1:TimerEvent) : void
      {
         stopCapture();
      }
      
      private function setEnvironmentVars() : void
      {
         new EnvironmentSetupHelper().setGlobalEnvironmentVars(Managers.mdmManager as IMDMManager);
      }
      
      private function toggleMouseEventTrail() : void
      {
         if(_isMouseEventTrailActive)
         {
            stage.removeEventListener(MouseEvent.CLICK,checkMouseEventTrail);
            _isMouseEventTrailActive = false;
            return;
         }
         stage.addEventListener(MouseEvent.CLICK,checkMouseEventTrail);
         _isMouseEventTrailActive = true;
      }
      
      private function initializeManagers() : void
      {
         _ssManager = StoredSettingManager.getInstance();
         _ssManager.setSystemPath(System.Paths.temp);
         _ssManager.setMDMRef(FileSystem);
         _ssManager.loadSettings();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc2_:IApplicationExiter = new ApplicationExiter(Managers.mdmManager);
         removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         setVisualQuality(_ssManager.getSettingOrSetDefault(StoredSetting.GAMEOPTIONS_QUALITY,"high"));
         stage.addEventListener(KeyboardEvent.KEY_UP,onStageKeyUp);
         if(Managers.analyticsManager.enabled)
         {
            addChild(Managers.analyticsManager.consumersDebugContainer);
         }
         var _loc3_:GoogleAnalyticsConsumer = new GoogleAnalyticsConsumer();
         Managers.analyticsManager.addAnalyticsConsumer(_loc3_);
         Managers.analyticsManager.trackView(View.APP_LAUNCH);
         _serviceRequestBrokerManager = new ServiceRequestBrokerManager();
         Managers.serviceRequestBrokerManager = _serviceRequestBrokerManager;
         DataManager.getInstance().onInitialize(_serviceRequestBrokerManager);
         var _loc4_:MusicManager = new MusicManager();
         var _loc5_:ILoginModel = new LoginModel(_serviceRequestBrokerManager,UserProfile.getInstance(),_loc4_,_loc2_);
         var _loc6_:ILoginController = new LoginController(_loc5_);
         _loginView = new LoginView(_loc5_,_loc6_);
         var _loc7_:IDownloadManagerStatusMediator = new DownloadManagerStatusMediator();
         var _loc8_:IDownloader = new DownloadovorDownloader(new FileOperator(Managers.mdmManager),Managers.mdmManager,_loc7_,_loc5_);
         var _loc9_:IDownloadManagerModel = new DownloadManagerModel(_loc7_,UserProfile.getInstance(),_loc8_,_serviceRequestBrokerManager,new FileOperator(Managers.mdmManager),DataManager.getInstance().getVirmonManager() as IVirmonDataRetriever,DataManager.getInstance().getEvoManager() as IEvoDataRetriever,Managers.analyticsManager,Managers.mdmManager);
         _downloadManagerView = new DownloadManagerView(_loc9_,new DownloadManagerController(_loc9_));
         var _loc10_:IGameEngineModel = new GameEngineModel(_loc9_,_loc8_,_loc7_,EventManager.getInstance(),UserProfile.getInstance(),_loc4_,Managers.mdmManager,_serviceRequestBrokerManager,Managers.webClientManager,Managers.homeBreadcrumbUIManager,_loc2_,Managers.analyticsManager);
         _gameEngineView = new GameEngineView(_loc10_,new GameEngineController(_loc10_));
         _loginView.add(_downloadManagerView);
         _loginView.add(_gameEngineView);
         _downloadManagerView.add(_gameEngineView);
         addChild(_loginView.sprite);
         addChild(_gameEngineView.sprite);
         _loc6_.loadLoginPanel();
      }
      
      private function openInternalBrowserUrl(param1:String, param2:Boolean = false) : void
      {
         this.addChild(mcInternalWebBrowser);
         mcInternalWebBrowser.show(param1,param2);
      }
      
      private function captureKey(param1:uint) : void
      {
         _keysCaptured.push(param1);
         if(handleCapturedKeys())
         {
            stopCapture();
            return;
         }
         resetKeyCaptureTimer();
      }
      
      private function handleCapturedKeys() : Boolean
      {
         var _loc2_:uint = 0;
         var _loc1_:String = "";
         for each(_loc2_ in _keysCaptured)
         {
            _loc1_ += String.fromCharCode(_loc2_);
         }
         if(_loc1_.toLowerCase() == "mouse")
         {
            toggleMouseEventTrail();
            return true;
         }
         if(_loc1_.toLowerCase() == "ddd")
         {
            toggleDebugging();
            return true;
         }
         return false;
      }
      
      private function onStageKeyUp(param1:KeyboardEvent) : void
      {
         if(_isKeyCaptureActive)
         {
            captureKey(param1.keyCode);
         }
         switch(param1.keyCode)
         {
            case Keyboard.F5:
               DebugLog.instance.log("System.totalMemory = " + Number(System.totalMemory / 1024 / 1024).toFixed(2) + " MB");
               break;
            case Keyboard.F6:
               EventHandlerMaster.dumpDanglers();
               break;
            case Keyboard.F7:
               EventHandlerMaster.dumpDanglerCount();
               break;
            case Keyboard.F8:
               log(Utils.ChildrenToString(stage,1,4,12));
               break;
            case Keyboard.F9:
               Utils.gc();
               break;
            case Keyboard.F11:
               startCapture();
               break;
            case Keyboard.F12:
               MemoryWatcher.logCurrentObjects();
         }
      }
      
      private function openExternalBrowserUrl(param1:String) : void
      {
         navigateToURL(new URLRequest(param1),"_blank");
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Wrapper: " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         Managers.analyticsManager = AnalyticsManager.getInstance();
         Managers.mdmManager.setAnalyticsManager(AnalyticsManager.getInstance());
         var _loc2_:String = Managers.mainConfigManager.getSetting(MainConfigOptions.ANALYTICS_ENABLED);
         if(_loc2_ == "")
         {
            AnalyticsManager.getInstance().enabled = ANALYTICS_ON_BY_DEFAULT;
         }
         else
         {
            AnalyticsManager.getInstance().enabled = Boolean(_loc2_.toLowerCase() == "yes");
         }
         _chainLoaderRetry.destroy();
         _chainLoaderRetry = null;
         Managers.soundManager = new SoundManager();
         EventManager.getInstance().addEventListener(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,onOpenBrowserHookCall);
         EventManager.getInstance().addEventListener("CHANGE_VISUAL_QUALITY",changeVisualQuality);
         SoundShortcuts.init();
         ColorShortcuts.init();
         DisplayShortcuts.init();
         FilterShortcuts.init();
         if(stage != null)
         {
            onAddedToStage(null);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         }
      }
      
      private function resetKeyCaptureTimer() : void
      {
         if(_keyCaptureTimer == null)
         {
            _keyCaptureTimer = new Timer(2000,1);
            _keyCaptureTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onKeyCaptureTimerComplete);
         }
         _keyCaptureTimer.reset();
         _keyCaptureTimer.start();
      }
      
      private function initializeStageInstances() : void
      {
         mcInternalWebBrowser.hide();
      }
      
      private function changeVisualQuality(param1:ProjectEvent) : void
      {
         setVisualQuality(String(param1.params.quality));
      }
      
      private function setVisualQuality(param1:String) : void
      {
         switch(param1)
         {
            case "high":
               stage.quality = StageQuality.HIGH;
               break;
            case "medium":
               stage.quality = StageQuality.MEDIUM;
               break;
            case "low":
               stage.quality = StageQuality.LOW;
         }
      }
      
      private function onOpenBrowserHookCall(param1:FrameWorkEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:* = String(param1.data);
         var _loc3_:* = Managers.webClientManager.getWebClientHookUrl(_loc2_);
         if(!_loc3_)
         {
            error("onBrowserOpenHookCall called, but there is no URL found with the name \'" + _loc2_ + "\'");
            return;
         }
         if(Managers.webClientManager.getWebClientHookToken(_loc2_))
         {
            _loc5_ = _serviceRequestBrokerManager.getLoginToken();
            _loc3_ += "?verification_token=" + _loc5_;
         }
         log("szUrl: " + _loc3_);
         var _loc4_:Boolean = false;
         if(_loc2_ == "account-creation")
         {
            _loc4_ = true;
         }
         if(Managers.webClientManager.getWebClientHookType(_loc2_) == "internal")
         {
            openInternalBrowserUrl(_loc3_,_loc4_);
         }
         else
         {
            openExternalBrowserUrl(_loc3_);
         }
      }
      
      private function stopCapture() : void
      {
         _isKeyCaptureActive = false;
         if(_keyCaptureTimer != null)
         {
            _keyCaptureTimer.stop();
            _keyCaptureTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onKeyCaptureTimerComplete);
            _keyCaptureTimer = null;
         }
         _keysCaptured = [];
      }
      
      private function checkMouseEventTrail(param1:MouseEvent) : void
      {
         log("//---------------------------------------------------------------------------------------------------");
         var _loc2_:* = param1.target;
         while(_loc2_)
         {
            log("checkMouseEventTrail >> " + _loc2_.name + ": " + _loc2_);
            _loc2_ = _loc2_.parent;
         }
         log("//---------------------------------------------------------------------------------------------------");
      }
      
      private function onStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,onStage);
         clearContextualMenu();
      }
      
      private function startChainLoader() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(Managers.webClientManager);
         _loc1_.add(Managers.mainConfigManager);
         _chainLoaderRetry = new ChainLoaderRetry(_loc1_,IChainLoaderConsumer(this),IChainLoaderErrorConsumer(this));
         _chainLoaderRetry.load();
      }
      
      private function toggleDebugging() : void
      {
         if(DebugLog.instance.debug)
         {
            error("[[[ Debug Logging being turned OFF ]]]");
            DebugLog.instance.debug = false;
            return;
         }
         DebugLog.instance.debug = true;
         error("[[[ Debug Logging turned ON ]]]");
      }
      
      private function clearContextualMenu() : void
      {
         stage.showDefaultContextMenu = false;
         contextMenu = new ContextMenu();
      }
   }
}

