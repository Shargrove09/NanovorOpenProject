package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.MovieClip;
   
   public interface IChatHeaderGlobal
   {
      
      function set privateChatMessageManager(param1:ChatMessageManager) : void;
      
      function get mode() : String;
      
      function get instructions() : MovieClip;
      
      function set mode(param1:String) : void;
      
      function removeSelectedChatRoomChangedHandler(param1:ISelectedChatRoomChangedHandler) : void;
      
      function enableMouse() : void;
      
      function hidePublicChat() : void;
      
      function addSelectedChatRoomChangedHandler(param1:ISelectedChatRoomChangedHandler) : void;
      
      function setPublicTitle(param1:String) : void;
      
      function set publicChatMessageManager(param1:ChatMessageManager) : void;
      
      function set y(param1:Number) : void;
      
      function handleChatHeaderDropDownEntryClick(param1:String) : void;
      
      function get y() : Number;
      
      function disableMouse() : void;
      
      function showPublicChat() : void;
   }
}

