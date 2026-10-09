package com.arkadium.virmon.battle.control
{
   public class NanovorStats
   {
      
      private static const BASE_DODGE_FAIL_PERCENT:Number = 1;
      
      private static const BASE_STUN_FAIL_PERCENT:Number = 1;
      
      public var strength:int = 0;
      
      public var speed:int = 0;
      
      public var moddedBlueSpike:int = 0;
      
      public var blueSpike:int = 0;
      
      public var moddedDodgeFailPercent:int = 1;
      
      public var moddedRedSpike:int = 0;
      
      public var health:int = 0;
      
      public var moddedStunFailPercent:int = 1;
      
      public var stunFailPercent:Number = 1;
      
      public var dodgeFailPercent:Number = 1;
      
      public var moddedYellowSpike:int = 0;
      
      public var yellowSpike:int = 0;
      
      public var redSpike:int = 0;
      
      public var hacks:Array = new Array();
      
      public var armor:int = 0;
      
      public function NanovorStats()
      {
         super();
      }
      
      public function clone() : NanovorStats
      {
         var _loc1_:NanovorStats = new NanovorStats();
         _loc1_.armor = this.armor;
         _loc1_.speed = this.speed;
         _loc1_.strength = this.strength;
         _loc1_.health = this.health;
         _loc1_.dodgeFailPercent = this.dodgeFailPercent;
         _loc1_.stunFailPercent = this.stunFailPercent;
         _loc1_.redSpike = this.redSpike;
         _loc1_.blueSpike = this.blueSpike;
         _loc1_.yellowSpike = this.yellowSpike;
         _loc1_.moddedDodgeFailPercent = this.moddedDodgeFailPercent;
         _loc1_.moddedStunFailPercent = this.moddedStunFailPercent;
         _loc1_.moddedRedSpike = this.moddedRedSpike;
         _loc1_.moddedBlueSpike = this.moddedBlueSpike;
         _loc1_.moddedYellowSpike = this.moddedYellowSpike;
         _loc1_.hacks = this.hacks.slice();
         return _loc1_;
      }
   }
}

