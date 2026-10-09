package com.arkadium.virmon.framework.asset.enum
{
   public class MasterDataAssetType
   {
      
      public static const EM:MasterDataAssetType = new MasterDataAssetType("EM");
      
      public static const EM_VALUE:MasterDataAssetType = new MasterDataAssetType("EMValue");
      
      public static const NANOVOR:MasterDataAssetType = new MasterDataAssetType("Nanovor");
      
      public static const NANOVOR_VALUE:MasterDataAssetType = new MasterDataAssetType("NanovorValue");
      
      public static const BADGE:MasterDataAssetType = new MasterDataAssetType("Badge");
      
      public static const CHAT:MasterDataAssetType = new MasterDataAssetType("Chat");
      
      public static const MESSAGES:MasterDataAssetType = new MasterDataAssetType("Messages");
      
      public static const EVO_TREE:MasterDataAssetType = new MasterDataAssetType("EvoTree");
      
      public static const SENSEI_PLAYERS:MasterDataAssetType = new MasterDataAssetType("SenseiPlayers");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function MasterDataAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'MasterDataAssetType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[MasterDataAssetType: " + _name + "]";
      }
   }
}

