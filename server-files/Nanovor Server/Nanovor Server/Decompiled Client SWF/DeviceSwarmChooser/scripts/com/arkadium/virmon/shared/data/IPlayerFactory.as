package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.battle.control.IPlayer;
   
   public interface IPlayerFactory
   {
      
      function createMyPlayer() : IPlayer;
      
      function createPlayer(param1:String, param2:int) : IPlayer;
   }
}

