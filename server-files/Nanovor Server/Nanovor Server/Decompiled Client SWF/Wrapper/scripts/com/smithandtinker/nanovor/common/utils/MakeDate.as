package com.smithandtinker.nanovor.common.utils
{
   public class MakeDate
   {
      
      public static const BANK_TIME_REGEX:RegExp = /(....)-(..)-(..)T(.+?:..:..)\.(.+?)(...):(..)/;
      
      public function MakeDate()
      {
         super();
      }
      
      public static function dateFromBankTime(param1:String) : Date
      {
         var _loc2_:Array = param1.match(BANK_TIME_REGEX);
         var _loc3_:String = _loc2_[2] + "/" + _loc2_[3] + "/" + _loc2_[1] + " " + _loc2_[4] + " UTC" + _loc2_[6] + _loc2_[7];
         var _loc4_:Number = Number(_loc2_[5]);
         var _loc5_:Number = Date.parse(_loc3_);
         if(isNaN(_loc5_))
         {
            return null;
         }
         var _loc6_:Date = new Date(_loc3_);
         _loc6_.setMilliseconds(_loc4_);
         return _loc6_;
      }
   }
}

