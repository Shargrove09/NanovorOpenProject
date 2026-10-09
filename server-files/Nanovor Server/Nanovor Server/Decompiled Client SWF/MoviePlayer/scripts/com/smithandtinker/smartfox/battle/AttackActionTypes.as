package com.smithandtinker.smartfox.battle
{
   public class AttackActionTypes
   {
      
      public static const NONE:String = "0";
      
      public static const PASS:String = "1";
      
      public static const DEAD:String = "2";
      
      public static const STUNNED:String = "3";
      
      public static const LOW_ENERGY:String = "4";
      
      public static const TARGET_IS_DEAD:String = "5";
      
      public static const NO_ACTIVE_VIRMON:String = "6";
      
      public static const INVALID_ACTION_ID:String = "7";
      
      public static const DODGED:String = "8";
      
      public static const FIZZLE:String = "10";
      
      public static const ADD_OVERRIDE:String = "11";
      
      public static const REMOVE_OVERRIDE:String = "12";
      
      public static const ADD_HACK:String = "13";
      
      public static const REMOVE_HACK:String = "14";
      
      public static const REMOVE_ALL_HACKS:String = "15";
      
      public static const REMOVE_LAST_HACK:String = "16";
      
      public static const SET_ENERGY_LEVEL:String = "17";
      
      public static const MOD_ENERGY_LEVEL:String = "19";
      
      public static const SWAP:* = "0";
      
      public static const BLOCK_SWAP:* = "1";
      
      public static const NO_SWAP:* = "2";
      
      public static const NO_ENERGY:* = "3";
      
      public function AttackActionTypes()
      {
         super();
      }
      
      public function attackActionTypes() : *
      {
      }
   }
}

