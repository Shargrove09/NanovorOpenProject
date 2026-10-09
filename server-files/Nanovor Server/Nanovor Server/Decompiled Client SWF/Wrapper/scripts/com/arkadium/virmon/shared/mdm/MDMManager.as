package com.arkadium.virmon.shared.mdm
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class MDMManager implements IMDMManager, IMDMBrowserManager
   {
      
      private var _mdmFilesystem:*;
      
      private var _mdmSystem:*;
      
      private var _lastBrowsersStates:Array = new Array();
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _mdmBrowser:*;
      
      private var _mdmDialogs:*;
      
      private var _mdmMacShell:*;
      
      private var _browserRegistry:Dictionary = new Dictionary();
      
      private var _mdmApplication:*;
      
      private const EXIT_DELAY_TIME:int = 250;
      
      private var _mdmProcess:*;
      
      private var _mdmHTTP:*;
      
      public function MDMManager()
      {
         super();
      }
      
      public function get mdmFilesystem() : *
      {
         return _mdmFilesystem;
      }
      
      public function set mdmHTTP(param1:*) : void
      {
         _mdmHTTP = param1;
      }
      
      public function get mdmSystem() : *
      {
         return _mdmSystem;
      }
      
      public function pushFakeBrowserState(param1:MDMBrowserKey, param2:Object) : void
      {
         var _loc4_:Dictionary = null;
         log("pushFakeBrowserState(): key = " + param1.name);
         if(param1 == null)
         {
            return;
         }
         var _loc3_:IMDMBrowserController = _browserRegistry[param1];
         if(_loc3_ == null)
         {
            return;
         }
         if(_lastBrowsersStates.length == 0)
         {
            _loc4_ = new Dictionary();
            _lastBrowsersStates.push(_loc4_);
         }
         else
         {
            _loc4_ = _lastBrowsersStates[_lastBrowsersStates.length - 1];
         }
         if(_browserRegistry[_loc3_.browserKey] == null)
         {
            _browserRegistry[_loc3_.browserKey] = _loc3_;
         }
         log("pushFakeBrowserState(): found key, storing state props:\n" + Utils.ObjectToString(param2));
         _loc4_[_loc3_] = param2;
      }
      
      public function set mdmSystem(param1:*) : void
      {
         _mdmSystem = param1;
      }
      
      public function get mdmMacShell() : *
      {
         return _mdmMacShell;
      }
      
      public function registerBrowserController(param1:IMDMBrowserController) : void
      {
         _browserRegistry[param1.browserKey] = param1;
      }
      
      public function set mdmFilesystem(param1:*) : void
      {
         _mdmFilesystem = param1;
      }
      
      public function get mdmBrowser() : *
      {
         return _mdmBrowser;
      }
      
      public function get mdmDialogs() : *
      {
         return _mdmDialogs;
      }
      
      public function unregisterBrowserController(param1:IMDMBrowserController) : void
      {
         delete _browserRegistry[param1.browserKey];
      }
      
      public function restoreLastMdmBrowsersStates() : void
      {
         var _loc2_:IMDMBrowserController = null;
         if(_lastBrowsersStates.length == 0)
         {
            return;
         }
         var _loc1_:Dictionary = _lastBrowsersStates.pop();
         for each(_loc2_ in _browserRegistry)
         {
            if(_loc1_[_loc2_] != null)
            {
               log("restoreLastMdmBrowserStates: key=" + _loc2_.browserKey.name + " params=\n" + Utils.ObjectToString(_loc1_[_loc2_]));
               _loc2_.visible = _loc1_[_loc2_].visible;
            }
         }
      }
      
      public function set mdmBrowser(param1:*) : void
      {
         _mdmBrowser = param1;
      }
      
      public function hideAllMdmBrowsers() : void
      {
         var _loc2_:IMDMBrowserController = null;
         log("hideAllMdmBrowsers()");
         var _loc1_:Dictionary = new Dictionary(true);
         for each(_loc2_ in _browserRegistry)
         {
            _loc1_[_loc2_] = {"visible":_loc2_.visible};
            if(_loc2_.visible)
            {
               _loc2_.visible = false;
            }
         }
         _lastBrowsersStates.push(_loc1_);
      }
      
      public function getBrowserController(param1:MDMBrowserKey) : IMDMBrowserController
      {
         if(_browserRegistry[param1] == null)
         {
            return null;
         }
         return _browserRegistry[param1];
      }
      
      public function set mdmDialogs(param1:*) : void
      {
         _mdmDialogs = param1;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MDMManager: " + param1);
      }
      
      public function get mdmHTTP() : *
      {
         return _mdmHTTP;
      }
      
      public function get mdmApplication() : *
      {
         return _mdmApplication;
      }
      
      private function onExitTimerComplete(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         e.target.removeEventListener(TimerEvent.TIMER_COMPLETE,onExitTimerComplete);
         mdmApplication.onAppExit = function():*
         {
         };
         mdmApplication.exit();
      }
      
      public function setAnalyticsManager(param1:IAnalyticsManager) : void
      {
         _analyticsManager = param1;
      }
      
      public function set mdmProcess(param1:*) : void
      {
         _mdmProcess = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MDMManager: " + param1);
      }
      
      public function exitApplication() : void
      {
         log("exitApplication()");
         EventManager.getInstance().dispatchEvent(new ProjectEvent("SHOW_BLOCKER"));
         var _loc1_:Timer = new Timer(EXIT_DELAY_TIME,1);
         _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,onExitTimerComplete);
         _loc1_.start();
         if(_analyticsManager != null)
         {
            _analyticsManager.trackView(View.APP_EXIT);
         }
      }
      
      public function get mdmProcess() : *
      {
         return _mdmProcess;
      }
      
      public function set mdmMacShell(param1:*) : void
      {
         _mdmMacShell = param1;
      }
      
      public function set mdmApplication(param1:*) : void
      {
         _mdmApplication = param1;
      }
   }
}

