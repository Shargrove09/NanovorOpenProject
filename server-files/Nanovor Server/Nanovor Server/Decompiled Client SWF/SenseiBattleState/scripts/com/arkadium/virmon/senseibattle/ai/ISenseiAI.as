package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.senseibattle.IRound;
   
   public interface ISenseiAI
   {
      
      function getCombatTurnData() : ICombatTurnData;
      
      function getPlayerId() : int;
      
      function setPlayerSwarmSize(param1:int) : void;
      
      function getPlayerName() : String;
      
      function setRound(param1:IRound) : void;
      
      function getSelectedNanovors() : Array;
   }
}

