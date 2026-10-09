package com.arkadium.communications.handlers
{
   public class LoginResultType
   {
      
      public static const LOGIN_SUCCESS:LoginResultType = new LoginResultType("Login Success");
      
      public static const LOGIN_FAILURE:LoginResultType = new LoginResultType("Login Failure");
      
      public static const CONNECTION_FAILURE:LoginResultType = new LoginResultType("Connection Failure");
      
      public static const CONFIG_LOAD_FAILURE:LoginResultType = new LoginResultType("Config Load Failure");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function LoginResultType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum \'LoginResultType\'.");
         }
         this._name = param1;
      }
      
      public function toString() : String
      {
         return this._name;
      }
   }
}

