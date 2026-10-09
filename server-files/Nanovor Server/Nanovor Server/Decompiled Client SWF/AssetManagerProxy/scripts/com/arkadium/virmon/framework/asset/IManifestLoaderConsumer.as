package com.arkadium.virmon.framework.asset
{
   public interface IManifestLoaderConsumer
   {
      
      function handleManifestLoadError(param1:String) : void;
      
      function handleManifestLoadComplete(param1:IManifestReference) : void;
   }
}

