package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.Conditional;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.smithandtinker.nanovor.common.Stat;
   
   public class SenseiNanovor extends AbstractSenseiNanovor implements ISenseiNanovor
   {
      
      public function SenseiNanovor(param1:INanovor)
      {
         super(param1);
      }
      
      private function isDamageAttack(param1:IAttackStatement) : Boolean
      {
         if(AttackStatementTypes.TYPE_DAMAGE != param1.type)
         {
            return false;
         }
         if(Stat.HEALTH != param1.stat)
         {
            return false;
         }
         if(AttackStatementTypes.TARGET_ENEMY_NANOVOR == param1.target)
         {
            return true;
         }
         if(AttackStatementTypes.TARGET_ENEMY_TEAM == param1.target)
         {
            return true;
         }
         return false;
      }
      
      private function isAttackStatementApplicableToDamageCalculation(param1:IAttack, param2:IAttackStatement) : Boolean
      {
         if(param1.attackStatements.length == 1)
         {
            return true;
         }
         if(null == param1.conditional)
         {
            return true;
         }
         if(Conditional.NONE == param1.conditional.conditionalName)
         {
            return true;
         }
         if(param2.name.indexOf("FAIL") != -1)
         {
            return true;
         }
         return true;
      }
      
      private function calculateDamageAttackExpectedDamage(param1:INanovor, param2:IAttack, param3:IAttackStatement) : Boolean
      {
         if(false == isAttackStatementApplicableToDamageCalculation(param2,param3))
         {
            return false;
         }
         if(param1 == null)
         {
            param2.expectedDamage += param3.calculateBaseFormula(this,param1);
            return true;
         }
         var _loc4_:Number = 0;
         _loc4_ = Number(param3.calculateBaseFormula(this,param1));
         if(faction == param1.faction)
         {
            param2.expectedDamage += _loc4_ * 0.85 + _loc4_ * 2 * 0.1 + _loc4_ * 0.25 * 0.5;
         }
         else if(isSenseiFactionAdvantage(param1))
         {
            param2.expectedDamage += _loc4_ * 0.75 + _loc4_ * 2 * 0.24;
         }
         else
         {
            param2.expectedDamage += _loc4_ * 0.84 + _loc4_ * 2 * 0.01 + _loc4_ * 0.25 * 0.15;
         }
         if(isArmorPiercingAttackStatement(param3))
         {
            param2.expectedDamage -= param1.armor;
         }
         return true;
      }
      
      private function calculateHackED(param1:INanovor, param2:IAttack, param3:IAttackStatement, param4:uint, param5:uint, param6:Number, param7:Number) : Boolean
      {
         var _loc10_:Number = NaN;
         if(AttackStatementTypes.TYPE_HACK == param3.type)
         {
            _loc10_ = Number(param3.calculateDamage(this,param1));
         }
         var _loc8_:int = int(owner.energyLevel);
         var _loc9_:int = int(owner.energyGenerator);
         switch(param3.name)
         {
            case "Chance ARM -15 50% (3R)":
               if(param1.armor >= 15)
               {
                  if(param4 * 15 < 45)
                  {
                     param2.expectedDamage += (_loc10_ + param4 * 15) / 2;
                     return true;
                  }
                  param2.expectedDamage += (_loc10_ + 45) / 2;
                  return true;
               }
               if(param4 < 3)
               {
                  param2.expectedDamage += (_loc10_ + (15 - Number(param1.armor)) * param4) / 2;
                  return true;
               }
               param2.expectedDamage += (_loc10_ + (15 - Number(param1.armor)) * 3) / 2;
               return true;
               break;
            case "Opp ARM -5 (2R)":
               if(param1.armor >= 5)
               {
                  param2.expectedDamage += _loc10_ + 10;
                  return true;
               }
               param2.expectedDamage += _loc10_ + (5 - Number(param1.armor)) * 2;
               return true;
               break;
            case "Opp ARM -10 (5R)":
               if(param1.armor >= 10)
               {
                  if(param4 * 10 < 50)
                  {
                     param2.expectedDamage += _loc10_ + param4 * 10;
                  }
                  else
                  {
                     param2.expectedDamage += _loc10_ + 50;
                  }
               }
               else if(param4 < 5)
               {
                  param2.expectedDamage += _loc10_ + (10 - Number(param1.armor)) * param4;
               }
               else
               {
                  param2.expectedDamage += _loc10_ + (10 - Number(param1.armor)) * 5;
               }
               return true;
            case "STR +5 (10R)":
               param2.expectedDamage += _loc10_ + 10 * (param4 - 1) / param5;
               return true;
            case "If Opp Mag, STR +25 (3R)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.25 * (param4 - (param2.cost - _loc8_) / _loc9_ + 1);
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.25 * ((param4 - 1) / 3 * 2);
                  }
                  return true;
               }
               break;
            case "If first, STR +15 (2R)":
               if(!isNaN(param6))
               {
                  if(health / param7 < 2)
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.15 * (health / param7) / 2;
                  }
                  else
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.15 * 2 / 2;
                  }
                  return true;
               }
         }
         return false;
      }
      
      private function isArmorPiercingAttackStatement(param1:IAttackStatement) : Boolean
      {
         return param1.name.indexOf("AP") != -1;
      }
      
      override public function calculateOverallExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void
      {
         var _loc10_:IAttack = null;
         var _loc11_:IAttack = null;
         var _loc12_:IAttack = null;
         var _loc13_:IAttackStatement = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         if(isDead)
         {
            _overallEnergyDamage = 0;
            return;
         }
         var _loc6_:Number = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Array = new Array();
         var _loc9_:Number = 0;
         for each(_loc10_ in attacks)
         {
            _loc10_.expectedDamage = 0;
         }
         for each(_loc11_ in attacks)
         {
            for each(_loc13_ in _loc11_.attackStatements)
            {
               if(isDamageAttack(_loc13_))
               {
                  _loc7_ = calculateDamageAttackExpectedDamage(param1,_loc11_,_loc13_);
               }
               else if(null != param1)
               {
                  _loc14_ = calculateHackED(param1,_loc11_,_loc13_,param2,param3,param4,param5);
                  _loc15_ = calculateModED(param1,_loc11_,_loc13_,param2,param3,param4,param5);
                  _loc7_ = _loc7_ ? _loc7_ : _loc14_;
                  _loc7_ = _loc7_ ? _loc7_ : _loc15_;
               }
            }
            if(_loc7_)
            {
               _loc8_.push(_loc11_);
            }
         }
         for each(_loc12_ in _loc8_)
         {
            _loc6_ += _loc12_.expectedDamage;
         }
         _loc9_ = _loc6_ / _loc8_.length;
         _overallEnergyDamage = isNaN(_loc9_) ? 0 : _loc9_;
         _overallEnergyDamage = checkNegativeNumbers(_overallEnergyDamage);
      }
      
      private function calculateOverrideED(param1:INanovor, param2:IAttack, param3:IAttackStatement, param4:uint, param5:uint, param6:Number, param7:Number) : Boolean
      {
         var _loc8_:int = int(owner.energyLevel);
         var _loc9_:int = int(owner.energyGenerator);
         switch(param3.name)
         {
            case "STR +10 (OR)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.1 * (param4 - (param2.cost - _loc8_) / _loc9_ + 1);
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.1 * (param4 - 1);
                  }
                  return true;
               }
               break;
            case "STR +15 (OR)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.15 * (param4 - (param2.cost - _loc8_) / _loc9_ + 1);
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.15 * (param4 - 1);
                  }
                  return true;
               }
               break;
            case "STR +20 (OR)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.2 * (param4 - (param2.cost - _loc8_) / _loc9_ + 1);
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.2 * (param4 - 1);
                  }
                  return true;
               }
               break;
            case "If Opp is Hex, +25 STR (OR)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.25 * ((param4 - (param2.cost - _loc8_) / _loc9_ + 1) / 3);
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.25 * ((param4 - 1) / 3);
                  }
                  return true;
               }
               break;
            case "If Opp is not Mag, STR +25 (OR)":
               if(!isNaN(param6))
               {
                  if(param2.cost > _loc8_)
                  {
                     param2.expectedDamage += param6 * 1.25 * ((param4 - (param2.cost - _loc8_) / _loc9_ + 1) / 3) * 2;
                  }
                  else
                  {
                     param2.expectedDamage += param6 * 1.25 * ((param4 - 1) / 3) * 2;
                  }
                  return true;
               }
               break;
            case "If HTH<40, STR +50 (OR)":
               if(!isNaN(param6))
               {
                  param2.expectedDamage += param6 * 1.5 * (param5 * (40 / param7));
                  return true;
               }
               break;
            case "If HTH<80, STR +25 (OR)":
               if(!isNaN(param6))
               {
                  param2.expectedDamage += param6 * 1.25 * (param5 * (80 / param7));
                  return true;
               }
               break;
            case "If Mag and last, STR +25 (OR)":
               if(!isNaN(param6))
               {
                  param2.expectedDamage += param6 * 1.25 * (param4 / 3 * 0.5);
                  return true;
               }
         }
         return false;
      }
      
      private function isSenseiFactionAdvantage(param1:INanovor) : Boolean
      {
         if(NanovorFaction.MAGNAMOD == faction && NanovorFaction.VELOCITRON == param1.faction)
         {
            return true;
         }
         if(NanovorFaction.VELOCITRON == faction && NanovorFaction.HEXITE == param1.faction)
         {
            return true;
         }
         if(NanovorFaction.HEXITE == faction && NanovorFaction.MAGNAMOD == param1.faction)
         {
            return true;
         }
         return false;
      }
      
      override public function calculateRemainingExpectedDamage(param1:ISenseiNanovor, param2:uint, param3:uint, param4:Number, param5:Number) : void
      {
         var _loc10_:IAttack = null;
         var _loc11_:IAttackStatement = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         if(isDead)
         {
            return;
         }
         if(0 == attacks.length)
         {
            return;
         }
         var _loc6_:Number = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Array = new Array();
         var _loc9_:Number = 0;
         for each(_loc10_ in attacks)
         {
            for each(_loc11_ in _loc10_.attackStatements)
            {
               _loc12_ = calculateOverrideED(param1,_loc10_,_loc11_,param2,param3,param4,param5);
               _loc7_ = _loc7_ ? _loc7_ : _loc12_;
               if(null != param1)
               {
                  _loc13_ = calculateModED(param1,_loc10_,_loc11_,param2,param3,param4,param5);
                  _loc7_ = _loc7_ ? _loc7_ : _loc13_;
               }
            }
         }
      }
      
      private function calculateModED(param1:INanovor, param2:IAttack, param3:IAttackStatement, param4:uint, param5:uint, param6:Number, param7:Number) : Boolean
      {
         var _loc10_:Number = NaN;
         if(AttackStatementTypes.TYPE_MOD == param3.type)
         {
            _loc10_ = Number(param3.calculateDamage(this,param1));
         }
         var _loc8_:int = int(owner.energyLevel);
         var _loc9_:int = int(owner.energyGenerator);
         switch(param3.name)
         {
            case "Opp ARM -5 (Mod)":
               param2.expectedDamage += _loc10_ + 5 * (param4 - 1) / param5;
               return true;
            case "Opp ARM -10 (Mod)":
               param2.expectedDamage += _loc10_ + 10 * (param4 - 1) / param5;
               return true;
            case "If not first, Me +25 STR (Mod)":
               if(!isNaN(param6))
               {
                  if(health / param7 < param4 / 4)
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.25 * (health / param7) / 2;
                  }
                  else
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.15 * (param4 / 2) / 2;
                  }
                  return true;
               }
               break;
            case "Me STR +10 (Mod)":
               if(!isNaN(param7))
               {
                  if(param4 < health / param7)
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.1 * param4;
                  }
                  else
                  {
                     param2.expectedDamage += _loc10_ + overallExpectedDamage * 1.1 * (health / param7);
                  }
                  return true;
               }
         }
         return false;
      }
      
      private function checkNegativeNumbers(param1:*) : Number
      {
         return param1 < 0 ? 0 : param1;
      }
   }
}

