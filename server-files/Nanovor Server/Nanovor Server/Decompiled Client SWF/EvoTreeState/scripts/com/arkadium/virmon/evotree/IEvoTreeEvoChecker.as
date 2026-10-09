package com.arkadium.virmon.evotree
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface IEvoTreeEvoChecker
   {
      
      function setConsumer(param1:IEvoTreeEvoCheckerConsumer) : void;
      
      function canEvolve(param1:INanovor) : void;
   }
}

