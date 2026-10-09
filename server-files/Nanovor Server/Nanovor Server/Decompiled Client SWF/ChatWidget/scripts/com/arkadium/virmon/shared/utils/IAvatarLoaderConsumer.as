package com.arkadium.virmon.shared.utils
{
   import flash.display.DisplayObject;
   
   public interface IAvatarLoaderConsumer
   {
      
      function handleAvatarLoadComplete(param1:DisplayObject) : void;
      
      function handleAvatarLoadError(param1:String) : void;
      
      function loadAvatarPicture(param1:IAvatarLoaderProvider, param2:int) : void;
   }
}

