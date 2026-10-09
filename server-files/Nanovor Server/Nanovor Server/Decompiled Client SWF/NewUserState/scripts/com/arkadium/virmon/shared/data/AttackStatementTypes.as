package com.arkadium.virmon.shared.data
{
   public class AttackStatementTypes
   {
      
      public static const TYPE_DAMAGE:String = "Attack";
      
      public static const TYPE_MOD:String = "Mod";
      
      public static const TYPE_HACK:String = "Hack";
      
      public static const TYPE_OVERRIDE:String = "Override";
      
      public static const TYPE_PASS:String = "Pass";
      
      public static const TARGET_MY_NANOVOR:String = "My active Virmon";
      
      public static const TARGET_ENEMY_NANOVOR:String = "Enemy active Virmon";
      
      public static const TARGET_MY_TEAM:String = "My team";
      
      public static const TARGET_ENEMY_TEAM:String = "Enemy team";
      
      public static const TARGET_ALL_ACTIVE_NANOVOR:String = "All active Virmon";
      
      public static const TARGET_ALL_SWARMS:String = "All teams";
      
      public static const VERB_SUBTRACT:String = "-";
      
      public static const VERB_ADD:String = "+";
      
      public static const VERB_MULTIPLY:String = "*";
      
      public static const VERB_DIVIDE:String = "/";
      
      public static const VERB_SET:String = "=";
      
      public static const VERB_REMOVE:String = "Remove";
      
      public static const VERB_LOCK:String = "Lock";
      
      public static const DURATION_NONE:String = "None";
      
      public static const DURATION_END_OF_ROUND:String = "Until end of this round";
      
      public static const DURATION_PERMANENT:String = "Permanent";
      
      public static const DURATION_1_ACTIVE_ROUND:String = "1 active round";
      
      public static const DURATION_2_ACTIVE_ROUNDS:String = "2 active rounds";
      
      public static const DURATION_3_ACTIVE_ROUNDS:String = "3 active rounds";
      
      public static const DURATION_4_ACTIVE_ROUNDS:String = "4 active rounds";
      
      public static const DURATION_5_ACTIVE_ROUNDS:String = "5 active rounds";
      
      public static const DURATION_6_ACTIVE_ROUNDS:String = "6 active rounds";
      
      public static const DURATION_7_ACTIVE_ROUNDS:String = "7 active rounds";
      
      public static const DURATION_8_ACTIVE_ROUNDS:String = "8 active rounds";
      
      public static const DURATION_9_ACTIVE_ROUNDS:String = "9 active rounds";
      
      public static const DURATION_10_ACTIVE_ROUNDS:String = "10 active rounds";
      
      public static const CLIENT_DESCRIPTION_FIELD:String = "statementClientDescription";
      
      public function AttackStatementTypes()
      {
         super();
         throw new Error("ENUM CLASS -- JUST USE STATIC PROPERTIES");
      }
   }
}

