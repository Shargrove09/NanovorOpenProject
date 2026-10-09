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
         this._virmon = param1;
         this._condition = param2.toLowerCase();
         this._modifier = param3;
         this._variable = param4;
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
         switch(this._condition)
         {
            case Conditional.ConditionMyHealthIs:
               return this.evaluateModifier(this._virmon.getCurrentHealth(),this._modifier,parseFloat(this._variable));
            case Conditional.ConditionMySpeedIs:
               return this.evaluateModifier(this._virmon.getSpeed(),this._modifier,parseFloat(this._variable));
            case Conditional.ConditionMyStrengthIs:
               return this.evaluateModifier(this._virmon.getStrength(),this._modifier,parseFloat(this._variable));
            case Conditional.ConditionMyArmorIs:
               return this.evaluateModifier(this._virmon.getArmor(),this._modifier,parseFloat(this._variable));
            case Conditional.ConditionMyFactionIs:
               if(this._modifier == "!=")
               {
                  return this._virmon.getFaction().toLowerCase() != this._variable.toLowerCase();
               }
               return this._virmon.getFaction().toLowerCase() == this._variable.toLowerCase();
               break;
            case Conditional.ConditionRandomD100Is:
               _loc1_ = Math.floor(Math.random() * 100 + 1);
               return this.evaluateModifier(_loc1_,this._modifier,parseFloat(this._variable));
            case Conditional.ConditionMyRedSpikeIsSet:
               return this.evaluateModifier(Number(this._virmon.getRedSpikeSet()),"!=",0);
            case Conditional.ConditionMyRedSpikeIsNotSet:
               return this.evaluateModifier(Number(this._virmon.getRedSpikeSet()),"==",0);
            case Conditional.ConditionMyYellowSpikeIsSet:
               return this.evaluateModifier(Number(this._virmon.getYellowSpikeSet()),"!=",0);
            case Conditional.ConditionMyYellowSpikeIsNotSet:
               return this.evaluateModifier(Number(this._virmon.getYellowSpikeSet()),"==",0);
            case Conditional.ConditionMyBlueSpikeIsSet:
               return this.evaluateModifier(Number(this._virmon.getBlueSpikeSet()),"!=",0);
            case Conditional.ConditionMyBlueSpikeIsNotSet:
               return this.evaluateModifier(Number(this._virmon.getBlueSpikeSet()),"==",0);
            default:
               return false;
         }
      }
   }
}

