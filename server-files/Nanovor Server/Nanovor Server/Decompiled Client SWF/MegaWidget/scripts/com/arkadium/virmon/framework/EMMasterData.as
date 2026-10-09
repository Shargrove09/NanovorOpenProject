package com.arkadium.virmon.framework
{
   public class EMMasterData
   {
      
      public static const RARITY_COMMON:String = "common";
      
      public static const RARITY_UNCOMMON:String = "uncommon";
      
      public static const RARITY_RARE:String = "rare";
      
      private var _sFaction:String;
      
      private var _sWave:String;
      
      private var _sShortName:String;
      
      private var _sCollectorId:String;
      
      private var _nAssetTypeID:Number;
      
      private var _sLongName:String;
      
      private var _sRarity:String;
      
      public function EMMasterData()
      {
         super();
      }
      
      public function getRarity() : String
      {
         return _sRarity;
      }
      
      public function getLongName() : String
      {
         return _sLongName;
      }
      
      public function getAssetTypeID() : Number
      {
         return _nAssetTypeID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         _nAssetTypeID = Number(param1.child("asset-type-id"));
         _sShortName = String(param1.child("short-name"));
         _sLongName = String(param1.child("long-name"));
         _sRarity = String(param1.child("rarity"));
         _sFaction = String(param1.child("faction"));
         _sWave = param1.wave;
         _sCollectorId = String(param1.child("collector-id"));
      }
      
      public function getShortName() : String
      {
         return _sShortName;
      }
      
      public function getCollectorId() : String
      {
         return _sCollectorId;
      }
      
      public function getFaction() : String
      {
         return _sFaction;
      }
      
      public function getWave() : String
      {
         return _sWave;
      }
   }
}

