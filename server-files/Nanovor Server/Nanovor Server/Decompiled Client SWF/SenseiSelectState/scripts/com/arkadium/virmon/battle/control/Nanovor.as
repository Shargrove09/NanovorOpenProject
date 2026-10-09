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
         _assetTypeId = 0;
         _name = "";
         _collectorId = "";
         _version = 0;
         _wave = 0;
         _rarity = "";
         _bloodType = "";
         _level = 0;
         _assetFlag = 0;
         _productionNumber = 0;
         _faction = "";
         _swarmValue = 0;
         _attacks = new Array();
         _assetId = "0";
         _nickName = "";
         _assetTypeCategory = "";
         _evolveId = 0;
         _selectedAttack = null;
         _owner = null;
         _isDead = false;
         _baseHealth = 0;
         _baseStrength = 0;
         _baseArmor = 0;
         _baseSpeed = 0;
         _fullEvolveDate = new Date();
         resetStatHistory();
      }
      
      public function get previousModdedStrength() : int
      {
         return calcModdedStat(Stat.STRENGTH,_statHistory[getPreviousStatIndex()].strength,true,null,null,true,getPreviousStatIndex());
      }
      
      private function calcModdedStat(param1:String, param2:Number, param3:Boolean = true, param4:IPlayer = null, param5:IPlayer = null, param6:Boolean = false, param7:int = -1) : Number
      {
         var _loc9_:IAttackStatement = null;
         var _loc10_:IAttackStatement = null;
         if(param4 == null)
         {
            param4 = _owner;
         }
         if(param7 == -1)
         {
            param7 = _statIndex;
         }
         var _loc8_:Number = param2;
         if(_owner != null)
         {
            for each(_loc9_ in _owner.getPlayerStats(param7).currentOverrideArray)
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
         return _statHistory[getPreviousStatIndex()].dodgeFailPercent;
      }
      
      public function get previousRedSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].redSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedBlueSpike = param1;
      }
      
      public function set moddedSpeed(param1:int) : void
      {
         logError("moddedSpeed setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get faction() : String
      {
         return _faction;
      }
      
      public function getModdedStat(param1:String, param2:Boolean = false) : Number
      {
         switch(param1)
         {
            case Stat.HEALTH:
               return health;
            case Stat.STRENGTH:
               return moddedStrength;
            case Stat.SPEED:
               return moddedSpeed;
            case Stat.ARMOR:
               return moddedArmor;
            case Stat.DODGE_FAIL_PERCENTAGE:
               return moddedDodgeFailPercent;
            case Stat.STUN_FAIL_PERCENTAGE:
               return moddedStunFailPercent;
            case Stat.RED_SPIKE:
               return _owner.moddedRedSpike;
            case Stat.BLUE_SPIKE:
               return _owner.moddedBlueSpike;
            case Stat.YELLOW_SPIKE:
               return _owner.moddedYellowSpike;
            case Stat.ENERGY_GENERATOR:
               return _owner.moddedEnergyGenerator;
            case Stat.ENERGY:
               return _owner.energyLevel;
            default:
               return 0;
         }
      }
      
      public function get assetId() : String
      {
         return _assetId;
      }
      
      public function get stunFailPercent() : Number
      {
         return _statHistory[_statIndex].stunFailPercent;
      }
      
      public function get baseStrength() : int
      {
         return _baseStrength;
      }
      
      public function get previousHealth() : int
      {
         return _statHistory[getPreviousStatIndex()].health;
      }
      
      public function get moddedStunFailPercent() : Number
      {
         return _statHistory[_statIndex].moddedStunFailPercent;
      }
      
      public function get previousStunFailPercent() : Number
      {
         return _statHistory[getPreviousStatIndex()].stunFailPercent;
      }
      
      public function get playerStats() : IPlayerStats
      {
         return _statHistory[_statIndex].playerStats;
      }
      
      public function addStatHistory() : void
      {
         var _loc1_:NanovorStats = _statHistory[_statIndex].clone();
         _statHistory.push(_loc1_);
         _statIndex = _statHistory.length - 1;
      }
      
      public function get strength() : int
      {
         return _statHistory[_statIndex].strength;
      }
      
      public function initializeWithMasterData(param1:IVirmonMasterData) : void
      {
         if(param1 == null)
         {
            return;
         }
         _virmonMasterData = param1;
         _assetTypeId = int(param1.getAssetTypeID());
         _name = param1.getName();
         _collectorId = param1.getCollectorID();
         _version = param1.getAssetTypeVersion();
         _wave = param1.getWave();
         _rarity = param1.getRarity();
         _level = param1.getLevel();
         _faction = param1.getFaction();
         _swarmValue = param1.getPointValue();
         armor = param1.getBaseArmor();
         speed = param1.getBaseSpeed();
         strength = param1.getBaseStrength();
         health = param1.getBaseHealth();
         _baseHealth = param1.getBaseHealth();
         _baseStrength = param1.getBaseStrength();
         _baseArmor = param1.getBaseArmor();
         _baseSpeed = param1.getBaseSpeed();
         addAttacksFromMaster(param1);
      }
      
      public function get speed() : int
      {
         return _statHistory[_statIndex].speed;
      }
      
      public function set moddedStrength(param1:int) : void
      {
         logError("moddedStrength setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get killCount() : int
      {
         return _killCount;
      }
      
      public function get bloodType() : String
      {
         return _bloodType;
      }
      
      public function set assetId(param1:String) : void
      {
         _assetId = param1;
      }
      
      public function get previousStrength() : int
      {
         return _statHistory[getPreviousStatIndex()].strength;
      }
      
      public function set stunFailPercent(param1:Number) : void
      {
         _statHistory[_statIndex].stunFailPercent = param1;
      }
      
      public function get health() : int
      {
         return _statHistory[_statIndex].health;
      }
      
      public function set baseStrength(param1:int) : void
      {
         _baseStrength = param1;
      }
      
      public function set moddedStunFailPercent(param1:Number) : void
      {
         _statHistory[_statIndex].moddedStunFailPercent = param1;
      }
      
      public function toString() : String
      {
         var _loc2_:AttackStatement = null;
         var _loc1_:String = _name;
         _loc1_ += _isDead ? " DEAD" : "";
         _loc1_ += " HP=" + health + "/" + baseHealth + " ARM=" + moddedArmor + "/" + baseArmor + " SPD=" + moddedSpeed + "/" + baseSpeed + " STR=" + moddedStrength + "/" + baseStrength;
         _loc1_ += " DF=" + moddedDodgeFailPercent + " SF=" + moddedStunFailPercent;
         _loc1_ += " R=" + moddedRedSpike + " Y=" + moddedYellowSpike + " B=" + moddedBlueSpike;
         _loc1_ += " HIDS: ";
         for each(_loc2_ in hacks)
         {
            _loc1_ += _loc2_.id + " ";
         }
         return _loc1_ + ("(" + _assetTypeId + ", " + _assetId + ")");
      }
      
      public function get previousYellowSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].yellowSpike;
      }
      
      public function set playerStats(param1:IPlayerStats) : void
      {
         _statHistory[_statIndex].playerStats = param1;
      }
      
      public function set armor(param1:int) : void
      {
         _statHistory[_statIndex].armor = param1;
      }
      
      public function set strength(param1:int) : void
      {
         _statHistory[_statIndex].strength = param1;
      }
      
      public function get previousModdedArmor() : int
      {
         return calcModdedStat(Stat.ARMOR,_statHistory[getPreviousStatIndex()].armor,true,null,null,true,getPreviousStatIndex());
      }
      
      public function get previousArmor() : int
      {
         return _statHistory[getPreviousStatIndex()].armor;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get assetFlag() : int
      {
         return _assetFlag;
      }
      
      public function get previousBlueSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].blueSpike;
      }
      
      public function set speed(param1:int) : void
      {
         _statHistory[_statIndex].speed = param1;
      }
      
      public function get maxDamageHit() : int
      {
         return _maxDamageHit;
      }
      
      public function get winCount() : int
      {
         return _winCount;
      }
      
      public function get velocitronKillCount() : int
      {
         return _velocitronKillCount;
      }
      
      public function get baseHealth() : int
      {
         return _baseHealth;
      }
      
      public function get maxDamageGame() : int
      {
         return _maxDamageGame;
      }
      
      public function get previousModdedDodgeFailPercent() : Number
      {
         return _statHistory[getPreviousStatIndex()].moddedDodgeFailPercent;
      }
      
      public function get maxRoundCount() : int
      {
         return _maxRoundCount;
      }
      
      public function get isDead() : Boolean
      {
         return _isDead;
      }
      
      public function get owner() : IPlayer
      {
         return _owner;
      }
      
      public function set health(param1:int) : void
      {
         _statHistory[_statIndex].health = param1;
      }
      
      public function get previousHacks() : Array
      {
         return _statHistory[getPreviousStatIndex()].hacks;
      }
      
      public function get magnamodKillCount() : int
      {
         return _magnamodKillCount;
      }
      
      public function get fullEvolveDate() : Date
      {
         return _fullEvolveDate;
      }
      
      public function get selectedAttack() : IAttack
      {
         return _selectedAttack;
      }
      
      public function get nickName() : String
      {
         return _nickName;
      }
      
      public function set assetTypeCategory(param1:String) : void
      {
         _assetTypeCategory = param1;
      }
      
      public function get moddedDodgeFailPercent() : Number
      {
         return _statHistory[_statIndex].moddedDodgeFailPercent;
      }
      
      public function get moddedRedSpike() : int
      {
         return _statHistory[_statIndex].moddedRedSpike;
      }
      
      public function get version() : int
      {
         return _version;
      }
      
      public function resetStatHistory() : void
      {
         var _loc1_:NanovorStats = null;
         if(_statHistory != null && _statHistory.length > 0)
         {
            _loc1_ = _statHistory.pop();
         }
         else
         {
            _loc1_ = new NanovorStats();
         }
         _statHistory = new Array();
         _statHistory.push(_loc1_);
         _statIndex = _statHistory.length - 1;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedYellowSpike = param1;
      }
      
      public function set hacks(param1:Array) : void
      {
         _statHistory[_statIndex].hacks = param1;
      }
      
      public function initializeWithVirmonData(param1:IVirmonData) : void
      {
         initializeWithMasterData(param1.getVirmonMasterData());
         _assetId = param1.getAssetID();
         _fullEvolveDate = param1.getFullEvolveDate();
         _nickName = param1.getNickName();
         _battleCount = param1.getBattleCount();
         _deathCount = param1.getDeathCount();
         _hexiteKillCount = param1.getHexiteKillCount();
         _killCount = param1.getKillCount();
         _magnamodKillCount = param1.getMagnamodKillCount();
         _winCount = param1.getWinCount();
         _velocitronKillCount = param1.getVelocitronKillCount();
         _allAttacksUsed = param1.areAllAttacksUsed();
         _maxDamageGame = param1.getMaxDamageGame();
         _maxDamageHit = param1.getMaxDamageHit();
         _maxRoundCount = param1.getMaxRoundCount();
         armor = param1.getArmor();
         speed = param1.getSpeed();
         strength = param1.getStrength();
         health = param1.getHealth();
         _baseArmor = param1.getArmor();
         _baseSpeed = param1.getSpeed();
         _baseStrength = param1.getStrength();
         _baseHealth = param1.getHealth();
      }
      
      public function get dodgeFailPercent() : Number
      {
         return _statHistory[_statIndex].dodgeFailPercent;
      }
      
      public function get baseArmor() : int
      {
         return _baseArmor;
      }
      
      public function get statIndex() : int
      {
         return _statIndex;
      }
      
      public function get wave() : int
      {
         return _wave;
      }
      
      public function get isFacingRight() : Boolean
      {
         return _isFacingRight;
      }
      
      public function get swarmValue() : int
      {
         return _swarmValue;
      }
      
      private function getPreviousStatIndex() : int
      {
         var _loc1_:int = _statIndex - 1;
         if(_loc1_ < 0)
         {
            return 0;
         }
         return _loc1_;
      }
      
      public function get deathCount() : int
      {
         return _deathCount;
      }
      
      private function getStat(param1:String) : Number
      {
         switch(param1)
         {
            case Stat.HEALTH:
               return health;
            case Stat.STRENGTH:
               return strength;
            case Stat.SPEED:
               return speed;
            case Stat.ARMOR:
               return armor;
            case Stat.DODGE_FAIL_PERCENTAGE:
               return dodgeFailPercent;
            case Stat.STUN_FAIL_PERCENTAGE:
               return stunFailPercent;
            case Stat.RED_SPIKE:
               return redSpike;
            case Stat.BLUE_SPIKE:
               return blueSpike;
            case Stat.YELLOW_SPIKE:
               return yellowSpike;
            case Stat.ENERGY_GENERATOR:
               return _owner.energyGenerator;
            case Stat.ENERGY:
               return _owner.energyLevel;
            default:
               return 0;
         }
      }
      
      public function removeAllHacks() : void
      {
         hacks = new Array();
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
      
      public function get moddedSpeed() : int
      {
         return calcModdedStat(Stat.SPEED,speed,true,null,null,true,_statIndex);
      }
      
      public function get moddedBlueSpike() : int
      {
         return _statHistory[_statIndex].moddedBlueSpike;
      }
      
      public function get previousModdedBlueSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedBlueSpike;
      }
      
      public function set baseHealth(param1:int) : void
      {
         _baseHealth = param1;
      }
      
      public function set nickName(param1:String) : void
      {
         _nickName = param1;
      }
      
      public function get moddedStrength() : int
      {
         return calcModdedStat(Stat.STRENGTH,strength,true,null,null,true,_statIndex);
      }
      
      public function logError(param1:String) : void
      {
         DebugLog.instance.error("** [Nanovor] " + param1);
      }
      
      public function get allAttacksUsed() : Boolean
      {
         return _allAttacksUsed;
      }
      
      public function get attacks() : Array
      {
         return _attacks;
      }
      
      public function getAttackByAttackId(param1:int) : IAttack
      {
         var _loc2_:* = 0;
         while(_loc2_ < _attacks.length)
         {
            if(_attacks[_loc2_].attackID == param1)
            {
               return _attacks[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function set evolveId(param1:int) : void
      {
         _evolveId = param1;
      }
      
      public function get battleCount() : int
      {
         return _battleCount;
      }
      
      public function get previousModdedYellowSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedYellowSpike;
      }
      
      public function get safeNickName() : String
      {
         if(Boolean(_nickName) && _nickName != "")
         {
            return _nickName;
         }
         return "";
      }
      
      public function get armor() : int
      {
         return _statHistory[_statIndex].armor;
      }
      
      public function getAttack(param1:int) : IAttack
      {
         return _attacks[param1];
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log("[Nanovor] " + param1);
      }
      
      public function set isDead(param1:Boolean) : void
      {
         _isDead = param1;
      }
      
      public function get productionNumber() : int
      {
         return _productionNumber;
      }
      
      public function set owner(param1:IPlayer) : void
      {
         _owner = param1;
      }
      
      public function checkStatOverride(param1:String) : Boolean
      {
         var _loc3_:AttackStatement = null;
         if(_owner == null)
         {
            return false;
         }
         if(_owner.currentOverrideArray == null)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in _owner.currentOverrideArray)
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
         return _statHistory[_statIndex].moddedYellowSpike;
      }
      
      public function get hacks() : Array
      {
         return _statHistory[_statIndex].hacks;
      }
      
      public function get previousModdedStunFailPercent() : Number
      {
         return _statHistory[getPreviousStatIndex()].moddedStunFailPercent;
      }
      
      public function addHack(param1:IAttackStatement) : void
      {
         hacks.push(param1);
         if(hacks.length > MAX_HACKS)
         {
            hacks.shift();
         }
      }
      
      public function removeLastHack() : void
      {
         hacks.pop();
      }
      
      public function get assetTypeCategory() : String
      {
         return _assetTypeCategory;
      }
      
      public function get hexiteKillCount() : int
      {
         return _hexiteKillCount;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set selectedAttack(param1:IAttack) : void
      {
         _selectedAttack = param1;
      }
      
      public function get evolveId() : int
      {
         return _evolveId;
      }
      
      public function get previousModdedSpeed() : int
      {
         return calcModdedStat(Stat.SPEED,_statHistory[getPreviousStatIndex()].speed,true,null,null,true,getPreviousStatIndex());
      }
      
      public function get previousSpeed() : int
      {
         return _statHistory[getPreviousStatIndex()].speed;
      }
      
      public function set blueSpike(param1:int) : void
      {
         _statHistory[_statIndex].blueSpike = param1;
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
            _attacks.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function get statHistory() : Array
      {
         return _statHistory;
      }
      
      public function set moddedDodgeFailPercent(param1:Number) : void
      {
         _statHistory[_statIndex].moddedDodgeFailPercent = param1;
      }
      
      public function get virmonMasterData() : IVirmonMasterData
      {
         return _virmonMasterData;
      }
      
      public function get rarity() : String
      {
         return _rarity;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedRedSpike = param1;
      }
      
      public function get previousModdedRedSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedRedSpike;
      }
      
      public function set isFacingRight(param1:Boolean) : void
      {
         _isFacingRight = param1;
      }
      
      public function set statIndex(param1:int) : void
      {
         _statIndex = param1;
      }
      
      public function get blueSpike() : int
      {
         return _statHistory[_statIndex].blueSpike;
      }
      
      public function removeHack(param1:IAttackStatement) : void
      {
         hacks.splice(hacks.indexOf(param1),1);
      }
      
      public function set baseArmor(param1:int) : void
      {
         _baseArmor = param1;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         _statHistory[_statIndex].yellowSpike = param1;
      }
      
      public function set dodgeFailPercent(param1:Number) : void
      {
         _statHistory[_statIndex].dodgeFailPercent = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         _statHistory[_statIndex].redSpike = param1;
      }
      
      public function get yellowSpike() : int
      {
         return _statHistory[_statIndex].yellowSpike;
      }
      
      public function get redSpike() : int
      {
         return _statHistory[_statIndex].redSpike;
      }
      
      public function get baseSpeed() : int
      {
         return _baseSpeed;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         _baseSpeed = param1;
      }
      
      public function set moddedArmor(param1:int) : void
      {
         logError("moddedArmor setter deprecated: " + new Error("stack-trace").getStackTrace());
      }
      
      public function get moddedArmor() : int
      {
         return calcModdedStat(Stat.ARMOR,armor,true,null,null,true,_statIndex);
      }
   }
}

