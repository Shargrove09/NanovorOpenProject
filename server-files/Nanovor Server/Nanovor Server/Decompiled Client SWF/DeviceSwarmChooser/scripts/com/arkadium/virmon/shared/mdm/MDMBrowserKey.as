package com.arkadium.virmon.shared.mdm
{
   public class MDMBrowserKey
   {
      
      public static const DEFAULT_INTERNAL_BROWSER:MDMBrowserKey = new MDMBrowserKey("defaultBrowser");
      
      public static const BUY_NANOCASH:MDMBrowserKey = new MDMBrowserKey("buyNanocash");
      
      public static const HOME_NEWS:MDMBrowserKey = new MDMBrowserKey("homeNews");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function MDMBrowserKey(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type MDMBrowserKey at runtime");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}

