package com.arkadium.virmon.framework
{
   import com.arkadium.virmon.shared.utils.IVirmon;
   
   public class Conditional
   {
      
      public static const ConditionMyHealthIs:String = "if my health is";
      
      public static const ConditionMySpeedIs:String = "if my speed is";
      
      public static const ConditionMyStrengthIs:String = "if my strength is";
      
      public static const ConditionMyArmorIs:String = "if my armor is";
      
      public static const ConditionMyFactionIs:String = "if my faction is";
      
      public static const ConditionRandomD100Is:String = "if random 1-100 is";
      
      public static const ConditionMyRedSpikeIsSet:String = "if my redspike is set";
      
      public static const ConditionMyRedSpikeIsNotSet:String = "if my redspike is not set";
      
      public static const ConditionMyYellowSpikeIsSet:String = "if my yellowspike is set";
      
      public static const ConditionMyYellowSpikeIsNotSet:String = "if my yellowspike is not set";
      
      public static const ConditionMyBlueSpikeIsSet:String = "if my bluespike is set";
      
      public static const ConditionMyBlueSpikeIsNotSet:String = "if my bluespike is not set";
      
      private var _condition:String;
      
      private var _virmon:IVirmon;
      
      private var _variable:String;
      
      private var _modifier:String;
      
      public function Conditional(param1:IVirmon, param2:String, param3:String, param4:String)
      {
         super();
         _virmon = param1;
         _condition = param2.toLowerCase();
         _modifier = param3;
         _variable = param4;
      }
      
      private function evaluateModifier(param1:Number, param2:String, param3:Number) : Boolean
      {
         switch(param2)
         {
            case "<":
               return param1 < param3;
            case "<=":
               return param1 <= param3;
            case ">":
               return param1 > param3;
            case ">=":
               return param1 >= param3;
            case "==":
               return param1 == param3;
            case "!=":
               return param1 != param3;
            default:
               return false;
         }
      }
      
      public function evaluate() : Boolean
      {
         var _loc1_:int = 0;
         switch(_condition)
         {
            case Conditional.ConditionMyHealthIs:
               return evaluateModifier(_virmon.getCurrentHealth(),_modifier,parseFloat(_variable));
            case Conditional.ConditionMySpeedIs:
               return evaluateModifier(_virmon.getSpeed(),_modifier,parseFloat(_variable));
            case Conditional.ConditionMyStrengthIs:
               return evaluateModifier(_virmon.getStrength(),_modifier,parseFloat(_variable));
            case Conditional.ConditionMyArmorIs:
               return evaluateModifier(_virmon.getArmor(),_modifier,parseFloat(_variable));
            case Conditional.ConditionMyFactionIs:
               if(_modifier == "!=")
               {
                  return _virmon.getFaction().toLowerCase() != _variable.toLowerCase();
               }
               return _virmon.getFaction().toLowerCase() == _variable.toLowerCase();
               break;
            case Conditional.ConditionRandomD100Is:
               _loc1_ = Math.floor(Math.random() * 100 + 1);
               return evaluateModifier(_loc1_,_modifier,parseFloat(_variable));
            case Conditional.ConditionMyRedSpikeIsSet:
               return evaluateModifier(Number(_virmon.getRedSpikeSet()),"!=",0);
            case Conditional.ConditionMyRedSpikeIsNotSet:
               return evaluateModifier(Number(_virmon.getRedSpikeSet()),"==",0);
            case Conditional.ConditionMyYellowSpikeIsSet:
               return evaluateModifier(Number(_virmon.getYellowSpikeSet()),"!=",0);
            case Conditional.ConditionMyYellowSpikeIsNotSet:
               return evaluateModifier(Number(_virmon.getYellowSpikeSet()),"==",0);
            case Conditional.ConditionMyBlueSpikeIsSet:
               return evaluateModifier(Number(_virmon.getBlueSpikeSet()),"!=",0);
            case Conditional.ConditionMyBlueSpikeIsNotSet:
               return evaluateModifier(Number(_virmon.getBlueSpikeSet()),"==",0);
            default:
               return false;
         }
      }
   }
}

