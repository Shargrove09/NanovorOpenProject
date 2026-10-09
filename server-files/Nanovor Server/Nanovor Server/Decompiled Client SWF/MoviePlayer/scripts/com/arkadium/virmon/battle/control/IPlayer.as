package com.arkadium.virmon.battle.control
{
   public interface IPlayer
   {
      
      function set currentTarget(param1:INanovor) : void;
      
      function get userRefId() : int;
      
      function toString() : String;
      
      function get declinedToWatch() : Boolean;
      
      function getPlayerStats(param1:int = -1) : IPlayerStats;
      
      function set animationIndex(param1:int) : void;
      
      function get selectedNanovor() : INanovor;
      
      function get previousCurrentOverrideArray() : Array;
      
      function get previousRedSpike() : int;
      
      function get swapPercentage() : Number;
      
      function get enemy() : IPlayer;
      
      function set enemy(param1:IPlayer) : void;
      
      function get moddedBlueSpike() : int;
      
      function set declinedToWatch(param1:Boolean) : void;
      
      function get previousModdedBlueSpike() : int;
      
      function get previousBlueSpike() : int;
      
      function set moddedBlueSpike(param1:int) : void;
      
      function set baseAttackPreviews(param1:Array) : void;
      
      function set blueSpike(param1:int) : void;
      
      function get swarmSize() : int;
      
      function set swapPercentage(param1:Number) : void;
      
      function set selectedNanovor(param1:INanovor) : void;
      
      function get lastNanovorDiedInRoundNum() : int;
      
      function set userRefId(param1:int) : void;
      
      function get hasNewNanovor() : Boolean;
      
      function get statHistory() : Array;
      
      function set waiting(param1:Boolean) : void;
      
      function get attackPreviews() : Array;
      
      function set attackPreviews(param1:Array) : void;
      
      function get leftGame() : Boolean;
      
      function get moddedEnergyGenerator() : int;
      
      function get energyGenerator() : int;
      
      function findNanovor(param1:String, param2:int = 0, param3:Boolean = false) : INanovor;
      
      function makeAndAddNanovor(param1:String, param2:int) : INanovor;
      
      function set currentOverrideDescription(param1:String) : void;
      
      function get nextNanovor() : INanovor;
      
      function set moddedRedSpike(param1:int) : void;
      
      function get previousModdedRedSpike() : int;
      
      function get previousCurrentOverrideDescription() : String;
      
      function setSwarm(param1:Array) : void;
      
      function get swapReason() : int;
      
      function set energyLevel(param1:int) : void;
      
      function set swarmSize(param1:int) : void;
      
      function get previousModdedYellowSpike() : int;
      
      function get statIndexUsed() : Boolean;
      
      function set statIndex(param1:int) : void;
      
      function get moddedSwapPercentage() : Number;
      
      function set hasNewNanovor(param1:Boolean) : void;
      
      function addStatHistory() : void;
      
      function set completedGame(param1:Boolean) : void;
      
      function set quitGame(param1:Boolean) : void;
      
      function get previousEnergyGenerator() : int;
      
      function get baseAttackPreviews() : Array;
      
      function get previousModdedSwapPercentage() : Number;
      
      function get isDead() : Boolean;
      
      function set leftGame(param1:Boolean) : void;
      
      function log(param1:String) : void;
      
      function get blueSpike() : int;
      
      function get waiting() : Boolean;
      
      function set roundPosition(param1:int) : void;
      
      function resetStatHistory(param1:Boolean = false) : void;
      
      function checkSwarmDead() : void;
      
      function get username() : String;
      
      function get currentOverrideDescription() : String;
      
      function addNanovorToSwarm(param1:INanovor) : void;
      
      function set moddedEnergyGenerator(param1:int) : void;
      
      function get energyLevel() : int;
      
      function get moddedRedSpike() : int;
      
      function get roundPosition() : int;
      
      function set lastNanovorDiedInRoundNum(param1:int) : void;
      
      function get quitGame() : Boolean;
      
      function set moddedYellowSpike(param1:int) : void;
      
      function set moddedSwapPercentage(param1:Number) : void;
      
      function set yellowSpike(param1:int) : void;
      
      function set energyGenerator(param1:int) : void;
      
      function get animationIndex() : int;
      
      function set currentOverrideArray(param1:Array) : void;
      
      function set redSpike(param1:int) : void;
      
      function get previousSwapPercentage() : Number;
      
      function get previousEnergyLevel() : int;
      
      function get statIndex() : int;
      
      function set currentPlayerState(param1:int) : void;
      
      function set swarm(param1:Array) : void;
      
      function get moddedYellowSpike() : int;
      
      function get yellowSpike() : int;
      
      function get previousModdedEnergyGenerator() : int;
      
      function get currentOverrideArray() : Array;
      
      function get redSpike() : int;
      
      function set statIndexUsed(param1:Boolean) : void;
      
      function get currentPlayerState() : int;
      
      function get swarm() : Array;
      
      function get currentTarget() : INanovor;
      
      function get previousYellowSpike() : int;
      
      function set nextNanovor(param1:INanovor) : void;
      
      function set swapReason(param1:int) : void;
      
      function set isDead(param1:Boolean) : void;
      
      function get completedGame() : Boolean;
   }
}

