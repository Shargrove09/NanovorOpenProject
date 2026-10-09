package com.arkadium.virmon.framework.asset
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ManifestComparator implements IManifestComparator
   {
      
      private static const MINIMINSET_THRESHOLD:uint = 3;
      
      private var _requiredDownloadList:IAssetDownloadItemList;
      
      private var _optionalDownloadList:IAssetDownloadItemList;
      
      private var _preMinSetDownloadList:IAssetDownloadItemList;
      
      public function ManifestComparator()
      {
         super();
         _preMinSetDownloadList = new AssetDownloadItemList();
         _requiredDownloadList = new AssetDownloadItemList();
         _optionalDownloadList = new AssetDownloadItemList();
      }
      
      public function get preMinSetDownloadList() : IAssetDownloadItemList
      {
         return _preMinSetDownloadList;
      }
      
      private function getSuperManifestAssetList(param1:IAssetManifest, param2:IAssetManifest) : IAssetDownloadItemList
      {
         var _loc4_:IAssetGroup = null;
         var _loc5_:IAsset = null;
         var _loc6_:String = null;
         var _loc3_:IAssetDownloadItemList = new AssetDownloadItemList();
         for each(_loc4_ in param2.groupList)
         {
            for each(_loc5_ in _loc4_.assetList)
            {
               _loc6_ = param2.assetManifestMetadata.getAssetCRC(_loc5_.assetGroup.name,_loc5_.id);
               if(_loc5_.CRC != _loc6_)
               {
                  _loc3_.push(new AssetDownloadItem(_loc5_));
               }
            }
         }
         return _loc3_;
      }
      
      private function isEmpty(param1:String) : Boolean
      {
         return Boolean(param1 == null || param1 == "");
      }
      
      public function compareManifests(param1:IManifestList, param2:IManifestList) : void
      {
         var _loc3_:IAssetManifest = null;
         var _loc4_:IAssetManifestMetadata = null;
         var _loc5_:IAssetDownloadItemList = null;
         var _loc6_:IAssetDownloadItemList = null;
         var _loc7_:IAssetGroup = null;
         var _loc8_:IAsset = null;
         var _loc9_:IAssetDownloadItemList = null;
         var _loc10_:IAssetDownloadItem = null;
         log("downloadAssets(): manifestList.length: " + param1.length + ", superManifestList.length: " + param2.length);
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.assetManifestMetadata;
            if(null == _loc4_)
            {
               throw new Error("manifest metadata was null: " + _loc3_.fileName);
            }
            _loc5_ = new AssetDownloadItemList();
            _loc6_ = new AssetDownloadItemList();
            for each(_loc7_ in _loc3_.groupList)
            {
               for each(_loc8_ in _loc7_.assetList)
               {
                  if(_loc8_.CRC != _loc4_.getAssetCRC(_loc7_.name,_loc8_.id))
                  {
                     if(Boolean(_loc8_.isPreMinSet) && (_loc8_.assetGroup.redundant == false || Boolean(_loc8_.isDefault)))
                     {
                        _preMinSetDownloadList.push(new AssetDownloadItem(_loc8_));
                     }
                     else if(isRequiredAsset(_loc8_))
                     {
                        _loc5_.push(new AssetDownloadItem(_loc8_,25000));
                     }
                     else
                     {
                        _loc6_.push(new AssetDownloadItem(_loc8_,-25100));
                     }
                  }
               }
            }
            _loc4_.requiredDownloadCount = _loc5_.length;
            if(hasSuperManifest(_loc3_,param2))
            {
               if(_loc5_.supersededItemsCount > MINIMINSET_THRESHOLD || hasSuperManifestWithAnyUpdatedAssets(_loc3_,param2))
               {
                  _loc9_ = new AssetDownloadItemList();
                  while(_loc5_.length > 0)
                  {
                     _loc10_ = _loc5_.pop();
                     if(isEmpty(_loc10_.asset.superId))
                     {
                        _loc9_.push(_loc10_);
                     }
                     else
                     {
                        _loc6_.push(_loc10_);
                     }
                  }
                  _loc5_ = _loc9_;
                  _loc5_.concat(getSuperManifestAssetList(_loc3_,param2.getManifest(_loc3_.superManifestName)));
               }
            }
            _requiredDownloadList.concat(_loc5_);
            _optionalDownloadList.concat(_loc6_);
         }
      }
      
      private function isRequiredAsset(param1:IAsset) : Boolean
      {
         if(false == param1.assetGroup.redundant)
         {
            return true;
         }
         if(param1.isDefault)
         {
            return true;
         }
         return false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ManifestComparator>> " + param1);
      }
      
      public function get requiredDownloadList() : IAssetDownloadItemList
      {
         return _requiredDownloadList;
      }
      
      public function get optionalDownloadList() : IAssetDownloadItemList
      {
         return _optionalDownloadList;
      }
      
      private function hasSuperManifestWithAnyUpdatedAssets(param1:IAssetManifest, param2:IManifestList) : Boolean
      {
         var _loc4_:IAssetGroup = null;
         var _loc5_:IAsset = null;
         var _loc3_:IAssetManifest = param2.getManifest(param1.superManifestName);
         for each(_loc4_ in _loc3_.groupList)
         {
            for each(_loc5_ in _loc4_.assetList)
            {
               if(!_loc5_.isOutdated)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function hasSuperManifest(param1:IAssetManifest, param2:IManifestList) : Boolean
      {
         if(null == param1.superManifestName)
         {
            return false;
         }
         if(null == param2.getManifest(param1.superManifestName))
         {
            return false;
         }
         return true;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<ManifestComparator>> " + param1);
      }
   }
}

