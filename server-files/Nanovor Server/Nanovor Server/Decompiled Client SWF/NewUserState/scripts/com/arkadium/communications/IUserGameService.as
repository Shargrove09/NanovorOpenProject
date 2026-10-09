package com.arkadium.communications
{
   import com.arkadium.communications.handlers.user.IAvatarUpdatedHandler;
   import com.arkadium.communications.handlers.user.IBuddyAvatarDataHandler;
   import com.arkadium.communications.handlers.user.IForcedLogOutHandler;
   
   public interface IUserGameService extends IGameService
   {
      
      function getBuddyAvatar(param1:String) : void;
      
      function updateAvatar(param1:int) : void;
      
      function addBuddyAvatarDataHandler(param1:IBuddyAvatarDataHandler) : void;
      
      function removeForcedLogOutHandler(param1:IForcedLogOutHandler) : void;
      
      function removeBuddyAvatarDataHandler(param1:IBuddyAvatarDataHandler) : void;
      
      function updateUserToken(param1:String, param2:String) : void;
      
      function addForcedLogOutHandler(param1:IForcedLogOutHandler) : void;
      
      function addAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void;
      
      function updateNanovorCount() : void;
      
      function removeAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void;
   }
}

