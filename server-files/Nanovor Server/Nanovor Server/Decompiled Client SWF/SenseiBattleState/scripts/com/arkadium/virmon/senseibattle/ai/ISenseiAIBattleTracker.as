package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.senseibattle.IRound;
   
   public interface ISenseiAIBattleTracker
   {
      
      function init(param1:IPlayer, param2:IPlayer) : void;
      
      function processRound(param1:IRound) : void;
   }
}

