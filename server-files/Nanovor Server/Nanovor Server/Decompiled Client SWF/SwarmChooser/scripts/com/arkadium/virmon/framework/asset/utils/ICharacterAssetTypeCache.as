package com.arkadium.virmon.framework.asset.utils
{
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   
   public interface ICharacterAssetTypeCache
   {
      
      function isCharacterSuperseded(param1:int) : Boolean;
      
      function getCharacterWidgetURL(param1:CharacterWidgetAssetType, param2:int) : IAssetURL;
      
      function getCharacterAnimationID(param1:int, param2:String) : String;
      
      function getCharacterAudioURL(param1:int, param2:String) : IAssetURL;
      
      function getCharacterAnimationURL(param1:CharacterAnimationAssetType, param2:int, param3:String = "1") : IAssetURL;
   }
}

