package com.arkadium.virmon.device
{
   public class GameData
   {
      
      private var _joltType:String;
      
      private var _gameDescription:String;
      
      private var _gameName:String;
      
      private var _gameFileName:String;
      
      public function GameData(param1:String, param2:String, param3:String, param4:String = null)
      {
         super();
         _gameName = param1;
         _joltType = param2;
         _gameDescription = param3;
         _gameFileName = param4;
      }
      
      public function get joltType() : String
      {
         return _joltType;
      }
      
      public function get gameDescription() : String
      {
         return _gameDescription;
      }
      
      public function get gameFileName() : String
      {
         return _gameFileName;
      }
      
      public function get gameName() : String
      {
         return _gameName;
      }
   }
}

