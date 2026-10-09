package com.arkadium.virmon.evotree
{
   import com.arkadium.virmon.evotree.evolver.IEvoTreeEvolver;
   import com.arkadium.virmon.framework.EvoData;
   
   public interface IEvoTreeEvolverFactory
   {
      
      function createEvoTreeEvolver(param1:String, param2:EvoData) : IEvoTreeEvolver;
   }
}

