package com.arkadium.virmon.musicmanager
{
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   
   public interface IMusicManager
   {
      
      function FadeOutFadeInToTrack(param1:IAssetURL, param2:int = 1600, param3:int = 1000) : void;
      
      function PlayTrack(param1:IAssetURL) : void;
   }
}

