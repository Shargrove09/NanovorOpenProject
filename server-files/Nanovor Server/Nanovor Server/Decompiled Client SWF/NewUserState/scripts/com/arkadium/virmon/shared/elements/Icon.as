package com.arkadium.virmon.shared.elements
{
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.common.AttackIconType;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class Icon
   {
      
      private static var _FRAMEWORK_ICON_MAP:Dictionary;
      
      public static const STAT_ARMOR:String = "StatArmor";
      
      public static const STAT_ENERGY:String = "StatEnergy";
      
      public static const STAT_HEALTH:String = "StatHealth";
      
      public static const STAT_SPEED:String = "StatSpeed";
      
      public static const STAT_STRENGTH:String = "StatStrength";
      
      public static const STAT_SWARMVALUE:String = "StatSwarmValue";
      
      public static const MOD_REMOVE_OVERRIDE:String = "ModRemoveOverride";
      
      public static const FACTION_HEXITE:String = "Hexite";
      
      public static const FACTION_MAGNAMOD:String = "Magnamod";
      
      public static const FACTION_VELOCITRON:String = "Velocitron";
      
      public static const ACTION_ACID:String = "ActionAcid";
      
      public static const ACTION_ANTIMATTER:String = "ActionAntimatter";
      
      public static const ACTION_CRYSTAL:String = "ActionCrystal";
      
      public static const ACTION_ELECTRIC:String = "ActionElectric";
      
      public static const ACTION_ENERGY:String = "ActionEnergy";
      
      public static const ACTION_FIRE:String = "ActionFire";
      
      public static const ACTION_HACK:String = "ActionHack";
      
      public static const ACTION_ICE:String = "ActionIce";
      
      public static const ACTION_MELEE:String = "ActionMelee";
      
      public static const ACTION_MOD:String = "ActionMod";
      
      public static const ACTION_PASS:String = "ActionPass";
      
      public static const ACTION_POISON:String = "ActionPoison";
      
      public static const ACTION_PSYCHIC:String = "ActionPsychic";
      
      public static const ACTION_SWAP:String = "ActionSwap";
      
      public static const ACTION_OVERRIDE:String = "ActionOverride";
      
      public static const OVERRIDE_ARMOR:String = "OverrideArmor";
      
      public static const OVERRIDE_HEALTH:String = "OverrideHealth";
      
      public static const OVERRIDE_SPEED:String = "OverrideSpeed";
      
      public static const OVERRIDE_STRENGTH:String = "OverrideStrength";
      
      public static const OVERRIDE_ENERGY:String = "OverrideEnergy";
      
      public static const OVERRIDE_DODGE:String = "OverrideDodge";
      
      public static const OVERRIDE_BLUESPIKE:String = "OverrideBlueSpike";
      
      public static const OVERRIDE_REDSPIKE:String = "OverrideRedSpike";
      
      public static const OVERRIDE_YELLOWSPIKE:String = "OverrideYellowSpike";
      
      public static const HACK_DODGE:String = "HackDodge";
      
      public static const HACK_STUN:String = "HackStun";
      
      public static const HACK_SWAP_BLOCK:String = "HackSwapBlock";
      
      public function Icon()
      {
         super();
      }
      
      public static function getActionIconTypeForAttack(param1:IAttack) : String
      {
         DebugLog.instance.log("getIconTypeForAttack: attack ==> " + param1.toString());
         return param1.actionIconType;
      }
      
      public static function getStatIconTypeForAttackStatement(param1:*) : String
      {
         var _loc2_:String = null;
         DebugLog.instance.log("getStatIconTypeForAttackStatement: attackStatement ==> " + param1.toString());
         switch(param1.type)
         {
            case AttackStatementTypes.TYPE_DAMAGE:
         }
         return STAT_HEALTH;
      }
      
      private static function createFrameworkIconMap() : void
      {
         _FRAMEWORK_ICON_MAP = new Dictionary();
         _FRAMEWORK_ICON_MAP[AttackIconType.ACID] = ACTION_ACID;
         _FRAMEWORK_ICON_MAP[AttackIconType.ANTI_MATTER] = ACTION_ANTIMATTER;
         _FRAMEWORK_ICON_MAP[AttackIconType.CRYSTAL] = ACTION_CRYSTAL;
         _FRAMEWORK_ICON_MAP[AttackIconType.ELECTRIC] = ACTION_ELECTRIC;
         _FRAMEWORK_ICON_MAP[AttackIconType.ENERGY] = ACTION_ENERGY;
         _FRAMEWORK_ICON_MAP[AttackIconType.FIRE] = ACTION_FIRE;
         _FRAMEWORK_ICON_MAP[AttackIconType.HACK] = ACTION_HACK;
         _FRAMEWORK_ICON_MAP[AttackIconType.ICE] = ACTION_ICE;
         _FRAMEWORK_ICON_MAP[AttackIconType.MELEE] = ACTION_MELEE;
         _FRAMEWORK_ICON_MAP[AttackIconType.OVERRIDE] = ACTION_OVERRIDE;
         _FRAMEWORK_ICON_MAP[AttackIconType.POISON] = ACTION_POISON;
         _FRAMEWORK_ICON_MAP[AttackIconType.PSYCHIC] = ACTION_PSYCHIC;
         _FRAMEWORK_ICON_MAP[AttackIconType.MOD] = ACTION_MOD;
         _FRAMEWORK_ICON_MAP[AttackIconType.BLUE_SPIKE] = OVERRIDE_BLUESPIKE;
         _FRAMEWORK_ICON_MAP[AttackIconType.RED_SPIKE] = OVERRIDE_REDSPIKE;
         _FRAMEWORK_ICON_MAP[AttackIconType.YELLOW_SPIKE] = OVERRIDE_YELLOWSPIKE;
      }
      
      public static function getIconFromFrameworkType(param1:String) : String
      {
         if(_FRAMEWORK_ICON_MAP == null)
         {
            createFrameworkIconMap();
         }
         var _loc2_:String = _FRAMEWORK_ICON_MAP[param1];
         if(_loc2_ == null)
         {
            _loc2_ = ACTION_MELEE;
         }
         return _loc2_;
      }
      
      public static function getAttackStatementIcon(param1:String, param2:String) : String
      {
         switch(param1)
         {
            case AttackStatementTypes.TYPE_DAMAGE:
               return STAT_HEALTH;
            case AttackStatementTypes.TYPE_HACK:
               switch(param2)
               {
                  case Stat.DODGE_FAIL_PERCENTAGE:
                     return HACK_DODGE;
                  case Stat.STUN_FAIL_PERCENTAGE:
                     return HACK_STUN;
                  case Stat.SWAP_PERCENTAGE:
                     return HACK_SWAP_BLOCK;
                  default:
                     return null;
               }
               break;
            case AttackStatementTypes.TYPE_MOD:
               if(param2 == Stat.OVERRIDE)
               {
                  return MOD_REMOVE_OVERRIDE;
               }
               return Icon["STAT_" + param2.toUpperCase()];
               break;
            case AttackStatementTypes.TYPE_OVERRIDE:
               if(param2 == Stat.DODGE_FAIL_PERCENTAGE)
               {
                  return OVERRIDE_DODGE;
               }
               if(param2 == Stat.ENERGY_GENERATOR)
               {
                  return OVERRIDE_ENERGY;
               }
               return Icon["OVERRIDE_" + param2.toUpperCase()];
               break;
            default:
               DebugLog.instance.error("** Icon: getAttackStatementIcon (type=\"" + param1 + "\" stat=\"" + param2 + "\"): default case in switch block reached");
               return STAT_HEALTH;
         }
      }
   }
}

