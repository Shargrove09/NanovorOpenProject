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
         return this._sRarity;
      }
      
      public function getLongName() : String
      {
         return this._sLongName;
      }
      
      public function getAssetTypeID() : Number
      {
         return this._nAssetTypeID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         this._nAssetTypeID = Number(param1.child("asset-type-id"));
         this._sShortName = String(param1.child("short-name"));
         this._sLongName = String(param1.child("long-name"));
         this._sRarity = String(param1.child("rarity"));
         this._sFaction = String(param1.child("faction"));
         this._sWave = param1.wave;
         this._sCollectorId = String(param1.child("collector-id"));
      }
      
      public function getShortName() : String
      {
         return this._sShortName;
      }
      
      public function getCollectorId() : String
      {
         return this._sCollectorId;
      }
      
      public function getFaction() : String
      {
         return this._sFaction;
      }
      
      public function getWave() : String
      {
         return this._sWave;
      }
   }
}

