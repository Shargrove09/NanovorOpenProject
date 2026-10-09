package com.arkadium.virmon.shared.widgets.chat
{
   public interface IChatMessageProvider
   {
      
      function addTextChangedHandler(param1:ITextChangedHandler) : void;
      
      function get message() : String;
      
      function clearMessage() : void;
      
      function addSendMessageHandler(param1:ISendMessageHandler) : void;
      
      function removeTextChangedHandler(param1:ITextChangedHandler) : void;
      
      function removeSendMessageHandler(param1:ISendMessageHandler) : void;
   }
}

