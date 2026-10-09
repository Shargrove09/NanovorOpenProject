package com.arkadium.virmon.shared.utils
{
   public class CFormulaParser
   {
      
      private static var operators:Array = new Array("+","-","*","/","^");
      
      public function CFormulaParser()
      {
         super();
      }
      
      public static function trim(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(param1.length != 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1.charAt(_loc3_) != " ")
               {
                  _loc2_ += param1.charAt(_loc3_);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public static function parseFormula(param1:String, param2:Number) : Number
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc3_:uint = 0;
         while(true)
         {
            _loc3_ = uint(param1.indexOf("("));
            if(!(Boolean(_loc3_) || _loc3_ != -1))
            {
               break;
            }
            _loc4_ = uint(param1.indexOf(")",++_loc3_));
            if(_loc4_ <= 0)
            {
               trace("Error: No ending \')\' !");
               return NaN;
            }
            _loc5_ = param1.substring(_loc3_,_loc4_);
            _loc3_ = uint(param1.indexOf("(",_loc3_));
            if(_loc3_ > _loc4_ || _loc3_ < 0)
            {
               param1 = param1.split("(" + _loc5_ + ")").join(Calculate(_loc5_,0,param2));
               _loc3_ = 0;
            }
         }
         return parseFloat(Calculate(param1,0,param2));
      }
      
      public static function Calculate(param1:String, param2:Number, param3:Number) : String
      {
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         param1 = param1.split("--").join("+");
         param1 = param1.split("+-").join("-");
         var _loc4_:* = param1.split(operators[param2]);
         var _loc5_:Number = 0;
         var _loc6_:* = 0;
         for(; _loc6_ < _loc4_.length; _loc6_++)
         {
            _loc7_ = _loc4_[_loc6_];
            if(_loc7_ == "$MyStrength")
            {
               _loc7_ = param3.toString();
            }
            _loc8_ = param2 + 1;
            while(_loc8_ < operators.length)
            {
               if(_loc7_.indexOf(operators[_loc8_]) > 0)
               {
                  _loc7_ = Calculate(_loc7_,_loc8_,param3);
                  break;
               }
               _loc8_++;
            }
            _loc9_ = parseFloat(_loc7_);
            if(_loc6_ == 0)
            {
               _loc5_ = _loc9_;
               continue;
            }
            switch(operators[param2])
            {
               case "^":
                  _loc5_ = Math.pow(_loc5_,_loc9_);
                  break;
               case "*":
                  _loc5_ *= _loc9_;
                  break;
               case "/":
                  _loc5_ /= _loc9_;
                  break;
               case "+":
                  _loc5_ += _loc9_;
                  break;
               case "-":
                  _loc5_ -= _loc9_;
            }
         }
         return String(_loc5_);
      }
   }
}

