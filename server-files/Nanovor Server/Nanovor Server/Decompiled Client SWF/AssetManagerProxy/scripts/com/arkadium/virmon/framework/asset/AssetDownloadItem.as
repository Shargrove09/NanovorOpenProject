package com.arkadium.virmon.framework.asset
{
   public class AssetDownloadItem implements IAssetDownloadItem
   {
      
      private var _asset:IAsset;
      
      private var _priority:int;
      
      public function AssetDownloadItem(param1:IAsset, param2:int = 0)
      {
         super();
         _asset = param1;
         _priority = param2;
      }
      
      public function get asset() : IAsset
      {
         return _asset;
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function set priority(param1:int) : void
      {
         _priority = param1;
      }
   }
}

