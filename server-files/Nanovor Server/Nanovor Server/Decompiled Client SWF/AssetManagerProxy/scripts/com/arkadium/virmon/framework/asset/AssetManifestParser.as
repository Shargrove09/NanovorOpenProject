package com.arkadium.virmon.framework.asset
{
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class AssetManifestParser implements IAssetManifestParser
   {
      
      private var _assetManagerProxy:IAssetManagerProxy;
      
      private var _assetManifestMetadata:IAssetManifestMetadata;
      
      public function AssetManifestParser(param1:IAssetManifestMetadata, param2:IAssetManagerProxy)
      {
         super();
         _assetManifestMetadata = param1;
         _assetManagerProxy = param2;
      }
      
      public function parseManifest(param1:IManifestReference, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:IAssetGroup = null;
         var _loc9_:XML = null;
         var _loc10_:IAsset = null;
         var _loc3_:IAssetManifest = new AssetManifest(param1,_assetManifestMetadata);
         for each(_loc4_ in param2.Assets.Group)
         {
            checkForMissingDefaultAsset(param1,_loc4_);
            _loc8_ = new AssetGroup(String(_loc4_.@name),isGroupXMLRedundant(_loc4_),_loc3_);
            for each(_loc9_ in _loc4_.Asset)
            {
               _loc10_ = createAsset(param1,_loc8_,_loc9_);
               _loc8_.addAsset(_loc10_);
            }
            _loc3_.addGroup(_loc8_);
         }
         _assetManagerProxy.addManifest(_loc3_);
         _loc5_ = new Array();
         for each(_loc6_ in param2..Manifests.Manifest)
         {
            _loc5_[_loc5_.length] = new ManifestReference(_loc3_,_loc6_.@name,_loc6_.@Filename,_loc6_.@CRC,_loc6_.@SuperManifestName,Boolean(String(_loc6_.@PreMinSet).toLowerCase() == "true"));
         }
         for each(_loc7_ in param2..SuperManifests.Manifest)
         {
            _loc5_[_loc5_.length] = new SuperManifestReference(_loc3_,_loc7_.@name,_loc7_.@Filename,_loc7_.@CRC,Boolean(String(_loc6_.@PreMinSet).toLowerCase() == "true"));
         }
         _assetManagerProxy.loadNextManifest(_loc5_);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetManifestParser>> " + param1);
      }
      
      private function isGroupXMLRedundant(param1:XML) : Boolean
      {
         return Boolean(String(param1.@redundant).toLowerCase() == "true");
      }
      
      private function createAsset(param1:IManifestReference, param2:IAssetGroup, param3:XML) : IAsset
      {
         var _loc4_:int = 0;
         if(param1.name.indexOf("NanovorTypeId") != -1)
         {
            _loc4_ = int(param1.name.replace(/NanovorTypeId(\d+)$/,"$1"));
            return new CharacterAsset(_loc4_,String(param3.@Id),AssetType.getByString(String(param3.@Type)),Utils.DOStoPOSIXpath(String(param3.@Filename)),param3.@CRC,Boolean(String(param3.@Default).toLowerCase()),String(param3.@SuperId),param2,Boolean(param1.isPreMinSet || String(param3.@PreMinSet).toLowerCase() == "true"));
         }
         return new Asset(String(param3.@Id),AssetType.getByString(String(param3.@Type)),Utils.DOStoPOSIXpath(String(param3.@Filename)),param3.@CRC,Boolean(String(param3.@Default).toLowerCase()),String(param3.@SuperId),param2,Boolean(param1.isPreMinSet || String(param3.@PreMinSet).toLowerCase() == "true"));
      }
      
      private function checkForMissingDefaultAsset(param1:IManifestReference, param2:XML) : void
      {
         var manifestReference:IManifestReference = param1;
         var assetGroupXML:XML = param2;
         var isRedundant:Boolean = isGroupXMLRedundant(assetGroupXML);
         if(!isRedundant)
         {
            return;
         }
         if(null == assetGroupXML.Asset.(attribute("Default") == "true")[0])
         {
            logError("checkForMissingDefaultAsset(): Found redundant Asset Group without default Asset specified: manifest=" + manifestReference.name + " group=" + assetGroupXML.@name);
            assetGroupXML.Asset[0].@Default = "true";
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<AssetManifestParser>> " + param1);
      }
   }
}

