package com.arkadium.communications.handlers.chat
{
   public interface IChatMessageReceivedHandler
   {
      
      function handleChatMessageReceived(param1:ChatRoomType, param2:String, param3:int, param4:int, param5:String) : void;
   }
}

