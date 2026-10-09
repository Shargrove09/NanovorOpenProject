package com.arkadium.virmon.avatar
{
   public interface IAvatarSpinnerProvider
   {
      
      function addAvatarSpinnerCloseHandler(param1:IAvatarSpinnerCloseHandler) : void;
      
      function get avatarSpinnerState() : IAvatarSpinnerState;
      
      function closeAvatarSpinners() : void;
      
      function addAvatarSpinnerOpenHandler(param1:IAvatarSpinnerOpenHandler) : void;
   }
}

