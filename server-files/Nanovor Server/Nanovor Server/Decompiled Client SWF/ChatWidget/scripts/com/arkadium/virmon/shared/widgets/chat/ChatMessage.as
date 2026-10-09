package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.avatar.AvatarManager;
   import com.arkadium.virmon.shared.utils.IAvatarLoader;
   import com.arkadium.virmon.shared.utils.IAvatarLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IAvatarLoaderProvider;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol11")]
   public class ChatMessage extends MovieClip implements IAvatarLoaderConsumer
   {
      
      public var tfPlayerName:TextField;
      
      private var _avatarLoader:IAvatarLoader;
      
      public var mcAvatar:MovieClip;
      
      private var _nmp:int;
      
      private var _avatarId:int;
      
      public var tfMessage:TextField;
      
      public var mcAvatarSpinnerTarget:MovieClip;
      
      public function ChatMessage()
      {
         super();
         this.mcAvatar.useHandCursor = false;
         addEventListener(MouseEvent.CLICK,this.handleAvatarClick,false,0,true);
      }
      
      public function handleAvatarLoadComplete(param1:DisplayObject) : void
      {
         this.mcAvatar.addChild(param1);
         this.mcAvatar.useHandCursor = true;
         this.mcAvatar.buttonMode = true;
         param1.x = 0;
         param1.y = -3;
         Tweener.addTween(param1,{
            "alpha":1,
            "time":1
         });
         while(this.mcAvatar.numChildren > 1)
         {
            this.mcAvatar.removeChildAt(0);
         }
      }
      
      public function handleAvatarLoadError(param1:String) : void
      {
         DebugLog.instance.error("<<ChatMessage>> failed to load avatar: " + param1);
      }
      
      public function set nmp(param1:int) : void
      {
         this._nmp = param1;
      }
      
      private function handleAvatarClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         AvatarManager.getInstance().handleAvatarClick(this.mcAvatarSpinnerTarget,this.tfPlayerName.text,this._avatarId,this._nmp);
      }
      
      public function loadAvatarPicture(param1:IAvatarLoaderProvider, param2:int) : void
      {
         this._avatarLoader = param1.avatarLoader;
         this._avatarId = param2;
         this._avatarLoader.loadSmallAvatarPicture(this._avatarId,IAvatarLoaderConsumer(this));
      }
   }
}

