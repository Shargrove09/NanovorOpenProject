package com.arkadium.virmon.battle.control
{
   public class AttackActionTypes
   {
      
      public static const NONE:int = 0;
      
      public static const PASS:int = 1;
      
      public static const DEAD:int = 2;
      
      public static const STUNNED:int = 3;
      
      public static const LOW_ENERGY:int = 4;
      
      public static const TARGET_IS_DEAD:int = 5;
      
      public static const NO_ACTIVE_VIRMON:int = 6;
      
      public static const INVALID_ACTION_ID:int = 7;
      
      public static const DODGED:int = 8;
      
      public static const SWAP:int = 0;
      
      public static const BLOCK_SWAP:int = 1;
      
      public static const NO_SWAP:int = 2;
      
      public static const NO_ENERGY:int = 3;
      
      public static const FIZZLE:int = 4;
      
      public static const ADD_OVERRIDE:int = 11;
      
      public static const REMOVE_OVERRIDE:int = 12;
      
      public static const ADD_HACK:int = 13;
      
      public static const REMOVE_HACK:int = 14;
      
      public static const REMOVE_ALL_HACKS:int = 15;
      
      public static const REMOVE_LAST_HACK:int = 16;
      
      public static const SET_ENERGY_LEVEL:int = 17;
      
      public static const MOD_ENERGY_LEVEL:int = 19;
      
      public static const FIZZLE_REASONS:Array = [FIZZLE,TARGET_IS_DEAD,NO_ACTIVE_VIRMON,INVALID_ACTION_ID];
      
      public function AttackActionTypes()
      {
         super();
      }
   }
}

