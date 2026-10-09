package com.arkadium.virmon.framework.asset
{
   import flash.utils.Dictionary;
   
   public class AssetManifest implements IAssetManifest
   {
      
      private var _assetManifestMetadata:IAssetManifestMetadata;
      
      private var _manifestReferenceList:Dictionary;
      
      private var _manifestReference:IManifestReference;
      
      private var _requiredDownloadList:Array;
      
      private var _hasAllRequiredAssets:Boolean;
      
      private var _groupList:Dictionary;
      
      public function AssetManifest(param1:IManifestReference, param2:IAssetManifestMetadata)
      {
         super();
         _hasAllRequiredAssets = false;
         _manifestReference = param1;
         _assetManifestMetadata = param2;
         _groupList = new Dictionary();
         _manifestReferenceList = new Dictionary();
      }
      
      public function set requiredDownloadList(param1:Array) : void
      {
         _requiredDownloadList = param1;
      }
      
      public function get name() : String
      {
         return _manifestReference.name;
      }
      
      public function get assetManifestMetadata() : IAssetManifestMetadata
      {
         return _assetManifestMetadata;
      }
      
      public function get manifestType() : ManifestType
      {
         return _manifestReference.manifestType;
      }
      
      public function getFullFolderPath() : String
      {
         var _loc1_:String = "";
         if(null != _manifestReference.parentAssetManifest)
         {
            _loc1_ += _manifestReference.parentAssetManifest.getFullFolderPath();
         }
         return _loc1_ + _manifestReference.fileName.replace(AssetLocation.MANIFEST_FILE_NAME.name,"");
      }
      
      public function addGroup(param1:IAssetGroup) : void
      {
         _groupList[param1.name.toLowerCase()] = param1;
      }
      
      public function get fileName() : String
      {
         return _manifestReference.fileName;
      }
      
      public function get parent() : IAssetManifest
      {
         return _manifestReference.parentAssetManifest;
      }
      
      public function getGroupByName(param1:String) : IAssetGroup
      {
         return _groupList[param1.toLowerCase()];
      }
      
      public function get CRC() : String
      {
         return _manifestReference.CRC;
      }
      
      public function get superManifestName() : String
      {
         return _manifestReference.superManifestName;
      }
      
      public function get groupList() : Dictionary
      {
         return _groupList;
      }
   }
}

