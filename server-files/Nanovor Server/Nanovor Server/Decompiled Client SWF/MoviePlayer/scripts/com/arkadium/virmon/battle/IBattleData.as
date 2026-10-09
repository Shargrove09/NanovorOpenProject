package com.arkadium.virmon.battle
{
   public interface IBattleData
   {
      
      function addPlayer(param1:String, param2:int) : BattlePlayer;
      
      function get battleType() : String;
      
      function removePlayerById(param1:int) : void;
      
      function removePlayerByName(param1:String) : void;
      
      function get swarmSize() : int;
      
      function toString() : String;
      
      function get combatTimeout() : int;
      
      function get swarmChooserTimeout() : int;
      
      function get playersInBattle() : Array;
   }
}

