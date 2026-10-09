package com.arkadium.virmon.framework.asset.enum
{
   public class AvatarAssetType
   {
      
      public static const SMALL:AvatarAssetType = new AvatarAssetType("avatar_large");
      
      public static const MEDIUM:AvatarAssetType = new AvatarAssetType("avatar_large");
      
      public static const LARGE:AvatarAssetType = new AvatarAssetType("avatar_large");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function AvatarAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'AvatarAssetType\'.");
         }
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "[AvatarAssetType: " + this._name + "]";
      }
   }
}

