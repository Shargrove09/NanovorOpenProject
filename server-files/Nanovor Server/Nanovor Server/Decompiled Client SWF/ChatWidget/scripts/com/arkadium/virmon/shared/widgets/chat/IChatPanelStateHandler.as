package com.arkadium.virmon.shared.widgets.chat
{
   public interface IChatPanelStateHandler
   {
      
      function handleChatPanelClosed() : void;
      
      function handlePrivateMessageAdded() : void;
      
      function handleChatPanelOpened() : void;
   }
}

