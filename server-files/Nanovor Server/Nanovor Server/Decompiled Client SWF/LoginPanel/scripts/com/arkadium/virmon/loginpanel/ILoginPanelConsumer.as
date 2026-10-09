package com.arkadium.virmon.loginpanel
{
   public interface ILoginPanelConsumer
   {
      
      function handleExitApplication() : void;
      
      function handleNewAccount() : void;
      
      function handleForgotPassword() : void;
   }
}

