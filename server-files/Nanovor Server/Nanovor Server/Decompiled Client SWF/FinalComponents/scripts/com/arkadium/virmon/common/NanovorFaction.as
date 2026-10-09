package com.arkadium.virmon.common
{
   public class NanovorFaction
   {
      
      public static const HEXITE:String = "Hexite";
      
      public static const VELOCITRON:String = "Velocitron";
      
      public static const MAGNAMOD:String = "Magnamod";
      
      public function NanovorFaction()
      {
         super();
         throw new Error("NanovorFaction is an enum class and should not be instantiated");
      }
   }
}

