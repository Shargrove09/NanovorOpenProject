package com.arkadium.virmon.senseibattle.battlelogic.player
{
   import com.arkadium.virmon.senseibattle.battlelogic.GameMath;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicAttackStatement;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicNanovor;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleLogicPlayer
   {
      
      private var _energyLevel:int = 2;
      
      private var _hasNewNanovor:Boolean;
      
      private var _totalGameDamage:int;
      
      private var _moddedEnergyGenerator:int = 2;
      
      private var _secretMatchmakingScore:Number;
      
      private var _username:String;
      
      public var wasAliveAtBeginningOfRound:Boolean;
      
      private var _totalMagnamodKilled:int;
      
      public var speed:Number;
      
      private var _selectedNanovor:BattleLogicNanovor;
      
      private var _quitGame:Boolean;
      
      public var curvePercent:Number;
      
      private var _nextNanovor:BattleLogicNanovor;
      
      private var _totalVelocitronKilled:int;
      
      private var _userRefId:String;
      
      private var _position:int;
      
      private var _enemy:BattleLogicPlayer;
      
      public var speedCurved:Number;
      
      private var _moddedSwapPercentage:Number;
      
      private var _swarm:Array;
      
      private var _overrides:Array;
      
      public var initiativeRoll:Number;
      
      private var _maximumDamage:int;
      
      private var _swapPercentage:Number;
      
      private var _declinedToWatch:Boolean;
      
      private var _isDead:Boolean;
      
      private var _virmonMasterRatingBeltId:int;
      
      private var _nmp:int;
      
      private var _killCount:int;
      
      private var _completedGame:Boolean;
      
      private var _totalHexiteKilled:int;
      
      private var _numPlayers:int;
      
      private var _energyGenerator:int = 2;
      
      private var _token:String;
      
      public function BattleLogicPlayer(param1:String, param2:String, param3:String = null)
      {
         super();
         _username = param1;
         _userRefId = param2;
         _swarm = null;
         _selectedNanovor = null;
         _overrides = new Array();
         _token = param3;
         _swapPercentage = 1;
         _moddedSwapPercentage = 1;
         _hasNewNanovor = false;
         _secretMatchmakingScore = 0;
         _nmp = 0;
         _virmonMasterRatingBeltId = 0;
         _numPlayers = 2;
         _killCount = 0;
         _totalGameDamage = 0;
         _maximumDamage = 0;
         _position = 0;
         _totalMagnamodKilled = 0;
         _totalVelocitronKilled = 0;
         _totalHexiteKilled = 0;
         _isDead = false;
         _quitGame = false;
         _declinedToWatch = false;
      }
      
      public function addDamageToTotal(param1:int) : void
      {
         _totalGameDamage += param1;
      }
      
      public function get userRefId() : String
      {
         return _userRefId;
      }
      
      public function declinedToWatch() : Boolean
      {
         return _declinedToWatch;
      }
      
      public function incKillCount() : void
      {
         ++_killCount;
      }
      
      public function setSecretMatchmakingScore(param1:Number) : void
      {
         _secretMatchmakingScore = param1;
      }
      
      public function get secretMatchmakingScore() : Number
      {
         return _secretMatchmakingScore;
      }
      
      public function get hasNewNanovor() : Boolean
      {
         return _hasNewNanovor;
      }
      
      public function setEnergyLevel(param1:int) : void
      {
         _energyLevel = param1 < 0 ? 0 : param1;
      }
      
      public function get overrides() : Array
      {
         return _overrides;
      }
      
      public function get position() : int
      {
         return _position;
      }
      
      public function get moddedEnergyGenerator() : int
      {
         return _moddedEnergyGenerator;
      }
      
      public function get nextNanovor() : BattleLogicNanovor
      {
         return _nextNanovor;
      }
      
      public function setSwarm(param1:Array) : void
      {
         _swarm = param1;
      }
      
      public function isEnemySelected() : Boolean
      {
         return _enemy != null || _quitGame || _isDead ? true : false;
      }
      
      public function get energyGenerator() : int
      {
         return _energyGenerator;
      }
      
      public function setDeclinedToWatch(param1:Boolean) : void
      {
         _declinedToWatch = param1;
      }
      
      public function setEnemy(param1:BattleLogicPlayer) : void
      {
         _enemy = param1 == null ? this : param1;
      }
      
      public function setNumPlayers(param1:int) : void
      {
         _numPlayers = param1;
      }
      
      public function get killCount() : int
      {
         return _killCount;
      }
      
      public function get numPlayers() : int
      {
         return _numPlayers;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicNanovor>>\t" + param1);
      }
      
      public function setQuitGame(param1:Boolean) : void
      {
         _quitGame = param1;
      }
      
      public function get totalGameDamage() : int
      {
         return _totalGameDamage;
      }
      
      public function get totalHexiteKilled() : int
      {
         return _totalHexiteKilled;
      }
      
      public function toString() : String
      {
         return _username;
      }
      
      public function setMaximumDamage(param1:int) : void
      {
         _maximumDamage = _maximumDamage >= param1 ? _maximumDamage : param1;
      }
      
      public function setNextNanovor(param1:BattleLogicNanovor) : void
      {
         _nextNanovor = param1;
         if(_nextNanovor != null)
         {
            _nextNanovor.setSelectedAttack(null);
         }
      }
      
      public function get virmonMasterRatingBeltId() : int
      {
         return _virmonMasterRatingBeltId;
      }
      
      public function get totalVelocitronKilled() : int
      {
         return _totalVelocitronKilled;
      }
      
      public function removeOverride() : Array
      {
         return _overrides.splice(0,_overrides.length);
      }
      
      public function setEnergyGenerator(param1:int) : void
      {
         _energyGenerator = param1;
      }
      
      public function resetEnemy() : void
      {
         _enemy = null;
      }
      
      public function get overrideIdsString() : String
      {
         var _loc3_:BattleLogicAttackStatement = null;
         var _loc1_:String = "";
         var _loc2_:Boolean = true;
         for each(_loc3_ in overrides)
         {
            if(!_loc2_)
            {
               _loc1_ += ",";
            }
            _loc1_ += _loc3_.attackStatementId;
            _loc2_ = false;
         }
         return _loc1_;
      }
      
      public function get swarm() : Array
      {
         return _swarm;
      }
      
      public function canSwap() : Boolean
      {
         var _loc1_:Number = GameMath.getRandomNumber();
         if(_loc1_ < _moddedSwapPercentage)
         {
            return true;
         }
         return false;
      }
      
      public function incMagnamodKillCount() : void
      {
         ++_totalMagnamodKilled;
      }
      
      public function get selectedNanovor() : BattleLogicNanovor
      {
         return _selectedNanovor;
      }
      
      public function get enemy() : BattleLogicPlayer
      {
         return _enemy;
      }
      
      public function get swapPercentage() : Number
      {
         return _swapPercentage;
      }
      
      public function get nmp() : int
      {
         return _nmp;
      }
      
      public function setCompletedGame(param1:Boolean) : void
      {
         _completedGame = param1;
      }
      
      public function addOverride(param1:BattleLogicAttackStatement, param2:Boolean) : void
      {
         _overrides.push(param1.clone());
      }
      
      public function resetModdedStats(param1:Boolean, param2:BattleLogicPlayer, param3:BattleLogicPlayer) : void
      {
         var _loc5_:BattleLogicAttackStatement = null;
         var _loc6_:BattleLogicAttackStatement = null;
         var _loc4_:Array = overrides;
         _moddedEnergyGenerator = _energyGenerator;
         if(_selectedNanovor != null && _selectedNanovor.hacks != null)
         {
            for each(_loc5_ in _selectedNanovor.hacks)
            {
               _loc5_.currentAttacker = param2;
               _loc5_.currentEnemy = param3;
               if(_loc5_.stat == Stat.ENERGY_GENERATOR)
               {
                  if(_loc5_.doesApplyThisRound(false,param2,param3))
                  {
                     _moddedEnergyGenerator += _loc5_.calculateDamage();
                  }
               }
            }
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.stat == Stat.ENERGY_GENERATOR)
            {
               if(_loc6_.doesApplyThisRound(false,param2,param3))
               {
                  _moddedEnergyGenerator += _loc6_.calculateDamage();
               }
            }
         }
         if(_energyGenerator != _moddedEnergyGenerator)
         {
            username + " energy generator base: " + _energyGenerator + " modded: " + _moddedEnergyGenerator;
         }
         _moddedSwapPercentage = _swapPercentage;
         if(_selectedNanovor != null && _selectedNanovor.hacks != null)
         {
            for each(_loc5_ in _selectedNanovor.hacks)
            {
               _loc5_.currentAttacker = param2;
               _loc5_.currentEnemy = param3;
               if(_loc5_.stat == Stat.SWAP_PERCENTAGE)
               {
                  if(_loc5_.doesApplyThisRound(false,param2,param3))
                  {
                     _moddedSwapPercentage = _loc5_.calculateDamage();
                  }
               }
            }
         }
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.stat == Stat.SWAP_PERCENTAGE)
            {
               if(_loc6_.doesApplyThisRound(false,param2,param3))
               {
                  _moddedSwapPercentage = _loc6_.calculateDamage();
               }
            }
         }
         if(_swapPercentage != _moddedSwapPercentage)
         {
         }
         if(_selectedNanovor != null)
         {
            _selectedNanovor.resetModdedStats(param1,param2,param3);
         }
      }
      
      public function hasQuitGame() : Boolean
      {
         return _quitGame;
      }
      
      public function get moddedSwapPercentage() : Number
      {
         return _moddedSwapPercentage;
      }
      
      public function get maximumDamage() : int
      {
         return _maximumDamage;
      }
      
      public function setPosition(param1:int) : void
      {
         this._position = param1;
      }
      
      public function incHexiteKillCount() : void
      {
         ++_totalHexiteKilled;
      }
      
      public function isDead() : Boolean
      {
         var _loc1_:BattleLogicNanovor = null;
         if(_swarm != null)
         {
            _isDead = true;
            for each(_loc1_ in _swarm)
            {
               if(_loc1_.hitPoints > 0)
               {
                  _isDead = false;
                  break;
               }
            }
         }
         return _isDead;
      }
      
      public function setToken(param1:String) : void
      {
         _token = param1;
      }
      
      public function setUserRefId(param1:String) : void
      {
         this._userRefId = param1;
      }
      
      public function setSelectedNanovor(param1:BattleLogicNanovor) : Boolean
      {
         _selectedNanovor = param1;
         if(_selectedNanovor != null)
         {
            _selectedNanovor.setSelectedAttack(null);
            _selectedNanovor.setOwner(this);
            return true;
         }
         return false;
      }
      
      public function setNMP(param1:int) : void
      {
         _nmp = param1;
      }
      
      public function get username() : String
      {
         return _username;
      }
      
      public function get energyLevel() : int
      {
         return _energyLevel;
      }
      
      public function setHasNewNanovor(param1:Boolean) : void
      {
         _hasNewNanovor = param1;
      }
      
      public function completedGame() : Boolean
      {
         return _completedGame;
      }
      
      public function incVelocitronKillCount() : void
      {
         ++_totalVelocitronKilled;
      }
      
      public function get token() : String
      {
         return _token;
      }
      
      public function setVirmonMasterRatingBeltId(param1:int) : void
      {
         _virmonMasterRatingBeltId = param1;
      }
      
      public function get totalMagnamodKilled() : int
      {
         return _totalMagnamodKilled;
      }
   }
}

