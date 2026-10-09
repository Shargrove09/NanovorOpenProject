package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class PatienceAttackGenerator implements IPatienceAttackGenerator
   {
      
      private static const STRATEGIC_PLANNING:Number = 3;
      
      private var _OSOED:Number;
      
      public function PatienceAttackGenerator()
      {
         super();
      }
      
      private function selectHEDAttacks(param1:Array, param2:INanovor) : Array
      {
         var _loc3_:INanovor = null;
         var _loc4_:IAttack = null;
         var _loc6_:Number = NaN;
         var _loc5_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(!_loc3_.isDead)
            {
               log("\tNanovor:  " + _loc3_);
               for each(_loc4_ in _loc3_.attacks)
               {
                  _loc6_ = _loc4_.cost - _loc3_.owner.energyLevel;
                  log("\t\tAttack:  " + _loc4_ + " [ED: " + _loc4_.expectedDamage + "] [Need Energy: " + _loc6_ + "] [Cost: " + _loc4_.cost + "]");
                  if(_loc4_.cost > _loc3_.owner.energyLevel)
                  {
                     _loc5_.push({
                        "attack":_loc4_,
                        "needEnergy":_loc6_,
                        "nanovor":_loc3_
                     });
                  }
               }
            }
         }
         return _loc5_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<PatienceAttackGenerator>> " + param1);
      }
      
      private function sortOnExpectedDamage(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = Number(IAttack(param1.attack).expectedDamage);
         var _loc4_:Number = Number(IAttack(param2.attack).expectedDamage);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(param1.needEnergy > param2.needEnergy)
         {
            return 1;
         }
         if(param1.needEnergy < param2.needEnergy)
         {
            return -1;
         }
         return 0;
      }
      
      private function findAED(param1:INanovor, param2:IAttack, param3:INanovor, param4:Object, param5:ISenseiNanovor = null) : Object
      {
         var _loc11_:IAttackStatement = null;
         var _loc6_:Number = Number(param4.needEnergy);
         var _loc7_:IAttack = IAttack(param4.attack);
         var _loc8_:Number = param3.owner.energyLevel - param2.cost;
         var _loc9_:Number = 0;
         var _loc10_:Boolean = true;
         for each(_loc11_ in param2.attackStatements)
         {
            if(AttackStatementTypes.TYPE_MOD != _loc11_.type)
            {
               continue;
            }
            switch(_loc11_.name)
            {
               case "EN +2 (Mod)":
                  _loc6_ -= 2;
                  break;
               case "EN +3 (Mod)":
                  _loc6_ -= 3;
                  break;
               case "EN x2 (Mod)":
                  if(param5 != null)
                  {
                     if(param1.health < param5.overallExpectedDamage)
                     {
                        _loc6_ -= 2 * param3.owner.energyLevel;
                     }
                  }
                  else if(param1.health < _OSOED)
                  {
                     _loc6_ -= 2 * param3.owner.energyLevel;
                  }
                  break;
               case "If Me die, EN +10 (Mod)":
                  if(param5 != null)
                  {
                     if(param5.health < param2.expectedDamage)
                     {
                        _loc6_ -= 10;
                     }
                  }
                  break;
               case "If Opp die, EN +2 (Mod)":
                  if(param5 != null)
                  {
                     if(param5.health < param2.expectedDamage)
                     {
                        _loc6_ -= 2;
                     }
                  }
                  break;
               case "If Opp die, EN +3 (Mod)":
                  if(param5 != null)
                  {
                     if(param5.health < param2.expectedDamage)
                     {
                        _loc6_ -= 3;
                     }
                  }
                  break;
               case "If Opp die, EN +4 (Mod)":
                  if(param5 != null)
                  {
                     if(param5.health < param2.expectedDamage)
                     {
                        _loc6_ -= 4;
                     }
                  }
                  break;
               case "If Opp die, EN +5 (Mod)":
                  if(param5 != null)
                  {
                     if(param5.health < param2.expectedDamage)
                     {
                        _loc6_ -= 5;
                     }
                  }
            }
         }
         for each(_loc11_ in param2.attackStatements)
         {
            if(AttackStatementTypes.TYPE_OVERRIDE == _loc11_.type)
            {
               switch(_loc11_.name)
               {
                  case "EN GEN +1 (OR)":
                     _loc8_ += 1;
                     break;
                  case "If Hex +1 EN Gen (OR)":
                     if(NanovorFaction.HEXITE == param1.faction && NanovorFaction.HEXITE == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 1;
                        break;
                     }
                     if(NanovorFaction.HEXITE == param1.faction)
                     {
                        _loc8_ += 0.75;
                        break;
                     }
                     if(NanovorFaction.HEXITE == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 0.25;
                     }
                     break;
                  case "If Mag +1 EN Gen (OR)":
                     if(NanovorFaction.MAGNAMOD == param1.faction && NanovorFaction.MAGNAMOD == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 1;
                        break;
                     }
                     if(NanovorFaction.MAGNAMOD == param1.faction)
                     {
                        _loc8_ += 0.75;
                        break;
                     }
                     if(NanovorFaction.MAGNAMOD == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 0.25;
                     }
                     break;
                  case "If Mag +2 EN Gen (OR)":
                     if(NanovorFaction.MAGNAMOD == param1.faction && NanovorFaction.MAGNAMOD == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 2;
                        break;
                     }
                     if(NanovorFaction.MAGNAMOD == param1.faction)
                     {
                        _loc8_ += 1.5;
                        break;
                     }
                     if(NanovorFaction.MAGNAMOD == INanovor(param4.nanovor).faction)
                     {
                        _loc8_ += 0.5;
                     }
               }
               _loc9_ = _loc8_ == 0 ? 0 : Math.ceil(_loc6_ / _loc8_ + 1);
               _loc10_ = false;
            }
         }
         param4.needEnergy = _loc6_;
         if(_loc10_)
         {
            _loc9_ = _loc8_ == 0 ? 0 : Math.ceil(_loc6_ / _loc8_);
         }
         if(param1.assetId != param3.assetId)
         {
            _loc9_ += 1;
         }
         var _loc12_:Number = 0;
         if(_loc9_ <= Number(STRATEGIC_PLANNING))
         {
            _loc12_ = (_loc7_.expectedDamage + param2.expectedDamage * _loc9_) / (_loc9_ + 1);
            _loc12_ = _loc12_ < 0 || isNaN(_loc12_) ? 0 : Math.round(_loc12_);
         }
         log("\t\tAttack:  " + param2 + " [ED: " + param2.expectedDamage + "] [Cost: " + param2.cost + "] [Surplus Energy: " + _loc8_ + "] [AED: " + _loc12_ + "]");
         return {
            "nanovor":param1,
            "attack":param2,
            "needEnergy":_loc6_,
            "needRounds":_loc9_,
            "surplusEnergy":_loc8_,
            "averageED":_loc12_
         };
      }
      
      public function selectPatienceAttack(param1:Array, param2:INanovor, param3:ISenseiNanovor, param4:Number) : Object
      {
         var _loc5_:INanovor = null;
         var _loc6_:IAttack = null;
         var _loc8_:Object = null;
         var _loc10_:INanovor = null;
         var _loc11_:IAttack = null;
         var _loc12_:IAttack = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         _OSOED = param4;
         log("\nHED EVALUATION");
         var _loc7_:Array = selectHEDAttacks(param1,param2);
         if(_loc7_.length > 0)
         {
            _loc7_.sort(sortOnExpectedDamage);
            _loc10_ = INanovor(_loc7_[0].nanovor);
            log("\nHED: " + _loc10_ + " [" + IAttack(_loc7_[0].attack) + " (ED: " + IAttack(_loc7_[0].attack).expectedDamage + ") (Need Energy: " + _loc7_[0].needEnergy + ")]\n");
         }
         else
         {
            log("There are no potential HED Nanovors!");
         }
         log("\nLED EVALUATION");
         var _loc9_:uint = 0;
         while(_loc9_ < _loc7_.length)
         {
            log("\tNanovor:  " + param2 + " (active nanovor)");
            for each(_loc11_ in param2.attacks)
            {
               if(_loc11_.cost <= param2.owner.energyLevel)
               {
                  _loc14_ = findAED(param2,_loc11_,param2,_loc7_[_loc9_],param3);
                  if(_loc8_ == null)
                  {
                     if(_loc14_.averageED > 0)
                     {
                        _loc8_ = _loc14_;
                     }
                  }
                  else if(_loc8_.averageED < _loc14_.averageED)
                  {
                     _loc8_ = _loc14_;
                  }
               }
               else
               {
                  log("\t\tAttack:  " + _loc11_ + " [ED: " + _loc11_.expectedDamage + "] [Cost: " + _loc11_.cost + "]");
               }
            }
            _loc12_ = new Attack();
            _loc13_ = findAED(param2,_loc12_,param2,_loc7_[_loc9_],param3);
            if(_loc8_ == null)
            {
               if(_loc13_.averageED > 0)
               {
                  _loc8_ = _loc13_;
               }
            }
            else if(_loc8_.averageED < _loc13_.averageED)
            {
               _loc8_ = _loc13_;
            }
            _loc5_ = INanovor(_loc7_[_loc9_].nanovor);
            log("\tNanovor:  " + _loc5_);
            for each(_loc6_ in _loc5_.attacks)
            {
               if(_loc6_.cost <= param2.owner.energyLevel)
               {
                  _loc15_ = findAED(_loc5_,_loc6_,param2,_loc7_[_loc9_],param3);
                  if(_loc8_ == null)
                  {
                     if(_loc15_.averageED > 0)
                     {
                        _loc8_ = _loc15_;
                     }
                  }
                  else if(_loc8_.averageED < _loc15_.averageED)
                  {
                     _loc8_ = _loc15_;
                  }
               }
               else
               {
                  log("\t\tAttack:  " + _loc6_ + " [ED: " + _loc6_.expectedDamage + "] [Cost: " + _loc6_.cost + "]");
               }
            }
            if(_loc8_ != null)
            {
               log("\nLED: " + INanovor(_loc8_.nanovor) + " [" + IAttack(_loc8_.attack) + " (ED: " + IAttack(_loc8_.attack).expectedDamage + ") (AED: " + _loc8_.averageED + ") (Cost: " + IAttack(_loc8_.attack).cost + ")]\n");
               return {
                  "led":_loc8_,
                  "hed":_loc7_[_loc9_]
               };
            }
            _loc9_++;
         }
         if(_loc8_ != null)
         {
            log("\nLED: " + INanovor(_loc8_.nanovor) + " [" + IAttack(_loc8_.attack) + " (ED: " + IAttack(_loc8_.attack).expectedDamage + ") (AED: " + _loc8_.averageED + ") (Cost: " + IAttack(_loc8_.attack).cost + ")]\n");
         }
         else
         {
            log("No LED attacks for this round");
         }
         return {
            "led":_loc8_,
            "hed":_loc7_[_loc9_]
         };
      }
   }
}

