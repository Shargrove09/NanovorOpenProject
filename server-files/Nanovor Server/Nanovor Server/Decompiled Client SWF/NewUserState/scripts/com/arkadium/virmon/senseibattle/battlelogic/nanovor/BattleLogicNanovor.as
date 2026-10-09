package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.senseibattle.battlelogic.GameMath;
   import com.arkadium.virmon.senseibattle.battlelogic.player.BattleLogicPlayer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleLogicNanovor extends Asset
   {
      
      private var _maxStrength:int;
      
      private var _baseStrength:int;
      
      private var _totalGameDamage:int;
      
      private var _baseHealth:int;
      
      private var _yellowSpike:int;
      
      private var _buffFormulaStrength:Array;
      
      private var _magnamodKillCount:int;
      
      private var _moddedArmor:int;
      
      private var _armor:int;
      
      private var _blueSpike:int;
      
      private var _lastEvolutionDate:String;
      
      private var _hacks:Array;
      
      private var _nanovor:INanovor;
      
      private var _baseSpeed:int;
      
      private var _swarmValue:int;
      
      private var _screenStar:Boolean;
      
      private var _maxDamageHit:int;
      
      private var _level:int;
      
      private var _deathCount:int;
      
      private var _maxSpeed:int;
      
      private var _deathCountLifeTime:int;
      
      private var _hitPointsTotal:int;
      
      private var _collectorId:String;
      
      private var _rarity:String;
      
      private var _killCount:int;
      
      private var _bloodType:String;
      
      private var _evolveId:int;
      
      private var _buffFormulaSpeed:Array;
      
      private var _moddedBlueSpike:int;
      
      private var _faction:String;
      
      private var _hitPoints:int;
      
      private var _killCountLifeTime:int;
      
      private var _selectedAttack:BattleLogicAttack;
      
      private var _moddedYellowSpike:int;
      
      private var _moddedRedSpike:int;
      
      private var _assetFlag:int;
      
      private var _lastManStanding:int;
      
      private var _typeId:Number;
      
      private var _scrapedBy:Boolean;
      
      private var _moddedStunFailPercent:Number;
      
      private var _hexiteKillCount:int;
      
      private var _moddedStrength:int;
      
      private var _assetTypeId:int;
      
      private var _moddedSpeed:int;
      
      private var _speed:int;
      
      private var _dodgeFailPercent:Number;
      
      private var _buffFormulaHealth:Array;
      
      private var _redSpike:int;
      
      private var _moddedHitPoints:int;
      
      private var _maxHealth:int;
      
      private var _name:String;
      
      private var _baseArmor:int;
      
      private var _battleCount:int;
      
      private var _health:int;
      
      private var _forSale:Boolean;
      
      private var _battleCountLifeTime:int;
      
      private var _birthDate:String;
      
      private var _version:int;
      
      private var _maxArmor:int;
      
      private var _strength:int;
      
      private var _owner:BattleLogicPlayer;
      
      private var _roundsPlayed:int;
      
      private var _productionNumber:int;
      
      private var _buffFormulaArmor:Array;
      
      private var _velocitronKillCount:int;
      
      private var _wave:int;
      
      private var _attacks:Array;
      
      private var _nickName:String;
      
      private var _stunFailPercent:Number;
      
      private var _moddedDodgeFailPercent:Number;
      
      private var _winCount:int;
      
      public function BattleLogicNanovor(param1:INanovor = null)
      {
         super();
         _nanovor = param1;
         _assetId = "";
         _name = "";
         _nickName = "";
         _assetTypeCategory = "";
         _collectorId = "";
         _version = 0;
         _wave = 0;
         _rarity = "";
         _bloodType = "";
         _level = 0;
         _assetFlag = 0;
         _productionNumber = 0;
         _faction = Faction.NONE;
         _typeId = 0;
         _armor = 0;
         _speed = 0;
         _strength = 0;
         _hitPoints = 0;
         _moddedArmor = 0;
         _moddedSpeed = 0;
         _moddedStrength = 0;
         _moddedHitPoints = 0;
         _hitPointsTotal = 0;
         _buffFormulaArmor = null;
         _buffFormulaSpeed = null;
         _buffFormulaStrength = null;
         _buffFormulaHealth = null;
         _baseArmor = 0;
         _baseSpeed = 0;
         _baseStrength = 0;
         _baseHealth = 0;
         _maxArmor = 0;
         _maxSpeed = 0;
         _maxStrength = 0;
         _maxHealth = 0;
         _dodgeFailPercent = 1;
         _stunFailPercent = 1;
         _moddedDodgeFailPercent = 1;
         _moddedStunFailPercent = 1;
         _swarmValue = 0;
         _attacks = new Array();
         _hacks = new Array();
         _redSpike = 0;
         _blueSpike = 0;
         _yellowSpike = 0;
         _moddedRedSpike = 0;
         _moddedBlueSpike = 0;
         _moddedYellowSpike = 0;
         _forSale = false;
         _battleCountLifeTime = 0;
         _killCountLifeTime = 0;
         _deathCountLifeTime = 0;
         _birthDate = "";
         _lastEvolutionDate = "";
         _maxDamageHit = 0;
         _totalGameDamage = 0;
         _roundsPlayed = 0;
         _killCount = 0;
         _battleCount = 1;
         _deathCount = 0;
         _magnamodKillCount = 0;
         _velocitronKillCount = 0;
         _hexiteKillCount = 0;
         _winCount = 0;
         _lastManStanding = 0;
         _screenStar = false;
         _scrapedBy = false;
         if(null != _nanovor)
         {
            _assetId = _nanovor.assetId;
            _typeId = _nanovor.assetTypeId;
            _assetTypeId = _nanovor.assetTypeId;
            _hitPoints = _nanovor.health;
            _hitPointsTotal = _hitPoints;
            _baseHealth = _hitPoints;
         }
      }
      
      public function addDamageToTotal(param1:int) : void
      {
         _totalGameDamage += param1;
      }
      
      public function getBattleCount() : int
      {
         return _battleCount;
      }
      
      public function setMaxStrength(param1:int) : void
      {
         _maxStrength = param1;
      }
      
      public function get deathCountLifeTime() : int
      {
         return _deathCountLifeTime;
      }
      
      public function isStunned(param1:Boolean) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = getModdedStat(Stat.STUN_FAIL_PERCENTAGE,param1);
         _loc3_ = GameMath.getRandomNumber();
         if(_loc3_ > _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public function setName(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            _name = _name;
         }
         else
         {
            _name = param1;
         }
      }
      
      public function setForSale(param1:Boolean) : void
      {
         _forSale = param1;
      }
      
      public function setBloodType(param1:String) : void
      {
         _bloodType = param1;
      }
      
      public function incKillCount() : void
      {
         ++_killCount;
      }
      
      public function setHitPoints(param1:int) : void
      {
         _hitPoints = param1;
      }
      
      public function setDeathCountLifeTime(param1:int) : void
      {
         _deathCountLifeTime = param1;
      }
      
      public function setVersion(param1:int) : void
      {
         _version = param1;
      }
      
      public function getWinCount() : int
      {
         return _winCount;
      }
      
      public function setBuffFormulaArmor(param1:Array) : void
      {
         _buffFormulaArmor = param1;
      }
      
      public function get faction() : String
      {
         return _faction;
      }
      
      public function get assetId() : String
      {
         return _assetId;
      }
      
      public function get naturalHitPoints() : int
      {
         return _hitPoints;
      }
      
      public function removeRandomHack() : int
      {
         var _loc1_:int = 0;
         if(_hacks.length > 0)
         {
            _loc1_ = Math.random() * (_hacks.length - 1);
            _hacks.splice(_loc1_,1);
            return _loc1_;
         }
         return -1;
      }
      
      public function setYellowSpike(param1:int) : void
      {
         _yellowSpike = param1;
      }
      
      public function setMaxDamageHit(param1:int) : void
      {
         _maxDamageHit = _maxDamageHit >= param1 ? _maxDamageHit : param1;
      }
      
      public function get baseStrength() : int
      {
         return _baseStrength;
      }
      
      public function get stunFailPercent() : Number
      {
         return _stunFailPercent;
      }
      
      public function get maxArmor() : int
      {
         return _maxArmor;
      }
      
      public function getTotalGameDamage() : int
      {
         return _totalGameDamage;
      }
      
      public function get strength() : int
      {
         return _strength;
      }
      
      public function setLevel(param1:int) : void
      {
         _level = param1;
      }
      
      public function get speed() : int
      {
         return _speed;
      }
      
      public function diedInBattle() : void
      {
         setDeathCount();
      }
      
      public function setAssetFlag(param1:int) : void
      {
         _assetFlag = param1;
      }
      
      public function getRoundsPlayed() : int
      {
         return _roundsPlayed;
      }
      
      public function get battleCountLifeTime() : int
      {
         return _battleCountLifeTime;
      }
      
      public function get hitPoints() : int
      {
         return _hitPoints;
      }
      
      public function get bloodType() : String
      {
         return _bloodType;
      }
      
      public function get health() : int
      {
         return _health;
      }
      
      private function addAttack(param1:BattleLogicAttack) : void
      {
         _attacks.push(param1);
      }
      
      public function setScrapedBy(param1:Boolean) : void
      {
         _scrapedBy = param1;
      }
      
      public function get buffFormulaSpeed() : Array
      {
         return _buffFormulaSpeed;
      }
      
      public function setWave(param1:int) : void
      {
         _wave = param1;
      }
      
      public function get assetFlag() : int
      {
         return _assetFlag;
      }
      
      public function toString() : String
      {
         var _loc1_:String = _name + " (HP: " + _hitPoints + "/" + _hitPointsTotal + ")";
         return _loc1_ + "Armor: " + armor + " Strength: " + strength + " Speed: " + speed + " Modded HP: " + _moddedHitPoints;
      }
      
      public function setRedSpike(param1:int) : void
      {
         _redSpike = param1;
      }
      
      public function get collectorId() : String
      {
         return _collectorId;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get baseHealth() : int
      {
         return _baseHealth;
      }
      
      public function setBaseHealth(param1:int) : void
      {
         _baseHealth = param1;
      }
      
      public function setLastEvolutionDate(param1:String) : void
      {
         _lastEvolutionDate = param1;
      }
      
      public function get nickName() : String
      {
         return _nickName;
      }
      
      public function get naturalArmor() : int
      {
         return _armor;
      }
      
      public function incMagnamodKillCount() : void
      {
         ++_magnamodKillCount;
      }
      
      public function get hitPointsTotal() : int
      {
         return _hitPointsTotal;
      }
      
      public function setMaxHealth(param1:int) : void
      {
         _maxHealth = param1;
      }
      
      private function setEvloveId(param1:int) : void
      {
         _evolveId = param1;
      }
      
      public function setBattleCountLifeTime(param1:int) : void
      {
         _battleCountLifeTime = param1;
      }
      
      public function scrapedBy() : Boolean
      {
         return _scrapedBy;
      }
      
      public function get forSale() : Boolean
      {
         return _forSale;
      }
      
      public function resetModdedStats(param1:Boolean, param2:BattleLogicPlayer, param3:BattleLogicPlayer) : void
      {
         _moddedArmor = setModdedStat(Stat.ARMOR,param1,param2,param3);
         if(_armor != _moddedArmor)
         {
         }
         _moddedSpeed = setModdedStat(Stat.SPEED,param1,param2,param3);
         if(_speed != _moddedSpeed)
         {
         }
         _moddedStrength = setModdedStat(Stat.STRENGTH,param1,param2,param3);
         if(_strength != _moddedStrength)
         {
            log(name + " strength base: " + _strength + " modded: " + _moddedStrength);
         }
         _moddedHitPoints = setModdedStat(Stat.HEALTH,param1,param2,param3);
         if(_hitPoints != _moddedHitPoints)
         {
            log(name + " hit points base: " + _hitPoints + " modded: " + _moddedHitPoints);
         }
         _moddedDodgeFailPercent = setModdedStat(Stat.DODGE_FAIL_PERCENTAGE,param1,param2,param3);
         if(_dodgeFailPercent != _moddedDodgeFailPercent)
         {
         }
         _moddedStunFailPercent = setModdedStat(Stat.STUN_FAIL_PERCENTAGE,param1,param2,param3);
         if(_stunFailPercent != _moddedStunFailPercent)
         {
         }
         _moddedRedSpike = setModdedStat(Stat.RED_SPIKE,param1,param2,param3);
         if(_redSpike != _moddedRedSpike)
         {
         }
         _moddedBlueSpike = setModdedStat(Stat.BLUE_SPIKE,param1,param2,param3);
         if(_blueSpike != _moddedBlueSpike)
         {
         }
         _moddedYellowSpike = setModdedStat(Stat.YELLOW_SPIKE,param1,param2,param3);
         if(_yellowSpike != _moddedYellowSpike)
         {
         }
      }
      
      public function get owner() : BattleLogicPlayer
      {
         return _owner;
      }
      
      public function setRarity(param1:String) : void
      {
         _rarity = param1;
      }
      
      public function setBaseArmor(param1:int) : void
      {
         _baseArmor = param1;
      }
      
      public function setMaxArmor(param1:int) : void
      {
         _maxArmor = param1;
      }
      
      public function get selectedAttack() : BattleLogicAttack
      {
         return _selectedAttack;
      }
      
      private function setCollectorId(param1:String) : void
      {
         _collectorId = param1;
      }
      
      public function setBirthDate(param1:String) : void
      {
         _birthDate = param1;
      }
      
      private function getStat(param1:String) : Number
      {
         if(param1 == Stat.HEALTH)
         {
            return _hitPoints;
         }
         if(param1 == Stat.STRENGTH)
         {
            return _strength;
         }
         if(param1 == Stat.SPEED)
         {
            return _speed;
         }
         if(param1 == Stat.ARMOR)
         {
            return _armor;
         }
         if(param1 == Stat.DODGE_FAIL_PERCENTAGE)
         {
            return _dodgeFailPercent;
         }
         if(param1 == Stat.STUN_FAIL_PERCENTAGE)
         {
            return _stunFailPercent;
         }
         if(param1 == Stat.RED_SPIKE)
         {
            return _redSpike;
         }
         if(param1 == Stat.BLUE_SPIKE)
         {
            return _blueSpike;
         }
         if(param1 == Stat.YELLOW_SPIKE)
         {
            return _yellowSpike;
         }
         if(param1 == Stat.ENERGY_GENERATOR)
         {
            return _owner.energyGenerator;
         }
         if(param1 == Stat.ENERGY)
         {
            return _owner.energyLevel;
         }
         return 0;
      }
      
      public function get lastEvolutionDate() : String
      {
         return _lastEvolutionDate;
      }
      
      public function incRoundsPlayed() : void
      {
         ++_roundsPlayed;
      }
      
      public function get version() : int
      {
         return _version;
      }
      
      public function get swarmValue() : int
      {
         return _swarmValue;
      }
      
      public function getAttackByAttackId(param1:int) : BattleLogicAttack
      {
         var _loc3_:BattleLogicAttack = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _attacks.length)
         {
            _loc3_ = _attacks[_loc2_];
            if(_loc3_.attackId == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return new BattleLogicAttack(0);
      }
      
      public function get maxHealth() : int
      {
         return _maxHealth;
      }
      
      public function setScreenStar(param1:Boolean) : void
      {
         _screenStar = param1;
      }
      
      private function setSwarmValue(param1:int) : void
      {
         _swarmValue = param1;
      }
      
      public function get baseArmor() : int
      {
         return _baseArmor;
      }
      
      public function get dodgeFailPercent() : Number
      {
         return _dodgeFailPercent;
      }
      
      public function get buffFormulaStrength() : Array
      {
         return _buffFormulaStrength;
      }
      
      public function getDeathCount() : int
      {
         return _deathCount;
      }
      
      public function get wave() : int
      {
         return _wave;
      }
      
      public function setDeathCount() : void
      {
         _deathCount = 1;
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
      
      private function setTypeId(param1:Number) : void
      {
         _typeId = param1;
      }
      
      public function setStrength(param1:int) : void
      {
         _strength = param1;
      }
      
      public function setSpeed(param1:int) : void
      {
         _speed = param1;
      }
      
      public function get birthDate() : String
      {
         return _birthDate;
      }
      
      public function setBuffFormulaSpeed(param1:Array) : void
      {
         _buffFormulaSpeed = param1;
      }
      
      public function setNickName(param1:String) : void
      {
         _nickName = param1 == null || param1 == "" ? _nickName : param1;
      }
      
      public function setWinCount(param1:int) : void
      {
         _winCount = param1;
      }
      
      public function getMaxDamageHit() : int
      {
         return _maxDamageHit;
      }
      
      public function setKillCountLifeTime(param1:int) : void
      {
         _killCountLifeTime = param1;
      }
      
      public function getLastManStanding() : int
      {
         return _lastManStanding;
      }
      
      public function allAttacksUsed() : Boolean
      {
         var _loc2_:BattleLogicAttack = null;
         var _loc1_:uint = 0;
         while(_loc1_ < _attacks.length)
         {
            _loc2_ = _attacks[_loc1_];
            if(!_loc2_.type == BattleLogicAttackStatement.TYPE_PASS && !_loc2_.wasUsed())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function setWasLastManStanding() : void
      {
         _lastManStanding = 1;
      }
      
      public function get attacks() : Array
      {
         return _attacks;
      }
      
      public function isDodged(param1:BattleLogicAttack, param2:Boolean) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1.isDodgeable())
         {
            _loc3_ = getModdedStat(Stat.DODGE_FAIL_PERCENTAGE,param2);
            _loc4_ = GameMath.getRandomNumber();
            if(_loc4_ > _loc3_)
            {
               log("DODGED! roll " + _loc4_ + " > fail % " + _loc3_);
               return true;
            }
            log("NO DODGE! roll " + _loc4_ + " < fail % " + _loc3_);
         }
         return false;
      }
      
      public function setBuffFormulaStrength(param1:Array) : void
      {
         _buffFormulaStrength = param1;
      }
      
      public function getHexiteKillCount() : int
      {
         return _hexiteKillCount;
      }
      
      public function getAttack(param1:int) : BattleLogicAttack
      {
         return _attacks[param1];
      }
      
      public function get armor() : int
      {
         return _armor;
      }
      
      public function get maxSpeed() : int
      {
         return _maxSpeed;
      }
      
      public function setAssetTypeId(param1:int) : void
      {
         _assetTypeId = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicNanovor>>\t" + param1);
      }
      
      public function clone() : BattleLogicNanovor
      {
         var _loc2_:uint = 0;
         var _loc3_:BattleLogicAttack = null;
         var _loc1_:BattleLogicNanovor = new BattleLogicNanovor(_nanovor);
         _loc1_.setAssetTypeId(_assetTypeId);
         _loc1_.setName(_name);
         _loc1_.setNickName(_nickName);
         _loc1_.setAssetTypeCategory(_assetTypeCategory);
         _loc1_.setCollectorId(_collectorId);
         _loc1_.setVersion(_version);
         _loc1_.setWave(_wave);
         _loc1_.setRarity(_rarity);
         _loc1_.setBloodType(_bloodType);
         _loc1_.setLevel(_level);
         _loc1_.setAssetFlag(_assetFlag);
         _loc1_.setProductionNumber(_productionNumber);
         _loc1_.setFaction(_faction);
         _loc1_.setTypeId(_typeId);
         _loc1_.setArmor(_armor);
         _loc1_.setSpeed(_speed);
         _loc1_.setStrength(_strength);
         _loc1_.setHitPoints(_hitPoints);
         _loc1_.setHitPointsTotal(_hitPointsTotal);
         _loc1_.setBuffFormulaArmor(_buffFormulaArmor);
         _loc1_.setBuffFormulaHealth(_buffFormulaHealth);
         _loc1_.setBuffFormulaSpeed(_buffFormulaSpeed);
         _loc1_.setBuffFormulaStrength(_buffFormulaStrength);
         _loc1_.setBaseArmor(_baseArmor);
         _loc1_.setBaseHealth(_baseHealth);
         _loc1_.setBaseSpeed(_baseSpeed);
         _loc1_.setBaseStrength(_baseStrength);
         _loc1_.setMaxArmor(_maxArmor);
         _loc1_.setMaxHealth(_maxHealth);
         _loc1_.setMaxSpeed(_maxSpeed);
         _loc1_.setMaxStrength(_maxStrength);
         _loc1_.setDodgeFailPercent(_dodgeFailPercent);
         _loc1_.setStunFailPercent(_stunFailPercent);
         _loc1_.setSwarmValue(_swarmValue);
         _loc1_.setEvloveId(_evolveId);
         _loc1_.setRedSpike(_redSpike);
         _loc1_.setBlueSpike(_blueSpike);
         _loc1_.setYellowSpike(_yellowSpike);
         _loc1_.setForSale(_forSale);
         _loc1_.setBirthDate(_birthDate);
         _loc1_.setLastEvolutionDate(_lastEvolutionDate);
         _loc1_.setBattleCountLifeTime(_battleCountLifeTime);
         _loc1_.setKillCountLifeTime(_killCountLifeTime);
         _loc1_.setDeathCountLifeTime(_deathCountLifeTime);
         if(_attacks.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _attacks.length)
            {
               _loc3_ = _attacks[_loc2_];
               _loc1_.addAttack(_loc3_);
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function get productionNumber() : int
      {
         return _productionNumber;
      }
      
      public function getVelocitronKillCount() : int
      {
         return _velocitronKillCount;
      }
      
      public function get killCountLifeTime() : int
      {
         return _killCountLifeTime;
      }
      
      private function setStunFailPercent(param1:Number) : void
      {
         _stunFailPercent = param1;
      }
      
      public function get buffFormulaArmor() : Array
      {
         return _buffFormulaArmor;
      }
      
      public function setOwner(param1:BattleLogicPlayer) : void
      {
         _owner = param1;
      }
      
      public function parseNanovor(param1:XML) : *
      {
         var _loc2_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BattleLogicAttack = null;
         _assetTypeId = Number(param1.child("asset-type-id"));
         _version = Number(param1.child("asset-type-version"));
         _name = String(param1.child("name"));
         _collectorId = String(param1.child("collector-id"));
         _wave = Number(param1.child("wave"));
         _rarity = String(param1.child("rarity"));
         _faction = String(param1.child("faction"));
         _bloodType = String(param1.child("blood-type"));
         _level = Number(param1.child("level"));
         _baseSpeed = Number(param1.child("base-speed"));
         _baseStrength = Number(param1.child("base-strength"));
         _baseArmor = Number(param1.child("base-armor"));
         _baseHealth = Number(param1.child("base-health"));
         _hitPoints = baseHealth;
         _hitPointsTotal = _baseHealth;
         _maxSpeed = Number(param1.child("max-speed"));
         _maxStrength = Number(param1.child("max-strength"));
         _maxArmor = Number(param1.child("max-armor"));
         _maxHealth = Number(param1.child("max-health"));
         var _loc3_:XMLList = param1.descendants("buff-formula-speed");
         _buffFormulaSpeed = new Array(_loc3_.length());
         _loc2_ = 0;
         while(_loc2_ < _buffFormulaSpeed.length)
         {
            _buffFormulaSpeed[_loc2_] = Number(_loc3_[_loc2_]);
            _loc2_++;
         }
         var _loc4_:XMLList = param1.descendants("buff-formula-strength");
         _buffFormulaStrength = new Array(_loc4_.length());
         _loc2_ = 0;
         while(_loc2_ < _buffFormulaStrength.length)
         {
            _buffFormulaStrength[_loc2_] = Number(_loc4_[_loc2_]);
            _loc2_++;
         }
         var _loc5_:XMLList = param1.descendants("buff-formula-armor");
         _buffFormulaArmor = new Array(_loc5_.length());
         _loc2_ = 0;
         while(_loc2_ < _buffFormulaArmor.length)
         {
            _buffFormulaArmor[_loc2_] = Number(_loc5_[_loc2_]);
            _loc2_++;
         }
         var _loc6_:XMLList = param1.descendants("buff-formula-health");
         _buffFormulaHealth = new Array(_loc6_.length());
         _loc2_ = 0;
         while(_loc2_ < _buffFormulaHealth.length)
         {
            _buffFormulaHealth[_loc2_] = Number(_loc6_[_loc2_]);
            _loc2_++;
         }
         _assetFlag = Number(param1.child("asset-flag"));
         _swarmValue = Number(param1.child("pv"));
         var _loc7_:XMLList = param1.descendants("attack");
         _attacks = new Array(_loc7_.length());
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length())
         {
            _loc8_ = int(_loc7_[_loc2_].@id);
            _loc9_ = new BattleLogicAttack(_loc8_);
            _loc9_.parseXMLData(_loc7_[_loc2_]);
            _attacks[_loc2_] = _loc9_;
            _loc2_++;
         }
         _attacks.push(createPassAttack());
      }
      
      public function setBattleCount() : void
      {
         _battleCount = 1;
      }
      
      public function get assetTypeCategory() : String
      {
         return _assetTypeCategory;
      }
      
      public function get hacks() : Array
      {
         return _hacks;
      }
      
      public function addHack(param1:BattleLogicAttackStatement, param2:Boolean) : void
      {
         if(param1.type == BattleLogicAttackStatement.TYPE_HACK)
         {
            if(param1.target == BattleLogicAttackStatement.TARGET_ENEMY_NANOVOR || param1.target == BattleLogicAttackStatement.TARGET_ENEMY_TEAM || param1.target == BattleLogicAttackStatement.TARGET_ALL_ACTIVE_NANOVOR || param1.target == BattleLogicAttackStatement.TARGET_ALL_SWARMS)
            {
               if(param2)
               {
                  _hacks.push(param1.clone());
                  param1.setCurrentDuration();
                  log("Hack added: " + _hacks[_hacks.length - 1]);
               }
            }
            else if(param1.target == BattleLogicAttackStatement.TARGET_MY_NANOVOR || param1.target == BattleLogicAttackStatement.TARGET_MY_TEAM || param1.target == BattleLogicAttackStatement.TARGET_ALL_ACTIVE_NANOVOR || param1.target == BattleLogicAttackStatement.TARGET_ALL_SWARMS)
            {
               if(!param2)
               {
                  _hacks.push(param1.clone());
                  param1.setCurrentDuration();
                  log("Hack added: " + _hacks[_hacks.length - 1]);
               }
            }
            while(_hacks.length > 5)
            {
               _hacks.pop();
            }
         }
      }
      
      private function setFaction(param1:String) : void
      {
         _faction = param1;
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function get naturalStrength() : int
      {
         return _strength;
      }
      
      public function setBuffFormulaHealth(param1:Array) : void
      {
         _buffFormulaHealth = param1;
      }
      
      public function setHitPointsTotal(param1:int) : void
      {
         _hitPointsTotal = param1;
      }
      
      public function setBlueSpike(param1:int) : void
      {
         _blueSpike = param1;
      }
      
      public function removeLastHack() : BattleLogicAttackStatement
      {
         if(_hacks.length > 0)
         {
            return _hacks.splice(_hacks.length - 1,1);
         }
         return null;
      }
      
      public function getKillCount() : int
      {
         return _killCount;
      }
      
      public function get naturalSpeed() : int
      {
         return _speed;
      }
      
      private function setDodgeFailPercent(param1:Number) : void
      {
         _dodgeFailPercent = param1;
      }
      
      public function isScreenStar() : Boolean
      {
         return _screenStar;
      }
      
      public function get rarity() : String
      {
         return _rarity;
      }
      
      public function getModdedStat(param1:String, param2:Boolean) : Number
      {
         if(param1 == Stat.HEALTH)
         {
            return _moddedHitPoints;
         }
         if(param1 == Stat.STRENGTH)
         {
            return _moddedStrength;
         }
         if(param1 == Stat.SPEED)
         {
            return _moddedSpeed;
         }
         if(param1 == Stat.ARMOR)
         {
            return _moddedArmor;
         }
         if(param1 == Stat.DODGE_FAIL_PERCENTAGE)
         {
            return _moddedDodgeFailPercent;
         }
         if(param1 == Stat.STUN_FAIL_PERCENTAGE)
         {
            return _moddedStunFailPercent;
         }
         if(param1 == Stat.RED_SPIKE)
         {
            return _moddedRedSpike;
         }
         if(param1 == Stat.BLUE_SPIKE)
         {
            return _moddedBlueSpike;
         }
         if(param1 == Stat.YELLOW_SPIKE)
         {
            return _moddedYellowSpike;
         }
         if(param1 == Stat.ENERGY_GENERATOR)
         {
            return _owner.moddedEnergyGenerator;
         }
         if(param1 == Stat.ENERGY)
         {
            return _owner.energyLevel;
         }
         return 0;
      }
      
      public function isSlacker() : Boolean
      {
         var _loc2_:BattleLogicAttack = null;
         var _loc1_:uint = 0;
         while(_loc1_ < _attacks.length)
         {
            _loc2_ = _attacks[_loc1_];
            if(!_loc2_.type == BattleLogicAttackStatement.TYPE_PASS && _loc2_.wasUsed())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function setBaseSpeed(param1:int) : void
      {
         _baseSpeed = param1;
      }
      
      private function setModdedStat(param1:String, param2:Boolean, param3:BattleLogicPlayer, param4:BattleLogicPlayer) : Number
      {
         var _loc7_:BattleLogicAttackStatement = null;
         var _loc8_:uint = 0;
         var _loc9_:BattleLogicAttackStatement = null;
         var _loc5_:Number = getStat(param1);
         if(_hacks != null)
         {
            _loc8_ = 0;
            while(_loc8_ < _hacks.length)
            {
               _loc9_ = _hacks[_loc8_];
               if(_loc9_.stat == param1)
               {
                  if(_loc9_.doesApplyThisRound(param2,param3,param4))
                  {
                     _loc5_ = AttackStatementFormula.performOperation(_loc5_,_loc9_.verb,_loc9_.calculateDamage());
                  }
               }
               _loc8_++;
            }
         }
         var _loc6_:Array = _owner.overrides;
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.stat == param1)
            {
               log("Checking if override applies to stat " + param1);
               if(_loc7_.doesApplyThisRound(param2,param3,param4))
               {
                  log("Override applies");
                  _loc5_ = AttackStatementFormula.performOperation(_loc5_,_loc7_.verb,_loc7_.calculateDamage());
                  log("new stat value: " + _loc5_);
               }
            }
         }
         return _loc5_;
      }
      
      public function setBaseStrength(param1:int) : void
      {
         _baseStrength = param1;
      }
      
      public function get maxStrength() : int
      {
         return _maxStrength;
      }
      
      public function get blueSpike() : int
      {
         return _blueSpike;
      }
      
      public function get buffFormulaHealth() : Array
      {
         return _buffFormulaHealth;
      }
      
      public function setSelectedAttack(param1:BattleLogicAttack) : void
      {
         _selectedAttack = param1 != null ? param1 : createPassAttack();
      }
      
      private function createPassAttack() : BattleLogicAttack
      {
         var _loc1_:int = 0;
         var _loc2_:BattleLogicAttackStatement = new BattleLogicAttackStatement(0,_loc1_);
         _loc2_.setName("Pass");
         _loc2_.setType(BattleLogicAttackStatement.TYPE_PASS);
         _loc2_.setTarget(BattleLogicAttackStatement.TARGET_MY_NANOVOR);
         var _loc3_:BattleLogicAttack = new BattleLogicAttack(_loc1_);
         _loc3_.setName("Pass");
         _loc3_.setDescription("");
         _loc3_.setCost(0);
         _loc3_.addAttackStatement(_loc2_);
         _loc3_.setType(BattleLogicAttackStatement.TYPE_PASS);
         return _loc3_;
      }
      
      public function incHexiteKillCount() : void
      {
         ++_hexiteKillCount;
      }
      
      public function incVelocitronKillCount() : void
      {
         ++_velocitronKillCount;
      }
      
      public function setMaxSpeed(param1:int) : void
      {
         _maxSpeed = param1;
      }
      
      public function get yellowSpike() : int
      {
         return _yellowSpike;
      }
      
      public function setProductionNumber(param1:int) : void
      {
         _productionNumber = param1;
      }
      
      public function get typeId() : Number
      {
         return _typeId;
      }
      
      public function get baseSpeed() : int
      {
         return _baseSpeed;
      }
      
      public function get redSpike() : int
      {
         return _redSpike;
      }
      
      public function setArmor(param1:int) : void
      {
         _armor = param1;
      }
      
      public function removeHack(param1:BattleLogicAttackStatement) : Boolean
      {
         return _hacks.splice(_hacks.indexOf(param1),1);
      }
      
      public function getMagnamodKillCount() : int
      {
         return _magnamodKillCount;
      }
   }
}

