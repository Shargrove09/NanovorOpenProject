package com.smithandtinker.nanovor.common.utils
{
   public class Cipher
   {
      
      private static const _KEY:String = "eDVFnLy1Tw8ArcUGtHMbuyi45uzfNR6G0fKqCRxjegznjxVcRIQ4ahg9BOU55i2R";
      
      private static const _BASE_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      
      public function Cipher()
      {
         super();
      }
      
      public static function decode(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:String = "";
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += String.fromCharCode(_fromBaseCharsChunk(param1.substr(_loc3_,4)));
            _loc3_ += 4;
         }
         var _loc4_:String = _KEY;
         while(_loc4_.length < param1.length)
         {
            _loc4_ += _KEY;
         }
         var _loc5_:String = "";
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc6_ = _loc2_.charCodeAt(_loc3_) ^ _loc4_.charCodeAt(_loc3_);
            _loc5_ += String.fromCharCode(_loc6_);
            _loc3_++;
         }
         return _loc5_;
      }
      
      public static function encode(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc2_:String = _KEY;
         while(_loc2_.length < param1.length)
         {
            _loc2_ += _KEY;
         }
         var _loc3_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = param1.charCodeAt(_loc5_) ^ _loc2_.charCodeAt(_loc5_);
            _loc3_ += _toBaseCharsChunk(_loc4_);
            _loc5_++;
         }
         return _loc3_;
      }
      
      private static function _fromBaseCharsChunk(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Array = _BASE_CHARS.split("");
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc2_ += _loc3_.indexOf(param1.charAt(_loc4_));
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function _toBaseCharsChunk(param1:int) : String
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(param1 < _BASE_CHARS.length)
            {
               _loc2_.push(_BASE_CHARS.charAt(param1));
               param1 -= param1;
            }
            else
            {
               _loc2_.push(_BASE_CHARS.charAt(_BASE_CHARS.length - 1));
               param1 -= _BASE_CHARS.length - 1;
            }
            _loc3_++;
         }
         return _loc2_.join("");
      }
   }
}

