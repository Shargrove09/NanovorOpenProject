package com.arkadium.virmon.battle.control
{
   public interface IAttackStatementFactory
   {
      
      function clone(param1:IAttackStatement) : IAttackStatement;
      
      function createAttackStatementById(param1:int) : IAttackStatement;
   }
}

