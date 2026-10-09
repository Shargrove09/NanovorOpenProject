package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.MovieClip;
   
   public interface IChatPanel
   {
      
      function get publicChatMessageContainer() : MovieClip;
      
      function set alpha(param1:Number) : void;
      
      function set visible(param1:Boolean) : void;
      
      function get chatHeader() : IChatHeaderGlobal;
      
      function set mouseChildren(param1:Boolean) : void;
      
      function removeChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void;
      
      function get alpha() : Number;
      
      function addChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void;
      
      function get chatInputPanel() : IChatInputPanel;
      
      function get mouseChildren() : Boolean;
      
      function get privateChatMessageContainer() : MovieClip;
      
      function set mouseEnabled(param1:Boolean) : void;
      
      function get visible() : Boolean;
      
      function get scrollBarContainer() : MovieClip;
      
      function get mouseEnabled() : Boolean;
      
      function get chatBG() : MovieClip;
      
      function get chatMessageContainerMask() : MovieClip;
   }
}

