package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterChipAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterEvoAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   
   public interface ICharacterAssetRetriever
   {
      
      function getCharacterChipURL(param1:CharacterChipAssetType, param2:int) : IAssetURL;
      
      function getAnimationAssetSuperID(param1:CharacterAnimationAssetType, param2:int, param3:String = "1") : String;
      
      function getCharacterWidgetURL(param1:CharacterWidgetAssetType, param2:int) : IAssetURL;
      
      function getCharacterEvoURL(param1:CharacterEvoAssetType, param2:int) : IAssetURL;
      
      function getCharacterAudioURL(param1:int, param2:String, param3:AssetURLType = null) : IAssetURL;
      
      function getCharacterAnimationURL(param1:CharacterAnimationAssetType, param2:int, param3:String = "1", param4:AssetURLType = null) : IAssetURL;
   }
}

