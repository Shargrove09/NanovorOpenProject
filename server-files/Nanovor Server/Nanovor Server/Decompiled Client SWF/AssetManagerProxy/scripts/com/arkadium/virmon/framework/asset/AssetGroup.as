package com.arkadium.virmon.framework.asset
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class AssetGroup implements IAssetGroup
   {
      
      public static const CHARACTERS:String = "characters";
      
      public static const CHARACTER_SOUNDS:String = "character_sounds";
      
      public static const CHARACTER_CHIP:String = "chip";
      
      public static const EMS:String = "ems";
      
      public static const EM_CHIP_ICONS:String = "ChipIcon";
      
      public static const EM_EVO_GAME_ICONS:String = "EvoGame";
      
      public static const EM_WIDGET_ICONS:String = "WidgetIcon";
      
      public static const OVERLAYS:String = "overlays";
      
      public static const QUICK_TIPS:String = "quick_tips";
      
      public static const AVATARS:String = "avatar";
      
      public static const AVATARS_SMALL:String = "avatar_small";
      
      public static const AVATARS_LARGE:String = "avatar_large";
      
      public static const BADGES:String = "badge";
      
      public static const BADGES_SMALL:String = "badge_small";
      
      public static const MASTER_DATA:String = "master_data";
      
      public static const AUDIO:String = "audio";
      
      private var _assetKeys:Dictionary = new Dictionary();
      
      private var _redundant:Boolean;
      
      private var _defaultAsset:IAsset;
      
      private var _manifest:IAssetManifest;
      
      private var _assets:Array = new Array();
      
      private var _name:String;
      
      public function AssetGroup(param1:String, param2:Boolean, param3:IAssetManifest)
      {
         super();
         _name = param1;
         _redundant = param2;
         _manifest = param3;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function addAsset(param1:IAsset) : void
      {
         var _loc2_:uint = _assets.push(param1);
         _assetKeys[param1.id.toLowerCase()] = _loc2_ - 1;
         if(param1.isDefault)
         {
            _defaultAsset = param1;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AssetGroup: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** AssetGroup: " + param1);
      }
      
      public function getDefaultAsset() : IAsset
      {
         return _defaultAsset;
      }
      
      public function getAssetById(param1:String) : IAsset
      {
         var id:String = param1;
         try
         {
            if(_assets[_assetKeys[id.toLowerCase()]] == undefined)
            {
               return null;
            }
         }
         catch(e:Error)
         {
            logError("getAssetById(): id=\'" + id + "\', Caught Error: " + e.message);
            return null;
         }
         return Asset(_assets[_assetKeys[id.toLowerCase()]]);
      }
      
      public function get redundant() : Boolean
      {
         return _redundant;
      }
      
      public function get assetList() : Array
      {
         return _assets;
      }
      
      public function get manifest() : IAssetManifest
      {
         return _manifest;
      }
   }
}

