package com.arkadium.virmon.shared.utils
{
   public class Environment
   {
      
      public static var osVersion:String;
      
      public static var osBitType:String;
      
      public static var osLocale:String;
      
      public static var localApplicationPath:String;
      
      public static var osKey:String;
      
      public static var osName:String;
      
      public static const OS_KEY_MAC:String = "mac";
      
      public static const OS_KEY_LINUX:String = "lin";
      
      public static const OS_KEY_WINDOWS:String = "win";
      
      public static const OS_KEY_UNRECOGNIZED:String = "na";
      
      public static var localPathDelimeter:String = "\\";
      
      public function Environment()
      {
         super();
      }
      
      public static function dumpVars() : String
      {
         return "Environment vars.... " + "\n\tlocalPathDelimeter   = " + localPathDelimeter + "\n\tlocalApplicationPath = " + localApplicationPath + "\n\tosKey                = " + osKey + "\n\tosName               = " + osName + "\n\tosVersion            = " + osVersion + "\n\tosLocale             = " + osLocale + "\n\tosBitType            = " + osBitType + "";
      }
      
      public static function posixToLocalPath(param1:String) : String
      {
         return param1.replace(/\//g,localPathDelimeter);
      }
   }
}

