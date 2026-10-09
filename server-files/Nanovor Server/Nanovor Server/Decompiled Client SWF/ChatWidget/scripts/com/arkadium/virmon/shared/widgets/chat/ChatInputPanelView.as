package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.IPermissionsManager;
   import com.arkadium.virmon.shared.utils.AvatarLoaderProvider;
   import com.arkadium.virmon.shared.utils.IAvatarLoader;
   import com.arkadium.virmon.shared.utils.IAvatarLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IAvatarLoaderProvider;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   
   public class ChatInputPanelView implements IAvatarLoaderConsumer, IAvatarUpdatedHandler, ISendMessageHandler, ITextChangedHandler
   {
      
      private var _chatMessageProvider:IChatMessageProvider;
      
      private var _isSendButtonActive:Boolean;
      
      private var _avatarLoader:IAvatarLoader;
      
      private var _chatInputPanelController:IChatInputPanelController;
      
      private var _avatarId:int;
      
      private var _chatInputPanel:IChatInputPanel;
      
      public function ChatInputPanelView(param1:IChatInputPanel, param2:IPermissionsManager, param3:IChatInputPanelController)
      {
         super();
         this._chatInputPanel = param1;
         this._chatInputPanel.addSendMessageHandler(ISendMessageHandler(this));
         this._chatInputPanel.playerNameTextField.text = UserProfile.getInstance().screenname.toUpperCase();
         this._chatInputPanelController = param3;
         this._chatInputPanelController.addAvatarUpdatedHandler(IAvatarUpdatedHandler(this));
         if(false == param2.canChat)
         {
            DebugLog.instance.log("<<ChatInputPanelView>> enabling canned chat...");
            this._chatInputPanel.enableCannedChat();
            this._chatMessageProvider = new CannedChatPanelView(this._chatInputPanel.cannedChatPanel);
         }
         else
         {
            this._chatInputPanel.disableCannedChat();
            this._chatMessageProvider = this._chatInputPanel;
         }
         this._chatMessageProvider.addTextChangedHandler(ITextChangedHandler(this));
         this._chatMessageProvider.addSendMessageHandler(ISendMessageHandler(this));
         this.loadAvatarPicture(new AvatarLoaderProvider(),UserProfile.getInstance().avatarId);
      }
      
      public function handleAvatarLoadComplete(param1:DisplayObject) : void
      {
         param1.x = 1;
         param1.y = -3;
         this._chatInputPanel.avatarMovieClip.addChild(param1);
         Tweener.addTween(param1,{
            "alpha":1,
            "time":1
         });
         while(this._chatInputPanel.avatarMovieClip.numChildren > 1)
         {
            this._chatInputPanel.avatarMovieClip.removeChildAt(0);
         }
      }
      
      public function clearMessage() : void
      {
         this._chatMessageProvider.clearMessage();
      }
      
      private function isBlank(param1:String) : Boolean
      {
         if(null == param1)
         {
            return true;
         }
         if(ChatInputPanel.DEFAULT_MESSAGE_TEXT == param1)
         {
            return true;
         }
         if(0 == param1.replace(/\s+/,"").length)
         {
            return true;
         }
         return false;
      }
      
      public function handleSendMessage() : void
      {
         if(this.isBlank(this._chatMessageProvider.message))
         {
            return;
         }
         this._chatInputPanelController.sendMessage(this._chatMessageProvider.message);
         this._chatMessageProvider.clearMessage();
         this.disableSendButton();
      }
      
      public function handleAvatarLoadError(param1:String) : void
      {
         DebugLog.instance.error("<<ChatInputPanelView>> handleAvatarLoadError(): " + param1);
      }
      
      public function loadAvatarPicture(param1:IAvatarLoaderProvider, param2:int) : void
      {
         this._avatarLoader = param1.avatarLoader;
         this._avatarId = param2;
         this._avatarLoader.loadSmallAvatarPicture(this._avatarId,IAvatarLoaderConsumer(this));
      }
      
      private function disableSendButton() : void
      {
         if(false == this._isSendButtonActive)
         {
            return;
         }
         this._isSendButtonActive = false;
         this._chatInputPanel.sendSpinningButton.disable(true);
      }
      
      public function handleAvatarUpdated(param1:Object = null) : void
      {
         if(UserProfile.getInstance().id != int(param1.userRefId))
         {
            return;
         }
         this._avatarId = int(param1.avatarId);
         this._avatarLoader.loadSmallAvatarPicture(this._avatarId,IAvatarLoaderConsumer(this));
      }
      
      private function activateSendButton() : void
      {
         if(this._isSendButtonActive)
         {
            return;
         }
         this._isSendButtonActive = true;
         this._chatInputPanel.sendSpinningButton.disable(false);
      }
      
      public function handleTextChanged(param1:String) : void
      {
         if(this.isBlank(param1))
         {
            this.disableSendButton();
            return;
         }
         this.activateSendButton();
      }
   }
}

