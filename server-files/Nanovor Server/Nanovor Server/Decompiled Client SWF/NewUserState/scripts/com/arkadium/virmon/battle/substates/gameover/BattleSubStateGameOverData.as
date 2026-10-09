package com.arkadium.virmon.battle.substates.gameover
{
   import com.arkadium.virmon.battle.control.IPlayer;
   
   public class BattleSubStateGameOverData
   {
      
      private var _myNMP:int;
      
      private var _gameOverInfo:GameOverInfo;
      
      private var _myPlayer:IPlayer;
      
      private var _spotlights:Array;
      
      public function BattleSubStateGameOverData(param1:Array, param2:GameOverInfo, param3:IPlayer, param4:int = 0)
      {
         super();
         _spotlights = param1;
         _gameOverInfo = param2;
         _myPlayer = param3;
         _myNMP = param4;
      }
      
      public function get myNMP() : int
      {
         return _myNMP;
      }
      
      public function get myPlayer() : IPlayer
      {
         return _myPlayer;
      }
      
      public function get gameOverInfo() : GameOverInfo
      {
         return _gameOverInfo;
      }
      
      public function get spotlights() : Array
      {
         return _spotlights;
      }
   }
}

