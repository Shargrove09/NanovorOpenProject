package com.arkadium.virmon.framework.asset
{
   public interface IManifestMetadataParserConsumer
   {
      
      function handleManifestMetadataParseComplete(param1:IAssetManifestMetadata, param2:IManifestReference) : void;
   }
}

