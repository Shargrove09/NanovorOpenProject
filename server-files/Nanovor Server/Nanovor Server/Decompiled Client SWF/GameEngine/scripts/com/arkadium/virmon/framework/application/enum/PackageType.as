package com.arkadium.virmon.framework.application.enum
{
   import flash.utils.Dictionary;
   
   public class PackageType
   {
      
      private static var _lookupTable:Dictionary;
      
      public static const NANOVOR:PackageType = new PackageType("Nanovor");
      
      public static const DOWNLOAD_MANAGER:PackageType = new PackageType("DownloadManager");
      
      public static const WAIT_STATE:PackageType = new PackageType("WaitState");
      
      public static const WRAPPER:PackageType = new PackageType("Wrapper");
      
      public static const LOGIN_STATE:PackageType = new PackageType("LoginState");
      
      public static const GAME_ENGINE:PackageType = new PackageType("GameEngine");
      
      public static const HOME_STATE:PackageType = new PackageType("HomeState");
      
      public static const COLLECTION_STATE:PackageType = new PackageType("CollectionState");
      
      public static const EVO_TREE_STATE:PackageType = new PackageType("EvoTreeState");
      
      public static const EVO_GAME_STATE:PackageType = new PackageType("EvoGameState");
      
      public static const NANOMALL_STATE:PackageType = new PackageType("NanomallState");
      
      public static const PROFILE_STATE:PackageType = new PackageType("ProfileState");
      
      public static const BATTLE_STATE:PackageType = new PackageType("BattleState");
      
      public static const SENSEI_BATTLE_STATE:PackageType = new PackageType("SenseiBattleState");
      
      public static const SENSEI_SELECT_STATE:PackageType = new PackageType("SenseiSelectState");
      
      public static const TRADE_STATE:PackageType = new PackageType("TradeState");
      
      public static const DEVICE_STATE:PackageType = new PackageType("DeviceState");
      
      public static const CHAT:PackageType = new PackageType("Chat");
      
      public static const MEGA_VIEWER:PackageType = new PackageType("MegaViewer");
      
      public static const DEBUG_LOG:PackageType = new PackageType("DebugLog");
      
      public static const NONE:PackageType = new PackageType("None");
      
      private var _name:String;
      
      public function PackageType(param1:String)
      {
         super();
         _name = param1;
      }
      
      public static function parse(param1:String) : PackageType
      {
         var _loc2_:PackageType = _safeLookupTable[param1];
         if(_loc2_ == null)
         {
            _lookupTable[param1] = new PackageType(param1);
            return _lookupTable[param1];
         }
         return _loc2_;
      }
      
      private static function get _safeLookupTable() : Dictionary
      {
         if(_lookupTable == null)
         {
            _lookupTable = new Dictionary();
            _lookupTable[NANOVOR.name] = NANOVOR;
            _lookupTable[DOWNLOAD_MANAGER.name] = DOWNLOAD_MANAGER;
            _lookupTable[WAIT_STATE.name] = WAIT_STATE;
            _lookupTable[WRAPPER.name] = WRAPPER;
            _lookupTable[LOGIN_STATE.name] = LOGIN_STATE;
            _lookupTable[GAME_ENGINE.name] = GAME_ENGINE;
            _lookupTable[HOME_STATE.name] = HOME_STATE;
            _lookupTable[COLLECTION_STATE.name] = COLLECTION_STATE;
            _lookupTable[EVO_TREE_STATE.name] = EVO_TREE_STATE;
            _lookupTable[EVO_GAME_STATE.name] = EVO_GAME_STATE;
            _lookupTable[NANOMALL_STATE.name] = NANOMALL_STATE;
            _lookupTable[PROFILE_STATE.name] = PROFILE_STATE;
            _lookupTable[BATTLE_STATE.name] = BATTLE_STATE;
            _lookupTable[SENSEI_BATTLE_STATE.name] = SENSEI_BATTLE_STATE;
            _lookupTable[SENSEI_SELECT_STATE.name] = SENSEI_SELECT_STATE;
            _lookupTable[TRADE_STATE.name] = TRADE_STATE;
            _lookupTable[DEVICE_STATE.name] = DEVICE_STATE;
            _lookupTable[CHAT.name] = CHAT;
            _lookupTable[MEGA_VIEWER.name] = MEGA_VIEWER;
            _lookupTable[DEBUG_LOG.name] = DEBUG_LOG;
            _lookupTable[NONE.name] = NONE;
         }
         return _lookupTable;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}

