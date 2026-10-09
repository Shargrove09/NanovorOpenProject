package com.arkadium.virmon.framework.asset.enum
{
   public class AssetURLType
   {
      
      public static const ACTUAL:AssetURLType = new AssetURLType("actual");
      
      public static const FALLBACK_SUPERSEDED:AssetURLType = new AssetURLType("fallbackSuperseded");
      
      public static const FALLBACK_DEFAULT:AssetURLType = new AssetURLType("fallbackDefault");
      
      public static const NOT_FOUND:AssetURLType = new AssetURLType("notFound");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function AssetURLType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'AssetURLType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[AssetURLType: " + _name + "]";
      }
   }
}

