package com.arkadium.virmon.framework.asset
{
   public class AbstractManifestReference implements IManifestReference
   {
      
      private var _fileName:String;
      
      private var _isPreMinSet:Boolean;
      
      private var _authorityCRC:String;
      
      private var _name:String;
      
      private var _parentAssetManifest:IAssetManifest;
      
      public function AbstractManifestReference(param1:IAssetManifest, param2:String, param3:String, param4:String, param5:Boolean)
      {
         super();
         _parentAssetManifest = param1;
         _name = isEmpty(param2) ? null : param2;
         _fileName = isEmpty(param3) ? null : param3;
         _authorityCRC = isEmpty(param4) ? null : param4;
         _isPreMinSet = param5;
      }
      
      protected function isEmpty(param1:String) : Boolean
      {
         if(null == param1)
         {
            return true;
         }
         if(1 > param1.length)
         {
            return true;
         }
         return false;
      }
      
      public function get superManifestName() : String
      {
         return null;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get manifestType() : ManifestType
      {
         throw new Error("AbstractManifestReference::get manifestType() is abstract and must be implemented by subclasses.");
      }
      
      public function get fileName() : String
      {
         return _fileName;
      }
      
      public function get isPreMinSet() : Boolean
      {
         return _isPreMinSet;
      }
      
      private function isRoot() : Boolean
      {
         if(null == _parentAssetManifest)
         {
            return true;
         }
         if(null == _name)
         {
            return true;
         }
         if(null == _authorityCRC)
         {
            return true;
         }
         return false;
      }
      
      public function get isOutdated() : Boolean
      {
         if(isRoot())
         {
            return true;
         }
         return Boolean(_parentAssetManifest.assetManifestMetadata.getManifestReferenceCRC(_name) != _authorityCRC);
      }
      
      public function get CRC() : String
      {
         return _authorityCRC;
      }
      
      public function get parentAssetManifest() : IAssetManifest
      {
         return _parentAssetManifest;
      }
      
      public function updateManifestReferenceInMetadata() : void
      {
         if(isRoot())
         {
            return;
         }
         if(false == isOutdated)
         {
            return;
         }
         _parentAssetManifest.assetManifestMetadata.updateManifest(_name,_authorityCRC);
         _parentAssetManifest.assetManifestMetadata.writeToFile();
      }
   }
}

