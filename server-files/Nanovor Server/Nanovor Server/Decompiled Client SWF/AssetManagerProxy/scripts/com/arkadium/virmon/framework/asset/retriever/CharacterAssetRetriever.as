package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAsset;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterChipAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterEvoAssetType;
   import com.arkadium.virmon.framework.asset.enum.CharacterWidgetAssetType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class CharacterAssetRetriever implements ICharacterAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function CharacterAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      public function getCharacterEvoURL(param1:CharacterEvoAssetType, param2:int) : IAssetURL
      {
         return _assetManager.getAssetURL(getManifestName(param2),"evo",param1.name);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CharacterAssetRetriever: " + param1);
      }
      
      public function getCharacterWidgetURL(param1:CharacterWidgetAssetType, param2:int) : IAssetURL
      {
         var _loc3_:IAssetURL = _assetManager.getAssetURL(getManifestName(param2),"widget",param1.name);
         if(_loc3_.assetURLType == AssetURLType.NOT_FOUND)
         {
            logError("getCharacterWidgetURL(): got null url... characterID=" + param2 + ", asetType=" + param1.name);
         }
         return _loc3_;
      }
      
      private function getManifestName(param1:int, param2:AssetURLType = null) : String
      {
         if(param2 == AssetURLType.FALLBACK_SUPERSEDED)
         {
            return _assetManager.getManifestSuperName(getManifestName(param1));
         }
         return "NanovorTypeId" + param1.toString();
      }
      
      private function isEmpty(param1:String) : Boolean
      {
         return Boolean(param1 == "" || param1 == null);
      }
      
      public function getCharacterChipURL(param1:CharacterChipAssetType, param2:int) : IAssetURL
      {
         return _assetManager.getAssetURL(getManifestName(param2),"chip",param1.name);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CharacterAssetRetriever: " + param1);
      }
      
      public function getAnimationAssetSuperID(param1:CharacterAnimationAssetType, param2:int, param3:String = "1") : String
      {
         var _loc5_:IAsset = null;
         var _loc6_:IAssetURL = null;
         var _loc4_:Array = _assetManager.getAssetList(getManifestName(param2),param1.name);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.id.toLowerCase() == param3.toLowerCase())
            {
               if(isEmpty(_loc5_.superId))
               {
                  logError("getAnimationAssetSuperID(): asset does not have a super ID assocated. [characterID=" + param2 + " characterAnimationAssetType=" + param1.name + " assetID=" + param3 + "]");
                  return "";
               }
               if(isEmpty(_loc5_.assetGroup.manifest.superManifestName))
               {
                  logError("getAnimationAssetSuperID(): asset\'s manifest is not superseded. [characterID=" + param2 + " characterAnimationAssetType=" + param1.name + " assetID=" + param3 + "]");
                  return "";
               }
               _loc6_ = _assetManager.getAssetURL(getManifestName(param2,AssetURLType.FALLBACK_SUPERSEDED),param1.name,_loc5_.superId);
               if(_loc6_.assetURLType == AssetURLType.NOT_FOUND)
               {
                  logError("getAnimationAssetSuperID(): asset\'s super asset was not found. [characterID=" + param2 + " characterAnimationAssetType=" + param1.name + " assetID=" + param3 + " asset.superId=" + _loc5_.superId + "]");
                  return "";
               }
               if(_loc6_.assetURLType != AssetURLType.ACTUAL)
               {
                  log("getAnimationAssetSuperID(): * asset\'s super asset was found, but assetURLType returned was \'" + _loc6_.assetURLType.name + "\', but \'actual\' is expected. [characterID=" + param2 + " characterAnimationAssetType=" + param1.name + " assetID=" + param3 + " asset.superId=" + _loc5_.superId + "]");
               }
               return _loc5_.superId;
            }
         }
         logError("getAnimationAssetSuperID(): asset not found. [characterID=" + param2 + " characterAnimationAssetType=" + param1.name + " assetID=" + param3 + "]");
         return "";
      }
      
      public function getCharacterAudioURL(param1:int, param2:String, param3:AssetURLType = null) : IAssetURL
      {
         var _loc5_:IAssetURL = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:CharacterAnimationAssetType = null;
         var _loc9_:IAssetURL = null;
         log("getCharacterAudioURL(): characterID=" + param1 + ", audioResourceReference=" + param2 + ", overrideAssetURLType=" + param3);
         if(param3 == null)
         {
            param3 = AssetURLType.ACTUAL;
         }
         var _loc4_:String = param2.replace(/.+_\d_*\d+_(.+)$/,"$1");
         if(param3 == AssetURLType.FALLBACK_SUPERSEDED)
         {
            _loc5_ = _assetManager.getAssetURL(getManifestName(param1,param3),"Audio",_loc4_);
         }
         else
         {
            _loc6_ = _loc4_.replace(/.+?([0-9]*)$/,"$1");
            _loc7_ = _loc6_.length == 0 ? "1" : String(int(_loc6_));
            _loc8_ = CharacterAnimationAssetType.parse(_loc4_.replace(/_.+/,"").replace(/[0-9]/g,""));
            _loc9_ = _assetManager.getAssetURL(getManifestName(param1,param3),_loc8_.name,_loc7_.toString());
            if(_loc9_.assetURLType == AssetURLType.FALLBACK_DEFAULT)
            {
               param2 = param2.replace(/[0-9]+$/,_loc9_.asset.id);
            }
            _loc5_ = _assetManager.getAssetURL(getManifestName(param1,param3),"Audio",param2);
         }
         if(_loc5_.assetURLType == AssetURLType.NOT_FOUND)
         {
            logError("getCharacterAudioURL(): asset not found for manifest <" + getManifestName(param1,param3) + "> group <Audio> id <" + _loc4_ + "> ::: (characterID=" + param1 + " audioResourceReference=" + param2 + ")");
         }
         return _loc5_;
      }
      
      public function getCharacterAnimationURL(param1:CharacterAnimationAssetType, param2:int, param3:String = "1", param4:AssetURLType = null) : IAssetURL
      {
         var _loc5_:IAssetURL = _assetManager.getAssetURL(getManifestName(param2),param1.name,param3,param4);
         if(_loc5_.assetURLType == AssetURLType.NOT_FOUND)
         {
            logError("getCharacterAnimationURL(): type:" + param1.name + " characterID:" + param2 + " assetID:" + param3 + " overrideAssetURLType:" + param4 + "\n" + _loc5_ + "\n" + new Error("STACK TRACE").getStackTrace());
         }
         return _loc5_;
      }
   }
}

