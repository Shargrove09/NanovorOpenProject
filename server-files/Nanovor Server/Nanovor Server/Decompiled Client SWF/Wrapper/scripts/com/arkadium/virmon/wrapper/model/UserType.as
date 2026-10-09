package com.arkadium.virmon.wrapper.model
{
   public class UserType
   {
      
      public static const NEW_USER:UserType = new UserType("NEW_USER");
      
      public static const EXISTING_USER:UserType = new UserType("EXISTING_USER");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function UserType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'UserType\'.");
         }
         _name = param1;
      }
      
      public function toString() : String
      {
         return "[UserType: " + _name + "]";
      }
   }
}

