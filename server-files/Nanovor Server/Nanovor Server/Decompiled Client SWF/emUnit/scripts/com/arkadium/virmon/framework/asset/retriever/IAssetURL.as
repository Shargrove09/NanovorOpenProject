package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAsset;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   
   public interface IAssetURL
   {
      
      function get asset() : IAsset;
      
      function get assetURLType() : AssetURLType;
      
      function toString() : String;
      
      function get url() : String;
   }
}

