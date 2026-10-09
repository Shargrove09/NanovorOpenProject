package com.arkadium.virmon.avatar
{
   public class AvatarSpinnerStateType
   {
      
      public static const ACTIVE:AvatarSpinnerStateType = new AvatarSpinnerStateType("ACTIVE");
      
      public static const INACTIVE:AvatarSpinnerStateType = new AvatarSpinnerStateType("INACTIVE");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function AvatarSpinnerStateType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'AvatarSpinnerStateType\'.");
         }
         this._name = param1;
      }
      
      public function toString() : String
      {
         return "[AvatarSpinnerStateType: " + this._name + "]";
      }
   }
}

