package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.IPlayer;
   
   public interface ISenseiAIFactory
   {
      
      function createAI(param1:IPlayer, param2:ISenseiAIBattleTracker, param3:ISenseiAIMoveGenerator, param4:String = "") : ISenseiAI;
      
      function createAIById(param1:IPlayer, param2:ISenseiAIBattleTracker, param3:ISenseiAIMoveGenerator, param4:int = -100) : ISenseiAI;
   }
}

