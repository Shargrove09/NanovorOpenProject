package com.arkadium.virmon.battle.control
{
   public class PlayerStats implements IPlayerStats
   {
      
      private static const ENERGY_GENERATOR:int = 2;
      
      private static const SWAP_PERCENTAGE:Number = 1;
      
      private var _energyGenerator:int = 2;
      
      private var _moddedSwapPercentage:Number = 1;
      
      private var _energyLevel:int = 2;
      
      private var _swapPercentage:Number = 1;
      
      private var _moddedEnergyGenerator:int = 2;
      
      private var _statIndexUsed:Boolean = false;
      
      private var _yellowSpike:int = 0;
      
      private var _moddedBlueSpike:int = 0;
      
      private var _blueSpike:int = 0;
      
      private var _currentOverrideArray:Array = new Array();
      
      private var _redSpike:int = 0;
      
      private var _moddedYellowSpike:int = 0;
      
      private var _moddedRedSpike:int = 0;
      
      private var _currentOverrideDescription:String;
      
      public function PlayerStats()
      {
         super();
      }
      
      public function get moddedYellowSpike() : int
      {
         return this._moddedYellowSpike;
      }
      
      public function get currentOverrideArray() : Array
      {
         return this._currentOverrideArray;
      }
      
      public function set yellowSpike(param1:int) : void
      {
         this._yellowSpike = param1;
      }
      
      public function get yellowSpike() : int
      {
         return this._yellowSpike;
      }
      
      public function get moddedBlueSpike() : int
      {
         return this._moddedBlueSpike;
      }
      
      public function get moddedRedSpike() : int
      {
         return this._moddedRedSpike;
      }
      
      public function get blueSpike() : int
      {
         return this._blueSpike;
      }
      
      public function set moddedBlueSpike(param1:int) : void
      {
         this._moddedBlueSpike = param1;
      }
      
      public function get swapPercentage() : Number
      {
         return this._swapPercentage;
      }
      
      public function set blueSpike(param1:int) : void
      {
         this._blueSpike = param1;
      }
      
      public function set swapPercentage(param1:Number) : void
      {
         this._swapPercentage = param1;
      }
      
      public function get energyGenerator() : int
      {
         return this._energyGenerator;
      }
      
      public function set currentOverrideDescription(param1:String) : void
      {
         this._currentOverrideDescription = param1;
      }
      
      public function get moddedEnergyGenerator() : int
      {
         return this._moddedEnergyGenerator;
      }
      
      public function set energyLevel(param1:int) : void
      {
         this._energyLevel = param1;
      }
      
      public function get statIndexUsed() : Boolean
      {
         return this._statIndexUsed;
      }
      
      public function get moddedSwapPercentage() : Number
      {
         return this._moddedSwapPercentage;
      }
      
      public function set moddedRedSpike(param1:int) : void
      {
         this._moddedRedSpike = param1;
      }
      
      public function set moddedEnergyGenerator(param1:int) : void
      {
         this._moddedEnergyGenerator = param1;
      }
      
      public function get currentOverrideDescription() : String
      {
         return this._currentOverrideDescription;
      }
      
      public function get energyLevel() : int
      {
         return this._energyLevel;
      }
      
      public function set moddedYellowSpike(param1:int) : void
      {
         this._moddedYellowSpike = param1;
      }
      
      public function set currentOverrideArray(param1:Array) : void
      {
         this._currentOverrideArray = param1;
      }
      
      public function set moddedSwapPercentage(param1:Number) : void
      {
         this._moddedSwapPercentage = param1;
      }
      
      public function set energyGenerator(param1:int) : void
      {
         this._energyGenerator = param1;
      }
      
      public function set redSpike(param1:int) : void
      {
         this._redSpike = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[PlayerStat]";
         _loc1_ += " energyLevel: " + this.energyLevel;
         return _loc1_ + (" currentOverrideArray length: " + this.currentOverrideArray.length);
      }
      
      public function get redSpike() : int
      {
         return this._redSpike;
      }
      
      public function set statIndexUsed(param1:Boolean) : void
      {
         this._statIndexUsed = param1;
      }
      
      public function clone() : IPlayerStats
      {
         var _loc2_:IAttackStatement = null;
         var _loc1_:IPlayerStats = new PlayerStats();
         _loc1_.energyLevel = this.energyLevel;
         _loc1_.energyGenerator = this.energyGenerator;
         _loc1_.moddedEnergyGenerator = this.moddedEnergyGenerator;
         _loc1_.swapPercentage = this.swapPercentage;
         _loc1_.moddedSwapPercentage = this.moddedSwapPercentage;
         for each(_loc2_ in this._currentOverrideArray)
         {
            _loc1_.currentOverrideArray.push(AttackStatement.copy(_loc2_));
         }
         _loc1_.redSpike = this.redSpike;
         _loc1_.blueSpike = this.blueSpike;
         _loc1_.yellowSpike = this.yellowSpike;
         _loc1_.moddedRedSpike = this.moddedRedSpike;
         _loc1_.moddedBlueSpike = this.moddedBlueSpike;
         _loc1_.moddedYellowSpike = this.moddedYellowSpike;
         return _loc1_;
      }
   }
}

