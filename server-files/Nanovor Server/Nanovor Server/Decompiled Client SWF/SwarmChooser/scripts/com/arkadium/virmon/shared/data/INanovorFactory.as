package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.IVirmonData;
   
   public interface INanovorFactory
   {
      
      function createNanovorInstanceById(param1:String) : INanovor;
      
      function findNanovorInstanceById(param1:String) : IVirmonData;
      
      function createNanovorTypeById(param1:int) : INanovor;
      
      function get baseResultNanovor() : INanovor;
   }
}

