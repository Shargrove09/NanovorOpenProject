package com.arkadium.virmon.framework.asset
{
   public interface IManifestMetadataLoaderConsumer
   {
      
      function handleManifestMetadataLoadError(param1:String) : void;
      
      function handleManifestMetadataLoadComplete(param1:Boolean, param2:String, param3:IManifestReference) : void;
   }
}

