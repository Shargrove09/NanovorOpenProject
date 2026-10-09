package com.arkadium.virmon.battle
{
   public class BattleData implements IBattleData
   {
      
      private var _combatTimeout:int;
      
      private var _playersInBattle:Array;
      
      private var _swarmSize:int;
      
      private var _battleType:String;
      
      private var _swarmChooserTimeout:int;
      
      public function BattleData(param1:int = 1000, param2:int = 90, param3:int = 60, param4:String = "FriendsBattle")
      {
         super();
         _swarmSize = param1;
         _swarmChooserTimeout = param2;
         _combatTimeout = param3;
         _battleType = param4;
         _playersInBattle = new Array();
      }
      
      public function get playersInBattle() : Array
      {
         return _playersInBattle.slice();
      }
      
      public function get combatTimeout() : int
      {
         return _combatTimeout;
      }
      
      public function get battleType() : String
      {
         return _battleType;
      }
      
      public function removePlayerByName(param1:String) : void
      {
         var _loc3_:BattlePlayer = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _playersInBattle.length)
         {
            _loc3_ = _playersInBattle[_loc2_] as BattlePlayer;
            if(_loc3_.playerName.toLowerCase() == param1.toLowerCase())
            {
               _playersInBattle.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function get swarmSize() : int
      {
         return _swarmSize;
      }
      
      public function toString() : String
      {
         var _loc3_:BattlePlayer = null;
         var _loc1_:String = "BattleData:\n" + "\tSwarmSize:\t" + _swarmSize.toString() + "\tBattleType:\t" + _battleType + "\tPlayers:\n";
         var _loc2_:uint = 0;
         while(_loc2_ < _playersInBattle.length)
         {
            _loc3_ = _playersInBattle[_loc2_] as BattlePlayer;
            _loc1_ += "\t\tPlayerName:\t" + _loc3_.playerName + "[" + _loc3_.playerId.toString() + "]";
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addPlayer(param1:String, param2:int) : BattlePlayer
      {
         var _loc3_:BattlePlayer = new BattlePlayer(param1,param2);
         _playersInBattle.push(_loc3_);
         return _loc3_;
      }
      
      public function removePlayerById(param1:int) : void
      {
         var _loc3_:BattlePlayer = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _playersInBattle.length)
         {
            _loc3_ = _playersInBattle[_loc2_] as BattlePlayer;
            if(_loc3_.playerId == param1)
            {
               _playersInBattle.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function get swarmChooserTimeout() : int
      {
         return _swarmChooserTimeout;
      }
   }
}

