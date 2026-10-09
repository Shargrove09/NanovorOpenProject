package com.arkadium.virmon.loginpanel.login.model
{
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginEligible;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginError;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginShardInitializer;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginStatusMessageHandler;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginUsernameAutoFill;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginVersionReceived;
   
   public interface ILoginPanelLoginModel
   {
      
      function addLoginVersionHandler(param1:ILoginVersionReceived) : void;
      
      function get gameServerIP() : String;
      
      function updateShardIndex(param1:int) : void;
      
      function addLoginStatusUpdateHandler(param1:ILoginStatusMessageHandler) : void;
      
      function autoFillUserName(param1:String) : void;
      
      function handleGotoForgotPassword() : void;
      
      function addLoginErrorHandler(param1:ILoginError) : void;
      
      function addLoginEligibleHandler(param1:ILoginEligible) : void;
      
      function addLoginShardInitializer(param1:ILoginShardInitializer) : void;
      
      function handleLoginError() : void;
      
      function setStatusMessage(param1:String, param2:Boolean = false) : void;
      
      function updateLoginCredentials(param1:String, param2:String) : void;
      
      function handleSRBConnected() : void;
      
      function get username() : String;
      
      function handleGotoNewAccount() : void;
      
      function handleSRBInitialized() : void;
      
      function addLoginUsernameAutoFillhandler(param1:ILoginUsernameAutoFill) : void;
      
      function get password() : String;
      
      function attemptLogin(param1:String, param2:String, param3:Boolean) : void;
      
      function setVersion(param1:String) : void;
   }
}

