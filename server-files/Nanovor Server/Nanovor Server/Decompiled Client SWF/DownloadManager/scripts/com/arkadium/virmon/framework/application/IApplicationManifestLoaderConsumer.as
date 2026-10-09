package com.arkadium.virmon.framework.application
{
   public interface IApplicationManifestLoaderConsumer
   {
      
      function handleManifestLoadError(param1:String) : void;
      
      function handleManifestLoadComplete() : void;
   }
}

