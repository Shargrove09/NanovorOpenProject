package com.arkadium.virmon.framework.asset.enum
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class CharacterAnimationAssetType
   {
      
      private static var _lookupTable:Dictionary;
      
      public static const ANIMATION_XML:CharacterAnimationAssetType = new CharacterAnimationAssetType("animation");
      
      public static const COMBAT_ANIMATION_XML:CharacterAnimationAssetType = new CharacterAnimationAssetType("combat-animation");
      
      public static const ATTACK:CharacterAnimationAssetType = new CharacterAnimationAssetType("At");
      
      public static const DAMAGE:CharacterAnimationAssetType = new CharacterAnimationAssetType("Da");
      
      public static const DEATH:CharacterAnimationAssetType = new CharacterAnimationAssetType("De");
      
      public static const DODGE:CharacterAnimationAssetType = new CharacterAnimationAssetType("Do");
      
      public static const ENTER:CharacterAnimationAssetType = new CharacterAnimationAssetType("En");
      
      public static const EXIT:CharacterAnimationAssetType = new CharacterAnimationAssetType("Ex");
      
      public static const EVOLVE_IN:CharacterAnimationAssetType = new CharacterAnimationAssetType("EvIn");
      
      public static const EVOLVE_OUT:CharacterAnimationAssetType = new CharacterAnimationAssetType("EvOut");
      
      public static const IDLE:CharacterAnimationAssetType = new CharacterAnimationAssetType("Id");
      
      public static const JUMP_BACK:CharacterAnimationAssetType = new CharacterAnimationAssetType("Jb");
      
      public static const REANIMATE:CharacterAnimationAssetType = new CharacterAnimationAssetType("Re");
      
      public static const TURN:CharacterAnimationAssetType = new CharacterAnimationAssetType("Tu");
      
      public static const VICTORY:CharacterAnimationAssetType = new CharacterAnimationAssetType("Vi");
      
      public static const TYPE_UNKNOWN:CharacterAnimationAssetType = new CharacterAnimationAssetType("typeUnknown");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function CharacterAnimationAssetType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'CharacterAnimationAssetType\'.");
         }
         this._name = param1;
      }
      
      public static function parse(param1:String) : CharacterAnimationAssetType
      {
         var _loc2_:CharacterAnimationAssetType = lookupTable[param1.toLowerCase()];
         if(_loc2_ == null)
         {
            logError("parse(): could not find type for string \'" + param1 + "\'");
            return TYPE_UNKNOWN;
         }
         return _loc2_;
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> CharacterAnimationAssetType: " + param1);
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error("** CharacterAnimationAssetType: " + param1);
      }
      
      private static function get lookupTable() : Dictionary
      {
         if(_lookupTable == null)
         {
            _lookupTable = new Dictionary();
            _lookupTable[ANIMATION_XML.name.toLowerCase()] = ANIMATION_XML;
            _lookupTable[COMBAT_ANIMATION_XML.name.toLowerCase()] = COMBAT_ANIMATION_XML;
            _lookupTable[ATTACK.name.toLowerCase()] = ATTACK;
            _lookupTable[DAMAGE.name.toLowerCase()] = DAMAGE;
            _lookupTable[DEATH.name.toLowerCase()] = DEATH;
            _lookupTable[DODGE.name.toLowerCase()] = DODGE;
            _lookupTable[ENTER.name.toLowerCase()] = ENTER;
            _lookupTable[EXIT.name.toLowerCase()] = EXIT;
            _lookupTable[EVOLVE_IN.name.toLowerCase()] = EVOLVE_IN;
            _lookupTable[EVOLVE_OUT.name.toLowerCase()] = EVOLVE_OUT;
            _lookupTable[IDLE.name.toLowerCase()] = IDLE;
            _lookupTable[JUMP_BACK.name.toLowerCase()] = JUMP_BACK;
            _lookupTable[REANIMATE.name.toLowerCase()] = REANIMATE;
            _lookupTable[TURN.name.toLowerCase()] = TURN;
            _lookupTable[VICTORY.name.toLowerCase()] = VICTORY;
         }
         return _lookupTable;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "[CharacterAnimationAssetType: " + this._name + "]";
      }
   }
}

