package com.arkadium.virmon.evogame
{
   public interface IEvoGameStateData
   {
      
      function get targetMasterVirmonId() : int;
      
      function get sourceVirmonId() : String;
      
      function get evolutionId() : int;
      
      function get activeTreeId() : int;
   }
}

