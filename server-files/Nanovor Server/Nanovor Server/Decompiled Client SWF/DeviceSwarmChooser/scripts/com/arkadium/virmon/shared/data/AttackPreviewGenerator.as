package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.battle.control.AttackStatementFormula;
   import com.arkadium.virmon.battle.control.Conditional;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class AttackPreviewGenerator
   {
      
      private static var _playerFactory:IPlayerFactory;
      
      private static var _nanovorFactory:INanovorFactory;
      
      public function AttackPreviewGenerator()
      {
         super();
         throw new Error("DO NO INSTANTIATE");
      }
      
      public static function initialize(param1:INanovorFactory, param2:IPlayerFactory) : void
      {
         _nanovorFactory = param1;
         _playerFactory = param2;
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorPickerInfo: " + param1);
      }
      
      public static function GenerateSelectedNanovorPreview(param1:Boolean, param2:IPlayer, param3:Array) : void
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:IPlayer = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Dictionary = null;
         var _loc14_:IAttackStatement = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:String = null;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:Boolean = false;
         var _loc26_:IAttackStatement = null;
         var _loc27_:IAttack = null;
         var _loc28_:Array = null;
         var _loc29_:IAttackStatement = null;
         var _loc30_:String = null;
         var _loc31_:Boolean = false;
         var _loc32_:IAttackStatement = null;
         var _loc33_:IAttackStatement = null;
         var _loc34_:Conditional = null;
         var _loc35_:Boolean = false;
         var _loc36_:Boolean = false;
         var _loc37_:Boolean = false;
         var _loc38_:Conditional = null;
         var _loc4_:IPlayer = _playerFactory.createPlayer("faux",0);
         _loc4_.energyLevel = 1000;
         _loc4_.moddedEnergyGenerator = 2;
         _loc4_.energyGenerator = 2;
         _loc4_.swarm = [_nanovorFactory.baseResultNanovor];
         _nanovorFactory.baseResultNanovor.owner = _loc4_;
         _loc4_.selectedNanovor = _loc4_.swarm[0];
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param2.selectedNanovor.attacks.length)
         {
            if(param2.selectedNanovor.attacks[_loc6_].attackID != 0)
            {
               _loc7_ = {
                  "attackID":param2.selectedNanovor.attacks[_loc6_].attackID,
                  "players":[]
               };
               _loc8_ = param1 ? -1 : 0;
               _loc9_ = param1 ? 0 : int(param3.length);
               while(_loc8_ < _loc9_)
               {
                  _loc10_ = _loc8_ == -1 ? _loc4_ : param3[_loc8_];
                  if(!(_loc10_ == param2 || _loc10_ == null))
                  {
                     if(param1)
                     {
                     }
                     _loc11_ = int(_loc10_.userRefId);
                     _loc12_ = new Array();
                     _loc13_ = new Dictionary(true);
                     for each(_loc14_ in param2.selectedNanovor.attacks[_loc6_].attackStatements)
                     {
                        if(!Boolean(_loc13_[_loc14_]))
                        {
                           _loc15_ = _loc14_.stat;
                           _nanovorFactory.baseResultNanovor.armor = _loc15_ == Stat.ARMOR ? 1000 : 0;
                           if(!param1 && _loc14_.statementFormula.getVariables().indexOf(AttackStatementFormula.VAR_ENEMY_ENERGY) != -1 && _loc14_.target == AttackStatementTypes.TARGET_ENEMY_NANOVOR)
                           {
                              _loc4_.energyLevel = _loc10_.energyLevel;
                           }
                           else
                           {
                              _loc4_.energyLevel = 1000;
                           }
                           _loc16_ = _loc14_.target == AttackStatementTypes.TARGET_MY_NANOVOR || _loc14_.target == AttackStatementTypes.TARGET_MY_TEAM;
                           _loc17_ = false;
                           if(!(_loc16_ && (_loc14_.stat == Stat.RED_SPIKE || _loc14_.stat == Stat.BLUE_SPIKE || _loc14_.stat == Stat.YELLOW_SPIKE || _loc14_.type == AttackStatementTypes.TYPE_MOD && _loc14_.stat == Stat.OVERRIDE || _loc14_.type == AttackStatementTypes.TYPE_OVERRIDE && _loc14_.stat == Stat.DODGE_FAIL_PERCENTAGE)))
                           {
                              if(_loc16_ && _loc14_.stat == Stat.ENERGY_GENERATOR)
                              {
                                 _loc15_ = Stat.ENERGY;
                              }
                              if(_loc10_.selectedNanovor != null)
                              {
                                 _loc18_ = _loc14_.getPreviewDelta(param2,_loc10_,_loc4_);
                              }
                              else
                              {
                                 _loc18_ = _loc14_.getPreviewDelta(param2,_loc4_,_loc4_);
                              }
                              if(param1 && _loc14_.statementFormula.getVariables().indexOf(AttackStatementFormula.VAR_ENEMY_ENERGY) != -1)
                              {
                                 _loc18_ = "??";
                              }
                              _loc19_ = false;
                              _loc20_ = false;
                              _loc22_ = false;
                              _loc23_ = "";
                              _loc24_ = "";
                              _loc25_ = false;
                              if(param2 != null && param2.currentOverrideArray != null)
                              {
                                 for each(_loc26_ in param2.currentOverrideArray)
                                 {
                                    if(_loc26_.type == AttackStatementTypes.TYPE_OVERRIDE)
                                    {
                                       if(_loc26_.stat.toUpperCase() == "REDSPIKE")
                                       {
                                          _loc23_ = "%Red%";
                                       }
                                       else if(_loc26_.stat.toUpperCase() == "BLUESPIKE")
                                       {
                                          _loc23_ = "%Blue%";
                                       }
                                       else if(_loc26_.stat.toUpperCase() == "YELLOWSPIKE")
                                       {
                                          _loc23_ = "%Yellow%";
                                       }
                                    }
                                 }
                              }
                              if((param2.selectedNanovor.attacks[_loc6_] as IAttack).conditional != null)
                              {
                                 _loc27_ = param2.selectedNanovor.attacks[_loc6_];
                                 _loc24_ = _loc27_.conditional.conditionalName;
                                 _loc28_ = _loc27_.findAttackStatements(_loc14_.type,_loc14_.stat);
                                 if(_loc28_.length > 1)
                                 {
                                    if(_loc28_[0].id == _loc14_.id)
                                    {
                                       _loc29_ = _loc28_[1];
                                    }
                                    else
                                    {
                                       _loc29_ = _loc28_[0];
                                    }
                                    _loc30_ = _loc29_.getPreviewDelta(param2,_loc10_,_loc4_);
                                    _loc31_ = false;
                                    if(_loc29_.conditionals.length > 0)
                                    {
                                       for each(_loc34_ in _loc29_.conditionals)
                                       {
                                          if(_loc34_.conditionalName == Conditional.ATTACK_FAILED)
                                          {
                                             _loc31_ = true;
                                          }
                                       }
                                    }
                                    _loc32_ = _loc31_ ? _loc14_ : _loc29_;
                                    _loc33_ = _loc31_ ? _loc29_ : _loc14_;
                                    if(!param1 && _loc10_.selectedNanovor && !_loc10_.selectedNanovor.isDead)
                                    {
                                       _loc35_ = Boolean(_loc27_.conditional.canEvaluatePreview(param2,_loc10_));
                                       if(Boolean(_loc14_.canEvaluateConditionalsForPreview(param2,_loc10_,_loc35_)) && Boolean(_loc29_.canEvaluateConditionalsForPreview(param2,_loc10_,_loc35_)))
                                       {
                                          _loc25_ = true;
                                       }
                                    }
                                    if(_loc25_)
                                    {
                                       _loc36_ = Boolean(_loc27_.conditional.evaluate(true,param2,_loc10_));
                                       log("#### YAY\n" + "fromPlayer=" + param2 + "\nnanovor=" + param2.selectedNanovor + "\nattack=" + _loc27_ + "\n**** bAttackSuccess=" + _loc36_);
                                       if(!_loc36_ && _loc31_ || _loc36_ && !_loc31_)
                                       {
                                          _loc18_ = _loc30_;
                                       }
                                       else if(_loc18_ == _loc30_)
                                       {
                                          _loc18_ = _loc18_ + "%SPLIT%" + _loc30_;
                                       }
                                    }
                                    else if(_loc31_)
                                    {
                                       _loc18_ = _loc18_ + "%SPLIT%" + _loc30_;
                                    }
                                    else
                                    {
                                       _loc18_ = _loc30_ + "%SPLIT%" + _loc18_;
                                    }
                                    _loc13_[_loc14_] = true;
                                    _loc13_[_loc29_] = true;
                                 }
                                 if(_loc24_ == Conditional.MY_RED_SPIKE_IS_SET)
                                 {
                                    _loc19_ = true;
                                    _loc21_ = "%Red%";
                                 }
                                 else if(_loc24_ == Conditional.MY_BLUE_SPIKE_IS_SET)
                                 {
                                    _loc19_ = true;
                                    _loc21_ = "%Blue%";
                                 }
                                 else if(_loc24_ == Conditional.MY_YELLOW_SPIKE_IS_SET)
                                 {
                                    _loc19_ = true;
                                    _loc21_ = "%Yellow%";
                                 }
                                 else
                                 {
                                    _loc20_ = true;
                                 }
                                 if(param1 && _loc19_ && _loc23_ == _loc21_)
                                 {
                                    if(_loc18_.indexOf("%SPLIT%") != -1 && !hasEqualDeltaSplit(_loc18_))
                                    {
                                       _loc18_ = _loc18_.split("%SPLIT%")[0];
                                    }
                                 }
                              }
                              if(_loc14_.conditionals.length > 0)
                              {
                                 _loc37_ = true;
                                 if(param1 || !_loc10_.selectedNanovor || Boolean(_loc10_.selectedNanovor.isDead) || !_loc14_.canEvaluateConditionalsForPreview(param2,_loc10_,_loc35_))
                                 {
                                    _loc37_ = false;
                                 }
                                 for each(_loc38_ in _loc14_.conditionals)
                                 {
                                    if(_loc38_.conditionalName == Conditional.MY_RED_SPIKE_IS_SET)
                                    {
                                       _loc19_ = true;
                                       _loc21_ = "%Red%";
                                    }
                                    else if(_loc38_.conditionalName == Conditional.MY_BLUE_SPIKE_IS_SET)
                                    {
                                       _loc19_ = true;
                                       _loc21_ = "%Blue%";
                                    }
                                    else if(_loc38_.conditionalName == Conditional.MY_YELLOW_SPIKE_IS_SET)
                                    {
                                       _loc19_ = true;
                                       _loc21_ = "%Yellow%";
                                    }
                                    else if(_loc38_.conditionalName == Conditional.ATTACK_FAILED)
                                    {
                                       _loc19_ = false;
                                       _loc21_ = "";
                                    }
                                    else
                                    {
                                       _loc37_ = false;
                                    }
                                    if(_loc19_ && _loc37_)
                                    {
                                       if(!_loc38_.evaluate(true,param2,_loc10_,true))
                                       {
                                          _loc17_ = true;
                                       }
                                    }
                                 }
                                 if(_loc37_)
                                 {
                                    _loc25_ = true;
                                 }
                              }
                              if(_loc19_)
                              {
                                 if(hasEqualDeltaSplit(_loc18_) && _loc29_.statementFormula.getFormula() == _loc14_.statementFormula.getFormula())
                                 {
                                    _loc18_ = getFirstDelta(_loc18_);
                                 }
                                 else
                                 {
                                    _loc22_ = _loc21_ == _loc23_;
                                    _loc15_ = "%Spiked%" + _loc21_ + (_loc22_ ? "%Active%" : "") + (_loc25_ ? "%Evaluated%" : "") + _loc15_;
                                 }
                              }
                              if(_loc20_)
                              {
                                 _loc22_ = false;
                                 _loc15_ = "%OtherConditional%" + (_loc22_ ? "%Active%" : "") + (_loc25_ ? "%Evaluated%" : "") + _loc15_;
                              }
                              if(_loc16_)
                              {
                                 _loc15_ = "self" + _loc15_;
                              }
                              if(!_loc17_)
                              {
                                 _loc12_[_loc15_] = {
                                    "delta":_loc18_,
                                    "type":_loc14_.type
                                 };
                              }
                           }
                        }
                     }
                     _loc7_.players[String(_loc11_)] = _loc12_;
                  }
                  _loc8_++;
               }
               _loc5_[String(_loc7_.attackID)] = _loc7_;
            }
            _loc6_++;
         }
         if(param1)
         {
            param2.baseAttackPreviews[param2.selectedNanovor.assetId] = _loc5_;
         }
         else
         {
            param2.attackPreviews = _loc5_;
         }
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorPickerInfo: " + param1);
      }
      
      private static function hasEqualDeltaSplit(param1:String) : Boolean
      {
         if(param1.indexOf("%SPLIT%") == -1)
         {
            return false;
         }
         var _loc2_:Array = param1.split("%SPLIT%");
         return Boolean(_loc2_[0] == _loc2_[1]);
      }
      
      private static function getFirstDelta(param1:String) : String
      {
         if(param1.indexOf("%SPLIT%") == -1)
         {
            return param1;
         }
         return String(param1.split("%SPLIT%")[0]);
      }
   }
}

