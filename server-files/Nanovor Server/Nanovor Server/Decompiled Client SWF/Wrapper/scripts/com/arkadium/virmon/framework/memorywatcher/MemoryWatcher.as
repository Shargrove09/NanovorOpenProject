package com.arkadium.virmon.framework.memorywatcher
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class MemoryWatcher
   {
      
      private static var _watchedVariables:Dictionary = new Dictionary(true);
      
      public function MemoryWatcher()
      {
         super();
      }
      
      public static function registerObject(param1:Object, param2:String) : void
      {
         log("registerObject() - Adding " + param2);
         _watchedVariables[param1] = param2;
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log("<<MemoryWatcher>>\t" + param1);
      }
      
      public static function logCurrentObjects() : void
      {
         var _loc3_:String = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         for each(_loc3_ in _watchedVariables)
         {
            _loc1_ += "\n\t\t\t" + _loc3_;
            _loc2_++;
         }
         log("log() - " + _loc2_ + " items - " + _loc1_);
      }
   }
}

