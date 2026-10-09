package com.arkadium.virmon.battle
{
   public class BattlePlayer implements IBattlePlayer
   {
      
      private var _playerName:String;
      
      private var _playerId:int;
      
      public function BattlePlayer(param1:String, param2:int)
      {
         super();
         _playerName = param1;
         _playerId = param2;
      }
      
      public function get playerName() : String
      {
         return _playerName;
      }
      
      public function get playerId() : int
      {
         return _playerId;
      }
   }
}

