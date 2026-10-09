package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.communications.handlers.chat.ChatRoomType;
   
   public interface ISelectedChatRoomChangedHandler
   {
      
      function handleSelectedChatRoomChangedHandler(param1:ChatRoomType) : void;
   }
}

