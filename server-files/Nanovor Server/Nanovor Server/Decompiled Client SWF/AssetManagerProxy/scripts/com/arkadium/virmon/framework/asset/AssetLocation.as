package com.arkadium.virmon.framework.asset
{
   public class AssetLocation
   {
      
      public static const ASSETS_DIRECTORY:AssetLocation = new AssetLocation("Assets");
      
      public static const MANIFEST_FILE_NAME:AssetLocation = new AssetLocation("manifest.xml");
      
      public static const MANIFEST_METADATA_FILE_NAME:AssetLocation = new AssetLocation("manifest-props.xml");
      
      public static const ROOT_MANIFEST_NAME:AssetLocation = new AssetLocation("root");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function AssetLocation(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'AssetLocation\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}

