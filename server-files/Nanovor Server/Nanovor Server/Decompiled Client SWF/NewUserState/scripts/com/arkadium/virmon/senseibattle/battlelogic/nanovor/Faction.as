package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   public class Faction
   {
      
      public static var ROCK:String = "magnamod";
      
      public static var PAPER:String = "hexite";
      
      public static var SCISSORS:String = "velocitron";
      
      public static var MAGNAMOD:String = "magnamod";
      
      public static var HEXITE:String = "hexite";
      
      public static var VELOCITRON:String = "velocitron";
      
      public static var NONE:String = "";
      
      public static var MAGNAMOD_PLURAL:String = "magnamods";
      
      public static var HEXITE_PLURAL:String = "hexites";
      
      public static var VELOCITRON_PLURAL:String = "velocitrons";
      
      public static var MAGNAMOD_SINGULAR:String = "magnamod";
      
      public static var HEXITE_SINGULAR:String = "hexite";
      
      public static var VELOCITRON_SINGULAR:String = "velocitron";
      
      public function Faction()
      {
         super();
      }
      
      public static function getFactionPlural(param1:String) : String
      {
         if(param1 == Faction.MAGNAMOD)
         {
            return Faction.MAGNAMOD_PLURAL;
         }
         if(param1 == Faction.HEXITE)
         {
            return Faction.HEXITE_PLURAL;
         }
         if(param1 == Faction.VELOCITRON)
         {
            return Faction.VELOCITRON_PLURAL;
         }
         return "";
      }
      
      public static function setFaction(param1:int) : String
      {
         if(param1 == 0)
         {
            return Faction.MAGNAMOD;
         }
         if(param1 == 1)
         {
            return Faction.VELOCITRON;
         }
         if(param1 == 2)
         {
            return Faction.HEXITE;
         }
         return Faction.NONE;
      }
      
      public static function getFactionSingular(param1:String) : String
      {
         if(param1 == Faction.MAGNAMOD)
         {
            return Faction.MAGNAMOD_SINGULAR;
         }
         if(param1 == Faction.HEXITE)
         {
            return Faction.HEXITE_SINGULAR;
         }
         if(param1 == Faction.VELOCITRON)
         {
            return Faction.VELOCITRON_SINGULAR;
         }
         return "";
      }
      
      public static function calculateFactionBonus(param1:BattleLogicNanovor, param2:BattleLogicNanovor) : Number
      {
         if(param1.faction == Faction.MAGNAMOD)
         {
            if(param2.faction == Faction.HEXITE)
            {
               return 0.9;
            }
            if(param2.faction == Faction.VELOCITRON)
            {
               return 1.1;
            }
         }
         else if(param1.faction == Faction.HEXITE)
         {
            if(param2.faction == Faction.VELOCITRON)
            {
               return 0.9;
            }
            if(param2.faction == Faction.MAGNAMOD)
            {
               return 1.1;
            }
         }
         else if(param1.faction == Faction.VELOCITRON)
         {
            if(param2.faction == Faction.MAGNAMOD)
            {
               return 0.9;
            }
            if(param2.faction == Faction.HEXITE)
            {
               return 1.1;
            }
         }
         return 1;
      }
   }
}

