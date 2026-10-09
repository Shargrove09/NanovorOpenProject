package com.arkadium.virmon.framework.application.enum
{
   public class ApplicationLocation
   {
      
      public static const DATA_DIRECTORY:ApplicationLocation = new ApplicationLocation("data");
      
      public static const TEMP_DIRECTORY:ApplicationLocation = new ApplicationLocation("tempupdates");
      
      public static const REMOTE_ROOT_DIRECTORY:ApplicationLocation = new ApplicationLocation("clientbin");
      
      public static const MANIFEST_FILE_NAME:ApplicationLocation = new ApplicationLocation("AppManifest.xml");
      
      public static const METADATA_FILE_NAME:ApplicationLocation = new ApplicationLocation("AppManifest-props.xml");
      
      public static const TEMP_METADATA_FILE_NAME:ApplicationLocation = new ApplicationLocation("_updates.xml");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function ApplicationLocation(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'ApplicationLocation\'.");
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

