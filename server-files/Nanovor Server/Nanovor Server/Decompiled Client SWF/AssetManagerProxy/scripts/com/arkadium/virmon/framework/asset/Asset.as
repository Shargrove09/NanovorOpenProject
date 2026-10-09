package com.arkadium.virmon.framework.asset
{
   public class Asset implements IAsset
   {
      
      private var _id:String;
      
      private var _fileName:String;
      
      private var _assetGroup:IAssetGroup;
      
      private var _type:uint;
      
      private var _isPreMinSet:Boolean;
      
      private var _CRC:String;
      
      private var _superId:String;
      
      private var _isDefault:Boolean = false;
      
      public function Asset(param1:String, param2:uint, param3:String, param4:String, param5:Boolean, param6:String, param7:IAssetGroup, param8:Boolean)
      {
         super();
         _id = isEmpty(param1) ? null : param1;
         _type = param2;
         _fileName = isEmpty(param3) ? null : param3;
         _CRC = isEmpty(param4) ? null : param4;
         _isDefault = param5;
         _superId = isEmpty(param6) ? null : param6;
         _assetGroup = param7;
         _isPreMinSet = param8;
      }
      
      private function isEmpty(param1:String) : Boolean
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
      
      public function updateAssetInManifestMetadata() : void
      {
         _assetGroup.manifest.assetManifestMetadata.updateAsset(_assetGroup.name,_id,_CRC);
         _assetGroup.manifest.assetManifestMetadata.writeToFile();
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get fileName() : String
      {
         return _fileName;
      }
      
      public function get isPreMinSet() : Boolean
      {
         return _isPreMinSet;
      }
      
      public function get assetGroup() : IAssetGroup
      {
         return _assetGroup;
      }
      
      public function get isOutdated() : Boolean
      {
         return _CRC != _assetGroup.manifest.assetManifestMetadata.getAssetCRC(_assetGroup.name,_id);
      }
      
      public function get type() : uint
      {
         return _type;
      }
      
      public function get CRC() : String
      {
         return _CRC;
      }
      
      public function get superId() : String
      {
         return _superId;
      }
      
      public function get isDefault() : Boolean
      {
         return _isDefault;
      }
      
      public function get fullFilePath() : String
      {
         return _assetGroup.manifest.getFullFolderPath() + _fileName;
      }
   }
}

