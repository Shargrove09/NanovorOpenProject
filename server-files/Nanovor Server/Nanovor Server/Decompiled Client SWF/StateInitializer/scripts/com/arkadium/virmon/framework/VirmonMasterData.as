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
         return this._sName;
      }
      
      public function getBaseHealth() : Number
      {
         return this._nBaseHealth;
      }
      
      public function getPointValue() : Number
      {
         return this._nPointValue;
      }
      
      public function getMaxStrength() : Number
      {
         return this._nMaxStrength;
      }
      
      public function getRarity() : String
      {
         return this._sRarity;
      }
      
      public function getAttackList() : Array
      {
         return this._aAttackDataList.slice();
      }
      
      public function getAssetTypeID() : Number
      {
         return this._nAssetTypeID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:int = 0;
         this._nAssetTypeID = Number(param1.child("asset-type-id"));
         this._nAssetTypeVersion = Number(param1.child("asset-type-version"));
         this._sName = String(param1.child("name"));
         this._sCollectorID = String(param1.child("collector-id"));
         this._nWave = Number(param1.child("wave"));
         this._sRarity = String(param1.child("rarity"));
         this._sFaction = String(param1.child("faction"));
         this._nLevel = Number(param1.child("level"));
         this._nBaseSpeed = Number(param1.child("base-speed"));
         this._nBaseStrength = Number(param1.child("base-strength"));
         this._nBaseArmor = Number(param1.child("base-armor"));
         this._nBaseHealth = Number(param1.child("base-health"));
         this._nMaxSpeed = Number(param1.child("max-speed"));
         this._nMaxStrength = Number(param1.child("max-strength"));
         this._nMaxArmor = Number(param1.child("max-armor"));
         this._nMaxHealth = Number(param1.child("max-health"));
         this._nPointValue = Number(param1.child("pv"));
         var _loc3_:XMLList = param1.descendants("attack");
         this._aAttackDataList = new Array(_loc3_.length());
         _loc2_ = 0;
         while(_loc2_ < this._aAttackDataList.length)
         {
            this._aAttackDataList[_loc2_] = new VirmonAttackData();
            this._aAttackDataList[_loc2_].parseXMLData(_loc3_[_loc2_]);
            _loc2_++;
         }
         var _loc4_:XMLList = param1.descendants("buff-formula-speed");
         this._aBuffFormulaSpeed = new Array(_loc4_.length());
         _loc2_ = 0;
         while(_loc2_ < this._aBuffFormulaSpeed.length)
         {
            this._aBuffFormulaSpeed[_loc2_] = Number(_loc4_[_loc2_]);
            _loc2_++;
         }
         var _loc5_:XMLList = param1.descendants("buff-formula-strength");
         this._aBuffFormulaStrength = new Array(_loc5_.length());
         _loc2_ = 0;
         while(_loc2_ < this._aBuffFormulaStrength.length)
         {
            this._aBuffFormulaStrength[_loc2_] = Number(_loc5_[_loc2_]);
            _loc2_++;
         }
         var _loc6_:XMLList = param1.descendants("buff-formula-armor");
         this._aBuffFormulaArmor = new Array(_loc6_.length());
         _loc2_ = 0;
         while(_loc2_ < this._aBuffFormulaArmor.length)
         {
            this._aBuffFormulaArmor[_loc2_] = Number(_loc6_[_loc2_]);
            _loc2_++;
         }
         var _loc7_:XMLList = param1.descendants("buff-formula-health");
         this._aBuffFormulaHealth = new Array(_loc7_.length());
         _loc2_ = 0;
         while(_loc2_ < this._aBuffFormulaHealth.length)
         {
            this._aBuffFormulaHealth[_loc2_] = Number(_loc7_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function getBaseStrength() : Number
      {
         return this._nBaseStrength;
      }
      
      public function getAssetTypeVersion() : Number
      {
         return this._nAssetTypeVersion;
      }
      
      public function getBaseSpeed() : Number
      {
         return this._nBaseSpeed;
      }
      
      public function getSpeedBuffFormula() : Array
      {
         return this._aBuffFormulaSpeed;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> VirmonMasterData: " + param1);
      }
      
      public function getMaxSpeed() : Number
      {
         return this._nMaxSpeed;
      }
      
      public function getMaxHealth() : Number
      {
         return this._nMaxHealth;
      }
      
      public function getLevel() : Number
      {
         return this._nLevel;
      }
      
      public function getBaseArmor() : Number
      {
         return this._nBaseArmor;
      }
      
      public function getArmorBuffFormula() : Array
      {
         return this._aBuffFormulaArmor;
      }
      
      public function getMaxArmor() : Number
      {
         return this._nMaxArmor;
      }
      
      public function getCollectorID() : String
      {
         return this._sCollectorID;
      }
      
      private function getAttackIds() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this._aAttackDataList.length)
         {
            _loc1_.push(VirmonAttackData(this._aAttackDataList[_loc2_]).getAttackID());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getHealthBuffFormula() : Array
      {
         return this._aBuffFormulaHealth;
      }
      
      public function getFaction() : String
      {
         return this._sFaction;
      }
      
      public function getWave() : Number
      {
         return this._nWave;
      }
      
      public function getStrengthBuffFormula() : Array
      {
         return this._aBuffFormulaStrength;
      }
   }
}

