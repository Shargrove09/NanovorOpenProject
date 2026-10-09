package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.framework.EMMasterData;
   
   public class CEm
   {
      
      private var _uiCollectorNumber:uint;
      
      private var _iMasterID:int;
      
      private var _sFaction:String;
      
      private var _iWave:String;
      
      private var _sShortName:String;
      
      private var _sName:String;
      
      private var _id:int;
      
      private var _sLongName:String;
      
      private var _sRarity:String;
      
      private var _iCount:int;
      
      private var _iMarketValue:int;
      
      private var _sCollectorID:String;
      
      private var _iAmpTokenPrice:int;
      
      public function CEm()
      {
         super();
      }
      
      private static function _rarityToInt(param1:String) : int
      {
         param1 = param1 == null ? "common" : param1.toLowerCase();
         var _loc2_:int = 0;
         switch(param1)
         {
            case "rare":
               _loc2_ = 30;
               break;
            case "uncommon":
               _loc2_ = 20;
               break;
            case "common":
               _loc2_ = 10;
         }
         return _loc2_;
      }
      
      public static function ConvertRarityToInt(param1:String) : int
      {
         return _rarityToInt(param1);
      }
      
      public function getCollectorNumber() : uint
      {
         return _uiCollectorNumber;
      }
      
      public function getName() : String
      {
         return _sName;
      }
      
      public function get masterID() : int
      {
         return _iMasterID;
      }
      
      public function get count() : int
      {
         return _iCount;
      }
      
      public function setName(param1:String) : void
      {
         _sName = param1;
      }
      
      public function get marketValue() : int
      {
         return _iMarketValue;
      }
      
      public function get faction() : String
      {
         return _sFaction;
      }
      
      public function set count(param1:int) : void
      {
         _iCount = param1;
      }
      
      public function get shortName() : String
      {
         return _sShortName;
      }
      
      public function set marketValue(param1:int) : void
      {
         _iMarketValue = param1;
      }
      
      public function get rarity() : String
      {
         return _sRarity;
      }
      
      public function get longName() : String
      {
         return _sLongName;
      }
      
      public function set wave(param1:String) : void
      {
         _iWave = param1;
      }
      
      public function get rarityInt() : int
      {
         return _rarityToInt(_sRarity);
      }
      
      public function set faction(param1:String) : void
      {
         _sFaction = param1;
      }
      
      public function createFromMaster(param1:EMMasterData) : CEm
      {
         _iMasterID = param1.getAssetTypeID();
         _sShortName = param1.getShortName();
         _sLongName = param1.getLongName();
         _sCollectorID = param1.getCollectorId();
         _iWave = param1.getWave();
         _sRarity = param1.getRarity();
         _sFaction = param1.getFaction();
         return this;
      }
      
      public function set longName(param1:String) : void
      {
         _sLongName = param1;
      }
      
      public function set collectorID(param1:String) : void
      {
         _sCollectorID = param1;
      }
      
      public function set shortName(param1:String) : void
      {
         _sShortName = param1;
      }
      
      public function set rarity(param1:String) : void
      {
         _sRarity = param1;
      }
      
      public function get collectorID() : String
      {
         return _sCollectorID;
      }
      
      public function getID() : int
      {
         return _id;
      }
      
      public function setAmpTokenPrice(param1:int) : void
      {
         _iAmpTokenPrice = param1;
      }
      
      public function setCollectorNumber(param1:uint) : void
      {
         _uiCollectorNumber = param1;
      }
      
      public function get wave() : String
      {
         return _iWave;
      }
      
      public function set masterID(param1:int) : void
      {
         _iMasterID = param1;
      }
      
      public function setID(param1:int) : void
      {
         _id = param1;
      }
      
      public function getAmpTokenPrice() : int
      {
         return _iAmpTokenPrice;
      }
   }
}

