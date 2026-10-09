package com.arkadium.virmon.senseibattle.battlelogic
{
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.senseibattle.Round;
   
   public interface IBattleLogic
   {
      
      function getRound(param1:BattlePlayer) : Round;
      
      function getGameOver() : Object;
      
      function receiveSwarm(param1:BattlePlayer, param2:Array) : void;
      
      function receiveCombatTurnData(param1:BattlePlayer, param2:ICombatTurnData) : void;
   }
}

