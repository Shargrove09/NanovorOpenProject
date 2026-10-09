package com.arkadium.virmon.senseibattle.battlelogic
{
   public class GameMath
   {
      
      public function GameMath()
      {
         super();
      }
      
      public static function getRandomNumber() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         return getRandomFromRange(_loc1_,_loc2_);
      }
      
      public static function Max(param1:Number, param2:Number) : Number
      {
         return param1 >= param2 ? param1 : param2;
      }
      
      public static function rollPercent() : int
      {
         return GameMath.RandRange(1,101);
      }
      
      public static function RandRangeFloat(param1:int, param2:int) : Number
      {
         return param1 + GameMath.RandomNumber() * (param2 - param1);
      }
      
      public static function RandomNumber() : Number
      {
         return Math.random();
      }
      
      public static function checkNegativeNumbers(param1:Number) : Number
      {
         if(param1 < 0)
         {
            return 0;
         }
         return param1;
      }
      
      public static function Round(param1:Number, param2:int) : Number
      {
         var _loc3_:Number = Math.pow(10,param2);
         var _loc4_:Number = param1;
         _loc4_ *= _loc3_;
         _loc4_ = Math.round(_loc4_);
         return _loc4_ / _loc3_;
      }
      
      public static function Min(param1:Number, param2:Number) : Number
      {
         return param1 <= param2 ? param1 : param2;
      }
      
      public static function DegToRad(param1:Number) : Number
      {
         return param1 / 180 * Math.PI;
      }
      
      public static function RadToDeg(param1:Number) : Number
      {
         return param1 * 180 / Math.PI;
      }
      
      public static function RandRange(param1:int, param2:int) : int
      {
         return int(param1 + Math.floor(GameMath.RandomNumber() * (param2 - param1)));
      }
      
      public static function getRandomFromRange(param1:int, param2:int) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
   }
}

