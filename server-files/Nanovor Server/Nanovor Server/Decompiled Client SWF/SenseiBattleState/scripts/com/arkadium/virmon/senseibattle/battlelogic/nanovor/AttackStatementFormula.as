package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   import com.arkadium.virmon.senseibattle.battlelogic.GameMath;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class AttackStatementFormula
   {
      
      public static var VAR_MY_HEALTH:String = "$MyHealth";
      
      public static var VAR_MY_HEALTH_FULL:String = "$MyHealthFull";
      
      public static var VAR_MY_STRENGTH:String = "$MyStrength";
      
      public static var VAR_MY_SPEED:String = "$MySpeed";
      
      public static var VAR_MY_ARMOR:String = "$MyArmor";
      
      public static var VAR_MY_ENERGY_GEN:String = "$MyEnergyGen";
      
      public static var VAR_MY_ENERGY:String = "$MyEnergy";
      
      public static var VAR_MY_FACTION_BONUS:String = "$MyFactionBonus";
      
      public static var VAR_MY_CRIT_MODIFIER:String = "$MyCritModifier";
      
      public static var VAR_MY_DAMAGE_TAKEN_THIS_ROUND:String = "$MyDamageTakenThisRound";
      
      public static var VAR_ENEMY_HEALTH:String = "$EnemyHealth";
      
      public static var VAR_ENEMY_HEALTH_FULL:String = "$EnemyHealthFull";
      
      public static var VAR_ENEMY_STRENGTH:String = "$EnemyStrength";
      
      public static var VAR_ENEMY_SPEED:String = "$EnemySpeed";
      
      public static var VAR_ENEMY_ARMOR:String = "$EnemyArmor";
      
      public static var VAR_ENEMY_ENERGY_GEN:String = "$EnemyEnergyGen";
      
      public static var VAR_ENEMY_ENERGY:String = "$EnemyEnergy";
      
      public static var VAR_ENEMY_FACTION_BONUS:String = "$EnemyFactionBonus";
      
      public static var VAR_ENEMY_CRIT_MODIFIER:String = "$EnemyCritModifier";
      
      public static var VAR_ENEMY_DAMAGE_TAKEN_THIS_ROUND:String = "$EnemyDamageTakenThisRound";
      
      public static var VAR_D4:String = "$D4";
      
      public static var VAR_D6:String = "$D6";
      
      public static var VAR_D10:String = "$D10";
      
      public static var VAR_D20:String = "$D20";
      
      public static var VAR_D30:String = "$D30";
      
      public static var VAR_D100:String = "$D100";
      
      public static var VAR_5_D20:String = "$5D20";
      
      public static var VAR_10_D20:String = "$10D20";
      
      public static var VAR_STATEMENT_BASE_DAMAGE:String = "$StatementBaseDamage";
      
      private var _formula:String;
      
      private var _rolls:Array;
      
      public function AttackStatementFormula(param1:String)
      {
         super();
         _formula = param1;
         if(_formula == null || _formula == "")
         {
            _formula = "0";
         }
         _rolls = new Array();
      }
      
      public static function performOperation(param1:Number, param2:String, param3:Number) : Number
      {
         var _loc4_:Number = NaN;
         if(param2 == "*")
         {
            _loc4_ = param1 * param3;
         }
         else if(param2 == "/")
         {
            if(param3 != 0)
            {
               _loc4_ = param1 / param3;
            }
            else
            {
               _loc4_ = 0;
            }
         }
         else if(param2 == "+")
         {
            _loc4_ = param1 + param3;
         }
         else if(param2 == "-")
         {
            _loc4_ = param1 - param3;
            DebugLog.instance.log("DAMAGE CALCULATED: " + param1 + " - " + param3 + " = " + _loc4_);
         }
         else if(param2 == "=")
         {
            _loc4_ = param3;
         }
         else
         {
            _loc4_ = 0;
         }
         return _loc4_;
      }
      
      private function getVariables(param1:String, param2:Boolean) : Array
      {
         var _loc6_:String = null;
         var _loc3_:Array = new Array();
         var _loc4_:RegExp = /\$\w+/g;
         var _loc5_:Array = _formula.match(_loc4_);
         if(_loc5_ != null)
         {
            for each(_loc6_ in _loc5_)
            {
               _loc3_.push(_loc6_);
            }
         }
         return _loc3_;
      }
      
      private function calculateVariable(param1:BattleLogicNanovor, param2:BattleLogicNanovor, param3:BattleLogicAttackStatement, param4:String) : Number
      {
         var _loc5_:BattleLogicNanovor = param1;
         var _loc6_:BattleLogicNanovor = param2;
         if(_loc6_ == null)
         {
            _loc6_ = new BattleLogicNanovor();
         }
         if(param4 == AttackStatementFormula.VAR_MY_HEALTH)
         {
            return _loc5_.getModdedStat(Stat.HEALTH,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_HEALTH_FULL)
         {
            return _loc5_.getModdedStat(Stat.HEALTH,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_STRENGTH)
         {
            return _loc5_.getModdedStat(Stat.STRENGTH,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_SPEED)
         {
            return _loc5_.getModdedStat(Stat.SPEED,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_ARMOR)
         {
            return _loc5_.getModdedStat(Stat.ARMOR,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_ENERGY_GEN)
         {
            return _loc5_.getModdedStat(Stat.ENERGY_GENERATOR,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_ENERGY)
         {
            return _loc5_.getModdedStat(Stat.ENERGY,false);
         }
         if(param4 == AttackStatementFormula.VAR_MY_FACTION_BONUS)
         {
            return Faction.calculateFactionBonus(_loc5_,_loc6_);
         }
         if(param4 != AttackStatementFormula.VAR_MY_DAMAGE_TAKEN_THIS_ROUND)
         {
            if(param4 == AttackStatementFormula.VAR_MY_CRIT_MODIFIER)
            {
               return 0;
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_HEALTH)
            {
               return _loc6_.getModdedStat(Stat.HEALTH,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_HEALTH_FULL)
            {
               return _loc6_.getModdedStat(Stat.HEALTH,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_STRENGTH)
            {
               return _loc6_.getModdedStat(Stat.STRENGTH,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_SPEED)
            {
               return _loc6_.getModdedStat(Stat.SPEED,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_ARMOR)
            {
               return _loc6_.getModdedStat(Stat.ARMOR,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_ENERGY_GEN)
            {
               return _loc6_.getModdedStat(Stat.ENERGY_GENERATOR,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_ENERGY)
            {
               return _loc6_.getModdedStat(Stat.ENERGY,false);
            }
            if(param4 == AttackStatementFormula.VAR_ENEMY_FACTION_BONUS)
            {
               return Faction.calculateFactionBonus(_loc6_,_loc5_);
            }
            if(param4 != AttackStatementFormula.VAR_ENEMY_DAMAGE_TAKEN_THIS_ROUND)
            {
               if(param4 == AttackStatementFormula.VAR_ENEMY_CRIT_MODIFIER)
               {
                  return 0;
               }
               if(param4 == AttackStatementFormula.VAR_D4)
               {
                  return GameMath.getRandomFromRange(1,5);
               }
               if(param4 == AttackStatementFormula.VAR_D6)
               {
                  return GameMath.getRandomFromRange(1,7);
               }
               if(param4 == AttackStatementFormula.VAR_D10)
               {
                  return GameMath.getRandomFromRange(1,11);
               }
               if(param4 == AttackStatementFormula.VAR_D20)
               {
                  return GameMath.getRandomFromRange(1,21);
               }
               if(param4 == AttackStatementFormula.VAR_D30)
               {
                  return GameMath.getRandomFromRange(1,31);
               }
               if(param4 == AttackStatementFormula.VAR_D100)
               {
                  return GameMath.getRandomFromRange(1,101);
               }
               if(param4 == AttackStatementFormula.VAR_5_D20)
               {
                  return d20(5);
               }
               if(param4 == AttackStatementFormula.VAR_10_D20)
               {
                  return d20(10);
               }
               if(param4 == AttackStatementFormula.VAR_STATEMENT_BASE_DAMAGE)
               {
                  return param3.baseDamageFormula.solve(param3);
               }
            }
         }
         return 0;
      }
      
      private function isRollVariable(param1:String) : Boolean
      {
         if(param1 == AttackStatementFormula.VAR_MY_CRIT_MODIFIER.toLowerCase() || param1 == AttackStatementFormula.VAR_ENEMY_CRIT_MODIFIER.toLowerCase() || param1 == AttackStatementFormula.VAR_D4.toLowerCase() || param1 == AttackStatementFormula.VAR_D6.toLowerCase() || param1 == AttackStatementFormula.VAR_D10.toLowerCase() || param1 == AttackStatementFormula.VAR_D20.toLowerCase() || param1 == AttackStatementFormula.VAR_D30.toLowerCase() || param1 == AttackStatementFormula.VAR_D100.toLowerCase() || param1 == AttackStatementFormula.VAR_5_D20.toLowerCase() || param1 == AttackStatementFormula.VAR_10_D20.toLowerCase())
         {
            return true;
         }
         return false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicNanovor>>\t" + param1);
      }
      
      private function d20(param1:int) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += GameMath.getRandomFromRange(1,21);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function solveSegment(param1:String) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = param1.replace(/\(|\)/g,"");
         var _loc7_:RegExp = new RegExp("([\\d\\.]+)\\s*(\\*|/)\\s*([\\d\\.]+)");
         var _loc8_:Array = _loc6_.match(_loc7_);
         while(_loc8_ != null)
         {
            _loc2_ = parseFloat(_loc8_[1]);
            _loc3_ = parseFloat(_loc8_[3]);
            _loc5_ = _loc8_[2];
            _loc4_ = performOperation(_loc2_,_loc5_,_loc3_);
            _loc6_ = _loc6_.replace(_loc8_[0],String(_loc4_));
            _loc8_ = _loc6_.match(_loc7_);
         }
         _loc7_ = /([\d\.]+)\s*(\+|-)\s*([\d\.]+)/;
         _loc8_ = _loc6_.match(_loc7_);
         while(_loc8_ != null)
         {
            _loc2_ = parseFloat(_loc8_[1]);
            _loc3_ = parseFloat(_loc8_[3]);
            _loc5_ = _loc8_[2];
            _loc4_ = performOperation(_loc2_,_loc5_,_loc3_);
            _loc6_ = _loc6_.replace(_loc8_[0],String(_loc4_));
            _loc8_ = _loc6_.match(_loc7_);
         }
         return parseFloat(_loc6_);
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
      
      private function substitueVariables(param1:BattleLogicNanovor, param2:BattleLogicNanovor, param3:BattleLogicAttackStatement) : String
      {
         var _loc7_:Number = NaN;
         var _loc4_:String = _formula;
         var _loc5_:Array = _rolls;
         var _loc6_:Array = getVariables(_loc4_,false);
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            if(isRollVariable(_loc6_[_loc8_]))
            {
               if(_loc5_.length > 0)
               {
                  _loc7_ = _loc5_.pop();
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
      
      public function clone() : AttackStatementFormula
      {
         return new AttackStatementFormula(_formula);
      }
      
      public function solve(param1:BattleLogicAttackStatement, param2:BattleLogicNanovor = null) : Number
      {
         var _loc3_:BattleLogicNanovor = param1.currentAttacker.selectedNanovor;
         var _loc4_:BattleLogicNanovor = null == param2 ? param1.currentEnemy.selectedNanovor : param2;
         var _loc5_:String = _formula;
         _loc5_ = substitueVariables(_loc3_,_loc4_,param1);
         return evaluate(_loc5_);
      }
   }
}

