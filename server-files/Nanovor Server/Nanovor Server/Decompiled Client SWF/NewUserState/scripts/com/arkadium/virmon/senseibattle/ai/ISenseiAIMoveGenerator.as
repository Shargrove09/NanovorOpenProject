package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   
   public interface ISenseiAIMoveGenerator
   {
      
      function getCombatTurnData() : ICombatTurnData;
      
      function selectActiveNanovor(param1:ISenseiNanovor) : void;
      
      function updateEnemySwarm(param1:ISenseiNanovor = null) : void;
      
      function setSenseiSwarm(param1:Array, param2:String) : void;
      
      function setRemoteNanovor(param1:ISenseiNanovor = null) : void;
   }
}

