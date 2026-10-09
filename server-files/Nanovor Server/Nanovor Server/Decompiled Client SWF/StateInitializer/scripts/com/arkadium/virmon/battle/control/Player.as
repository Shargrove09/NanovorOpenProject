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
         this._nanovorFactory = param3;
         this._username = param1;
         this._userRefId = param2;
         this._roundPosition = -1;
         this._currentPlayerState = -1;
         this._swarm = new Array();
         this._selectedNanovor = null;
         this._nextNanovor = null;
         this._hasNewNanovor = false;
         this._enemy = null;
         this._currentTarget = null;
         this._isDead = false;
         this._quitGame = false;
         this._declinedToWatch = false;
         this._completedGame = false;
         this._swarmSize = 0;
         this._swapReason = 0;
         this._animationIndex = -1;
         this.leftGame = false;
         this.waiting = false;
         this.lastNanovorDiedInRoundNum = -1;
         this.resetStatHistory();
      }
      
      public function get userRefId() : int
      {
         return this._userRefId;
      }
      
      public function get redSpike() : int
      {
         return this._statHistory[this._statIndex].redSpike;
      }
      
      public function set userRefId(param1:int) : void
      {
         this._userRefId = param1;
      }
      
      public function get previousRedSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].redSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedBlueSpike = param1;
      }
      
      public function set declinedToWatch(param1:Boolean) : void
      {
         this._declinedToWatch = param1;
      }
      
      public function get hasNewNanovor() : Boolean
      {
         return this._hasNewNanovor;
      }
      
      public function get attackPreviews() : Array
      {
         return this._attackPreviews;
      }
      
      public function set attackPreviews(param1:Array) : void
      {
         this._attackPreviews = param1;
      }
      
      public function setSwarm(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:INanovor = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this._nanovorFactory.createNanovorInstanceById(_loc2_);
            if(Boolean(_loc3_))
            {
               this.addNanovorToSwarm(_loc3_);
            }
         }
      }
      
      public function set hasNewNanovor(param1:Boolean) : void
      {
         this._hasNewNanovor = param1;
      }
      
      public function addStatHistory() : void
      {
         var _loc2_:INanovor = null;
         var _loc1_:PlayerStats = this._statHistory[this._statIndex].clone();
         this._statHistory.push(_loc1_);
         this._statIndex = this._statHistory.length - 1;
         for each(_loc2_ in this._swarm)
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
         return this._statHistory[this.getPreviousStatIndex()].moddedSwapPercentage;
      }
      
      public function set moddedEnergyGenerator(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedEnergyGenerator = param1;
      }
      
      public function set energyGenerator(param1:int) : void
      {
         this._statHistory[this._statIndex].energyGenerator = param1;
      }
      
      public function get currentOverrideDescription() : String
      {
         return this._statHistory[this._statIndex].currentOverrideDescription;
      }
      
      public function get waiting() : Boolean
      {
         return this._waiting;
      }
      
      public function get previousEnergyLevel() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].energyLevel;
      }
      
      public function get lastNanovorDiedInRoundNum() : int
      {
         return this._lastNanovorDiedInRoundNum;
      }
      
      public function get currentTarget() : INanovor
      {
         return this._currentTarget;
      }
      
      public function get previousModdedEnergyGenerator() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedEnergyGenerator;
      }
      
      public function set nextNanovor(param1:INanovor) : void
      {
         this._nextNanovor = param1;
      }
      
      public function get previousYellowSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].yellowSpike;
      }
      
      public function set baseAttackPreviews(param1:Array) : void
      {
         this._baseAttackPreviews = param1;
      }
      
      public function get selectedNanovor() : INanovor
      {
         return this._selectedNanovor;
      }
      
      public function get previousCurrentOverrideArray() : Array
      {
         return this._statHistory[this.getPreviousStatIndex()].currentOverrideArray;
      }
      
      public function get swapPercentage() : Number
      {
         return this._statHistory[this._statIndex].swapPercentage;
      }
      
      public function toString() : String
      {
         var _loc1_:String = this._username;
         _loc1_ += this._isDead ? " DEAD" : "";
         _loc1_ += " ID=" + this._userRefId;
         _loc1_ += " ENG=" + this.moddedEnergyGenerator;
         _loc1_ += " SP=" + this.moddedSwapPercentage;
         if(Boolean(this.currentOverrideArray))
         {
            _loc1_ += " OR(s)=" + this.currentOverrideArray.toString();
         }
         else
         {
            _loc1_ += " OR=0";
         }
         if(this.attackPreviews != null)
         {
            _loc1_ += " attackPreviews length: " + this.countLameArray(this.attackPreviews).toString();
         }
         if(this.baseAttackPreviews != null)
         {
            _loc1_ += " baseAttackPreviews length: " + this.countLameArray(this.baseAttackPreviews).toString();
         }
         return _loc1_;
      }
      
      public function get previousBlueSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].blueSpike;
      }
      
      public function get leftGame() : Boolean
      {
         return this._leftGame;
      }
      
      public function set waiting(param1:Boolean) : void
      {
         this._waiting = param1;
      }
      
      public function get isDead() : Boolean
      {
         return this._isDead;
      }
      
      public function get previousCurrentOverrideDescription() : String
      {
         return this._statHistory[this.getPreviousStatIndex()].currentOverrideDescription;
      }
      
      public function get moddedSwapPercentage() : Number
      {
         return this._statHistory[this._statIndex].moddedSwapPercentage;
      }
      
      public function resetStatHistory(param1:Boolean = false) : void
      {
         var _loc2_:PlayerStats = null;
         var _loc3_:INanovor = null;
         if(this._statHistory != null && this._statHistory.length > 0)
         {
            this.log("resetStatHistory(): *** POPPING statHistory...");
            _loc2_ = this._statHistory.pop();
         }
         else
         {
            _loc2_ = new PlayerStats();
         }
         this._statHistory = new Array();
         this._statHistory.push(_loc2_);
         this._statIndex = 0;
         if(param1)
         {
            for each(_loc3_ in this._swarm)
            {
               _loc3_.resetStatHistory();
            }
         }
      }
      
      public function set currentTarget(param1:INanovor) : void
      {
         this._currentTarget = param1;
      }
      
      public function get completedGame() : Boolean
      {
         return this._completedGame;
      }
      
      public function get quitGame() : Boolean
      {
         return this._quitGame;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedYellowSpike = param1;
      }
      
      public function get roundPosition() : int
      {
         return this._roundPosition;
      }
      
      public function set currentOverrideDescription(param1:String) : void
      {
         this._statHistory[this._statIndex].currentOverrideDescription = param1;
      }
      
      public function set lastNanovorDiedInRoundNum(param1:int) : void
      {
         this._lastNanovorDiedInRoundNum = param1;
      }
      
      public function set swarm(param1:Array) : void
      {
         this._swarm = param1;
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
      
      public function get statIndex() : int
      {
         return this._statIndex;
      }
      
      public function get moddedRedSpike() : int
      {
         return this._statHistory[this._statIndex].moddedRedSpike;
      }
      
      public function get currentOverrideArray() : Array
      {
         return this._statHistory[this._statIndex].currentOverrideArray;
      }
      
      public function get currentPlayerState() : int
      {
         return this._currentPlayerState;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function get declinedToWatch() : Boolean
      {
         return this._declinedToWatch;
      }
      
      public function get moddedBlueSpike() : int
      {
         return this._statHistory[this._statIndex].moddedBlueSpike;
      }
      
      public function getPlayerStats(param1:int = -1) : IPlayerStats
      {
         if(param1 < 0)
         {
            return this._statHistory[this._statIndex];
         }
         if(param1 > this._statHistory.length - 1)
         {
            return this._statHistory[this._statHistory.length - 1];
         }
         return this._statHistory[param1];
      }
      
      public function set enemy(param1:IPlayer) : void
      {
         this._enemy = param1;
      }
      
      public function get previousModdedBlueSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedBlueSpike;
      }
      
      public function set swapPercentage(param1:Number) : void
      {
         this._statHistory[this._statIndex].swapPercentage = param1;
      }
      
      public function get moddedEnergyGenerator() : int
      {
         return this._statHistory[this._statIndex].moddedEnergyGenerator;
      }
      
      public function get energyGenerator() : int
      {
         return this._statHistory[this._statIndex].energyGenerator;
      }
      
      public function get nextNanovor() : INanovor
      {
         return this._nextNanovor;
      }
      
      public function get previousEnergyGenerator() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].energyGenerator;
      }
      
      public function set selectedNanovor(param1:INanovor) : void
      {
         this._selectedNanovor = param1;
      }
      
      public function get previousModdedYellowSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedYellowSpike;
      }
      
      public function get baseAttackPreviews() : Array
      {
         return this._baseAttackPreviews;
      }
      
      public function set swarmSize(param1:int) : void
      {
         this._swarmSize = param1;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log("[Player] " + param1);
      }
      
      public function addNanovorToSwarm(param1:INanovor) : void
      {
         param1.owner = this;
         this._swarm.push(param1);
         this.log("addNanovorToSwarm [" + this.username + "]: " + param1.toString());
      }
      
      public function set moddedSwapPercentage(param1:Number) : void
      {
         this._statHistory[this._statIndex].moddedSwapPercentage = param1;
      }
      
      public function get previousSwapPercentage() : Number
      {
         return this._statHistory[this.getPreviousStatIndex()].swapPercentage;
      }
      
      public function set swapReason(param1:int) : void
      {
         this._swapReason = param1;
      }
      
      public function get moddedYellowSpike() : int
      {
         return this._statHistory[this._statIndex].moddedYellowSpike;
      }
      
      public function set isDead(param1:Boolean) : void
      {
         this._isDead = param1;
      }
      
      public function set statIndexUsed(param1:Boolean) : void
      {
         this._statHistory[this._statIndex].statIndexUsed = param1;
      }
      
      public function get swarm() : Array
      {
         return this._swarm;
      }
      
      public function set leftGame(param1:Boolean) : void
      {
         this._leftGame = param1;
      }
      
      public function set animationIndex(param1:int) : void
      {
         this._animationIndex = param1;
      }
      
      public function get enemy() : IPlayer
      {
         return this._enemy;
      }
      
      public function set blueSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].blueSpike = param1;
      }
      
      public function get swarmSize() : int
      {
         return this._swarmSize;
      }
      
      public function get statHistory() : Array
      {
         return this._statHistory;
      }
      
      public function get previousModdedRedSpike() : int
      {
         return this._statHistory[this.getPreviousStatIndex()].moddedRedSpike;
      }
      
      public function set roundPosition(param1:int) : void
      {
         this._roundPosition = param1;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].moddedRedSpike = param1;
      }
      
      public function get swapReason() : int
      {
         return this._swapReason;
      }
      
      public function set energyLevel(param1:int) : void
      {
         this._statHistory[this._statIndex].energyLevel = param1;
      }
      
      public function set completedGame(param1:Boolean) : void
      {
         this._completedGame = param1;
      }
      
      public function get statIndexUsed() : Boolean
      {
         return this._statHistory[this._statIndex].statIndexUsed;
      }
      
      public function get animationIndex() : int
      {
         return this._animationIndex;
      }
      
      public function set statIndex(param1:int) : void
      {
         var _loc2_:INanovor = null;
         this._statIndex = param1;
         for each(_loc2_ in this._swarm)
         {
            _loc2_.statIndex = this._statIndex;
         }
      }
      
      public function makeAndAddNanovor(param1:String, param2:int) : INanovor
      {
         var _loc3_:INanovor = this._nanovorFactory.createNanovorTypeById(param2);
         if(_loc3_ == null)
         {
            throw new Error("Nanovor typeID not found!");
         }
         _loc3_.assetId = param1;
         this.addNanovorToSwarm(_loc3_);
         this.log("makeAndAddNanovor() - Adding " + _loc3_.name + " to player: " + this.username);
         return _loc3_;
      }
      
      public function set quitGame(param1:Boolean) : void
      {
         this._quitGame = param1;
      }
      
      public function get blueSpike() : int
      {
         return this._statHistory[this._statIndex].blueSpike;
      }
      
      public function findNanovor(param1:String, param2:int = 0, param3:Boolean = false) : INanovor
      {
         var _loc5_:INanovor = null;
         var _loc4_:INanovor = null;
         for each(_loc5_ in this._swarm)
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
         var _loc1_:String = "checkSwarmDead: _swarmSize=" + this._swarmSize + " for player: " + this.username;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc4_ in this._swarm)
         {
            _loc1_ += "\n                ... [" + _loc2_++ + "] " + _loc4_.name + " isDead=" + _loc4_.isDead;
            if(_loc4_.isDead)
            {
               _loc3_++;
            }
         }
         this._isDead = _loc3_ >= this._swarmSize;
         _loc1_ += "\n                === numDead=" + _loc3_ + "  ... _isDead=" + this._isDead + "\n###########################################################";
         this.log(_loc1_);
      }
      
      public function get energyLevel() : int
      {
         return this._statHistory[this._statIndex].energyLevel;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].yellowSpike = param1;
      }
      
      public function set currentOverrideArray(param1:Array) : void
      {
         this._statHistory[this._statIndex].currentOverrideArray = param1;
      }
      
      public function set currentPlayerState(param1:int) : void
      {
         this._currentPlayerState = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         this._statHistory[this._statIndex].redSpike = param1;
      }
      
      public function get yellowSpike() : int
      {
         return this._statHistory[this._statIndex].yellowSpike;
      }
   }
}

