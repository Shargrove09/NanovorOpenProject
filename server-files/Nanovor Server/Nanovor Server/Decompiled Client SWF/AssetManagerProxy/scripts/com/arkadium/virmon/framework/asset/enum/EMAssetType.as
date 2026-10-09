package com.arkadium.virmon.framework.asset.enum
{
   public class EMAssetType
   {
      
      public static const CHIP_ICON:EMAssetType = new EMAssetType("ChipIcon");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function EMAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'EMAssetType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[EMAssetType: " + _name + "]";
      }
   }
}

