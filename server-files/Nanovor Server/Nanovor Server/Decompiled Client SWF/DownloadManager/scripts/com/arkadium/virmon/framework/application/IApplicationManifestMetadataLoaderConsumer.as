package com.arkadium.virmon.framework.application
{
   public interface IApplicationManifestMetadataLoaderConsumer
   {
      
      function handleManifestMetadataLoadError(param1:String) : void;
      
      function handleManifestMetadataLoadComplete(param1:Boolean) : void;
   }
}

