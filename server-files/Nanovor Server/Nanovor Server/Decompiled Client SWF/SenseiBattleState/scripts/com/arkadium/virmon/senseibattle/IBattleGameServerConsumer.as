package com.arkadium.virmon.senseibattle
{
   public interface IBattleGameServerConsumer
   {
      
      function swarmSelected(param1:String, param2:uint, param3:String, param4:int) : void;
      
      function readyForTurn() : void;
      
      function gameOver(param1:int, param2:Object) : void;
      
      function performAttack(param1:Object) : void;
      
      function setRoundInfo(param1:Object) : void;
      
      function roundCompleted(param1:Object) : void;
   }
}

