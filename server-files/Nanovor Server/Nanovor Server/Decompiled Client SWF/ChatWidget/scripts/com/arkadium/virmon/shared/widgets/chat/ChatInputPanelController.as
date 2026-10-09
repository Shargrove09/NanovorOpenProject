package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   import flash.utils.Dictionary;
   
   public class ChatInputPanelController implements IChatInputPanelController, IAvatarUpdatedHandler
   {
      
      private var _chatGameService:IChatGameService;
      
      private var _handlers:Dictionary;
      
      public function ChatInputPanelController(param1:IChatGameService, param2:IUserGameService)
      {
         super();
         this._chatGameService = param1;
         param2.addAvatarUpdatedHandler(IAvatarUpdatedHandler(this));
         this.createHandlersDictionary();
      }
      
      public function addAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void
      {
         this._handlers[IAvatarUpdatedHandler][param1] = param1;
      }
      
      private function isBlank(param1:String) : Boolean
      {
         if(null == param1)
         {
            return true;
         }
         if(0 == param1.replace(/\s+/,"").length)
         {
            return true;
         }
         return false;
      }
      
      public function removeAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void
      {
         delete this._handlers[IAvatarUpdatedHandler][param1];
      }
      
      public function handleAvatarUpdated(param1:Object = null) : void
      {
         var _loc2_:IAvatarUpdatedHandler = null;
         for each(_loc2_ in this._handlers[IAvatarUpdatedHandler])
         {
            _loc2_.handleAvatarUpdated(param1);
         }
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[IAvatarUpdatedHandler] = new Dictionary(true);
      }
      
      public function sendMessage(param1:String) : void
      {
         if(this.isBlank(param1))
         {
            return;
         }
         this._chatGameService.sendChatMessage(param1);
      }
   }
}

