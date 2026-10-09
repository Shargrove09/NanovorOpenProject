package com.arkadium.virmon.framework.asset
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class AssetManifestMetadata implements IAssetManifestMetadata
   {
      
      private static const LAST_UPDATE_TOKEN:String = "{LastUpdate}";
      
      private static const GROUPS_TOKEN:String = "{Groups}";
      
      private static const MANIFESTS_TOKEN:String = "{Manifests}";
      
      private static const METADATA_TEMPLATE:String = "<ManifestMetadata lastUpdate=\"" + LAST_UPDATE_TOKEN + "\">\n\t<Assets>\n" + GROUPS_TOKEN + "\t</Assets>\n\t<Manifests>\n" + MANIFESTS_TOKEN + "\t</Manifests>\n</ManifestMetadata>";
      
      private var _requiredDownloadCount:int;
      
      private var _lastUpdate:Date;
      
      private var _posixFilePath:String;
      
      private var _manifests:Dictionary;
      
      private var _fileOperator:IFileOperator;
      
      private var _groups:Dictionary;
      
      public function AssetManifestMetadata(param1:IFileOperator, param2:String, param3:Dictionary, param4:Dictionary, param5:Date)
      {
         super();
         _fileOperator = param1;
         _posixFilePath = param2;
         _groups = param3;
         _manifests = param4;
         _lastUpdate = param5;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AssetManifestMetadata: " + param1);
      }
      
      public function get hasAllRequiredAssets() : Boolean
      {
         return Boolean(0 == _requiredDownloadCount);
      }
      
      public function getManifestReferenceCRC(param1:String) : String
      {
         return _manifests[param1];
      }
      
      public function writeToFile() : void
      {
         _fileOperator.saveFile(_posixFilePath,createXMLString(),false);
      }
      
      public function set requiredDownloadCount(param1:int) : void
      {
         _requiredDownloadCount = param1;
      }
      
      private function generateManifestsXMLString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in _manifests)
         {
            _loc1_ += "\t\t<Manifest name=\"" + _loc2_ + "\" CRC=\"" + _manifests[_loc2_] + "\" />\n";
         }
         return _loc1_;
      }
      
      private function generateGroupsXMLString() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in _groups)
         {
            _loc1_ += "\t\t<Group name=\"" + _loc2_ + "\">\n";
            for(_loc3_ in _groups[_loc2_.toLowerCase()])
            {
               _loc1_ += "\t\t\t<Asset Id=\"" + _loc3_ + "\" CRC=\"" + _groups[_loc2_.toLowerCase()][_loc3_] + "\" />\n";
            }
            _loc1_ += "\t\t</Group>\n";
         }
         return _loc1_;
      }
      
      public function updateManifest(param1:String, param2:String) : void
      {
         _lastUpdate = new Date();
         _manifests[param1] = param2;
      }
      
      public function updateAsset(param1:String, param2:String, param3:String) : void
      {
         if(null == param2 || "" == param2)
         {
            throw new Error("UH-OH: assetId = null, groupName=" + param1 + "\n");
         }
         _lastUpdate = new Date();
         if(_groups[param1.toLowerCase()] == null)
         {
            _groups[param1.toLowerCase()] = new Dictionary();
         }
         _groups[param1.toLowerCase()][param2] = param3;
         if(_requiredDownloadCount != 0)
         {
            --_requiredDownloadCount;
         }
      }
      
      public function getAssetCRC(param1:String, param2:String) : String
      {
         if(null == _groups[param1.toLowerCase()])
         {
            return null;
         }
         return _groups[param1.toLowerCase()][param2];
      }
      
      private function createXMLString() : String
      {
         var _loc1_:String = METADATA_TEMPLATE.replace(LAST_UPDATE_TOKEN,_lastUpdate.toLocaleString());
         _loc1_ = _loc1_.replace(GROUPS_TOKEN,generateGroupsXMLString());
         return _loc1_.replace(MANIFESTS_TOKEN,generateManifestsXMLString());
      }
   }
}

