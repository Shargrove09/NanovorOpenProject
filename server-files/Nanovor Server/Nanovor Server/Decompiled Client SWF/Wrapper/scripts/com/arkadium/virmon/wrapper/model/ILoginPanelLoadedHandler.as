package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   
   public interface ILoginPanelLoadedHandler
   {
      
      function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void;
   }
}

