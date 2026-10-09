package com.arkadium.virmon.battle.substates.gameover
{
   import com.arkadium.virmon.battle.control.IPlayer;
   
   public class GameOverInfo
   {
      
      private var _playerInfos:Array = new Array();
      
      private var _isWinner:Boolean = false;
      
      private var _players:Array;
      
      private var _placementIndex:Array = new Array();
      
      public function GameOverInfo(param1:Array, param2:Boolean, param3:Array)
      {
         super();
         _players = param1;
         _isWinner = param2;
         parseResultsArray(param3);
      }
      
      public function get isWinner() : Boolean
      {
         return _isWinner;
      }
      
      public function getPlacementByIndex(param1:int) : int
      {
         return _playerInfos[param1].placement;
      }
      
      public function getUserNMPDiffByIndex(param1:int) : int
      {
         return _playerInfos[param1].nmpDiff;
      }
      
      public function getPlacementIndexes() : Array
      {
         return _placementIndex;
      }
      
      private function getPlayerIndexById(param1:int) : int
      {
         var _loc2_:IPlayer = null;
         var _loc3_:int = 0;
         while(_loc3_ < _players.length)
         {
            _loc2_ = _players[_loc3_];
            if(_loc2_.userRefId == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function get length() : int
      {
         return _players.length;
      }
      
      private function parseResultsArray(param1:Array) : void
      {
         var _loc3_:PlayerGameOverInfo = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < _players.length)
         {
            _loc3_ = new PlayerGameOverInfo();
            for each(_loc4_ in param1)
            {
               if(int(_players[_loc2_].userRefId) == int(_loc4_.userRefId))
               {
                  _loc3_.placement = int(_loc4_.position);
                  _loc3_.totalDamage = int(_loc4_.totalDamage);
                  _loc3_.totalKills = int(_loc4_.totalNanovorKilled);
                  _loc3_.userId = int(_loc4_.userRefId);
                  _loc3_.nmpDiff = int(_loc4_.nmpDiff);
               }
            }
            _playerInfos.push(_loc3_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _players.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _playerInfos.length)
            {
               if(_loc2_ + 1 == _playerInfos[_loc5_].placement)
               {
                  _placementIndex.push(_loc5_);
                  break;
               }
               _loc5_++;
            }
            _loc2_++;
         }
      }
      
      public function getKillsByIndex(param1:int) : int
      {
         return _playerInfos[param1].totalKills;
      }
      
      public function getDamageByIndex(param1:int) : int
      {
         return _playerInfos[param1].totalDamage;
      }
      
      private function sortPlayerInfos() : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(_players.length);
         var _loc5_:int = int(_playerInfos.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_players[_loc2_].userRefId == _playerInfos[_loc4_].userId)
               {
                  _loc1_.push(_playerInfos);
                  break;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         _playerInfos = _loc1_;
      }
      
      public function getUserIdByIndex(param1:int) : int
      {
         return _playerInfos[param1].userId;
      }
   }
}

