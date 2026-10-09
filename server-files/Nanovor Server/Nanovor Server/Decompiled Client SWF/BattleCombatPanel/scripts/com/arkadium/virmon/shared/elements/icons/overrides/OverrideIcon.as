package com.arkadium.virmon.shared.elements.icons.overrides
{
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class OverrideIcon extends Sprite
   {
      
      private var _overrideDescription:String;
      
      private var _childIcon:* = null;
      
      public function OverrideIcon()
      {
         super();
      }
      
      public static function createFromAttackStatements(param1:Array, param2:String) : OverrideIcon
      {
         var _loc6_:AttackStatement = null;
         var _loc7_:String = null;
         var _loc8_:OverrideStat = null;
         log("createFromAttackStatement: statements length = " + param1.length);
         if(param1.length == 0)
         {
            return null;
         }
         var _loc3_:OverrideIcon = new OverrideIcon();
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         log("      .... icon loop count = " + param1.length);
         for each(_loc6_ in param1)
         {
            _loc7_ = Icon.getAttackStatementIcon(_loc6_.type,_loc6_.stat);
            _loc3_.overrideDescription = param2;
            log("      .... icon loop type = " + _loc7_);
            switch(_loc7_)
            {
               case Icon.OVERRIDE_ARMOR:
                  log("      .... icon type = " + Icon.OVERRIDE_ARMOR + " : " + OverrideStat.OVERRIDE_ARMOR);
                  _loc4_ |= OverrideStat.OVERRIDE_ARMOR;
                  break;
               case Icon.OVERRIDE_SPEED:
                  log("      .... icon type = " + Icon.OVERRIDE_SPEED + " : " + OverrideStat.OVERRIDE_SPEED);
                  _loc4_ |= OverrideStat.OVERRIDE_SPEED;
                  break;
               case Icon.OVERRIDE_STRENGTH:
                  log("      .... icon type = " + Icon.OVERRIDE_STRENGTH + " : " + OverrideStat.OVERRIDE_STRENGTH);
                  _loc4_ |= OverrideStat.OVERRIDE_STRENGTH;
                  break;
               case Icon.OVERRIDE_ENERGY:
                  log("      .... icon type = " + Icon.OVERRIDE_ENERGY + " : " + OverrideStat.OVERRIDE_ENERGY);
                  _loc4_ |= OverrideStat.OVERRIDE_ENERGY;
                  break;
               case Icon.OVERRIDE_DODGE:
                  log("      .... icon type = " + Icon.OVERRIDE_DODGE + " : " + OverrideStat.OVERRIDE_DODGE);
                  _loc4_ |= OverrideStat.OVERRIDE_DODGE;
                  break;
               case Icon.OVERRIDE_BLUESPIKE:
                  log("      .... icon type = " + Icon.OVERRIDE_BLUESPIKE);
                  _loc5_ = new OverrideSpikeBlue();
                  break;
               case Icon.OVERRIDE_REDSPIKE:
                  log("      .... icon type = " + Icon.OVERRIDE_REDSPIKE);
                  _loc5_ = new OverrideSpikeRed();
                  break;
               case Icon.OVERRIDE_YELLOWSPIKE:
                  log("      .... icon type = " + Icon.OVERRIDE_YELLOWSPIKE);
                  _loc5_ = new OverrideSpikeYellow();
                  break;
               default:
                  log("      .... icon type = UNKNOWN (default) ***");
                  _loc5_ = null;
            }
         }
         if(_loc5_ != null)
         {
            _loc3_.addChild(_loc5_);
            _loc3_._childIcon = _loc5_;
         }
         else if(_loc4_ > 0)
         {
            log("      .... stat icon id = " + _loc4_);
            _loc8_ = new OverrideStat(_loc4_);
            _loc3_.addChild(_loc8_);
            _loc3_._childIcon = _loc8_;
         }
         return _loc3_;
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error("** OverrideIcon: " + param1);
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> OverrideIcon: " + param1);
      }
      
      public function get overrideDescription() : String
      {
         return _overrideDescription;
      }
      
      public function get childIcon() : *
      {
         return _childIcon;
      }
      
      public function set overrideDescription(param1:String) : void
      {
         _overrideDescription = param1;
      }
   }
}

