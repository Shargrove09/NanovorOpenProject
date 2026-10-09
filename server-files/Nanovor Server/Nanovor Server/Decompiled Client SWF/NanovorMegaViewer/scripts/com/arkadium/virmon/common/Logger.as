package com.arkadium.virmon.common
{
   public class Logger
   {
      
      private static var _bDebugMode:Boolean;
      
      public function Logger()
      {
         super();
      }
      
      public static function setDebugMode(param1:Boolean) : *
      {
         _bDebugMode = param1;
      }
      
      public static function debug(param1:String) : void
      {
         if(!_bDebugMode)
         {
            return;
         }
         param1 = "DEBUG:: " + param1;
      }
   }
}

