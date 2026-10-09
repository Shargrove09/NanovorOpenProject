package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol110")]
   public class ChatPanel extends MovieClip implements IChatPanel
   {
      
      public var mcChatInputPanel:ChatInputPanel;
      
      private var _handlers:Dictionary;
      
      public var mcScrollBarContainer:MovieClip;
      
      public var mcChatBG:MovieClip;
      
      public var mcPrivateChatMessageContainer:MovieClip;
      
      public var mcPublicChatMessageContainer:MovieClip;
      
      public var mcChatMessageContainerMask:MovieClip;
      
      public var mcChatHeader:ChatHeaderGlobal;
      
      public function ChatPanel()
      {
         super();
         this.createHandlersDictionary();
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[IChatPanelClickedHandler] = new Dictionary(true);
         addEventListener(MouseEvent.CLICK,this.handleChatPanelClicked);
      }
      
      private function handleChatPanelClicked(param1:MouseEvent) : void
      {
         var _loc2_:IChatPanelClickedHandler = null;
         for each(_loc2_ in this._handlers[IChatPanelClickedHandler])
         {
            _loc2_.handleChatPanelClicked();
         }
      }
      
      public function get chatHeader() : IChatHeaderGlobal
      {
         return this.mcChatHeader;
      }
      
      public function get publicChatMessageContainer() : MovieClip
      {
         return this.mcPublicChatMessageContainer;
      }
      
      public function get chatMessageContainerMask() : MovieClip
      {
         return this.mcChatMessageContainerMask;
      }
      
      public function get chatInputPanel() : IChatInputPanel
      {
         return this.mcChatInputPanel;
      }
      
      public function get privateChatMessageContainer() : MovieClip
      {
         return this.mcPrivateChatMessageContainer;
      }
      
      public function get scrollBarContainer() : MovieClip
      {
         return this.mcScrollBarContainer;
      }
      
      public function removeChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void
      {
         delete this._handlers[IChatPanelClickedHandler][param1];
      }
      
      public function get chatBG() : MovieClip
      {
         return this.mcChatBG;
      }
      
      public function addChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void
      {
         this._handlers[IChatPanelClickedHandler][param1] = param1;
      }
   }
}

