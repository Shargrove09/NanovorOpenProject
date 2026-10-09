package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   
   public interface ICombatGamePanelConsumer
   {
      
      function handleGameOver(param1:BattleSubStateGameOverData) : void;
   }
}

