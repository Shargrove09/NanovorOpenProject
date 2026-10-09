package com.arkadium.virmon.framework
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class VirmonMasterData implements IVirmonMasterData
   {
      
      private var _nWave:Number;
      
      private var _aBuffFormulaHealth:Array;
      
      private var _sFaction:String;
      
      private var _sName:String;
      
      private var _nMaxHealth:Number;
      
      private var _nPointValue:Number;
      
      private var _aBuffFormulaStrength:Array;
      
      private var _nAssetTypeVersion:Number;
      
      private var _sRarity:String;
      
      private var _nBaseStrength:Number;
      
      private var _nBaseArmor:Number;
      
      private var _nBaseSpeed:Number;
      
      private var _nMaxArmor:Number;
      
      private var _nMaxSpeed:Number;
      
      private var _sCollectorID:String;
      
      private var _nLevel:Number;
      
      private var _nMaxStrength:Number;
      
      private var _aAttackDataList:Array;
      
      private var _nBaseHealth:Number;
      
      private var _aBuffFormulaArmor:Array;
      
      private var _aBuffFormulaSpeed:Array;
      
      private var _nAssetTypeID:Number;
      
      public function VirmonMasterData()
      {
         super();
      }
      
      public function getName() : String
      {
         return _sName;
      }
      
      public function getBaseHealth() : Number
      {
         return _nBaseHealth;
      }
      
      public function getPointValue() : Number
      {
         return _nPointValue;
      }
      
      public function getMaxStrength() : Number
      {
         return _nMaxStrength;
      }
      
      public function getRarity() : String
      {
         return _sRarity;
      }
      
      public function getAttackList() : Array
      {
         return _aAttackDataList.slice();
      }
      
      public function getAssetTypeID() : Number
      {
         return _nAssetTypeID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:int = 0;
         _nAssetTypeID = Number(param1.child("asset-type-id"));
         _nAssetTypeVersion = Number(param1.child("asset-type-version"));
         _sName = String(param1.child("name"));
         _sCollectorID = String(param1.child("collector-id"));
         _nWave = Number(param1.child("wave"));
         _sRarity = String(param1.child("rarity"));
         _sFaction = String(param1.child("faction"));
         _nLevel = Number(param1.child("level"));
         _nBaseSpeed = Number(param1.child("base-speed"));
         _nBaseStrength = Number(param1.child("base-strength"));
         _nBaseArmor = Number(param1.child("base-armor"));
         _nBaseHealth = Number(param1.child("base-health"));
         _nMaxSpeed = Number(param1.child("max-speed"));
         _nMaxStrength = Number(param1.child("max-strength"));
         _nMaxArmor = Number(param1.child("max-armor"));
         _nMaxHealth = Number(param1.child("max-health"));
         _nPointValue = Number(param1.child("pv"));
         var _loc3_:XMLList = param1.descendants("attack");
         _aAttackDataList = new Array(_loc3_.length());
         _loc2_ = 0;
         while(_loc2_ < _aAttackDataList.length)
         {
            _aAttackDataList[_loc2_] = new VirmonAttackData();
            _aAttackDataList[_loc2_].parseXMLData(_loc3_[_loc2_]);
            _loc2_++;
         }
         var _loc4_:XMLList = param1.descendants("buff-formula-speed");
         _aBuffFormulaSpeed = new Array(_loc4_.length());
         _loc2_ = 0;
         while(_loc2_ < _aBuffFormulaSpeed.length)
         {
            _aBuffFormulaSpeed[_loc2_] = Number(_loc4_[_loc2_]);
            _loc2_++;
         }
         var _loc5_:XMLList = param1.descendants("buff-formula-strength");
         _aBuffFormulaStrength = new Array(_loc5_.length());
         _loc2_ = 0;
         while(_loc2_ < _aBuffFormulaStrength.length)
         {
            _aBuffFormulaStrength[_loc2_] = Number(_loc5_[_loc2_]);
            _loc2_++;
         }
         var _loc6_:XMLList = param1.descendants("buff-formula-armor");
         _aBuffFormulaArmor = new Array(_loc6_.length());
         _loc2_ = 0;
         while(_loc2_ < _aBuffFormulaArmor.length)
         {
            _aBuffFormulaArmor[_loc2_] = Number(_loc6_[_loc2_]);
            _loc2_++;
         }
         var _loc7_:XMLList = param1.descendants("buff-formula-health");
         _aBuffFormulaHealth = new Array(_loc7_.length());
         _loc2_ = 0;
         while(_loc2_ < _aBuffFormulaHealth.length)
         {
            _aBuffFormulaHealth[_loc2_] = Number(_loc7_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function getBaseStrength() : Number
      {
         return _nBaseStrength;
      }
      
      public function getAssetTypeVersion() : Number
      {
         return _nAssetTypeVersion;
      }
      
      public function getBaseSpeed() : Number
      {
         return _nBaseSpeed;
      }
      
      public function getSpeedBuffFormula() : Array
      {
         return _aBuffFormulaSpeed;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> VirmonMasterData: " + param1);
      }
      
      public function getMaxSpeed() : Number
      {
         return _nMaxSpeed;
      }
      
      public function getMaxHealth() : Number
      {
         return _nMaxHealth;
      }
      
      public function getLevel() : Number
      {
         return _nLevel;
      }
      
      public function getBaseArmor() : Number
      {
         return _nBaseArmor;
      }
      
      public function getArmorBuffFormula() : Array
      {
         return _aBuffFormulaArmor;
      }
      
      public function getMaxArmor() : Number
      {
         return _nMaxArmor;
      }
      
      public function getCollectorID() : String
      {
         return _sCollectorID;
      }
      
      private function getAttackIds() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < _aAttackDataList.length)
         {
            _loc1_.push(VirmonAttackData(_aAttackDataList[_loc2_]).getAttackID());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getHealthBuffFormula() : Array
      {
         return _aBuffFormulaHealth;
      }
      
      public function getFaction() : String
      {
         return _sFaction;
      }
      
      public function getWave() : Number
      {
         return _nWave;
      }
      
      public function getStrengthBuffFormula() : Array
      {
         return _aBuffFormulaStrength;
      }
   }
}

