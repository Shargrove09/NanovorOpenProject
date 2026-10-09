package com.arkadium.virmon.framework.application.enum
{
   public class PackagePriority
   {
      
      public static const MOVE_AND_RESTART:PackagePriority = new PackagePriority(-1);
      
      public static const RESTART:PackagePriority = new PackagePriority(9);
      
      public static const PRE_WAIT_STATE:PackagePriority = new PackagePriority(19);
      
      public static const WAIT_STATE:PackagePriority = new PackagePriority(29);
      
      public static const BACKGROUND:PackagePriority = new PackagePriority(int.MAX_VALUE - 1);
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _priority:int;
      
      public function PackagePriority(param1:int)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'PackagePriority\'.");
         }
         _priority = param1;
      }
      
      public static function parse(param1:int) : PackagePriority
      {
         if(param1 <= MOVE_AND_RESTART.priority)
         {
            return MOVE_AND_RESTART;
         }
         if(param1 <= RESTART.priority)
         {
            return RESTART;
         }
         if(param1 <= PRE_WAIT_STATE.priority)
         {
            return PRE_WAIT_STATE;
         }
         if(param1 <= WAIT_STATE.priority)
         {
            return WAIT_STATE;
         }
         return BACKGROUND;
      }
      
      public function toString() : String
      {
         return "[PackagePriority: " + _priority + "]";
      }
      
      public function get priority() : int
      {
         return _priority;
      }
   }
}

