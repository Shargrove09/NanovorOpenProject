package com.arkadium.analytics.enum
{
   public class Click
   {
      
      public static const NANOLOG:Click = new Click("/click/nanolog");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function Click(param1:String, param2:Function = null)
      {
         super();
         if(_isLocked && param2 != internalEnforcer)
         {
            throw new Error("Cannot instantiate enum type \'Click\' at runtime.");
         }
         _name = param1;
      }
      
      public static function createDynamic(param1:String) : Click
      {
         return new Click(param1,internalEnforcer);
      }
      
      private static function internalEnforcer() : void
      {
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}

