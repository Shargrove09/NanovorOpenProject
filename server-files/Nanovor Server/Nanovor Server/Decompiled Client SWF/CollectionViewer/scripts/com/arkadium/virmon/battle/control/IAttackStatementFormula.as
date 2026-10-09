package com.arkadium.virmon.battle.control
{
   public interface IAttackStatementFormula
   {
      
      function getFormula() : String;
      
      function getVariables() : Array;
      
      function solve(param1:IAttackStatement, param2:INanovor = null, param3:INanovor = null) : Number;
   }
}

