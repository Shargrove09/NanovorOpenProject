package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   import com.arkadium.virmon.senseibattle.battlelogic.GameMath;
   import com.arkadium.virmon.senseibattle.battlelogic.player.BattleLogicPlayer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleLogicConditional
   {
      
      public static var NONE:String = "no conditions";
      
      public static var I_DIE:String = "if i die";
      
      public static var IM_FIRST_IN_TURN:String = "if i\'m first in turn";
      
      public static var IM_NOT_FIRST_IN_TURN:String = "if i\'m not first in turn";
      
      public static var IM_LAST_IN_TURN:String = "if i\'m last in turn";
      
      public static var MY_ENERGY_IS:String = "if my energy is";
      
      public static var MY_HEALTH_IS:String = "if my health is";
      
      public static var MY_SPEED_IS:String = "if my speed is";
      
      public static var MY_STRENGTH_IS:String = "if my strength is";
      
      public static var MY_ARMOR_IS:String = "if my armor is";
      
      public static var MY_FACTION_IS:String = "if my faction is";
      
      public static var ENEMY_DIES:String = "if enemy dies";
      
      public static var ENEMY_FIRST_IN_TURN:String = "if enemy first in turn";
      
      public static var ENEMY_NOT_FIRST_IN_TURN:String = "if enemy not first in turn";
      
      public static var ENEMY_LAST_IN_TURN:String = "if enemy last in turn";
      
      public static var ENEMY_ENERGY_IS:String = "if enemy energy is";
      
      public static var ENEMY_HEALTH_IS:String = "if enemy health is";
      
      public static var ENEMY_SPEED_IS:String = "if enemy speed is";
      
      public static var ENEMY_STRENGTH_IS:String = "if enemy strength is";
      
      public static var ENEMY_ARMOR_IS:String = "if enemy armor is";
      
      public static var ENEMY_FACTION_IS:String = "if enemy faction is";
      
      public static var RANDOM_D100_IS:String = "if random 1-100 is";
      
      public static var ATTACK_FAILED:String = "if attack failed";
      
      public static var MY_OVERRIDE_CONTAINS_STATEMENT_ID:String = "if my override contains statementid";
      
      public static var ENEMY_OVERRIDE_CONTAINS_STATEMENT_ID:String = "if opponent override contains statementid";
      
      public static var MY_RED_SPIKE_IS_SET:String = "if my redspike is set";
      
      public static var MY_RED_SPIKE_IS_NOT_SET:String = "if my redspike is not set";
      
      public static var ENEMY_RED_SPIKE_IS_SET:String = "if enemy redspike is set";
      
      public static var ENEMY_RED_SPIKE_IS_NOT_SET:String = "if enemy redspike is not set";
      
      public static var MY_YELLOW_SPIKE_IS_SET:String = "if my yellowspike is set";
      
      public static var MY_YELLOW_SPIKE_IS_NOT_SET:String = "if my yellowspike is not set";
      
      public static var ENEMY_YELLOW_SPIKE_IS_SET:String = "if enemy yellowspike is set";
      
      public static var ENEMY_YELLOW_SPIKE_IS_NOT_SET:String = "if enemy yellowspike is not set";
      
      public static var MY_BLUE_SPIKE_IS_SET:String = "if my bluespike is set";
      
      public static var MY_BLUE_SPIKE_IS_NOT_SET:String = "if my bluespike is not set";
      
      public static var ENEMY_BLUE_SPIKE_IS_SET:String = "if enemy bluespike is set";
      
      public static var ENEMY_BLUE_SPIKE_IS_NOT_SET:String = "if enemy bluespike is not set";
      
      public static var MOD_GREATER_THAN:String = ">";
      
      public static var MOD_GREATER_THAN_EQUAL:String = ">=";
      
      public static var MOD_LESS_THAN:String = "<";
      
      public static var MOD_LESS_THAN_EQUAL:String = "<=";
      
      public static var MOD_EQUAL:String = "==";
      
      public static var MOD_NOT_EQUAL:String = "!=";
      
      public static var MOD_NONE:String = "";
      
      private var _modifier:String;
      
      private var _conditionName:String;
      
      private var _variable:String;
      
      public function BattleLogicConditional(param1:String, param2:String, param3:String)
      {
         super();
         _conditionName = param1.toLowerCase();
         _modifier = param2.toLowerCase();
         _variable = param3;
         if(param1 == null || param1 == "" || param1 == "no conditions")
         {
            _conditionName = BattleLogicConditional.NONE;
         }
         if(_modifier == null)
         {
            _modifier = "";
         }
         if(_variable == null)
         {
            _variable = "";
         }
         if(_conditionName == BattleLogicConditional.NONE || _conditionName == BattleLogicConditional.I_DIE || _conditionName == BattleLogicConditional.IM_FIRST_IN_TURN || _conditionName == BattleLogicConditional.IM_NOT_FIRST_IN_TURN || _conditionName == BattleLogicConditional.IM_LAST_IN_TURN || _conditionName == BattleLogicConditional.MY_ENERGY_IS || _conditionName == BattleLogicConditional.MY_HEALTH_IS || _conditionName == BattleLogicConditional.MY_SPEED_IS || _conditionName == BattleLogicConditional.MY_STRENGTH_IS || _conditionName == BattleLogicConditional.MY_ARMOR_IS || _conditionName == BattleLogicConditional.MY_FACTION_IS || _conditionName == BattleLogicConditional.ENEMY_DIES || _conditionName == BattleLogicConditional.ENEMY_FIRST_IN_TURN || _conditionName == BattleLogicConditional.ENEMY_NOT_FIRST_IN_TURN || _conditionName == BattleLogicConditional.ENEMY_LAST_IN_TURN || _conditionName == BattleLogicConditional.ENEMY_ENERGY_IS || _conditionName == BattleLogicConditional.ENEMY_HEALTH_IS || _conditionName == BattleLogicConditional
         .ENEMY_SPEED_IS || _conditionName == BattleLogicConditional.ENEMY_STRENGTH_IS || _conditionName == BattleLogicConditional.ENEMY_ARMOR_IS || _conditionName == BattleLogicConditional.ENEMY_FACTION_IS || _conditionName == BattleLogicConditional.RANDOM_D100_IS || _conditionName == BattleLogicConditional.ATTACK_FAILED || _conditionName == BattleLogicConditional.MY_RED_SPIKE_IS_SET || _conditionName == BattleLogicConditional.MY_RED_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional.MY_BLUE_SPIKE_IS_SET || _conditionName == BattleLogicConditional.MY_BLUE_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional.MY_YELLOW_SPIKE_IS_SET || _conditionName == BattleLogicConditional.MY_YELLOW_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional.ENEMY_RED_SPIKE_IS_SET || _conditionName == BattleLogicConditional.ENEMY_RED_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional.ENEMY_BLUE_SPIKE_IS_SET || _conditionName == BattleLogicConditional.ENEMY_BLUE_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional
         .ENEMY_YELLOW_SPIKE_IS_SET || _conditionName == BattleLogicConditional.ENEMY_YELLOW_SPIKE_IS_NOT_SET || _conditionName == BattleLogicConditional.MY_OVERRIDE_CONTAINS_STATEMENT_ID || _conditionName == BattleLogicConditional.ENEMY_OVERRIDE_CONTAINS_STATEMENT_ID)
         {
            return;
         }
         trace("WRONG CONDITIONAL!!!");
         throw new Error();
      }
      
      public function toString() : String
      {
         return _conditionName + " " + _modifier + " " + _variable;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicAttack>>\t" + param1);
      }
      
      private function evaluateConditional(param1:Boolean, param2:Boolean, param3:BattleLogicPlayer, param4:BattleLogicPlayer) : Boolean
      {
         var _loc5_:BattleLogicPlayer = param3;
         var _loc6_:BattleLogicPlayer = param4;
         var _loc7_:BattleLogicNanovor = _loc5_.selectedNanovor;
         var _loc8_:BattleLogicNanovor = _loc6_.selectedNanovor;
         var _loc9_:Number = GameMath.getRandomNumber();
         var _loc10_:int = _loc5_.energyLevel;
         var _loc11_:int = _loc6_.energyLevel;
         if(_conditionName == BattleLogicConditional.NONE)
         {
            return false;
         }
         if(_conditionName == BattleLogicConditional.ENEMY_DIES)
         {
            if(_loc8_.hitPoints > 0)
            {
               return false;
            }
            return true;
         }
         if(_conditionName == BattleLogicConditional.IM_FIRST_IN_TURN)
         {
            return param1;
         }
         if(_conditionName == BattleLogicConditional.IM_NOT_FIRST_IN_TURN || _conditionName == BattleLogicConditional.IM_LAST_IN_TURN)
         {
            return !param1;
         }
         if(_conditionName == BattleLogicConditional.MY_ENERGY_IS)
         {
            return evaluateModifier(_loc10_,_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.MY_HEALTH_IS)
         {
            return evaluateModifier(_loc7_.hitPoints,_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.MY_SPEED_IS)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.SPEED,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.MY_STRENGTH_IS)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.STRENGTH,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.MY_ARMOR_IS)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.ARMOR,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.MY_FACTION_IS)
         {
            log("NANOVOR: " + _loc7_.faction + " FACTION VAR: " + _variable + " modifier: " + _modifier);
            if(_modifier == "!=")
            {
               return _loc7_.faction.toLowerCase() != Faction.setFaction(parseInt(_variable)).toLowerCase();
            }
            return _loc7_.faction.toLowerCase() == Faction.setFaction(parseInt(_variable)).toLowerCase();
         }
         if(_conditionName == BattleLogicConditional.ENEMY_FIRST_IN_TURN)
         {
            return !param1;
         }
         if(_conditionName == BattleLogicConditional.ENEMY_NOT_FIRST_IN_TURN || _conditionName == BattleLogicConditional.ENEMY_LAST_IN_TURN)
         {
            return param1;
         }
         if(_conditionName == BattleLogicConditional.ENEMY_ENERGY_IS)
         {
            return evaluateModifier(_loc11_,_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ENEMY_HEALTH_IS)
         {
            return evaluateModifier(_loc8_.hitPoints,_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ENEMY_SPEED_IS)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.SPEED,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ENEMY_STRENGTH_IS)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.STRENGTH,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ENEMY_ARMOR_IS)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.ARMOR,param1),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ENEMY_FACTION_IS)
         {
            if(_modifier == "!=")
            {
               return !_loc8_.faction == Faction.setFaction(parseInt(_variable));
            }
            return _loc8_.faction == Faction.setFaction(parseInt(_variable));
         }
         if(_conditionName == BattleLogicConditional.RANDOM_D100_IS)
         {
            return evaluateModifier(Math.round(_loc9_ * 100),_modifier,_variable);
         }
         if(_conditionName == BattleLogicConditional.ATTACK_FAILED)
         {
            return !param2;
         }
         if(_conditionName == BattleLogicConditional.MY_RED_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.RED_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.MY_RED_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.RED_SPIKE,param1),"==","0");
         }
         if(_conditionName == BattleLogicConditional.MY_BLUE_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.BLUE_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.MY_BLUE_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.BLUE_SPIKE,param1),"==","0");
         }
         if(_conditionName == BattleLogicConditional.MY_YELLOW_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.YELLOW_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.MY_YELLOW_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc7_.getModdedStat(Stat.YELLOW_SPIKE,param1),"==","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_RED_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.RED_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_RED_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.RED_SPIKE,param1),"==","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_BLUE_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.BLUE_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_BLUE_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.BLUE_SPIKE,param1),"==","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_YELLOW_SPIKE_IS_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.YELLOW_SPIKE,param1),"!=","0");
         }
         if(_conditionName == BattleLogicConditional.ENEMY_YELLOW_SPIKE_IS_NOT_SET)
         {
            return evaluateModifier(_loc8_.getModdedStat(Stat.YELLOW_SPIKE,param1),"==","0");
         }
         return false;
      }
      
      private function evaluateModifier(param1:Number, param2:String, param3:String) : Boolean
      {
         var _loc4_:int = parseInt(param3);
         if(param2 == BattleLogicConditional.MOD_LESS_THAN)
         {
            return param1 < _loc4_;
         }
         if(param2 == BattleLogicConditional.MOD_LESS_THAN_EQUAL)
         {
            return param1 <= _loc4_;
         }
         if(param2 == BattleLogicConditional.MOD_GREATER_THAN)
         {
            return param1 > _loc4_;
         }
         if(param2 == BattleLogicConditional.MOD_GREATER_THAN_EQUAL)
         {
            return param1 >= _loc4_;
         }
         if(param2 == BattleLogicConditional.MOD_EQUAL)
         {
            return param1 == _loc4_;
         }
         if(param2 == BattleLogicConditional.MOD_NOT_EQUAL)
         {
            return param1 != _loc4_;
         }
         return false;
      }
      
      public function get conditionalName() : String
      {
         return _conditionName;
      }
      
      public function evaluate(param1:Boolean, param2:BattleLogicPlayer, param3:BattleLogicPlayer, param4:Boolean = true) : Boolean
      {
         return evaluateConditional(param1,param4,param2,param3);
      }
      
      public function clone() : BattleLogicConditional
      {
         try
         {
            return new BattleLogicConditional(_conditionName,_modifier,_variable);
         }
         catch(e:Error)
         {
            trace("Error: " + e);
         }
         return null;
      }
   }
}

