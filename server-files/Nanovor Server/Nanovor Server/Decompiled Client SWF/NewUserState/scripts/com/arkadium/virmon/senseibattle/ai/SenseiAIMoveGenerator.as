package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.combatgame.CombatTurnData;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import it.gotoandplay.smartfoxserver.*;
   import it.gotoandplay.smartfoxserver.data.*;
   
   public class SenseiAIMoveGenerator implements ISenseiAIMoveGenerator
   {
      
      private static const PATIENCE_RATING:Number = 100;
      
      private var _pings:Array;
      
      private var _senseiNumber:uint = 1;
      
      private var _selectedNanovor:ISenseiNanovor;
      
      private var _OSOED:Number;
      
      private var _remainingRounds:uint = 14;
      
      private var _swapAssetId:String;
      
      private var _enemyNanovor:ISenseiNanovor;
      
      private var _selectedAttackId:int;
      
      private var _enemyUserName:String;
      
      private var _selectedAttack:IAttack;
      
      private var _enemySwarm:Array;
      
      private var _patienceAttackGenerator:IPatienceAttackGenerator;
      
      private var _senseiSwarm:Array;
      
      public function SenseiAIMoveGenerator(param1:IPatienceAttackGenerator)
      {
         super();
         _patienceAttackGenerator = param1;
         _senseiSwarm = null;
         _enemySwarm = new Array();
      }
      
      public function setSenseiSwarm(param1:Array, param2:String) : void
      {
         _senseiSwarm = param1;
         _enemyUserName = param2;
      }
      
      private function calculateExpectedDamages() : void
      {
         var _loc1_:ISenseiNanovor = null;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         for each(_loc1_ in _senseiSwarm)
         {
            if(!_loc1_.isDead)
            {
               _loc3_++;
            }
         }
         for each(_loc1_ in _enemySwarm)
         {
            if(!_loc1_.isDead)
            {
               _loc2_++;
            }
         }
         _loc5_ = new Array();
         for each(_loc1_ in _senseiSwarm)
         {
            _loc1_.calculateOverallExpectedDamage(_enemyNanovor,_remainingRounds,_loc2_,_loc4_,_OSOED);
            _loc4_ = isNaN(_loc4_) ? 0 : _loc4_;
            _loc6_ = Number(_loc1_.overallExpectedDamage);
            _loc4_ += _loc6_;
         }
         _OSOED = _loc4_;
         if(_enemyNanovor != null)
         {
            _loc5_ = new Array();
            _OSOED = 0;
            for each(_loc1_ in _enemySwarm)
            {
               _loc1_.calculateOverallExpectedDamage(_selectedNanovor,_remainingRounds,_loc3_,_loc7_,_loc7_);
               _loc8_ = Number(_loc1_.overallExpectedDamage);
               _OSOED += _loc8_;
            }
         }
         for each(_loc1_ in _senseiSwarm)
         {
            _loc1_.calculateRemainingExpectedDamage(_enemyNanovor,_remainingRounds,_loc2_,_loc4_,_OSOED);
         }
      }
      
      public function getCombatTurnData() : ICombatTurnData
      {
         selectAttack();
         var _loc1_:CombatTurnData = new CombatTurnData();
         _loc1_.AttackData = null;
         _loc1_.AttackId = _selectedAttackId;
         _loc1_.MyActiveNanovorId = _selectedNanovor.assetId;
         _loc1_.MyNextNanovorId = null != _swapAssetId ? _swapAssetId : "0";
         _loc1_.TargetedPlayerName = _enemyUserName;
         return _loc1_;
      }
      
      public function selectActiveNanovor(param1:ISenseiNanovor) : void
      {
         var _loc2_:ISenseiNanovor = null;
         var _loc3_:IAttack = null;
         var _loc4_:ISenseiNanovor = null;
         var _loc5_:IAttack = null;
         var _loc6_:IAttack = null;
         var _loc7_:uint = 0;
         if(param1 != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _senseiSwarm.length)
            {
               if(_senseiSwarm[_loc7_].assetId == param1.assetId)
               {
                  _senseiSwarm[_loc7_] = param1;
                  _selectedNanovor = param1;
                  break;
               }
               _loc7_++;
            }
            if(false == _selectedNanovor.isDead)
            {
               return;
            }
         }
         calculateExpectedDamages();
         if(_senseiSwarm.length == 1 && !_senseiSwarm[0].isDead)
         {
            _loc2_ = _senseiSwarm[0];
         }
         else
         {
            for each(_loc4_ in _senseiSwarm)
            {
               if(!_loc4_.isDead)
               {
                  if(_loc2_ == null)
                  {
                     for each(_loc6_ in _loc4_.attacks)
                     {
                        if(_loc3_ == null)
                        {
                           if(_loc6_.cost <= _loc4_.owner.energyLevel)
                           {
                              _loc2_ = _loc4_;
                              _loc3_ = _loc6_;
                           }
                        }
                        else if(_loc6_.expectedDamage > _loc3_.expectedDamage && _loc6_.cost <= _loc4_.owner.energyLevel)
                        {
                           _loc2_ = _loc4_;
                           _loc3_ = _loc6_;
                        }
                     }
                  }
                  else
                  {
                     for each(_loc5_ in _loc4_.attacks)
                     {
                        if(_loc5_.expectedDamage > _loc3_.expectedDamage && _loc5_.cost <= _loc4_.owner.energyLevel)
                        {
                           _loc2_ = _loc4_;
                           _loc3_ = _loc5_;
                        }
                     }
                  }
               }
            }
         }
         if(_loc2_ == null)
         {
            for each(_loc4_ in _senseiSwarm)
            {
               if(!_loc4_.isDead)
               {
                  if(_loc2_ == null)
                  {
                     for each(_loc6_ in _loc4_.attacks)
                     {
                        if(_loc3_ == null)
                        {
                           _loc2_ = _loc4_;
                           _loc3_ = _loc6_;
                        }
                        else if(_loc6_.cost < _loc3_.cost)
                        {
                           _loc2_ = _loc4_;
                           _loc3_ = _loc6_;
                        }
                     }
                  }
                  else
                  {
                     for each(_loc5_ in _loc4_.attacks)
                     {
                        if(_loc5_.cost < _loc3_.cost)
                        {
                           _loc2_ = _loc4_;
                           _loc3_ = _loc5_;
                        }
                     }
                  }
               }
            }
         }
         _selectedNanovor = _loc2_;
         log("selectActiveNanovor() - _selectedNanovor: " + _selectedNanovor.toString());
      }
      
      private function selectAttack() : void
      {
         var _loc2_:IAttack = null;
         var _loc4_:IAttack = null;
         var _loc5_:ISenseiNanovor = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         calculateExpectedDamages();
         var _loc1_:Boolean = false;
         var _loc3_:String = null;
         if(_enemyNanovor != null)
         {
            for each(_loc4_ in _selectedNanovor.attacks)
            {
               if(_loc2_ == null)
               {
                  if(_loc4_.cost <= _selectedNanovor.owner.energyLevel && _loc4_.expectedDamage >= _enemyNanovor.health * 1.2)
                  {
                     _loc2_ = _loc4_;
                  }
               }
               else if(_loc4_.cost < _loc2_.cost && _loc4_.expectedDamage >= _loc2_.expectedDamage)
               {
                  _loc2_ = _loc4_;
               }
            }
            if(_loc2_ != null)
            {
               log("ATTACK WITH ED >= (ENEMY HP x 1.2) AND COST <= SWARM EN:  " + _loc2_);
            }
         }
         if(_enemyNanovor == null)
         {
            log("Enemy not known");
         }
         var _loc6_:Boolean = true;
         if(_loc2_ == null)
         {
            for each(_loc4_ in _selectedNanovor.attacks)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = _loc4_;
               }
               else if(_loc2_.expectedDamage < _loc4_.expectedDamage)
               {
                  _loc2_ = _loc4_;
               }
            }
            for each(_loc5_ in _senseiSwarm)
            {
               if(!_loc5_.isDead)
               {
                  for each(_loc4_ in _loc5_.attacks)
                  {
                     if(_loc4_.expectedDamage > _loc2_.expectedDamage)
                     {
                        _loc6_ = false;
                        _loc2_ = null;
                        break;
                     }
                  }
                  if(_loc6_ == false)
                  {
                     break;
                  }
               }
            }
         }
         var _loc9_:Number = 0;
         if(false == _loc6_ || _loc2_.cost > _selectedNanovor.owner.energyLevel)
         {
            _loc2_ = null;
            if(hasPatience())
            {
               _loc10_ = _patienceAttackGenerator.selectPatienceAttack(_senseiSwarm,_selectedNanovor,_enemyNanovor,_OSOED);
               _loc7_ = _loc10_.led;
               _loc8_ = _loc10_.hed;
               if(_loc7_ != null)
               {
                  for each(_loc4_ in _selectedNanovor.attacks)
                  {
                     if(_loc2_ == null)
                     {
                        if(_loc4_.cost <= _selectedNanovor.owner.energyLevel)
                        {
                           _loc2_ = _loc4_;
                        }
                     }
                     else if(_loc2_.expectedDamage < _loc4_.expectedDamage && _loc4_.cost <= _selectedNanovor.owner.energyLevel)
                     {
                        _loc2_ = _loc4_;
                     }
                  }
                  if(_loc2_ != null)
                  {
                     log("Best attack on active nanovor: " + _loc2_ + " [ED: " + _loc2_.expectedDamage + "] [Cost: " + _loc2_.cost + "]");
                     _loc11_ = _loc2_ == null ? 0 : Number(_loc2_.expectedDamage);
                     if(_loc7_.averageED > _loc11_)
                     {
                        if(INanovor(_loc7_.nanovor).assetId == _selectedNanovor.assetId)
                        {
                           _loc2_ = IAttack(_loc7_.attack);
                           if(INanovor(_loc8_.nanovor).assetId != _selectedNanovor.assetId)
                           {
                              _loc12_ = _selectedNanovor.owner.energyLevel + _selectedNanovor.owner.energyGenerator - IAttack(_loc7_.attack).cost;
                              log("[SEN + ENG - LED COST: " + _loc12_ + "] >= [NEED EN: " + _loc8_.needEnergy + "] = " + (_loc12_ >= _loc8_.needEnergy));
                              if(_loc12_ >= _loc8_.needEnergy)
                              {
                                 _loc3_ = INanovor(_loc8_.nanovor).assetId;
                              }
                           }
                        }
                        else
                        {
                           for each(_loc4_ in _selectedNanovor.attacks)
                           {
                              if(_loc2_ == null)
                              {
                                 if(_loc4_.cost < _selectedNanovor.owner.energyLevel)
                                 {
                                    _loc2_ = _loc4_;
                                 }
                              }
                              else if(_loc2_.expectedDamage < _loc4_.expectedDamage && _loc4_.cost < _selectedNanovor.owner.energyLevel)
                              {
                                 _loc2_ = _loc4_;
                              }
                              else if(_loc2_.expectedDamage == _loc4_.expectedDamage && _loc4_.cost < _loc2_.cost)
                              {
                                 _loc2_ = _loc4_;
                              }
                           }
                           _loc3_ = INanovor(_loc7_.nanovor).assetId;
                        }
                     }
                  }
               }
            }
         }
         if(_loc2_ == null)
         {
            log("Sensei has no patience or AED <= Highest ED");
            for each(_loc4_ in _selectedNanovor.attacks)
            {
               if(_loc2_ == null)
               {
                  if(_loc4_.cost <= _selectedNanovor.owner.energyLevel)
                  {
                     _loc2_ = _loc4_;
                  }
               }
               else if(_loc2_.expectedDamage < _loc4_.expectedDamage && _loc4_.cost <= _selectedNanovor.owner.energyLevel)
               {
                  _loc2_ = _loc4_;
               }
            }
            if(_loc2_ == null)
            {
               _loc2_ = new Attack();
            }
         }
         if(null == _loc3_)
         {
            log("Will Not Swap");
         }
         else
         {
            for each(_loc5_ in _senseiSwarm)
            {
               if(_loc5_.assetId == _loc3_)
               {
                  log("Will Swap to: " + _loc5_);
                  break;
               }
            }
         }
         log("selected attack: " + _loc2_.attackID);
         _selectedAttackId = _loc2_.attackID;
         _swapAssetId = _loc3_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiAIMoveGenerator>> " + param1);
      }
      
      protected function hasPatience() : Boolean
      {
         return PATIENCE_RATING >= uint(Math.random() * 100);
      }
      
      public function updateEnemySwarm(param1:ISenseiNanovor = null) : void
      {
         var _loc2_:INanovor = null;
         if(null == param1)
         {
            return;
         }
         if(Boolean(_enemySwarm.length))
         {
            for each(_loc2_ in _enemySwarm)
            {
               if(_loc2_.assetId == param1.assetId)
               {
                  return;
               }
            }
         }
         _enemySwarm.push(param1);
      }
      
      public function setRemoteNanovor(param1:ISenseiNanovor = null) : void
      {
         var _loc2_:INanovor = null;
         if(null == param1)
         {
            return;
         }
         _enemyNanovor = param1;
         if(_enemySwarm.length >= 1)
         {
            for each(_loc2_ in _enemySwarm)
            {
               if(_loc2_.assetId == _enemyNanovor.assetId)
               {
                  return;
               }
            }
         }
         _enemySwarm.push(_enemyNanovor);
      }
   }
}

