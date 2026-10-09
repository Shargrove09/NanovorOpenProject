package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class Nanovor implements INanovor
   {
      
      private static const MAX_HACKS:int = 5;
      
      private var _winCount:int;
      
      protected var _baseStrength:int;
      
      protected var _baseHealth:int;
      
      private var _magnamodKillCount:int;
      
      protected var _baseSpeed:int;
      
      private var _swarmValue:int;
      
      private var _maxDamageHit:int;
      
      private var _level:int;
      
      private var _maxDamageGame:int;
      
      private var _deathCount:int;
      
      private var _maxRoundCount:int;
      
      private var _collectorId:String;
      
      private var _rarity:String;
      
      private var _killCount:int;
      
      private var _bloodType:String;
      
      private var _evolveId:int;
      
      private var _isFacingRight:Boolean;
      
      private var _faction:String;
      
      private var _fullEvolveDate:Date;
      
      private var _assetId:String;
      
      private var _selectedAttack:IAttack;
      
      private var _assetTypeCategory:String;
      
      private var _assetFlag:int;
      
      private var _hexiteKillCount:int;
      
      private var _assetTypeId:int;
      
      private var _allAttacksUsed:Boolean;
      
      private var _statIndex:int;
      
      protected var _name:String;
      
      protected var _baseArmor:int;
      
      private var _battleCount:int;
      
      private var _version:int;
      
      private var _owner:IPlayer;
      
      private var _productionNumber:int;
      
      private var _isDead:Boolean;
      
      private var _velocitronKillCount:int;
      
      private var _wave:int;
      
      private var _statHistory:Array;
      
      private var _attacks:Array;
      
      protected var _nickName:String;
      
      private var _virmonMasterData:IVirmonMasterData;
      
      public function Nanovor()
      {
         super();
         this._assetTypeId = 0;
         this._name = "";
         this._collectorId = "";
         this._version = 0;
         this._wave = 0;
         this._rarity = "";
         this._bloodType = "";
         this._level = 0;
         this._assetFlag = 0;
         this._productionNumber = 0;
         this._faction = "";
         this._swarmValue = 0;
         this._attacks = new Array();
         this._assetId = "0";
         this._nickName = "";
         this._assetTypeCategory = "";
         this._evolveId = 0;
         this._selectedAttack = null;
         this._owner = null;
         this._isDead = false;
         this._baseHealth = 0;
         this._baseStrength = 0;
         this._baseArmor = 0;
         this._baseSpeed = 0;
         this._fullEvolveDate = new Date();
         this.resetStatHistory();
      }
      
      public function get previousModdedStrength() : int
      {
         return this.calcModdedStat(Stat.STRENGTH,this._statHistory[this.getPreviousStatIndex()].strength,true,null,null,true,this.getPreviousStatIndex());
      }
      
      private function calcModdedStat(param1:String, param2:Number, param3:Boolean = true, param4:IPlayer = null, param5:IPlayer = null, param6:Boolean = false, param7:int = -1) : Number
      {
         var _loc9_:IAttackStatement = null;
         var _loc10_:IAttackStatement = null;
         if(param4 == null)
         {
            param4 = this._owner;
         }
         if(param7 == -1)
         {
            param7 = this._statIndex;
         }
         var _loc8_:Number = param2;
         if(this._owner != null)
         {
            for each(_loc9_ in this._owner.getPlayerStats(param7).currentOverrideArray)
            {
               _loc10_ = AttackStatement.copy(_loc9_);
               if(_loc10_ != null)
               {
                  if(_loc10_.stat == param1)
                  {
                     if(param6 || Boolean(_loc10_.doesApplyThisRound(param3,param4,param5)))
                     {
                        if(param5 != null)
                        {
                           _loc8_ = AttackStatementFormula.performOperation(_loc8_,_loc10_.verb,_loc10_.calculateDamage(param4.selectedNanovor,param5.selectedNanovor));
                        }
                        else
                        {
                           _loc8_ = AttackStatementFormula.performOperation(_loc8_,_loc10_.verb,_loc10_.calculateDamage(param4.selectedNanovor));
                        }
                     }
                  }
               }
            }
         }
         return _loc8_;
      }
      
      public function get previousDodgeFailPercent() : Number
      {
         return this._statHistory[this.getPreviousStatIndex()].dodgeFailPercent;
      }
      
      public function get previousRedSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].redSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedBlueSpike = param1;
      }
      
      public function set moddedSpeed(param1:int) : void
      {
         this.logError("moddedSpeed setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get faction() : String
      {
         return this._faction;
      }
      
      public function getModdedStat(param1:String, param2:Boolean = false) : Number
      {
         switch(param1)
         {
            case Stat.HEALTH:
               return this.health;
            case Stat.STRENGTH:
               return this.moddedStrength;
            case Stat.SPEED:
               return this.moddedSpeed;
            case Stat.ARMOR:
               return this.moddedArmor;
            case Stat.DODGE_FAIL_PERCENTAGE:
               return this.moddedDodgeFailPercent;
            case Stat.STUN_FAIL_PERCENTAGE:
               return this.moddedStunFailPercent;
            case Stat.RED_SPIKE:
               return this._owner.moddedRedSpike;
            case Stat.BLUE_SPIKE:
               return this._owner.moddedBlueSpike;
            case Stat.YELLOW_SPIKE:
               return this._owner.moddedYellowSpike;
            case Stat.ENERGY_GENERATOR:
               return this._owner.moddedEnergyGenerator;
            case Stat.ENERGY:
               return this._owner.energyLevel;
            default:
               return 0;
         }
      }
      
      public function get assetId() : String
      {
         return this._assetId;
      }
      
      public function get stunFailPercent() : Number
      {
         return this._statHistory[this._statIndex].stunFailPercent;
      }
      
      public function get baseStrength() : int
      {
         return this._baseStrength;
      }
      
      public function get previousHealth() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].health;
      }
      
      public function get moddedStunFailPercent() : Number
      {
         return this._statHistory[this._statIndex].moddedStunFailPercent;
      }
      
      public function get previousStunFailPercent() : Number
      {
         return this._statHistory[this.getPreviousStatIndex()].stunFailPercent;
      }
      
      public function get playerStats() : IPlayerStats
      {
         return this._statHistory[this._statIndex].playerStats;
      }
      
      public function addStatHistory() : void
      {
         var _loc1_:NanovorStats = this._statHistory[this._statIndex].clone();
         this._statHistory.push(_loc1_);
         this._statIndex = this._statHistory.length - 1;
      }
      
      public function get strength() : int
      {
         return this._statHistory[this._statIndex].strength;
      }
      
      public function initializeWithMasterData(param1:IVirmonMasterData) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._virmonMasterData = param1;
         this._assetTypeId = int(param1.getAssetTypeID());
         this._name = param1.getName();
         this._collectorId = param1.getCollectorID();
         this._version = param1.getAssetTypeVersion();
         this._wave = param1.getWave();
         this._rarity = param1.getRarity();
         this._level = param1.getLevel();
         this._faction = param1.getFaction();
         this._swarmValue = param1.getPointValue();
         this.armor = param1.getBaseArmor();
         this.speed = param1.getBaseSpeed();
         this.strength = param1.getBaseStrength();
         this.health = param1.getBaseHealth();
         this._baseHealth = param1.getBaseHealth();
         this._baseStrength = param1.getBaseStrength();
         this._baseArmor = param1.getBaseArmor();
         this._baseSpeed = param1.getBaseSpeed();
         this.addAttacksFromMaster(param1);
      }
      
      public function get speed() : int
      {
         return this._statHistory[this._statIndex].speed;
      }
      
      public function set moddedStrength(param1:int) : void
      {
         this.logError("moddedStrength setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get killCount() : int
      {
         return this._killCount;
      }
      
      public function get bloodType() : String
      {
         return this._bloodType;
      }
      
      public function set assetId(param1:String) : void
      {
         this._assetId = param1;
      }
      
      public function get previousStrength() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].strength;
      }
      
      public function set stunFailPercent(param1:Number) : void
      {
         this._statHistory[this._statIndex].stunFailPercent = param1;
      }
      
      public function get health() : int
      {
         return this._statHistory[this._statIndex].health;
      }
      
      public function set baseStrength(param1:int) : void
      {
         this._baseStrength = param1;
      }
      
      public function set moddedStunFailPercent(param1:Number) : void
      {
         this._statHistory[this._statIndex].moddedStunFailPercent = param1;
      }
      
      public function toString() : String
      {
         var _loc2_:AttackStatement = null;
         var _loc1_:String = this._name;
         _loc1_ += this._isDead ? " DEAD" : "";
         _loc1_ += " HP=" + this.health + "/" + this.baseHealth + " ARM=" + this.moddedArmor + "/" + this.baseArmor + " SPD=" + this.moddedSpeed + "/" + this.baseSpeed + " STR=" + this.moddedStrength + "/" + this.baseStrength;
         _loc1_ += " DF=" + this.moddedDodgeFailPercent + " SF=" + this.moddedStunFailPercent;
         _loc1_ += " R=" + this.moddedRedSpike + " Y=" + this.moddedYellowSpike + " B=" + this.moddedBlueSpike;
         _loc1_ += " HIDS: ";
         for each(_loc2_ in this.hacks)
         {
            _loc1_ += _loc2_.id + " ";
         }
         return _loc1_ + ("(" + this._assetTypeId + ", " + this._assetId + ")");
      }
      
      public function get previousYellowSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].yellowSpike;
      }
      
      public function set playerStats(param1:IPlayerStats) : void
      {
         this._statHistory[this._statIndex].playerStats = param1;
      }
      
      public function set armor(param1:int) : void
      {
         this._statHistory[this._statIndex].armor = param1;
      }
      
      public function set strength(param1:int) : void
      {
         this._statHistory[this._statIndex].strength = param1;
      }
      
      public function get previousModdedArmor() : int
      {
         return this.calcModdedStat(Stat.ARMOR,this._statHistory[this.getPreviousStatIndex()].armor,true,null,null,true,this.getPreviousStatIndex());
      }
      
      public function get previousArmor() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].armor;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get assetFlag() : int
      {
         return this._assetFlag;
      }
      
      public function get previousBlueSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].blueSpike;
      }
      
      public function set speed(param1:int) : void
      {
         this._statHistory[this._statIndex].speed = param1;
      }
      
      public function get maxDamageHit() : int
      {
         return this._maxDamageHit;
      }
      
      public function get winCount() : int
      {
         return this._winCount;
      }
      
      public function get velocitronKillCount() : int
      {
         return this._velocitronKillCount;
      }
      
      public function get baseHealth() : int
      {
         return this._baseHealth;
      }
      
      public function get maxDamageGame() : int
      {
         return this._maxDamageGame;
      }
      
      public function get previousModdedDodgeFailPercent() : Number
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedDodgeFailPercent;
      }
      
      public function get maxRoundCount() : int
      {
         return this._maxRoundCount;
      }
      
      public function get isDead() : Boolean
      {
         return this._isDead;
      }
      
      public function get owner() : IPlayer
      {
         return this._owner;
      }
      
      public function set health(param1:int) : void
      {
         this._statHistory[this._statIndex].health = param1;
      }
      
      public function get previousHacks() : Array
      {
         return this._statHistory[this.getPreviousStatIndex()].hacks;
      }
      
      public function get magnamodKillCount() : int
      {
         return this._magnamodKillCount;
      }
      
      public function get fullEvolveDate() : Date
      {
         return this._fullEvolveDate;
      }
      
      public function get selectedAttack() : IAttack
      {
         return this._selectedAttack;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function set assetTypeCategory(param1:String) : void
      {
         this._assetTypeCategory = param1;
      }
      
      public function get moddedDodgeFailPercent() : Number
      {
         return this._statHistory[this._statIndex].moddedDodgeFailPercent;
      }
      
      public function get moddedRedSpike() : int
      {
         return this._statHistory[this._statIndex].moddedRedSpike;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function resetStatHistory() : void
      {
         var _loc1_:NanovorStats = null;
         if(this._statHistory != null && this._statHistory.length > 0)
         {
            _loc1_ = this._statHistory.pop();
         }
         else
         {
            _loc1_ = new NanovorStats();
         }
         this._statHistory = new Array();
         this._statHistory.push(_loc1_);
         this._statIndex = this._statHistory.length - 1;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedYellowSpike = param1;
      }
      
      public function set hacks(param1:Array) : void
      {
         this._statHistory[this._statIndex].hacks = param1;
      }
      
      public function initializeWithVirmonData(param1:IVirmonData) : void
      {
         this.initializeWithMasterData(param1.getVirmonMasterData());
         this._assetId = param1.getAssetID();
         this._fullEvolveDate = param1.getFullEvolveDate();
         this._nickName = param1.getNickName();
         this._battleCount = param1.getBattleCount();
         this._deathCount = param1.getDeathCount();
         this._hexiteKillCount = param1.getHexiteKillCount();
         this._killCount = param1.getKillCount();
         this._magnamodKillCount = param1.getMagnamodKillCount();
         this._winCount = param1.getWinCount();
         this._velocitronKillCount = param1.getVelocitronKillCount();
         this._allAttacksUsed = param1.areAllAttacksUsed();
         this._maxDamageGame = param1.getMaxDamageGame();
         this._maxDamageHit = param1.getMaxDamageHit();
         this._maxRoundCount = param1.getMaxRoundCount();
         this.armor = param1.getArmor();
         this.speed = param1.getSpeed();
         this.strength = param1.getStrength();
         this.health = param1.getHealth();
         this._baseArmor = param1.getArmor();
         this._baseSpeed = param1.getSpeed();
         this._baseStrength = param1.getStrength();
         this._baseHealth = param1.getHealth();
      }
      
      public function get dodgeFailPercent() : Number
      {
         return this._statHistory[this._statIndex].dodgeFailPercent;
      }
      
      public function get baseArmor() : int
      {
         return this._baseArmor;
      }
      
      public function get statIndex() : int
      {
         return this._statIndex;
      }
      
      public function get wave() : int
      {
         return this._wave;
      }
      
      public function get isFacingRight() : Boolean
      {
         return this._isFacingRight;
      }
      
      public function get swarmValue() : int
      {
         return this._swarmValue;
      }
      
      private function getPreviousStatIndex() : int
      {
         var _loc1_:int = this._statIndex - 1;
         if(_loc1_ < 0)
         {
            return 0;
         }
         return _loc1_;
      }
      
      public function get deathCount() : int
      {
         return this._deathCount;
      }
      
      private function getStat(param1:String) : Number
      {
         switch(param1)
         {
            case Stat.HEALTH:
               return this.health;
            case Stat.STRENGTH:
               return this.strength;
            case Stat.SPEED:
               return this.speed;
            case Stat.ARMOR:
               return this.armor;
            case Stat.DODGE_FAIL_PERCENTAGE:
               return this.dodgeFailPercent;
            case Stat.STUN_FAIL_PERCENTAGE:
               return this.stunFailPercent;
            case Stat.RED_SPIKE:
               return this.redSpike;
            case Stat.BLUE_SPIKE:
               return this.blueSpike;
            case Stat.YELLOW_SPIKE:
               return this.yellowSpike;
            case Stat.ENERGY_GENERATOR:
               return this._owner.energyGenerator;
            case Stat.ENERGY:
               return this._owner.energyLevel;
            default:
               return 0;
         }
      }
      
      public function removeAllHacks() : void
      {
         this.hacks = new Array();
      }
      
      public function get assetTypeId() : int
      {
         return this._assetTypeId;
      }
      
      public function get moddedSpeed() : int
      {
         return this.calcModdedStat(Stat.SPEED,this.speed,true,null,null,true,this._statIndex);
      }
      
      public function get moddedBlueSpike() : int
      {
         return this._statHistory[this._statIndex].moddedBlueSpike;
      }
      
      public function get previousModdedBlueSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedBlueSpike;
      }
      
      public function set baseHealth(param1:int) : void
      {
         this._baseHealth = param1;
      }
      
      public function set nickName(param1:String) : void
      {
         this._nickName = param1;
      }
      
      public function get moddedStrength() : int
      {
         return this.calcModdedStat(Stat.STRENGTH,this.strength,true,null,null,true,this._statIndex);
      }
      
      public function logError(param1:String) : void
      {
         DebugLog.instance.error("** [Nanovor] " + param1);
      }
      
      public function get allAttacksUsed() : Boolean
      {
         return this._allAttacksUsed;
      }
      
      public function get attacks() : Array
      {
         return this._attacks;
      }
      
      public function getAttackByAttackId(param1:int) : IAttack
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._attacks.length)
         {
            if(this._attacks[_loc2_].attackID == param1)
            {
               return this._attacks[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function set evolveId(param1:int) : void
      {
         this._evolveId = param1;
      }
      
      public function get battleCount() : int
      {
         return this._battleCount;
      }
      
      public function get previousModdedYellowSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedYellowSpike;
      }
      
      public function get safeNickName() : String
      {
         if(Boolean(this._nickName) && this._nickName != "")
         {
            return this._nickName;
         }
         return "";
      }
      
      public function get armor() : int
      {
         return this._statHistory[this._statIndex].armor;
      }
      
      public function getAttack(param1:int) : IAttack
      {
         return this._attacks[param1];
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log("[Nanovor] " + param1);
      }
      
      public function set isDead(param1:Boolean) : void
      {
         this._isDead = param1;
      }
      
      public function get productionNumber() : int
      {
         return this._productionNumber;
      }
      
      public function set owner(param1:IPlayer) : void
      {
         this._owner = param1;
      }
      
      public function checkStatOverride(param1:String) : Boolean
      {
         var _loc3_:AttackStatement = null;
         if(this._owner == null)
         {
            return false;
         }
         if(this._owner.currentOverrideArray == null)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in this._owner.currentOverrideArray)
         {
            if(_loc3_.stat == param1)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function get moddedYellowSpike() : int
      {
         return this._statHistory[this._statIndex].moddedYellowSpike;
      }
      
      public function get hacks() : Array
      {
         return this._statHistory[this._statIndex].hacks;
      }
      
      public function get previousModdedStunFailPercent() : Number
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedStunFailPercent;
      }
      
      public function addHack(param1:IAttackStatement) : void
      {
         this.hacks.push(param1);
         if(this.hacks.length > MAX_HACKS)
         {
            this.hacks.shift();
         }
      }
      
      public function removeLastHack() : void
      {
         this.hacks.pop();
      }
      
      public function get assetTypeCategory() : String
      {
         return this._assetTypeCategory;
      }
      
      public function get hexiteKillCount() : int
      {
         return this._hexiteKillCount;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set selectedAttack(param1:IAttack) : void
      {
         this._selectedAttack = param1;
      }
      
      public function get evolveId() : int
      {
         return this._evolveId;
      }
      
      public function get previousModdedSpeed() : int
      {
         return this.calcModdedStat(Stat.SPEED,this._statHistory[this.getPreviousStatIndex()].speed,true,null,null,true,this.getPreviousStatIndex());
      }
      
      public function get previousSpeed() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].speed;
      }
      
      public function set blueSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].blueSpike = param1;
      }
      
      private function addAttacksFromMaster(param1:IVirmonMasterData) : void
      {
         var _loc4_:IAttack = null;
         var _loc2_:Array = param1.getAttackList();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = Attack.createAttackById(int(_loc2_[_loc3_].getAttackID()));
            _loc4_.animationID = _loc3_ + 1;
            this._attacks.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function get statHistory() : Array
      {
         return this._statHistory;
      }
      
      public function set moddedDodgeFailPercent(param1:Number) : void
      {
         this._statHistory[this._statIndex].moddedDodgeFailPercent = param1;
      }
      
      public function get virmonMasterData() : IVirmonMasterData
      {
         return this._virmonMasterData;
      }
      
      public function get rarity() : String
      {
         return this._rarity;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedRedSpike = param1;
      }
      
      public function get previousModdedRedSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedRedSpike;
      }
      
      public function set isFacingRight(param1:Boolean) : void
      {
         this._isFacingRight = param1;
      }
      
      public function set statIndex(param1:int) : void
      {
         this._statIndex = param1;
      }
      
      public function get blueSpike() : int
      {
         return this._statHistory[this._statIndex].blueSpike;
      }
      
      public function removeHack(param1:IAttackStatement) : void
      {
         this.hacks.splice(this.hacks.indexOf(param1),1);
      }
      
      public function set baseArmor(param1:int) : void
      {
         this._baseArmor = param1;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].yellowSpike = param1;
      }
      
      public function set dodgeFailPercent(param1:Number) : void
      {
         this._statHistory[this._statIndex].dodgeFailPercent = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].redSpike = param1;
      }
      
      public function get yellowSpike() : int
      {
         return this._statHistory[this._statIndex].yellowSpike;
      }
      
      public function get redSpike() : int
      {
         return this._statHistory[this._statIndex].redSpike;
      }
      
      public function get baseSpeed() : int
      {
         return this._baseSpeed;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         this._baseSpeed = param1;
      }
      
      public function set moddedArmor(param1:int) : void
      {
         this.logError("moddedArmor setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get moddedArmor() : int
      {
         return this.calcModdedStat(Stat.ARMOR,this.armor,true,null,null,true,this._statIndex);
      }
   }
}

