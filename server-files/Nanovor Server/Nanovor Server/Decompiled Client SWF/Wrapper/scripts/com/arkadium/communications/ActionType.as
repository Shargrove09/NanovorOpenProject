package com.arkadium.communications
{
   public class ActionType
   {
      
      public static const CONNECT:ActionType = new ActionType("CONNECT");
      
      public static const REFRESH:ActionType = new ActionType("REFRESH");
      
      public static const MAINTENANCE:ActionType = new ActionType("MAINTENANCE");
      
      public static const NULL:ActionType = new ActionType("NULL");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function ActionType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'ActionType\'.");
         }
         _name = param1;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}

