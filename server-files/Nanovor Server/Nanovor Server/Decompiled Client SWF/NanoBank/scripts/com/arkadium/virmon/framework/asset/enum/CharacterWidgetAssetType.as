package com.arkadium.virmon.framework.asset.enum
{
   public class CharacterWidgetAssetType
   {
      
      public static const DEATHS:CharacterWidgetAssetType = new CharacterWidgetAssetType("Deaths");
      
      public static const IDLE:CharacterWidgetAssetType = new CharacterWidgetAssetType("Idle");
      
      public static const STUNNED:CharacterWidgetAssetType = new CharacterWidgetAssetType("Stunned");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function CharacterWidgetAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'CharacterWidgetAssetType\'.");
         }
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "[CharacterWidgetAssetType: " + this._name + "]";
      }
   }
}

