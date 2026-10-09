package com.arkadium.virmon.shared.mdm
{
   import com.arkadium.analytics.IAnalyticsManager;
   
   public interface IMDMManager
   {
      
      function get mdmFilesystem() : *;
      
      function set mdmFilesystem(param1:*) : void;
      
      function get mdmSystem() : *;
      
      function registerBrowserController(param1:IMDMBrowserController) : void;
      
      function setAnalyticsManager(param1:IAnalyticsManager) : void;
      
      function set mdmSystem(param1:*) : void;
      
      function unregisterBrowserController(param1:IMDMBrowserController) : void;
      
      function exitApplication() : void;
      
      function get mdmDialogs() : *;
      
      function get mdmBrowser() : *;
      
      function restoreLastMdmBrowsersStates() : void;
      
      function get mdmProcess() : *;
      
      function hideAllMdmBrowsers() : void;
      
      function set mdmBrowser(param1:*) : void;
      
      function set mdmDialogs(param1:*) : void;
      
      function set mdmMacShell(param1:*) : void;
      
      function set mdmProcess(param1:*) : void;
      
      function set mdmApplication(param1:*) : void;
      
      function getBrowserController(param1:MDMBrowserKey) : IMDMBrowserController;
      
      function get mdmMacShell() : *;
      
      function pushFakeBrowserState(param1:MDMBrowserKey, param2:Object) : void;
      
      function get mdmApplication() : *;
      
      function set mdmHTTP(param1:*) : void;
      
      function get mdmHTTP() : *;
   }
}

