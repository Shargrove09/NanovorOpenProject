package com.arkadium.virmon.framework.asset.enum
{
   public class HelpAssetType
   {
      
      public static const HELP_SWARM_CHOOSER:HelpAssetType = new HelpAssetType("helpSwarmChooser");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function HelpAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'HelpAssetType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[HelpAssetType: " + _name + "]";
      }
   }
}

