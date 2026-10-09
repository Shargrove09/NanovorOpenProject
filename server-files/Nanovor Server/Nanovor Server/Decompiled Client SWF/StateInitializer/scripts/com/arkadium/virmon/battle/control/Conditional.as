package com.arkadium.virmon.battle.control
{
   import com.smithandtinker.nanovor.common.Stat;
   
   public class Conditional implements IConditional
   {
      
      public static const NONE:String = "no conditions";
      
      public static const I_DIE:String = "if i die";
      
      public static const IM_FIRST_IN_TURN:String = "if i\'m first in turn";
      
      public static const IM_NOT_FIRST_IN_TURN:String = "if i\'m not first in turn";
      
      public static const IM_LAST_IN_TURN:String = "if i\'m last in turn";
      
      public static const MY_ENERGY_IS:String = "if my energy is";
      
      public static const MY_HEALTH_IS:String = "if my health is";
      
      public static const MY_SPEED_IS:String = "if my speed is";
      
      public static const MY_STRENGTH_IS:String = "if my strength is";
      
      public static const MY_ARMOR_IS:String = "if my armor is";
      
      public static const MY_FACTION_IS:String = "if my faction is";
      
      public static const ENEMY_DIES:String = "if enemy dies";
      
      public static const ENEMY_FIRST_IN_TURN:String = "if enemy first in turn";
      
      public static const ENEMY_NOT_FIRST_IN_TURN:String = "if enemy not first in turn";
      
      public static const ENEMY_LAST_IN_TURN:String = "if enemy last in turn";
      
      public static const ENEMY_ENERGY_IS:String = "if enemy energy is";
      
      public static const ENEMY_HEALTH_IS:String = "if enemy health is";
      
      public static const ENEMY_SPEED_IS:String = "if enemy speed is";
      
      public static const ENEMY_STRENGTH_IS:String = "if enemy strength is";
      
      public static const ENEMY_ARMOR_IS:String = "if enemy armor is";
      
      public static const ENEMY_FACTION_IS:String = "if enemy faction is";
      
      public static const RANDOM_D100_IS:String = "if random 1-100 is";
      
      public static const ATTACK_FAILED:String = "if attack failed";
      
      public static const MY_OVERRIDE_CONTAINS_STATEMENT_ID:String = "if my override contains statementid";
      
      public static const ENEMY_OVERRIDE_CONTAINS_STATEMENT_ID:String = "if opponent override contains statementid";
      
      public static const MY_RED_SPIKE_IS_SET:String = "if my redspike is set";
      
      public static const MY_RED_SPIKE_IS_NOT_SET:String = "if my redspike is not set";
      
      public static const ENEMY_RED_SPIKE_IS_SET:String = "if enemy redspike is set";
      
      public static const ENEMY_RED_SPIKE_IS_NOT_SET:String = "if enemy redspike is not set";
      
      public static const MY_YELLOW_SPIKE_IS_SET:String = "if my yellowspike is set";
      
      public static const MY_YELLOW_SPIKE_IS_NOT_SET:String = "if my yellowspike is not set";
      
      public static const ENEMY_YELLOW_SPIKE_IS_SET:String = "if enemy yellowspike is set";
      
      public static const ENEMY_YELLOW_SPIKE_IS_NOT_SET:String = "if enemy yellowspike is not set";
      
      public static const MY_BLUE_SPIKE_IS_SET:String = "if my bluespike is set";
      
      public static const MY_BLUE_SPIKE_IS_NOT_SET:String = "if my bluespike is not set";
      
      public static const ENEMY_BLUE_SPIKE_IS_SET:String = "if enemy bluespike is set";
      
      public static const ENEMY_BLUE_SPIKE_IS_NOT_SET:String = "if enemy bluespike is not set";
      
      public static const MOD_GREATER_THAN:String = ">";
      
      public static const MOD_GREATER_THAN_EQUAL:String = ">=";
      
      public static const MOD_LESS_THAN:String = "<";
      
      public static const MOD_LESS_THAN_EQUAL:String = "<=";
      
      public static const MOD_EQUAL:String = "==";
      
      public static const MOD_NOT_EQUAL:String = "!=";
      
      public static const MOD_NONE:String = "";
      
      private var _conditionalName:String;
      
      private var _variable:String;
      
      private var _modifier:String;
      
      public function Conditional()
      {
         super();
      }
      
      public static function createConditional(param1:String, param2:String, param3:String) : IConditional
      {
         var _loc4_:Conditional = new Conditional();
         _loc4_._conditionalName = param1.toLowerCase();
         _loc4_._modifier = param2.toLowerCase();
         _loc4_._variable = param3;
         if(param1 == null || param1 == "" || param1 == "no conditions")
         {
            _loc4_._conditionalName = Conditional.NONE;
         }
         if(param2 == null)
         {
            _loc4_._modifier = "";
         }
         if(param3 == null)
         {
            _loc4_._variable = "";
         }
         return _loc4_;
      }
      
      private function evaluateModifier(param1:Number, param2:String, param3:String) : Boolean
      {
         var _loc4_:int = int(param3);
         switch(param2)
         {
            case Conditional.MOD_LESS_THAN:
               return param1 < _loc4_;
            case Conditional.MOD_LESS_THAN_EQUAL:
               return param1 <= _loc4_;
            case Conditional.MOD_GREATER_THAN:
               return param1 > _loc4_;
            case Conditional.MOD_GREATER_THAN_EQUAL:
               return param1 >= _loc4_;
            case Conditional.MOD_EQUAL:
               return param1 == _loc4_;
            case Conditional.MOD_NOT_EQUAL:
               return param1 != _loc4_;
            default:
               return false;
         }
      }
      
      public function get conditionalName() : String
      {
         return this._conditionalName;
      }
      
      public function get modifier() : String
      {
         return this._modifier;
      }
      
      public function evaluate(param1:Boolean, param2:IPlayer, param3:IPlayer, param4:Boolean = true) : Boolean
      {
         var _loc5_:IPlayer = param2;
         var _loc6_:IPlayer = param3;
         var _loc7_:INanovor = _loc5_.selectedNanovor;
         var _loc8_:INanovor = _loc6_.selectedNanovor;
         var _loc9_:Number = this.getRandomFromRange(0,1);
         var _loc10_:int = int(_loc5_.energyLevel);
         var _loc11_:int = int(_loc6_.energyLevel);
         switch(this._conditionalName)
         {
            case Conditional.NONE:
               return false;
            case Conditional.ENEMY_DIES:
               if(_loc8_.health > 0)
               {
                  return false;
               }
               return true;
               break;
            case Conditional.IM_FIRST_IN_TURN:
               return param1;
            case Conditional.IM_NOT_FIRST_IN_TURN:
               return !param1;
            case Conditional.IM_LAST_IN_TURN:
               return !param1;
            case Conditional.MY_ENERGY_IS:
               return this.evaluateModifier(_loc10_,this._modifier,this._variable);
            case Conditional.MY_HEALTH_IS:
               return this.evaluateModifier(_loc7_.health,this._modifier,this._variable);
            case Conditional.MY_SPEED_IS:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.SPEED,param1),this._modifier,this._variable);
            case Conditional.MY_STRENGTH_IS:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.STRENGTH,param1),this._modifier,this._variable);
            case Conditional.MY_ARMOR_IS:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.ARMOR,param1),this._modifier,this._variable);
            case Conditional.MY_FACTION_IS:
               if(this._modifier == "!=")
               {
                  return _loc7_.faction != this._variable;
               }
               return _loc7_.faction == this._variable;
               break;
            case Conditional.ENEMY_FIRST_IN_TURN:
               return !param1;
            case Conditional.ENEMY_NOT_FIRST_IN_TURN:
               return param1;
            case Conditional.ENEMY_LAST_IN_TURN:
               return param1;
            case Conditional.ENEMY_ENERGY_IS:
               return this.evaluateModifier(_loc11_,this._modifier,this._variable);
            case Conditional.ENEMY_HEALTH_IS:
               return this.evaluateModifier(_loc8_.health,this._modifier,this._variable);
            case Conditional.ENEMY_SPEED_IS:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.SPEED,param1),this._modifier,this._variable);
            case Conditional.ENEMY_STRENGTH_IS:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.STRENGTH,param1),this._modifier,this._variable);
            case Conditional.ENEMY_ARMOR_IS:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.ARMOR,param1),this._modifier,this._variable);
            case Conditional.ENEMY_FACTION_IS:
               if(this._modifier == "!=")
               {
                  return _loc8_.faction != this._variable;
               }
               return _loc8_.faction == this._variable;
               break;
            case Conditional.RANDOM_D100_IS:
               return this.evaluateModifier(Math.round(_loc9_ * 100),this._modifier,this._variable);
            case Conditional.ATTACK_FAILED:
               return !param4;
            case Conditional.MY_RED_SPIKE_IS_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.RED_SPIKE,param1),"!=","0");
            case Conditional.MY_RED_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.RED_SPIKE,param1),"==","0");
            case Conditional.MY_BLUE_SPIKE_IS_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.BLUE_SPIKE,param1),"!=","0");
            case Conditional.MY_BLUE_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.BLUE_SPIKE,param1),"==","0");
            case Conditional.MY_YELLOW_SPIKE_IS_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.YELLOW_SPIKE,param1),"!=","0");
            case Conditional.MY_YELLOW_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc7_.getModdedStat(Stat.YELLOW_SPIKE,param1),"==","0");
            case Conditional.ENEMY_RED_SPIKE_IS_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.RED_SPIKE,param1),"!=","0");
            case Conditional.ENEMY_RED_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.RED_SPIKE,param1),"==","0");
            case Conditional.ENEMY_BLUE_SPIKE_IS_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.BLUE_SPIKE,param1),"!=","0");
            case Conditional.ENEMY_BLUE_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.BLUE_SPIKE,param1),"==","0");
            case Conditional.ENEMY_YELLOW_SPIKE_IS_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.YELLOW_SPIKE,param1),"!=","0");
            case Conditional.ENEMY_YELLOW_SPIKE_IS_NOT_SET:
               return this.evaluateModifier(_loc8_.getModdedStat(Stat.YELLOW_SPIKE,param1),"==","0");
            default:
               return false;
         }
      }
      
      private function getRandomFromRange(param1:int, param2:int) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      public function get variable() : String
      {
         return this._variable;
      }
      
      public function canEvaluatePreview(param1:IPlayer, param2:IPlayer, param3:Boolean = true) : Boolean
      {
         switch(this._conditionalName)
         {
            case Conditional.ATTACK_FAILED:
               return param3;
            case Conditional.NONE:
            case Conditional.MY_ENERGY_IS:
            case Conditional.MY_HEALTH_IS:
            case Conditional.MY_SPEED_IS:
            case Conditional.MY_STRENGTH_IS:
            case Conditional.MY_ARMOR_IS:
            case Conditional.MY_FACTION_IS:
            case Conditional.ENEMY_ENERGY_IS:
            case Conditional.ENEMY_HEALTH_IS:
            case Conditional.ENEMY_SPEED_IS:
            case Conditional.ENEMY_STRENGTH_IS:
            case Conditional.ENEMY_ARMOR_IS:
            case Conditional.ENEMY_FACTION_IS:
            case Conditional.MY_RED_SPIKE_IS_SET:
            case Conditional.MY_RED_SPIKE_IS_NOT_SET:
            case Conditional.MY_BLUE_SPIKE_IS_SET:
            case Conditional.MY_BLUE_SPIKE_IS_NOT_SET:
            case Conditional.MY_YELLOW_SPIKE_IS_SET:
            case Conditional.MY_YELLOW_SPIKE_IS_NOT_SET:
            case Conditional.ENEMY_RED_SPIKE_IS_SET:
            case Conditional.ENEMY_RED_SPIKE_IS_NOT_SET:
            case Conditional.ENEMY_BLUE_SPIKE_IS_SET:
            case Conditional.ENEMY_BLUE_SPIKE_IS_NOT_SET:
            case Conditional.ENEMY_YELLOW_SPIKE_IS_SET:
            case Conditional.ENEMY_YELLOW_SPIKE_IS_NOT_SET:
               return true;
            case Conditional.ENEMY_DIES:
            case Conditional.IM_FIRST_IN_TURN:
            case Conditional.IM_NOT_FIRST_IN_TURN:
            case Conditional.IM_LAST_IN_TURN:
            case Conditional.ENEMY_FIRST_IN_TURN:
            case Conditional.ENEMY_NOT_FIRST_IN_TURN:
            case Conditional.ENEMY_LAST_IN_TURN:
            case Conditional.RANDOM_D100_IS:
         }
         return false;
      }
   }
}

