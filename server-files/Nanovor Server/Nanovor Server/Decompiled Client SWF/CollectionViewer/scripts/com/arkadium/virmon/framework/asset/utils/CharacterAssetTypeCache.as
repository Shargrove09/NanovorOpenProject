package com.arkadium.virmon.framework.asset.utils
{
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import flash.utils.Dictionary;
   
   public class CharacterAssetTypeCache implements ICharacterAssetTypeCache
   {
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _characterAssetTypeMap:Dictionary;
      
      public function CharacterAssetTypeCache(param1:ICharacterAssetRetriever)
      {
         super();
         _characterAssetRetriever = param1;
         _characterAssetTypeMap = new Dictionary();
      }
      
      public function getCharacterAudioURL(param1:int, param2:String) : IAssetURL
      {
         if(_characterAssetTypeMap[param1.toString()] == AssetURLType.FALLBACK_SUPERSEDED)
         {
            return _characterAssetRetriever.getCharacterAudioURL(param1,param2,AssetURLType.FALLBACK_SUPERSEDED);
         }
         var _loc3_:IAssetURL = _characterAssetRetriever.getCharacterAudioURL(param1,param2);
         if(_loc3_.assetURLType == AssetURLType.FALLBACK_SUPERSEDED)
         {
            processRetrievedCharacterType(param1,AssetURLType.FALLBACK_SUPERSEDED);
            return getCharacterAudioURL(param1,param2);
         }
         return _loc3_;
      }
      
      public function getCharacterAnimationURL(param1:CharacterAnimationAssetType, param2:int, param3:String = "1") : IAssetURL
      {
         if(param1 == CharacterAnimationAssetType.COMBAT_ANIMATION_XML)
         {
            return _characterAssetRetriever.getCharacterAnimationURL(param1,param2,param3);
         }
         if(_characterAssetTypeMap[param2.toString()] == AssetURLType.FALLBACK_SUPERSEDED)
         {
            return _characterAssetRetriever.getCharacterAnimationURL(param1,param2,param3,AssetURLType.FALLBACK_SUPERSEDED);
         }
         var _loc4_:IAssetURL = _characterAssetRetriever.getCharacterAnimationURL(param1,param2,param3);
         processRetrievedCharacterType(param2,_loc4_.assetURLType);
         return _loc4_;
      }
      
      public function getCharacterWidgetURL(param1:CharacterWidgetAssetType, param2:int) : IAssetURL
      {
         return _characterAssetRetriever.getCharacterWidgetURL(param1,param2);
      }
      
      private function processRetrievedCharacterType(param1:int, param2:AssetURLType) : void
      {
         switch(param2)
         {
            case AssetURLType.FALLBACK_SUPERSEDED:
               _characterAssetTypeMap[param1.toString()] = AssetURLType.FALLBACK_SUPERSEDED;
               break;
            case AssetURLType.ACTUAL:
            case AssetURLType.FALLBACK_DEFAULT:
               _characterAssetTypeMap[param1.toString()] = AssetURLType.ACTUAL;
         }
      }
      
      public function isCharacterSuperseded(param1:int) : Boolean
      {
         return Boolean(_characterAssetTypeMap[param1.toString()] == AssetURLType.FALLBACK_SUPERSEDED);
      }
      
      public function getCharacterAnimationID(param1:int, param2:String) : String
      {
         if(_characterAssetTypeMap[param1.toString()] != AssetURLType.FALLBACK_SUPERSEDED)
         {
            return param2;
         }
         var _loc3_:CharacterAnimationAssetType = CharacterAnimationAssetType.parse(param2.replace(/[0-9]/g,""));
         if(_loc3_ != CharacterAnimationAssetType.ATTACK)
         {
            return param2;
         }
         var _loc4_:String = param2.replace(/.+?([0-9]*)$/,"$1");
         if(_loc4_ == "")
         {
            _loc4_ = "1";
         }
         return _loc3_.name + _characterAssetRetriever.getAnimationAssetSuperID(_loc3_,param1,_loc4_);
      }
   }
}

