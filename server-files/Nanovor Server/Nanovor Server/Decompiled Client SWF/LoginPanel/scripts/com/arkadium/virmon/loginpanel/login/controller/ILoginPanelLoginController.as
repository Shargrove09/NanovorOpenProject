package com.arkadium.virmon.loginpanel.login.controller
{
   public interface ILoginPanelLoginController
   {
      
      function handleGotoNewAccount() : void;
      
      function handleGotoForgotPassword() : void;
      
      function updateLoginCredentials(param1:String, param2:String) : void;
      
      function attemptLogin(param1:String, param2:String, param3:Boolean) : void;
      
      function updateShardIndex(param1:int) : void;
   }
}

