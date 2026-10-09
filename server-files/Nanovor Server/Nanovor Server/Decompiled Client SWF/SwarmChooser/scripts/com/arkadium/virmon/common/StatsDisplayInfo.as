package com.arkadium.virmon.common
{
   public class StatsDisplayInfo
   {
      
      public static const SWARMVALUE:String = "swarmvalue";
      
      public static const SPEED:String = "speed";
      
      public static const ARMOR:String = "armor";
      
      public static const STRENGTH:String = "strength";
      
      public static const HEALTH:String = "health";
      
      public static const SWARMVALUE_LABEL:String = "SV";
      
      public static const SPEED_LABEL:String = "SPD";
      
      public static const ARMOR_LABEL:String = "ARM";
      
      public static const STRENGTH_LABEL:String = "STR";
      
      public static const HEALTH_LABEL:String = "HLTH";
      
      public static const SWARMVALUE_COLOR:uint = 13500415;
      
      public static const SPEED_COLOR:uint = 1371906;
      
      public static const ARMOR_COLOR:uint = 10092798;
      
      public static const STRENGTH_COLOR:uint = 13412898;
      
      public static const HEALTH_COLOR:uint = 13382451;
      
      public function StatsDisplayInfo()
      {
         super();
         throw new Error("StatsDisplayInfo is an enum class and should not be instantiated");
      }
   }
}

