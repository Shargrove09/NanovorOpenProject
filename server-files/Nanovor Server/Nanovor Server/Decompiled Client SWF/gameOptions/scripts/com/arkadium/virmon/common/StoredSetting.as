package com.arkadium.virmon.common
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class StoredSetting
   {
      
      public static const GAMEOPTIONS_QUALITY:String = "gameoptions_quality";
      
      public static const GAMEOPTIONS_SOUND:String = "gameoptions_sound";
      
      public static const GAMEOPTIONS_MUSIC:String = "gameoptions_music";
      
      public static const GAMEOPTIONS_FULLSCREEN:String = "gameoptions_fullscreen";
      
      public static const GAMEOPTIONS_HELP:String = "gameoptions_help";
      
      public static const SFS_DOWNLOAD_ONCE:String = "firstSFSDownload";
      
      public static const LOGIN_PASSWORD:String = "login_password";
      
      public static const LOGIN_USERNAME:String = "login_username";
      
      public static const GAMESETTINGS_NUMPLAYERS:String = "gamesettings_numplayers";
      
      public static const GAMESETTINGS_SWARMSIZE:String = "gamesettings_swarmsize";
      
      public static const BREADCRUMB_COUNT:String = "breadCrumbCount";
      
      public static const BREADCRUMB_PROGRESS:String = "breadcrumbProgress";
      
      public static const BATTLE_COUNT:String = "battleCount";
      
      public static const HAS_SEEN_NEW_USER_EXPERIENCE:String = "hasSeenNewUserExperience";
      
      public static const HELPVIEWS_SWARMCHOOSER:String = "helpviews_swarmchooser";
      
      public static const HELPVIEWS_ATTACKCHOOSER:String = "helpviews_attackchooser";
      
      public static const SHARD_NAME:String = "shard_name";
      
      private static const _supportedTypes:Array = ["string","boolean","int","number","null"];
      
      private var _oValue:*;
      
      private var _szXmlValue:String;
      
      private var _szType:String;
      
      private var _szName:String;
      
      public function StoredSetting()
      {
         super();
      }
      
      public function parseXML(param1:XML) : void
      {
         var _loc2_:Class = null;
         _szName = param1.@name;
         _szType = param1.@type;
         _szXmlValue = param1.@value;
         if(_szType == "null")
         {
            _szXmlValue = "";
            _oValue = null;
         }
         else if(_szType == "Boolean")
         {
            _oValue = _szXmlValue == "true" ? true : false;
         }
         else
         {
            _loc2_ = getDefinitionByName(_szType) as Class;
            _oValue = _loc2_(_szXmlValue);
         }
      }
      
      public function get name() : String
      {
         return _szName;
      }
      
      private function _setValue(param1:*) : void
      {
         _oValue = param1;
         _szType = getQualifiedClassName(_oValue);
         if(_supportedTypes.indexOf(_szType.toLowerCase()) == -1)
         {
            DebugLog.instance.error("** StoredSetting >> _setValue was given a value whose type [" + _szType + "] is not suported; defaulting to \"String\"");
            _szType = "String";
         }
         _szXmlValue = _oValue === null ? "" : _oValue.toString();
      }
      
      public function get value() : *
      {
         return _oValue;
      }
      
      public function getXMLString() : String
      {
         return "<setting name=\"" + _szName + "\" type=\"" + _szType + "\" value=\"" + _szXmlValue + "\" />";
      }
      
      public function set name(param1:String) : void
      {
         _szName = param1;
      }
      
      public function set value(param1:*) : void
      {
         _setValue(param1);
      }
   }
}

