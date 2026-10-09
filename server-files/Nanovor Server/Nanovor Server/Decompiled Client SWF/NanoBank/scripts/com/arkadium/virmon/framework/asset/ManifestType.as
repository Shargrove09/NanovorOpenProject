package com.arkadium.virmon.framework.asset
{
   public class ManifestType
   {
      
      public static const NORMAL:ManifestType = new ManifestType("NORMAL");
      
      public static const SUPER:ManifestType = new ManifestType("SUPER");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function ManifestType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'ManifestType\'.");
         }
         this._name = param1;
      }
      
      public function toString() : String
      {
         return "[ManifestType]: " + this._name;
      }
   }
}

