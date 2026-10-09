package com.arkadium.virmon.framework.asset.enum
{
   public class CharacterChipAssetType
   {
      
      public static const DEATHS:CharacterChipAssetType = new CharacterChipAssetType("Deaths");
      
      public static const IDLE:CharacterChipAssetType = new CharacterChipAssetType("Idle");
      
      public static const STUNNED:CharacterChipAssetType = new CharacterChipAssetType("Stunned");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function CharacterChipAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'CharacterChipAssetType\'.");
         }
         this._name = param1;
      }
      
      public static function parse(param1:String) : CharacterChipAssetType
      {
         switch(param1)
         {
            case DEATHS.name:
               return DEATHS;
            case IDLE.name:
               return IDLE;
            case STUNNED.name:
               return STUNNED;
            default:
               throw new Error("Unknown asset type ID: " + param1);
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "[CharacterChipAssetType: " + this._name + "]";
      }
   }
}

