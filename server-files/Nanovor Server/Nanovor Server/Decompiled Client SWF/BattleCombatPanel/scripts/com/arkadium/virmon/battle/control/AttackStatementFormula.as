package com.arkadium.virmon.battle.control
{
   import com.smithandtinker.nanovor.common.Stat;
   
   public class AttackStatementFormula implements IAttackStatementFormula
   {
      
      public static const VAR_MY_HEALTH:String = "$MyHealth";
      
      public static const VAR_MY_HEALTH_FULL:String = "$MyHealthFull";
      
      public static const VAR_MY_STRENGTH:String = "$MyStrength";
      
      public static const VAR_MY_SPEED:String = "$MySpeed";
      
      public static const VAR_MY_ARMOR:String = "$MyArmor";
      
      public static const VAR_MY_ENERGY_GEN:String = "$MyEnergyGen";
      
      public static const VAR_MY_ENERGY:String = "$MyEnergy";
      
      public static const VAR_MY_FACTION_BONUS:String = "$MyFactionBonus";
      
      public static const VAR_MY_CRIT_MODIFIER:String = "$MyCritModifier";
      
      public static const VAR_MY_DAMAGE_TAKEN_THIS_ROUND:String = "$MyDamageTakenThisRound";
      
      public static const VAR_ENEMY_HEALTH:String = "$EnemyHealth";
      
      public static const VAR_ENEMY_HEALTH_FULL:String = "$EnemyHealthFull";
      
      public static const VAR_ENEMY_STRENGTH:String = "$EnemyStrength";
      
      public static const VAR_ENEMY_SPEED:String = "$EnemySpeed";
      
      public static const VAR_ENEMY_ARMOR:String = "$EnemyArmor";
      
      public static const VAR_ENEMY_ENERGY_GEN:String = "$EnemyEnergyGen";
      
      public static const VAR_ENEMY_ENERGY:String = "$EnemyEnergy";
      
      public static const VAR_ENEMY_FACTION_BONUS:String = "$EnemyFactionBonus";
      
      public static const VAR_ENEMY_CRIT_MODIFIER:String = "$EnemyCritModifier";
      
      public static const VAR_ENEMY_DAMAGE_TAKEN_THIS_ROUND:String = "$EnemyDamageTakenThisRound";
      
      public static const VAR_D4:String = "$D4";
      
      public static const VAR_D6:String = "$D6";
      
      public static const VAR_D10:String = "$D10";
      
      public static const VAR_D20:String = "$D20";
      
      public static const VAR_D30:String = "$D30";
      
      public static const VAR_D100:String = "$D100";
      
      public static const VAR_5_D20:String = "$5D20";
      
      public static const VAR_10_D20:String = "$10D20";
      
      public static const VAR_STATEMENT_BASE_DAMAGE:String = "$StatementBaseDamage";
      
      private var _formula:String;
      
      private var _rolls:Array;
      
      public function AttackStatementFormula()
      {
         super();
         _formula = "";
         _rolls = new Array();
      }
      
      public static function performOperation(param1:Number, param2:String, param3:Number) : Number
      {
         var _loc4_:Number = 0;
         switch(param2)
         {
            case "*":
               _loc4_ = param1 * param3;
               break;
            case "/":
               if(param3 != 0)
               {
                  _loc4_ = param1 / param3;
                  break;
               }
               _loc4_ = 0;
               break;
            case "+":
               _loc4_ = param1 + param3;
               break;
            case "-":
               _loc4_ = param1 - param3;
               break;
            case "=":
               _loc4_ = param3;
               break;
            default:
               _loc4_ = 0;
         }
         return _loc4_;
      }
      
      public static function createAttackStatementFormula(param1:String) : IAttackStatementFormula
      {
         var _loc2_:AttackStatementFormula = new AttackStatementFormula();
         if(param1 == null || param1 == "")
         {
            param1 = "0";
         }
         _loc2_._formula = param1;
         return _loc2_;
      }
      
      public function getVariables() : Array
      {
         var _loc4_:String = null;
         var _loc1_:Array = new Array();
         var _loc2_:RegExp = /\$\w+/g;
         var _loc3_:Array = _formula.match(_loc2_);
         if(_loc3_ != null)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc1_.push(_loc4_);
            }
         }
         return _loc1_;
      }
      
      private function calculateVariable(param1:INanovor, param2:INanovor, param3:IAttackStatement, param4:String) : Number
      {
         var _loc5_:INanovor = param1;
         var _loc6_:INanovor = param2;
         if(_loc6_ == null)
         {
            _loc6_ = null;
         }
         switch(param4)
         {
            case AttackStatementFormula.VAR_MY_HEALTH:
               return _loc5_.getModdedStat(Stat.HEALTH,false);
            case AttackStatementFormula.VAR_MY_HEALTH_FULL:
               return _loc5_.getModdedStat(Stat.HEALTH,false);
            case AttackStatementFormula.VAR_MY_STRENGTH:
               return _loc5_.getModdedStat(Stat.STRENGTH,false);
            case AttackStatementFormula.VAR_MY_SPEED:
               return _loc5_.getModdedStat(Stat.SPEED,false);
            case AttackStatementFormula.VAR_MY_ARMOR:
               return _loc5_.getModdedStat(Stat.ARMOR,false);
            case AttackStatementFormula.VAR_MY_ENERGY_GEN:
            case AttackStatementFormula.VAR_MY_ENERGY:
            case AttackStatementFormula.VAR_MY_FACTION_BONUS:
            case AttackStatementFormula.VAR_MY_DAMAGE_TAKEN_THIS_ROUND:
               break;
            case AttackStatementFormula.VAR_MY_CRIT_MODIFIER:
               return 0;
            case AttackStatementFormula.VAR_ENEMY_HEALTH:
               return _loc6_.getModdedStat(Stat.HEALTH,false);
            case AttackStatementFormula.VAR_ENEMY_HEALTH_FULL:
               return _loc6_.getModdedStat(Stat.HEALTH,false);
            case AttackStatementFormula.VAR_ENEMY_STRENGTH:
               return _loc6_.getModdedStat(Stat.STRENGTH,false);
            case AttackStatementFormula.VAR_ENEMY_SPEED:
               return _loc6_.getModdedStat(Stat.SPEED,false);
            case AttackStatementFormula.VAR_ENEMY_ARMOR:
               return _loc6_.getModdedStat(Stat.ARMOR,false);
            case AttackStatementFormula.VAR_ENEMY_ENERGY_GEN:
               break;
            case AttackStatementFormula.VAR_ENEMY_ENERGY:
               return _loc6_.getModdedStat(Stat.ENERGY,false);
            case AttackStatementFormula.VAR_ENEMY_FACTION_BONUS:
            case AttackStatementFormula.VAR_ENEMY_DAMAGE_TAKEN_THIS_ROUND:
               break;
            case AttackStatementFormula.VAR_ENEMY_CRIT_MODIFIER:
               return 0;
            case AttackStatementFormula.VAR_D4:
               return getRandomFromRange(1,5);
            case AttackStatementFormula.VAR_D6:
               return getRandomFromRange(1,7);
            case AttackStatementFormula.VAR_D10:
               return getRandomFromRange(1,11);
            case AttackStatementFormula.VAR_D20:
               return getRandomFromRange(1,21);
            case AttackStatementFormula.VAR_D30:
               return getRandomFromRange(1,31);
            case AttackStatementFormula.VAR_D100:
               return getRandomFromRange(1,101);
            case AttackStatementFormula.VAR_5_D20:
               return d20(5);
            case AttackStatementFormula.VAR_10_D20:
               return d20(10);
            case AttackStatementFormula.VAR_STATEMENT_BASE_DAMAGE:
               return param3.baseDamageFormula.solve(param3,param1,param2);
         }
         return 0;
      }
      
      private function isRollVariable(param1:String) : Boolean
      {
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_ == AttackStatementFormula.VAR_MY_CRIT_MODIFIER.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_ENEMY_CRIT_MODIFIER.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D4.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D6.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D10.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D20.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D30.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_D100.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_5_D20.toLowerCase() || _loc2_ == AttackStatementFormula.VAR_10_D20.toLowerCase())
         {
            return true;
         }
         return false;
      }
      
      private function d20(param1:int) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += getRandomFromRange(1,21);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getFormula() : String
      {
         return _formula;
      }
      
      private function solveSegment(param1:String) : Number
      {
         var _loc3_:RegExp = null;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc2_:String = param1.replace(/\(|\)/g,"");
         _loc3_ = new RegExp("([\\d\\.]+)\\s*(\\*|/)\\s*([\\d\\.]+)");
         _loc4_ = _loc2_.match(_loc3_);
         while(_loc4_ != null)
         {
            _loc5_ = parseFloat(_loc4_[1]);
            _loc6_ = parseFloat(_loc4_[3]);
            _loc7_ = _loc4_[2];
            _loc8_ = performOperation(_loc5_,_loc7_,_loc6_);
            _loc2_ = _loc2_.replace(_loc4_[0],String(_loc8_));
            _loc4_ = _loc2_.match(_loc3_);
         }
         _loc3_ = /([\d\.]+)\s*(\+|-)\s*([\d\.]+)/;
         _loc4_ = _loc2_.match(_loc3_);
         while(_loc4_ != null)
         {
            _loc5_ = parseFloat(_loc4_[1]);
            _loc6_ = parseFloat(_loc4_[3]);
            _loc7_ = _loc4_[2];
            _loc8_ = performOperation(_loc5_,_loc7_,_loc6_);
            _loc2_ = _loc2_.replace(_loc4_[0],String(_loc8_));
            _loc4_ = _loc2_.match(_loc3_);
         }
         return parseFloat(_loc2_);
      }
      
      private function evaluate(param1:String) : Number
      {
         var _loc5_:Number = NaN;
         var _loc2_:String = param1;
         var _loc3_:RegExp = /\([^\)\(]*\)/;
         var _loc4_:Array = _loc2_.match(_loc3_);
         while(_loc4_ != null)
         {
            _loc5_ = solveSegment(_loc4_[0]);
            _loc2_ = _loc2_.replace(_loc4_[0],String(_loc5_));
            _loc4_ = _loc2_.match(_loc3_);
         }
         return solveSegment(_loc2_);
      }
      
      private function getRandomFromRange(param1:int, param2:int) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      private function substitueVariables(param1:INanovor, param2:INanovor, param3:IAttackStatement) : String
      {
         var _loc7_:Number = NaN;
         var _loc4_:String = _formula;
         var _loc5_:Array = _rolls;
         var _loc6_:Array = getVariables();
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            if(isRollVariable(_loc6_[_loc8_]))
            {
               if(_loc5_.length > 0)
               {
                  _loc7_ = Number(_loc5_.pop());
               }
               else
               {
                  _loc7_ = calculateVariable(param1,param2,param3,_loc6_[_loc8_]);
               }
            }
            else
            {
               _loc7_ = calculateVariable(param1,param2,param3,_loc6_[_loc8_]);
            }
            _loc4_ = _loc4_.replace(_loc6_[_loc8_],_loc7_);
            _loc8_++;
         }
         return _loc4_;
      }
      
      public function solve(param1:IAttackStatement, param2:INanovor = null, param3:INanovor = null) : Number
      {
         var _loc4_:INanovor = param2;
         var _loc5_:INanovor = param3;
         var _loc6_:String = _formula;
         _loc6_ = substitueVariables(_loc4_,_loc5_,param1);
         return evaluate(_loc6_);
      }
   }
}

