package com.arkadium.virmon.framework.asset
{
   public class ManifestReference extends AbstractManifestReference
   {
      
      private var _superManifestName:String;
      
      public function ManifestReference(param1:IAssetManifest, param2:String, param3:String, param4:String, param5:String, param6:Boolean)
      {
         super(param1,param2,param3,param4,param6);
         _superManifestName = isEmpty(param5) ? null : param5;
      }
      
      override public function get manifestType() : ManifestType
      {
         return ManifestType.NORMAL;
      }
      
      override public function get superManifestName() : String
      {
         return _superManifestName;
      }
   }
}

