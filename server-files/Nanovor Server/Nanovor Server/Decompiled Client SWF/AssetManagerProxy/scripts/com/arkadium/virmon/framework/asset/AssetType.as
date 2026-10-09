package com.arkadium.virmon.framework.asset
{
   public class AssetType
   {
      
      public static const UNKNOWN:uint = 0;
      
      public static const SWF:uint = 1;
      
      public static const XML:uint = 2;
      
      public static const BITMAP:uint = 3;
      
      private static var _aStrings:* = ["Unknown","SWF","XML","Bitmap"];
      
      public function AssetType()
      {
         super();
      }
      
      public static function getByString(param1:String) : uint
      {
         var _loc2_:uint = 0;
         switch(param1.toUpperCase())
         {
            case "SWF":
               _loc2_ = AssetType.SWF;
               break;
            case "XML":
               _loc2_ = AssetType.XML;
               break;
            case "BITMAP":
               _loc2_ = AssetType.BITMAP;
               break;
            default:
               _loc2_ = AssetType.UNKNOWN;
         }
         return _loc2_;
      }
      
      public static function getString(param1:uint) : String
      {
         return _aStrings[param1] == undefined ? _aStrings[0] : _aStrings[param1];
      }
   }
}

