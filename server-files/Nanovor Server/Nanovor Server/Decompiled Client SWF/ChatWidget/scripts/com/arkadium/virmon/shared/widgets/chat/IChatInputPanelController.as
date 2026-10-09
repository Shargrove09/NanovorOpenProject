package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   
   public interface IChatInputPanelController
   {
      
      function addAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void;
      
      function removeAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void;
      
      function sendMessage(param1:String) : void;
   }
}

