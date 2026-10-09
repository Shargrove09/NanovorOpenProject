package com.arkadium.virmon.battle.control
{
   public interface IPlayerStats
   {
      
      function get moddedYellowSpike() : int;
      
      function get moddedBlueSpike() : int;
      
      function get blueSpike() : int;
      
      function get swapPercentage() : Number;
      
      function set moddedEnergyGenerator(param1:int) : void;
      
      function get moddedRedSpike() : int;
      
      function get currentOverrideDescription() : String;
      
      function set blueSpike(param1:int) : void;
      
      function set swapPercentage(param1:Number) : void;
      
      function get energyLevel() : int;
      
      function set energyGenerator(param1:int) : void;
      
      function set moddedYellowSpike(param1:int) : void;
      
      function set moddedSwapPercentage(param1:Number) : void;
      
      function set yellowSpike(param1:int) : void;
      
      function set moddedBlueSpike(param1:int) : void;
      
      function set currentOverrideArray(param1:Array) : void;
      
      function get moddedEnergyGenerator() : int;
      
      function get energyGenerator() : int;
      
      function toString() : String;
      
      function get moddedSwapPercentage() : Number;
      
      function set redSpike(param1:int) : void;
      
      function get yellowSpike() : int;
      
      function set moddedRedSpike(param1:int) : void;
      
      function get currentOverrideArray() : Array;
      
      function get redSpike() : int;
      
      function set statIndexUsed(param1:Boolean) : void;
      
      function set energyLevel(param1:int) : void;
      
      function get statIndexUsed() : Boolean;
      
      function set currentOverrideDescription(param1:String) : void;
      
      function clone() : IPlayerStats;
   }
}

