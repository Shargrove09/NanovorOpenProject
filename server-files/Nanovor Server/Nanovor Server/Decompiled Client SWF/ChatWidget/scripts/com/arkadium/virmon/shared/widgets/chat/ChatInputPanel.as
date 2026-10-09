package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconExclaimation;
   import com.arkadium.virmon.shared.final.components.spinningbutton.ISpinningButtonComponent;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.utils.IAvatarLoader;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol105")]
   public class ChatInputPanel extends MovieClip implements IChatInputPanel
   {
      
      public static const DEFAULT_MESSAGE_TEXT:String = "<Enter chat message>";
      
      public var mcAvatar:MovieClip;
      
      public var mcAvatarHolder:MovieClip;
      
      public var tfPlayerName:TextField;
      
      private var _avatarLoader:IAvatarLoader;
      
      public var tfMessage:TextField;
      
      private var _inputTextField:TextField;
      
      private var _handlers:Dictionary;
      
      private var _avatarId:int;
      
      private var _mcSend:SpinningButtonComponent;
      
      public var mcCannedChat:CannedChatPanel;
      
      public function ChatInputPanel()
      {
         super();
         this.createHandlersDictionary();
         this.initializeInputTextField();
         this._mcSend = new SpinningButtonComponent(new SpinnerIconExclaimation());
         this._mcSend.x = 336;
         this._mcSend.y = 38;
         addChild(this._mcSend);
         this._mcSend.open();
         this._mcSend.disable(true);
         this._mcSend.addEventListener(MouseEvent.CLICK,this.handleSendButtonClick);
      }
      
      private function handleSendButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:ISendMessageHandler = null;
         for each(_loc2_ in this._handlers[ISendMessageHandler])
         {
            _loc2_.handleSendMessage();
         }
      }
      
      public function get message() : String
      {
         return this.tfMessage.text;
      }
      
      public function addTextChangedHandler(param1:ITextChangedHandler) : void
      {
         this._handlers[ITextChangedHandler][param1] = param1;
      }
      
      public function enableCannedChat() : void
      {
         this.mcCannedChat.visible = true;
         this.addChild(this.mcCannedChat);
         this.tfMessage.visible = false;
      }
      
      public function get playerNameTextField() : TextField
      {
         return this.tfPlayerName;
      }
      
      public function removeTextChangedHandler(param1:ITextChangedHandler) : void
      {
         delete this._handlers[ITextChangedHandler][param1];
      }
      
      private function handleFocusOut(param1:FocusEvent) : void
      {
         this.setDefaultText();
      }
      
      public function removeSendMessageHandler(param1:ISendMessageHandler) : void
      {
         delete this._handlers[ISendMessageHandler][param1];
      }
      
      public function disableCannedChat() : void
      {
         this.mcCannedChat.visible = false;
         if(null != this.mcCannedChat.parent)
         {
            this.mcCannedChat.parent.removeChild(this.mcCannedChat);
         }
         this.tfMessage.visible = true;
         this.tfMessage.addEventListener(Event.CHANGE,this.handleTextChanged);
         this.tfMessage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      public function get avatarMovieClip() : MovieClip
      {
         return this.mcAvatar;
      }
      
      public function setDefaultText() : void
      {
         if(this.tfMessage == stage.focus)
         {
            return;
         }
         if("" == this.tfMessage.text)
         {
            this.tfMessage.text = ChatInputPanel.DEFAULT_MESSAGE_TEXT;
         }
      }
      
      private function initializeInputTextField() : void
      {
         this.tfMessage.wordWrap = true;
         this.tfMessage.maxChars = 56;
         this.tfMessage.restrict = "^1234567890@";
         this.tfMessage.text = ChatInputPanel.DEFAULT_MESSAGE_TEXT;
         this.tfMessage.addEventListener(FocusEvent.FOCUS_IN,this.handleFocusIn);
         this.tfMessage.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocusOut);
      }
      
      private function handleFocusIn(param1:FocusEvent) : void
      {
         if(ChatInputPanel.DEFAULT_MESSAGE_TEXT == this.tfMessage.text)
         {
            this.tfMessage.text = "";
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:ISendMessageHandler = null;
         if(Keyboard.ENTER != param1.keyCode)
         {
            return;
         }
         for each(_loc2_ in this._handlers[ISendMessageHandler])
         {
            _loc2_.handleSendMessage();
         }
      }
      
      public function get cannedChatPanel() : ICannedChatPanel
      {
         return this.mcCannedChat;
      }
      
      public function get avatarHolder() : MovieClip
      {
         return this.mcAvatarHolder;
      }
      
      public function get sendSpinningButton() : ISpinningButtonComponent
      {
         return this._mcSend;
      }
      
      public function addSendMessageHandler(param1:ISendMessageHandler) : void
      {
         this._handlers[ISendMessageHandler][param1] = param1;
      }
      
      public function clearMessage() : void
      {
         this.tfMessage.text = "";
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[ITextChangedHandler] = new Dictionary(true);
         this._handlers[ISendMessageHandler] = new Dictionary(true);
      }
      
      private function handleTextChanged(param1:Event) : void
      {
         var _loc2_:ITextChangedHandler = null;
         for each(_loc2_ in this._handlers[ITextChangedHandler])
         {
            _loc2_.handleTextChanged(this.tfMessage.text);
         }
      }
   }
}

