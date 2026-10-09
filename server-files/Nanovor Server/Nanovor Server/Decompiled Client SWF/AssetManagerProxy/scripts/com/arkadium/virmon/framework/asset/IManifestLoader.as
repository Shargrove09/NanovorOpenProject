package com.arkadium.virmon.framework.asset
{
   public interface IManifestLoader
   {
      
      function get assetManifestXML() : XML;
      
      function get posixFileName() : String;
      
      function load(param1:IManifestLoaderConsumer) : void;
   }
}

