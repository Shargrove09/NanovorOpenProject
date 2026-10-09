package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.framework.asset.IAsset;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   
   public class DefaultMusicTrack implements IAssetURL
   {
      
      public function DefaultMusicTrack()
      {
         super();
      }
      
      public function get assetURLType() : AssetURLType
      {
         return AssetURLType.FALLBACK_DEFAULT;
      }
      
      public function get url() : String
      {
         return "Assets/Client/Sound/Super/SecondaryMenuTrack.mp3";
      }
      
      public function get asset() : IAsset
      {
         return null;
      }
      
      public function toString() : String
      {
         return "[DefaultMusicTrack:IAssetURL" + "|url=" + url + "|assetURLType=" + assetURLType + "|asset=" + asset + "]";
      }
   }
}

