package com.arkadium.virmon.shared.utils
{
   public class AvatarLoaderProvider implements IAvatarLoaderProvider
   {
      
      private var _avatarLoader:IAvatarLoader;
      
      public function AvatarLoaderProvider()
      {
         super();
         this._avatarLoader = new AvatarLoader();
      }
      
      public function get avatarLoader() : IAvatarLoader
      {
         return this._avatarLoader;
      }
   }
}

