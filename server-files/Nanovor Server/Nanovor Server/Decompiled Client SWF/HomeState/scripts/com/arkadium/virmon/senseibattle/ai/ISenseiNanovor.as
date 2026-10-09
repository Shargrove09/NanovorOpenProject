package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface ISenseiNanovor extends INanovor
   {
      
      function get overallExpectedDamage() : Number;
      
      function calculateOverallExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void;
      
      function calculateRemainingExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void;
   }
}

