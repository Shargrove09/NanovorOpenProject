package com.arkadium.virmon.framework.asset.enum
{
   public class CharacterEvoAssetType
   {
      
      public static const REVEALED:CharacterEvoAssetType = new CharacterEvoAssetType("Revealed");
      
      public static const SILHOUETTE:CharacterEvoAssetType = new CharacterEvoAssetType("Silhouette");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function CharacterEvoAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'CharacterEvoAssetType\'.");
         }
         _name = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[CharacterEvoAssetType: " + _name + "]";
      }
   }
}

