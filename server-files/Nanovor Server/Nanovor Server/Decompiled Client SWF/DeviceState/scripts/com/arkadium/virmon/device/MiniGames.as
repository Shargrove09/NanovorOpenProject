package com.arkadium.virmon.device
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class MiniGames
   {
      
      public static const JOLT_STRENGTH:* = 0;
      
      public static const JOLT_SPEED:* = 1;
      
      public static const JOLT_ARMOR:* = 2;
      
      public static const JOLT_HEALTH:* = 3;
      
      public static const JOLT_ALL:* = 4;
      
      private static var _oInstance:MiniGames = null;
      
      private var aGameList:Array = new Array();
      
      private const GAME_COUNT:* = 4;
      
      public function MiniGames()
      {
         super();
      }
      
      public static function getName(param1:ByteArray) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:ByteArray = new ByteArray();
         param1.position = 48;
         param1.readBytes(_loc3_,0,66);
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc3_.position = 0;
            if(_loc3_[_loc5_] != 0)
            {
               _loc2_[_loc4_] = _loc3_[_loc5_];
               _loc4_++;
            }
            _loc5_++;
         }
         return _loc2_.readMultiByte(_loc2_.length,"us-ascii");
      }
      
      public static function getDescription(param1:ByteArray) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:ByteArray = new ByteArray();
         param1.position = 114;
         param1.readBytes(_loc3_,0,130);
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc3_.position = 0;
            if(_loc3_[_loc5_] != 0)
            {
               _loc2_[_loc4_] = _loc3_[_loc5_];
               _loc4_++;
            }
            _loc5_++;
         }
         _loc2_.position = 0;
         return _loc2_.readMultiByte(_loc2_.length,"us-ascii");
      }
      
      public static function getInstance() : MiniGames
      {
         if(_oInstance == null)
         {
            _oInstance = new MiniGames();
         }
         return _oInstance;
      }
      
      public static function getJolts(param1:ByteArray) : int
      {
         var _loc2_:ByteArray = new ByteArray();
         param1.position = 1268;
         _loc2_ = new ByteArray();
         param1.readBytes(_loc2_,0,2);
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         return _loc2_.readShort();
      }
      
      public static function getJoltType(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case JOLT_ARMOR:
               _loc2_ = "Armor";
               break;
            case JOLT_HEALTH:
               _loc2_ = "Health";
               break;
            case JOLT_SPEED:
               _loc2_ = "Speed";
               break;
            case JOLT_STRENGTH:
               _loc2_ = "Strength";
               break;
            case JOLT_ALL:
               _loc2_ = "All";
         }
         return _loc2_;
      }
   }
}

