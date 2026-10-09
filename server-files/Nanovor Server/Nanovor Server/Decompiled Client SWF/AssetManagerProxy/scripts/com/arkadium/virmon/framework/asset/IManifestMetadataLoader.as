package com.arkadium.virmon.framework.asset
{
   public interface IManifestMetadataLoader
   {
      
      function get manifestMetadataXML() : XML;
      
      function load(param1:String, param2:IManifestMetadataLoaderConsumer) : void;
   }
}

