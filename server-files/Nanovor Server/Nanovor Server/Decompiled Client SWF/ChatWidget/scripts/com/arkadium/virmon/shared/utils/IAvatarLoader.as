package com.arkadium.virmon.shared.utils
{
   public interface IAvatarLoader
   {
      
      function loadSmallAvatarPicture(param1:int, param2:IAvatarLoaderConsumer) : void;
      
      function loadAvatarPicture(param1:int, param2:IAvatarLoaderConsumer) : void;
   }
}

