package com.smithandtinker.nanovor.common.utils
{
   import mx.utils.Base64Decoder;
   import mx.utils.Base64Encoder;
   
   public class FastCipher
   {
      
      public static const KEY:String = "fVBHOulunx9B4kimjhRQ9UEfooDINTyzpn3SJ7FSzmwCodeTWI1";
      
      public function FastCipher()
      {
         super();
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:Base64Decoder = new Base64Decoder();
         _loc2_.decode(param1);
         return FastCipher.xor(_loc2_.flush().toString());
      }
      
      private static function xor(param1:String) : String
      {
         var _loc2_:String = KEY;
         var _loc3_:String = new String();
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc4_ > _loc2_.length - 1)
            {
               _loc2_ += _loc2_;
            }
            _loc3_ += String.fromCharCode(param1.charCodeAt(_loc4_) ^ _loc2_.charCodeAt(_loc4_));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function encode(param1:String) : String
      {
         var _loc2_:Base64Encoder = new Base64Encoder();
         _loc2_.encode(FastCipher.xor(param1));
         return _loc2_.flush();
      }
   }
}

