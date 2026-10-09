package com.arkadium.virmon.loginpanel
{
   import com.arkadium.communications.IVersionDataProvider;
   import com.arkadium.virmon.wrapper.view.ILoginSubmitHandler;
   import flash.display.Sprite;
   
   public interface ILoginPanel
   {
      
      function replaceStatusMessage(param1:String, param2:String = "") : void;
      
      function get sprite() : Sprite;
      
      function renderShardList(param1:Array) : void;
      
      function handleSuccessfulLogin() : void;
      
      function autoFillUserName(param1:String) : void;
      
      function initAfterDataRetrievalError() : void;
      
      function handleSRBConnected() : void;
      
      function init(param1:ILoginSubmitHandler, param2:ILoginPanelConsumer) : void;
      
      function addStatusMessage(param1:String, param2:String = "", param3:Boolean = false) : void;
      
      function get userName() : String;
      
      function renderVersionInfo(param1:IVersionDataProvider) : void;
      
      function handleSRBInitialized() : void;
      
      function get password() : String;
      
      function get gameServerIP() : String;
      
      function initAfterInvalidLogin() : void;
   }
}

