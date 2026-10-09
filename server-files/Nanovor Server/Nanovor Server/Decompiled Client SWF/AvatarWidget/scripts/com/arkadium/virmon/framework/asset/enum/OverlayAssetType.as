package com.arkadium.virmon.framework.asset.enum
{
   public class OverlayAssetType
   {
      
      public static const OVERLAY:OverlayAssetType = new OverlayAssetType("overlay");
      
      public static const OVERLAY_AUDIO:OverlayAssetType = new OverlayAssetType("overlayAudo");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function OverlayAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'OverlayAssetType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[OverlayAssetType: " + _name + "]";
      }
   }
}

