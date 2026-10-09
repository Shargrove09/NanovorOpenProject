package com.arkadium.virmon.framework.application
{
   public interface IApplicationManifestMetadataLoader
   {
      
      function get manifestMetadataXML() : XML;
      
      function load(param1:IApplicationManifestMetadataLoaderConsumer) : void;
   }
}

