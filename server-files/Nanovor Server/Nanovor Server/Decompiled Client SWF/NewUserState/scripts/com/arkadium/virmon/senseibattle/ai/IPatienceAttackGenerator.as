package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface IPatienceAttackGenerator
   {
      
      function selectPatienceAttack(param1:Array, param2:INanovor, param3:ISenseiNanovor, param4:Number) : Object;
   }
}

