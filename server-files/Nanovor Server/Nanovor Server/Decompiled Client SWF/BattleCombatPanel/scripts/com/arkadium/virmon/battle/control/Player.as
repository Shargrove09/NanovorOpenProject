package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class Player implements IPlayer
   {
      
      private var _swarmSize:int;
      
      private var _hasNewNanovor:Boolean;
      
      private var _attackPreviews:Array;
      
      private var _username:String;
      
      private var _quitGame:Boolean;
      
      private var _selectedNanovor:INanovor;
      
      private var _currentTarget:INanovor;
      
      private var _swarm:Array;
      
      private var _userRefId:int;
      
      private var _enemy:IPlayer;
      
      private var _declinedToWatch:Boolean;
      
      private var _roundPosition:int;
      
      private var _completedGame:Boolean;
      
      private var _lastNanovorDiedInRoundNum:int;
      
      private var _waiting:Boolean;
      
      private var _swapReason:int;
      
      private var _statIndex:int;
      
      private var _nextNanovor:INanovor;
      
      private var _currentPlayerState:int;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _isDead:Boolean;
      
      private var _animationIndex:int;
      
      private var _statHistory:Array;
      
      private var _baseAttackPreviews:Array = new Array();
      
      private var _leftGame:Boolean;
      
      public function Player(param1:String, param2:int, param3:INanovorFactory)
      {
         super();
         _nanovorFactory = param3;
         _username = param1;
         _userRefId = param2;
         _roundPosition = -1;
         _currentPlayerState = -1;
         _swarm = new Array();
         _selectedNanovor = null;
         _nextNanovor = null;
         _hasNewNanovor = false;
         _enemy = null;
         _currentTarget = null;
         _isDead = false;
         _quitGame = false;
         _declinedToWatch = false;
         _completedGame = false;
         _swarmSize = 0;
         _swapReason = 0;
         _animationIndex = -1;
         leftGame = false;
         waiting = false;
         lastNanovorDiedInRoundNum = -1;
         resetStatHistory();
      }
      
      public function get userRefId() : int
      {
         return _userRefId;
      }
      
      public function get redSpike() : int
      {
         return _statHistory[_statIndex].redSpike;
      }
      
      public function set userRefId(param1:int) : void
      {
         _userRefId = param1;
      }
      
      public function get previousRedSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].redSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedBlueSpike = param1;
      }
      
      public function set declinedToWatch(param1:Boolean) : void
      {
         _declinedToWatch = param1;
      }
      
      public function get hasNewNanovor() : Boolean
      {
         return _hasNewNanovor;
      }
      
      public function get attackPreviews() : Array
      {
         return _attackPreviews;
      }
      
      public function set attackPreviews(param1:Array) : void
      {
         _attackPreviews = param1;
      }
      
      public function setSwarm(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:INanovor = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = _nanovorFactory.createNanovorInstanceById(_loc2_);
            if(Boolean(_loc3_))
            {
               addNanovorToSwarm(_loc3_);
            }
         }
      }
      
      public function set hasNewNanovor(param1:Boolean) : void
      {
         _hasNewNanovor = param1;
      }
      
      public function addStatHistory() : void
      {
         var _loc2_:INanovor = null;
         var _loc1_:PlayerStats = _statHistory[_statIndex].clone();
         _statHistory.push(_loc1_);
         _statIndex = _statHistory.length - 1;
         for each(_loc2_ in _swarm)
         {
            _loc2_.addStatHistory();
         }
      }
      
      private function countLameArray(param1:Array) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function get previousModdedSwapPercentage() : Number
      {
         return _statHistory[getPreviousStatIndex()].moddedSwapPercentage;
      }
      
      public function set moddedEnergyGenerator(param1:int) : void
      {
         _statHistory[_statIndex].moddedEnergyGenerator = param1;
      }
      
      public function set energyGenerator(param1:int) : void
      {
         _statHistory[_statIndex].energyGenerator = param1;
      }
      
      public function get currentOverrideDescription() : String
      {
         return _statHistory[_statIndex].currentOverrideDescription;
      }
      
      public function get waiting() : Boolean
      {
         return _waiting;
      }
      
      public function get previousEnergyLevel() : int
      {
         return _statHistory[getPreviousStatIndex()].energyLevel;
      }
      
      public function get lastNanovorDiedInRoundNum() : int
      {
         return _lastNanovorDiedInRoundNum;
      }
      
      public function get currentTarget() : INanovor
      {
         return _currentTarget;
      }
      
      public function get previousModdedEnergyGenerator() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedEnergyGenerator;
      }
      
      public function set nextNanovor(param1:INanovor) : void
      {
         _nextNanovor = param1;
      }
      
      public function get previousYellowSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].yellowSpike;
      }
      
      public function set baseAttackPreviews(param1:Array) : void
      {
         _baseAttackPreviews = param1;
      }
      
      public function get selectedNanovor() : INanovor
      {
         return _selectedNanovor;
      }
      
      public function get previousCurrentOverrideArray() : Array
      {
         return _statHistory[getPreviousStatIndex()].currentOverrideArray;
      }
      
      public function get swapPercentage() : Number
      {
         return _statHistory[_statIndex].swapPercentage;
      }
      
      public function toString() : String
      {
         var _loc1_:String = _username;
         _loc1_ += _isDead ? " DEAD" : "";
         _loc1_ += " ID=" + _userRefId;
         _loc1_ += " ENG=" + moddedEnergyGenerator;
         _loc1_ += " SP=" + moddedSwapPercentage;
         if(Boolean(currentOverrideArray))
         {
            _loc1_ += " OR(s)=" + currentOverrideArray.toString();
         }
         else
         {
            _loc1_ += " OR=0";
         }
         if(attackPreviews != null)
         {
            _loc1_ += " attackPreviews length: " + countLameArray(attackPreviews).toString();
         }
         if(baseAttackPreviews != null)
         {
            _loc1_ += " baseAttackPreviews length: " + countLameArray(baseAttackPreviews).toString();
         }
         return _loc1_;
      }
      
      public function get previousBlueSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].blueSpike;
      }
      
      public function get leftGame() : Boolean
      {
         return _leftGame;
      }
      
      public function set waiting(param1:Boolean) : void
      {
         _waiting = param1;
      }
      
      public function get isDead() : Boolean
      {
         return _isDead;
      }
      
      public function get previousCurrentOverrideDescription() : String
      {
         return _statHistory[getPreviousStatIndex()].currentOverrideDescription;
      }
      
      public function get moddedSwapPercentage() : Number
      {
         return _statHistory[_statIndex].moddedSwapPercentage;
      }
      
      public function resetStatHistory(param1:Boolean = false) : void
      {
         var _loc2_:PlayerStats = null;
         var _loc3_:INanovor = null;
         if(_statHistory != null && _statHistory.length > 0)
         {
            log("resetStatHistory(): *** POPPING statHistory...");
            _loc2_ = _statHistory.pop();
         }
         else
         {
            _loc2_ = new PlayerStats();
         }
         _statHistory = new Array();
         _statHistory.push(_loc2_);
         _statIndex = 0;
         if(param1)
         {
            for each(_loc3_ in _swarm)
            {
               _loc3_.resetStatHistory();
            }
         }
      }
      
      public function set currentTarget(param1:INanovor) : void
      {
         _currentTarget = param1;
      }
      
      public function get completedGame() : Boolean
      {
         return _completedGame;
      }
      
      public function get quitGame() : Boolean
      {
         return _quitGame;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedYellowSpike = param1;
      }
      
      public function get roundPosition() : int
      {
         return _roundPosition;
      }
      
      public function set currentOverrideDescription(param1:String) : void
      {
         _statHistory[_statIndex].currentOverrideDescription = param1;
      }
      
      public function set lastNanovorDiedInRoundNum(param1:int) : void
      {
         _lastNanovorDiedInRoundNum = param1;
      }
      
      public function set swarm(param1:Array) : void
      {
         _swarm = param1;
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
      
      public function get statIndex() : int
      {
         return _statIndex;
      }
      
      public function get moddedRedSpike() : int
      {
         return _statHistory[_statIndex].moddedRedSpike;
      }
      
      public function get currentOverrideArray() : Array
      {
         return _statHistory[_statIndex].currentOverrideArray;
      }
      
      public function get currentPlayerState() : int
      {
         return _currentPlayerState;
      }
      
      public function get username() : String
      {
         return _username;
      }
      
      public function get declinedToWatch() : Boolean
      {
         return _declinedToWatch;
      }
      
      public function get moddedBlueSpike() : int
      {
         return _statHistory[_statIndex].moddedBlueSpike;
      }
      
      public function getPlayerStats(param1:int = -1) : IPlayerStats
      {
         if(param1 < 0)
         {
            return _statHistory[_statIndex];
         }
         if(param1 > _statHistory.length - 1)
         {
            return _statHistory[_statHistory.length - 1];
         }
         return _statHistory[param1];
      }
      
      public function set enemy(param1:IPlayer) : void
      {
         _enemy = param1;
      }
      
      public function get previousModdedBlueSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedBlueSpike;
      }
      
      public function set swapPercentage(param1:Number) : void
      {
         _statHistory[_statIndex].swapPercentage = param1;
      }
      
      public function get moddedEnergyGenerator() : int
      {
         return _statHistory[_statIndex].moddedEnergyGenerator;
      }
      
      public function get energyGenerator() : int
      {
         return _statHistory[_statIndex].energyGenerator;
      }
      
      public function get nextNanovor() : INanovor
      {
         return _nextNanovor;
      }
      
      public function get previousEnergyGenerator() : int
      {
         return _statHistory[getPreviousStatIndex()].energyGenerator;
      }
      
      public function set selectedNanovor(param1:INanovor) : void
      {
         _selectedNanovor = param1;
      }
      
      public function get previousModdedYellowSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedYellowSpike;
      }
      
      public function get baseAttackPreviews() : Array
      {
         return _baseAttackPreviews;
      }
      
      public function set swarmSize(param1:int) : void
      {
         _swarmSize = param1;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log("[Player] " + param1);
      }
      
      public function addNanovorToSwarm(param1:INanovor) : void
      {
         param1.owner = this;
         _swarm.push(param1);
         log("addNanovorToSwarm [" + this.username + "]: " + param1.toString());
      }
      
      public function set moddedSwapPercentage(param1:Number) : void
      {
         _statHistory[_statIndex].moddedSwapPercentage = param1;
      }
      
      public function get previousSwapPercentage() : Number
      {
         return _statHistory[getPreviousStatIndex()].swapPercentage;
      }
      
      public function set swapReason(param1:int) : void
      {
         _swapReason = param1;
      }
      
      public function get moddedYellowSpike() : int
      {
         return _statHistory[_statIndex].moddedYellowSpike;
      }
      
      public function set isDead(param1:Boolean) : void
      {
         _isDead = param1;
      }
      
      public function set statIndexUsed(param1:Boolean) : void
      {
         _statHistory[_statIndex].statIndexUsed = param1;
      }
      
      public function get swarm() : Array
      {
         return _swarm;
      }
      
      public function set leftGame(param1:Boolean) : void
      {
         _leftGame = param1;
      }
      
      public function set animationIndex(param1:int) : void
      {
         _animationIndex = param1;
      }
      
      public function get enemy() : IPlayer
      {
         return _enemy;
      }
      
      public function set blueSpike(param1:int) : void
      {
         _statHistory[_statIndex].blueSpike = param1;
      }
      
      public function get swarmSize() : int
      {
         return _swarmSize;
      }
      
      public function get statHistory() : Array
      {
         return _statHistory;
      }
      
      public function get previousModdedRedSpike() : int
      {
         return _statHistory[getPreviousStatIndex()].moddedRedSpike;
      }
      
      public function set roundPosition(param1:int) : void
      {
         _roundPosition = param1;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         _statHistory[_statIndex].moddedRedSpike = param1;
      }
      
      public function get swapReason() : int
      {
         return _swapReason;
      }
      
      public function set energyLevel(param1:int) : void
      {
         _statHistory[_statIndex].energyLevel = param1;
      }
      
      public function set completedGame(param1:Boolean) : void
      {
         _completedGame = param1;
      }
      
      public function get statIndexUsed() : Boolean
      {
         return _statHistory[_statIndex].statIndexUsed;
      }
      
      public function get animationIndex() : int
      {
         return _animationIndex;
      }
      
      public function set statIndex(param1:int) : void
      {
         var _loc2_:INanovor = null;
         _statIndex = param1;
         for each(_loc2_ in _swarm)
         {
            _loc2_.statIndex = _statIndex;
         }
      }
      
      public function makeAndAddNanovor(param1:String, param2:int) : INanovor
      {
         var _loc3_:INanovor = _nanovorFactory.createNanovorTypeById(param2);
         if(_loc3_ == null)
         {
            throw new Error("Nanovor typeID not found!");
         }
         _loc3_.assetId = param1;
         addNanovorToSwarm(_loc3_);
         log("makeAndAddNanovor() - Adding " + _loc3_.name + " to player: " + this.username);
         return _loc3_;
      }
      
      public function set quitGame(param1:Boolean) : void
      {
         _quitGame = param1;
      }
      
      public function get blueSpike() : int
      {
         return _statHistory[_statIndex].blueSpike;
      }
      
      public function findNanovor(param1:String, param2:int = 0, param3:Boolean = false) : INanovor
      {
         var _loc5_:INanovor = null;
         var _loc4_:INanovor = null;
         for each(_loc5_ in _swarm)
         {
            if(_loc5_.assetId == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         return _loc4_;
      }
      
      public function checkSwarmDead() : void
      {
         var _loc4_:INanovor = null;
         var _loc1_:String = "checkSwarmDead: _swarmSize=" + _swarmSize + " for player: " + username;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc4_ in _swarm)
         {
            _loc1_ += "\n                ... [" + _loc2_++ + "] " + _loc4_.name + " isDead=" + _loc4_.isDead;
            if(_loc4_.isDead)
            {
               _loc3_++;
            }
         }
         _isDead = _loc3_ >= _swarmSize;
         _loc1_ += "\n                === numDead=" + _loc3_ + "  ... _isDead=" + _isDead + "\n###########################################################";
         log(_loc1_);
      }
      
      public function get energyLevel() : int
      {
         return _statHistory[_statIndex].energyLevel;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         _statHistory[_statIndex].yellowSpike = param1;
      }
      
      public function set currentOverrideArray(param1:Array) : void
      {
         _statHistory[_statIndex].currentOverrideArray = param1;
      }
      
      public function set currentPlayerState(param1:int) : void
      {
         _currentPlayerState = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         _statHistory[_statIndex].redSpike = param1;
      }
      
      public function get yellowSpike() : int
      {
         return _statHistory[_statIndex].yellowSpike;
      }
   }
}

