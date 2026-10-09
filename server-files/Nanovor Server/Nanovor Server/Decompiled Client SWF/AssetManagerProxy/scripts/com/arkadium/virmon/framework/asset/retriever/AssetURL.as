package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAsset;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   
   public class AssetURL implements IAssetURL
   {
      
      private var _url:String;
      
      private var _asset:IAsset;
      
      private var _assetURLType:AssetURLType;
      
      public function AssetURL(param1:String, param2:AssetURLType, param3:IAsset)
      {
         super();
         _url = param1;
         _assetURLType = param2;
         _asset = param3;
      }
      
      public function get asset() : IAsset
      {
         return _asset;
      }
      
      public function toString() : String
      {
         return "[AssetURL" + "|url=" + url + "|assetURLType=" + assetURLType + "|asset=" + asset + "]";
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      public function get assetURLType() : AssetURLType
      {
         return _assetURLType;
      }
   }
}

