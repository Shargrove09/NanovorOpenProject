package com.arkadium.virmon.senseibattle
{
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   
   public interface ISenseiBattleServerImitator
   {
      
      function receiveAttackInfo(param1:ICombatTurnData) : void;
      
      function receiveSwarm(param1:Array) : void;
      
      function receiveEndRound() : void;
   }
}

