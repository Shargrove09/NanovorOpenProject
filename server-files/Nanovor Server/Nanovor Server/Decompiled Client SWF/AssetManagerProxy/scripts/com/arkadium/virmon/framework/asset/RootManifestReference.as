package com.arkadium.virmon.framework.asset
{
   public class RootManifestReference extends ManifestReference
   {
      
      public function RootManifestReference()
      {
         super(null,AssetLocation.ROOT_MANIFEST_NAME.name,AssetLocation.MANIFEST_FILE_NAME.name,"",null,false);
      }
   }
}

