package com.arkadium.virmon.framework.asset
{
   public class SuperManifestReference extends AbstractManifestReference
   {
      
      public function SuperManifestReference(param1:IAssetManifest, param2:String, param3:String, param4:String, param5:Boolean)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function get manifestType() : ManifestType
      {
         return ManifestType.SUPER;
      }
   }
}

