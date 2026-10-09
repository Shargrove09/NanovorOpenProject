package com.arkadium.virmon.senseibattle.battlelogic
{
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.combatgame.CombatTurnData;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.senseibattle.Round;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.AttackActionTypes;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.AttackStatementFormula;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicAttack;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicAttackStatement;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicConditional;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicNanovor;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.Faction;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.Stat;
   import com.arkadium.virmon.senseibattle.battlelogic.player.BattleLogicPlayer;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class BattleLogic implements IBattleLogic
   {
      
      public static var MASTER_NANOVOR_LIST:Array = new Array();
      
      public static var SWAP_COST:int = 0;
      
      private var _attackResults:Array;
      
      private var _roundInfo:Object;
      
      private var _roundResults:Object;
      
      private var _players:Array;
      
      private var _roundCounter:int;
      
      private var _playerCombatTurnData:Dictionary;
      
      public function BattleLogic(param1:IBattleData, param2:IMasterDataAssetRetriever)
      {
         super();
         setMasterNanovorList(param2);
         _playerCombatTurnData = new Dictionary();
         createPlayers(param1);
      }
      
      public function getPlayerStats(param1:BattleLogicPlayer) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.userRefId = param1.userRefId;
         _loc2_.totalDamage = param1.totalGameDamage.toString();
         _loc2_.maxDamage = param1.maximumDamage.toString();
         _loc2_.totalNanovorKilled = param1.killCount.toString();
         _loc2_.position = param1.position.toString();
         trace(param1.username + " finished " + param1.position + " performed " + param1.totalGameDamage + " damage and killed " + param1.killCount + " nanovor");
         return _loc2_;
      }
      
      private function performAttack(param1:BattleLogicPlayer, param2:BattleLogicPlayer) : Object
      {
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:BattleLogicAttackStatement = null;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:uint = 0;
         var _loc19_:BattleLogicConditional = null;
         var _loc20_:Boolean = false;
         var _loc3_:BattleLogicNanovor = param1.selectedNanovor;
         var _loc4_:BattleLogicNanovor = param2.selectedNanovor;
         var _loc5_:Object = new Object();
         var _loc6_:Array = new Array();
         var _loc7_:Object = new Object();
         _loc5_.attacker = param1.username;
         _loc5_.attackerId = param1.userRefId;
         _loc5_.attackerNanovorId = _loc3_.assetId;
         _loc5_.attackerNanovorAssetId = _loc3_.assetTypeId;
         _loc5_.attackId = _loc3_.selectedAttack.attackId;
         var _loc8_:Boolean = _players.indexOf(param1) == 0 ? true : false;
         var _loc9_:BattleLogicAttack = param1.selectedNanovor.selectedAttack;
         param1.selectedNanovor.getAttackByAttackId(_loc9_.attackId).setWasUsed(true);
         resetPlayerAndNanovorStats();
         var _loc10_:Boolean = true;
         if(_loc9_.attackId == 0)
         {
            _loc6_.push(setActionResponseObject(null,AttackActionTypes.PASS));
            _loc10_ = false;
         }
         else if(_loc4_ == null || _loc4_.hitPoints <= 0)
         {
            _loc6_.push(setActionResponseObject(param1,AttackActionTypes.TARGET_IS_DEAD));
            _loc10_ = false;
         }
         else if(param1.energyLevel < _loc9_.cost)
         {
            _loc6_.push(setActionResponseObject(param1,AttackActionTypes.FIZZLE));
         }
         else if(!_loc4_.isDodged(_loc9_,_loc8_) && !_loc3_.isStunned(_loc8_))
         {
            _loc11_ = true;
            _loc12_ = true;
            if(_loc9_.conditional != null)
            {
               _loc11_ = _loc9_.conditional.evaluate(_loc8_,param1,param2);
            }
            _loc13_ = false;
            if(isOverrideAttack(_loc9_) && _loc11_)
            {
               param1.removeOverride();
            }
            for each(_loc14_ in _loc9_.attackStatements)
            {
               _loc14_.currentAttacker = param1;
               _loc14_.currentEnemy = param2;
               resetPlayerAndNanovorStats();
               _loc16_ = false;
               log("SID: " + _loc14_.attackStatementId + " STATEMENT: " + _loc14_);
               if(_loc11_ || !_loc11_ && _loc14_.conditionals != null)
               {
                  _loc17_ = false;
                  if(_loc14_.conditionals != null && _loc14_.conditionals.length > 0)
                  {
                     _loc18_ = 0;
                     while(_loc18_ < _loc14_.conditionals.length)
                     {
                        _loc19_ = _loc14_.conditionals[_loc18_];
                        if(_loc19_.conditionalName == BattleLogicConditional.ENEMY_DIES || _loc19_.conditionalName == BattleLogicConditional.I_DIE)
                        {
                           _loc16_ = true;
                        }
                        if(_loc19_.conditionalName == BattleLogicConditional.ATTACK_FAILED)
                        {
                           _loc17_ = true;
                        }
                        _loc18_++;
                     }
                  }
                  if(_loc11_ || _loc17_)
                  {
                     if(_loc16_)
                     {
                        _loc12_ = true;
                     }
                     else if(_loc14_.conditionals != null)
                     {
                        _loc12_ = _loc14_.doesApply(_loc8_,_loc11_,param1,param2);
                     }
                     _loc7_ = addHack(param1,param2,_loc9_,_loc14_);
                     _loc5_.hacksInfo = _loc7_;
                     if(_loc7_.attackerHacks != null)
                     {
                        log("ATTACKER HACKS: " + _loc7_.attackerHacks.length);
                     }
                     if(_loc7_.enemyHacks != null)
                     {
                        log("ENEMY HACKS:    " + _loc7_.enemyHacks.length);
                     }
                     addOverride(param1,param2,_loc14_);
                     if(_loc12_)
                     {
                        _loc20_ = false;
                        if(_loc16_)
                        {
                           if(_loc4_.hitPoints == 0)
                           {
                              _loc20_ = true;
                           }
                        }
                        else
                        {
                           _loc20_ = true;
                        }
                        if(_loc3_.selectedAttack.cost > param1.energyLevel)
                        {
                           _loc20_ = false;
                           log("Not enough energy to use attack.");
                        }
                        if(_loc20_)
                        {
                           _loc13_ = true;
                           _loc6_ = calculateAttack(_loc14_,_loc6_,_loc8_,param1,param2);
                        }
                     }
                  }
               }
            }
            _loc15_ = 0;
            if(_loc13_)
            {
               log("ATTACK COST:     " + _loc3_.selectedAttack.cost);
               log("CURRENT ENERGY: " + param1.energyLevel);
               _loc5_.attackId = _loc3_.selectedAttack.attackId.toString();
               _loc5_.attackCost = _loc3_.selectedAttack.cost.toString();
               _loc15_ = GameMath.checkNegativeNumbers(param1.energyLevel - _loc3_.selectedAttack.cost);
               param1.setEnergyLevel(_loc15_);
               _loc5_.energyLevel = _loc15_.toString();
               log("NEW ENERGY:     " + param1.energyLevel);
            }
         }
         else if(_loc3_.isStunned(_loc8_))
         {
            log("attacker is stunned");
            _loc6_.push(setActionResponseObject(param1,AttackActionTypes.STUNNED));
         }
         else
         {
            log("enemy dodged attack");
            _loc6_.push(setActionResponseObject(param2,AttackActionTypes.DODGED));
            _loc5_.attackCost = _loc3_.selectedAttack.cost.toString();
            _loc15_ = GameMath.checkNegativeNumbers(param1.energyLevel - _loc3_.selectedAttack.cost);
            param1.setEnergyLevel(_loc15_);
            _loc5_.energyLevel = _loc15_.toString();
         }
         if(_loc6_.length == 0)
         {
            _loc6_.push(setActionResponseObject(param1,AttackActionTypes.FIZZLE));
         }
         _loc5_.attackActions = _loc6_;
         if(_loc10_)
         {
            resetPlayerAndNanovorStats();
         }
         return _loc5_;
      }
      
      private function addOverride(param1:BattleLogicPlayer, param2:BattleLogicPlayer, param3:BattleLogicAttackStatement) : void
      {
         log("Adding override for: " + param1.username + " to: " + param2.username + " statement: " + param3.toString() + " id: " + param3.attackStatementId);
         if(param3.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
         {
            if(param3.target == BattleLogicAttackStatement.TARGET_ENEMY_NANOVOR || param3.target == BattleLogicAttackStatement.TARGET_ENEMY_TEAM)
            {
               param2.addOverride(param3,true);
            }
            else if(param3.target == BattleLogicAttackStatement.TARGET_MY_NANOVOR || param3.target == BattleLogicAttackStatement.TARGET_MY_TEAM)
            {
               param1.addOverride(param3,false);
            }
            else
            {
               param2.addOverride(param3,true);
               param1.addOverride(param3,false);
            }
         }
      }
      
      public function setRoundPosition() : Array
      {
         var _loc1_:BattleLogicPlayer = null;
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:BattleLogicNanovor = null;
         var _loc6_:Number = NaN;
         var _loc7_:BattleLogicPlayer = null;
         var _loc8_:Number = NaN;
         var _loc2_:Array = new Array();
         for each(_loc1_ in _players)
         {
            _loc2_.push(_loc1_);
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         for each(_loc1_ in _loc2_)
         {
            _loc1_.speed = 1;
            _loc5_ = _loc1_.selectedNanovor;
            if(_loc5_ != null)
            {
               _loc1_.speed = _loc5_.getModdedStat(Stat.SPEED,false);
               if(_loc1_.speed < 1)
               {
                  _loc1_.speed = 1;
               }
               _loc1_.curvePercent = 0;
               _loc1_.speedCurved = 0;
               _loc4_ += _loc1_.speed;
            }
         }
         for each(_loc1_ in _loc2_)
         {
            _loc1_.initiativeRoll = Math.random();
            _loc1_.speedCurved = Math.pow(_loc1_.speed / _loc4_,2);
         }
         while(_loc2_.length > 0)
         {
            _loc6_ = 0;
            for each(_loc1_ in _loc2_)
            {
               _loc6_ += _loc1_.speedCurved;
            }
            _loc7_ = _loc2_[0];
            for each(_loc1_ in _loc2_)
            {
               _loc1_.curvePercent = _loc1_.speedCurved / _loc6_;
               if(!_loc1_.userRefId == _loc7_.userRefId && _loc1_.curvePercent > _loc7_.curvePercent)
               {
                  _loc7_ = _loc1_;
               }
            }
            _loc8_ = 0;
            for each(_loc1_ in _loc2_)
            {
               _loc8_ += _loc1_.curvePercent;
               if(_loc7_.initiativeRoll <= _loc8_ || _loc2_.length < 2)
               {
                  _loc3_.push(_loc1_);
                  _loc2_.splice(_loc2_.indexOf(_loc1_),1);
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      private function prepareHackInfo(param1:BattleLogicAttackStatement, param2:BattleLogicNanovor) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.attackId = param1.attackId;
         _loc3_.statementId = param1.attackStatementId;
         _loc3_.nanovorInstanceId = param2.assetId;
         return _loc3_;
      }
      
      private function calculateNanovorResults() : void
      {
         var _loc1_:BattleLogicPlayer = null;
         var _loc2_:Array = null;
         var _loc3_:BattleLogicNanovor = null;
         var _loc4_:BattleLogicNanovor = null;
         for each(_loc1_ in _players)
         {
            if(_loc1_.position == 1 && !_loc1_.hasQuitGame() && _loc1_.swarm != null)
            {
               _loc2_ = new Array();
               for each(_loc3_ in _loc1_.swarm)
               {
                  _loc3_.setWinCount(1);
                  if(_loc3_.hitPoints > 0 && _loc3_.hitPoints < Math.round(_loc3_.hitPointsTotal * 0.1))
                  {
                     _loc3_.setScrapedBy(true);
                  }
                  if(_loc3_.hitPoints > 0)
                  {
                     _loc2_.push(_loc3_);
                  }
               }
               if(_loc2_.length == 1)
               {
                  _loc4_ = _loc2_[0];
                  _loc4_.setWasLastManStanding();
                  log("Nanovor: " + _loc4_.name + " LAST MAN STANDING!");
               }
               break;
            }
         }
      }
      
      private function setAttackInfo() : Boolean
      {
         var _loc1_:BattleLogicPlayer = null;
         var _loc2_:ICombatTurnData = null;
         var _loc3_:BattleLogicNanovor = null;
         for each(_loc1_ in _players)
         {
            _loc2_ = _playerCombatTurnData[_loc1_.userRefId] as CombatTurnData;
            _loc3_ = getNanovorByAssetId(_loc2_.MyActiveNanovorId,_loc1_.swarm);
            _loc1_.setSelectedNanovor(_loc3_);
            log("RSK: selectedNanovor = " + _loc3_ + " ... combatTurnData = " + _loc2_ + (_loc2_ != null ? " ATTACK ID = " + _loc2_.AttackId : ""));
            _loc3_.setSelectedAttack(_loc3_.getAttackByAttackId(_loc2_.AttackId));
            _loc1_.setNextNanovor(getNanovorByAssetId(_loc2_.MyNextNanovorId,_loc1_.swarm));
            _loc1_.setEnemy(getPlayerByName(_loc2_.TargetedPlayerName));
         }
         return true;
      }
      
      private function generateRound() : void
      {
         var _loc1_:BattleLogicPlayer = null;
         var _loc2_:ICombatTurnData = null;
         var _loc3_:BattleLogicNanovor = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:BattleLogicPlayer = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         _roundInfo = new Object();
         _attackResults = new Array();
         _roundResults = new Object();
         setAttackInfo();
         resetPlayerAndNanovorStats();
         _players = setRoundPosition();
         var _loc4_:Object = setRoundInfo();
         _roundInfo.players = _loc4_;
         _roundInfo.roundCounter = increaseRoundCounter();
         for each(_loc1_ in _players)
         {
            _loc1_.wasAliveAtBeginningOfRound = false;
            if(!_loc1_.hasQuitGame())
            {
               _loc1_.wasAliveAtBeginningOfRound = _loc1_.selectedNanovor.hitPoints > 0 ? true : false;
            }
         }
         _attackResults = new Array();
         for each(_loc1_ in _players)
         {
            _loc2_ = ICombatTurnData(_playerCombatTurnData[_loc1_.userRefId]);
            if(!_loc1_.hasQuitGame())
            {
               if(!_loc1_.isDead())
               {
                  if(_loc1_.selectedNanovor.hitPoints > 0)
                  {
                     _loc7_ = getPlayerByName(_loc2_.TargetedPlayerName);
                     _loc8_ = performAttack(_loc1_,_loc7_);
                     _attackResults.push(_loc8_);
                  }
               }
            }
         }
         _loc5_ = new Array();
         for each(_loc1_ in _players)
         {
            if(!_loc1_.isDead() && !_loc1_.hasQuitGame())
            {
               _loc9_ = checkHacks(_loc1_);
               _loc5_.push(_loc9_);
            }
         }
         _loc6_ = finishRound();
         resetPlayerAndNanovorStats();
         _loc4_ = setRoundInfo();
         _roundResults.swapActions = _loc6_;
         _roundResults.players = _loc4_;
         _roundResults.hacks = _loc5_;
         log("This is the roundInfo: " + Utils.ObjectToString(_roundInfo,4));
         log("This is the attackResults: " + _attackResults);
         log("This is the roundResults: " + Utils.ObjectToString(_roundResults,4));
         for each(_loc1_ in _players)
         {
            _playerCombatTurnData[_loc1_.userRefId] = null;
         }
      }
      
      private function setRoundInfo() : Array
      {
         var _loc3_:BattleLogicPlayer = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:BattleLogicNanovor = null;
         var _loc9_:String = null;
         var _loc10_:BattleLogicNanovor = null;
         var _loc11_:BattleLogicPlayer = null;
         var _loc12_:Array = null;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _players)
         {
            if(!_loc3_.isDead() && !_loc3_.hasQuitGame())
            {
               _loc4_ = new Object();
               _loc4_.hasNewNanovor = _loc3_.hasNewNanovor;
               _loc3_.setHasNewNanovor(false);
               _loc4_.username = _loc3_.username;
               _loc4_.userRefId = _loc3_.userRefId;
               if(_loc3_.enemy != null)
               {
                  _loc4_.enemy = _loc3_.enemy;
               }
               _loc4_.energyLevel = _loc3_.energyLevel;
               _loc5_ = _loc3_.overrides;
               if(_loc5_.length > 0)
               {
                  _loc4_.overrideId = _loc3_.overrides[0].attackStatementId;
                  _loc4_.overrideIds = _loc3_.overrideIdsString;
               }
               _loc6_ = new Object();
               _loc7_ = new Object();
               _loc8_ = new BattleLogicNanovor();
               for(_loc9_ in _loc1_)
               {
                  _loc11_ = _loc9_ as BattleLogicPlayer;
                  if(_loc11_.username == _loc3_.username)
                  {
                     _loc8_ = _loc1_[_loc9_];
                     break;
                  }
               }
               if(_loc8_ != null)
               {
                  _loc12_ = getHacksObject(_loc8_);
                  _loc6_.name = _loc8_.name;
                  _loc6_.instanceId = _loc8_.assetId;
                  _loc6_.hacks = _loc12_;
               }
               else
               {
                  _loc6_ = null;
               }
               _loc10_ = _loc3_.selectedNanovor;
               resetPlayerAndNanovorStats();
               _loc7_.name = _loc10_.name;
               _loc7_.nickname = _loc10_.nickName;
               _loc7_.instanceId = _loc10_.assetId;
               _loc7_.assetTypeId = _loc10_.assetTypeId;
               _loc7_.swapChance = _loc10_.getModdedStat(Stat.SWAP_PERCENTAGE,false);
               _loc7_.stunFailChance = _loc10_.getModdedStat(Stat.STUN_FAIL_PERCENTAGE,false);
               _loc7_.dodgeChance = _loc10_.getModdedStat(Stat.DODGE_FAIL_PERCENTAGE,false);
               _loc7_.armor = _loc10_.getModdedStat(Stat.ARMOR,false);
               _loc7_.speed = _loc10_.getModdedStat(Stat.SPEED,false);
               _loc7_.strength = _loc10_.getModdedStat(Stat.STRENGTH,false);
               _loc7_.health = _loc10_.getModdedStat(Stat.HEALTH,false);
               log("PLAYER " + _loc3_.username + " NANOVOR(" + _loc3_.selectedNanovor.assetTypeId + "): " + _loc3_.selectedNanovor.toString());
               _loc7_.hacks = getHacksObject(_loc10_);
               _loc4_.selectedNanovor = _loc7_;
               _loc4_.oldNanovor = _loc6_;
               _loc4_.swarmSize = _loc3_.swarm.length;
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getHacksObject(param1:BattleLogicNanovor) : Array
      {
         var _loc3_:BattleLogicAttackStatement = null;
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         if(param1.hacks != null)
         {
            for each(_loc3_ in param1.hacks)
            {
               _loc4_ = new Object();
               _loc4_.statementId = _loc3_.attackStatementId.toString();
               _loc4_.currentDuration = _loc3_.currentDuration.toString();
               _loc4_.totalDuration = _loc3_.duration.toString();
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getActivePlayers() : Array
      {
         var _loc2_:BattleLogicPlayer = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in _players)
         {
            if(!_loc2_.isDead() && !_loc2_.hasQuitGame())
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function setPlayerPosition(param1:BattleLogicPlayer) : void
      {
         var _loc4_:BattleLogicPlayer = null;
         var _loc5_:int = 0;
         if(param1.position > 0)
         {
            log("PLAYER " + param1.username + " POSITION ALREADY SET.");
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = int(_players.length);
         for each(_loc4_ in _players)
         {
            _loc5_ = _loc4_.position;
            if(_loc5_ > 0)
            {
               if(_loc3_ >= _loc5_)
               {
                  _loc3_ = _loc5_ - 1;
                  _loc2_ = _loc3_;
               }
            }
            else
            {
               _loc2_ = _loc3_;
            }
         }
         log("PLAYER " + param1.username + " POSITION: " + _loc2_);
         param1.setPosition(_loc2_);
      }
      
      public function receiveCombatTurnData(param1:BattlePlayer, param2:ICombatTurnData) : void
      {
         var _loc3_:BattleLogicPlayer = null;
         _playerCombatTurnData[param1.playerId] = param2;
         for each(_loc3_ in _players)
         {
            if(null == _playerCombatTurnData[_loc3_.userRefId])
            {
               return;
            }
         }
         generateRound();
      }
      
      private function createPlayers(param1:IBattleData) : void
      {
         var _loc2_:BattlePlayer = null;
         var _loc3_:BattleLogicPlayer = null;
         _players = new Array();
         for each(_loc2_ in param1.playersInBattle)
         {
            log("createPlayers: " + _loc2_.playerName);
            _loc3_ = new BattleLogicPlayer(_loc2_.playerName,_loc2_.playerId.toString());
            _players.push(_loc3_);
         }
      }
      
      private function getNanovorByAssetId(param1:String, param2:Array) : BattleLogicNanovor
      {
         var _loc3_:BattleLogicNanovor = null;
         log("getNanovorByAssetId() - Looking for nanovorAssetId: " + param1 + " through a swarm of length: " + param2.length);
         for each(_loc3_ in param2)
         {
            if(_loc3_.assetId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function setActionResponseObject(param1:BattleLogicPlayer, param2:String, param3:String = null, param4:int = -1) : Object
      {
         var _loc5_:Object = new Object();
         var _loc6_:String = param1 == null ? "0" : param1.username;
         var _loc7_:String = param1 == null ? "0" : param1.userRefId.toString();
         var _loc8_:String = param1 == null ? "0" : param1.selectedNanovor.assetId.toString();
         var _loc9_:String = param1 == null ? "0" : param1.selectedNanovor.assetTypeId.toString();
         _loc5_.targetUsername = _loc6_;
         _loc5_.targetUserRefId = _loc7_;
         _loc5_.targetNanovorId = _loc8_;
         _loc5_.targetNanovorAssetTypeId = _loc9_;
         _loc5_.type = param2;
         if(param3 != null)
         {
            _loc5_.verb = param3;
         }
         if(param4 != -1)
         {
            _loc5_.value = param4.toString();
         }
         _loc5_.targetUpdates = getTargetUpdates(param1);
         return _loc5_;
      }
      
      private function getPlayerByName(param1:String) : BattleLogicPlayer
      {
         var _loc2_:BattleLogicPlayer = null;
         for each(_loc2_ in _players)
         {
            if(_loc2_.username.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function finishRound() : Array
      {
         var _loc3_:BattleLogicPlayer = null;
         var _loc4_:BattleLogicNanovor = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _players)
         {
            if(_loc3_.selectedNanovor != null)
            {
               _loc3_.selectedNanovor.incRoundsPlayed();
               if(!_loc3_.isDead())
               {
                  _loc4_ = _loc3_.nextNanovor;
                  if(_loc4_ != null)
                  {
                     log("NEXT NANOVOR: " + _loc4_.name);
                  }
                  if(_loc4_ != null && _loc3_.selectedNanovor.hitPoints > 0)
                  {
                     _loc5_ = _loc3_.energyLevel - SWAP_COST >= 0 ? true : false;
                     if(_loc3_.canSwap())
                     {
                        if(_loc5_)
                        {
                           _loc1_.player = _loc3_.selectedNanovor;
                           _loc3_.setSelectedNanovor(_loc4_);
                           _loc6_ = GameMath.checkNegativeNumbers(_loc3_.energyLevel - SWAP_COST);
                           _loc3_.setEnergyLevel(_loc6_);
                           _loc2_.push(setSwapResponseObject(_loc3_));
                           log("SWAP: nanovor " + _loc4_ + " for " + _loc3_);
                        }
                        else
                        {
                           log("SWAP: failed - not enough energy");
                           _loc2_.push(setSwapResponseObject(_loc3_,AttackActionTypes.NO_ENERGY));
                        }
                     }
                     else
                     {
                        log("SWAP: blocked");
                        _loc2_.push(setSwapResponseObject(_loc3_,AttackActionTypes.BLOCK_SWAP));
                     }
                  }
                  else
                  {
                     log("SWAP: no swap");
                     _loc2_.push(setSwapResponseObject(_loc3_,AttackActionTypes.NO_SWAP));
                  }
                  _loc3_.resetEnemy();
                  _loc3_.setNextNanovor(null);
                  _loc3_.setEnergyLevel(_loc3_.energyLevel + _loc3_.moddedEnergyGenerator);
               }
            }
         }
         return _loc2_;
      }
      
      public function resetPlayerAndNanovorStats() : void
      {
         var _loc1_:BattleLogicPlayer = null;
         var _loc2_:BattleLogicPlayer = null;
         for each(_loc1_ in _players)
         {
            if(!_loc1_.isDead() && !_loc1_.hasQuitGame())
            {
               _loc2_ = _loc1_.enemy;
               if(_loc2_ == null)
               {
                  _loc2_ = _loc1_;
               }
               _loc1_.resetModdedStats(_players.indexOf(_loc1_) == 0 ? true : false,_loc1_,_loc2_);
            }
         }
      }
      
      private function getTargetUpdates(param1:BattleLogicPlayer) : Object
      {
         var _loc2_:Object = new Object();
         if(param1 == null)
         {
            _loc2_.noTarget = "true";
            return _loc2_;
         }
         resetPlayerAndNanovorStats();
         _loc2_.username = param1.username;
         _loc2_.userRefId = param1.userRefId;
         _loc2_.energyLevel = param1.energyLevel;
         _loc2_.energyGenerator = param1.energyGenerator;
         _loc2_.swapChance = param1.swapPercentage;
         _loc2_.moddedEnergyGenerator = param1.moddedEnergyGenerator;
         _loc2_.moddedSwapChance = param1.moddedSwapPercentage;
         var _loc3_:Array = param1.overrides;
         if(_loc3_.length > 0)
         {
            log("player has this current override: " + param1.overrides[0].toString() + " and has these: " + param1.overrideIdsString);
            _loc2_.overrideId = param1.overrides[0].attackStatementId;
            _loc2_.overrideIds = param1.overrideIdsString;
         }
         _loc2_.hasNewNanovor = param1.hasNewNanovor;
         if(param1.hasNewNanovor)
         {
            _loc2_.newNanoAssetId = param1.nextNanovor.assetId;
            _loc2_.newNanoAssetTypeId = param1.nextNanovor.assetTypeId;
         }
         var _loc4_:Object = new Object();
         var _loc5_:BattleLogicNanovor = param1.selectedNanovor;
         _loc4_.name = _loc5_.nickName;
         _loc4_.instanceId = _loc5_.assetId;
         _loc4_.assetTypeId = _loc5_.assetTypeId;
         _loc4_.health = _loc5_.hitPoints;
         _loc4_.stunFailChance = _loc5_.stunFailPercent;
         _loc4_.dodgeChance = _loc5_.dodgeFailPercent;
         _loc4_.armor = _loc5_.armor;
         _loc4_.speed = _loc5_.speed;
         _loc4_.strength = _loc5_.strength;
         _loc4_.moddedStunFailChance = _loc5_.getModdedStat(Stat.STUN_FAIL_PERCENTAGE,false);
         _loc4_.moddedDodgeChance = _loc5_.getModdedStat(Stat.DODGE_FAIL_PERCENTAGE,false);
         _loc4_.moddedArmor = _loc5_.getModdedStat(Stat.ARMOR,false);
         _loc4_.moddedSpeed = _loc5_.getModdedStat(Stat.SPEED,false);
         _loc4_.moddedStrength = _loc5_.getModdedStat(Stat.STRENGTH,false);
         _loc4_.yellowSpike = _loc5_.yellowSpike;
         _loc4_.redSpike = _loc5_.redSpike;
         _loc4_.blueSpike = _loc5_.blueSpike;
         _loc4_.moddedYellowSpike = _loc5_.getModdedStat(Stat.YELLOW_SPIKE,false);
         _loc4_.moddedRedSpike = _loc5_.getModdedStat(Stat.RED_SPIKE,false);
         _loc4_.moddedBlueSpike = _loc5_.getModdedStat(Stat.BLUE_SPIKE,false);
         _loc4_.hacks = getHacksObject(_loc5_);
         _loc2_.selectedNanovor = _loc4_;
         return _loc2_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogic>>\t" + param1);
      }
      
      public function checkHacks(param1:BattleLogicPlayer) : Object
      {
         var _loc7_:BattleLogicAttackStatement = null;
         var _loc11_:BattleLogicAttackStatement = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc2_:Object = new Object();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Boolean = false;
         log("CHECKING HACKS FOR " + param1.username + " " + param1.selectedNanovor.name);
         var _loc8_:BattleLogicNanovor = param1.nextNanovor;
         var _loc9_:BattleLogicNanovor = param1.selectedNanovor;
         var _loc10_:Array = _loc9_.hacks;
         if(_loc10_ != null)
         {
            for each(_loc7_ in _loc10_)
            {
               _loc7_.currentAttacker = param1;
               _loc7_.currentEnemy = param1.enemy;
               if(_loc7_.currentEnemy == null)
               {
                  _loc7_.currentEnemy = param1;
               }
               log("HACK:::             " + _loc7_.name);
               if(_loc7_.type == BattleLogicAttackStatement.TYPE_HACK)
               {
                  log("STATEMENT:::        " + _loc7_.name);
                  log("STATEMENT DURATION: " + _loc7_.currentDuration + "/" + _loc7_.duration);
                  _loc7_.updateCurrentDuration();
                  if(_loc7_.currentDuration <= 0)
                  {
                     log("HACK REMOVED!");
                     _loc7_.resetCurrentDuration();
                     _loc5_.push(_loc7_);
                     _loc6_ = true;
                  }
                  else
                  {
                     _loc3_.push(prepareHackInfo(_loc7_,_loc9_));
                  }
               }
            }
         }
         if(_loc6_)
         {
            for each(_loc11_ in _loc5_)
            {
               _loc11_.currentAttacker = param1;
               _loc11_.currentEnemy = param1.enemy;
               if(_loc11_.currentEnemy == null)
               {
                  _loc11_.currentEnemy = param1;
               }
               _loc9_.removeHack(_loc11_);
               if(_loc8_ == null)
               {
                  _loc12_ = _loc11_.stat;
                  if(_loc12_ == Stat.STRENGTH || _loc12_ == Stat.ARMOR || _loc12_ == Stat.SPEED || _loc12_ == Stat.HEALTH)
                  {
                     _loc13_ = _loc12_ + "|" + _loc9_.getModdedStat(_loc12_,false);
                     _loc4_.push(_loc13_);
                  }
               }
            }
         }
         if(_loc8_ != null)
         {
            _loc10_ = _loc8_.hacks;
            if(_loc10_ != null)
            {
               for each(_loc7_ in _loc10_)
               {
                  log("HACK:::             " + _loc7_.name);
                  if(_loc7_.type == BattleLogicAttackStatement.TYPE_HACK)
                  {
                     _loc3_.push(prepareHackInfo(_loc7_,_loc8_));
                  }
               }
            }
         }
         _loc2_.userRefId = param1.userRefId;
         _loc2_.remainingHacks = _loc3_;
         _loc2_.statChanges = _loc4_;
         return _loc2_;
      }
      
      private function setAttackResponseObject(param1:BattleLogicPlayer, param2:int, param3:String, param4:String, param5:String, param6:int, param7:int) : Object
      {
         var _loc8_:String = null;
         if(param3 == BattleLogicAttackStatement.TYPE_OVERRIDE)
         {
            _loc8_ = AttackActionTypes.ADD_OVERRIDE;
         }
         else if(param3 == BattleLogicAttackStatement.TYPE_DAMAGE || param3 == BattleLogicAttackStatement.TYPE_MOD)
         {
            _loc8_ = AttackActionTypes.NONE;
         }
         else if(param3 == BattleLogicAttackStatement.TYPE_HACK)
         {
            _loc8_ = AttackActionTypes.ADD_HACK;
         }
         var _loc9_:Object = setActionResponseObject(param1,_loc8_,param5,param6);
         _loc9_.attackStatementId = param2.toString();
         _loc9_.statName = param4;
         _loc9_.totalDamage = param7.toString();
         return _loc9_;
      }
      
      private function calculateAttack(param1:BattleLogicAttackStatement, param2:Array, param3:Boolean, param4:BattleLogicPlayer, param5:BattleLogicPlayer) : Array
      {
         var _loc8_:BattleLogicPlayer = null;
         var _loc16_:BattleLogicNanovor = null;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc6_:String = param1.stat;
         var _loc7_:String = param1.verb;
         param1.currentAttacker = param4;
         param1.currentEnemy = param5;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Boolean = true;
         var _loc12_:Boolean = false;
         var _loc13_:Array = new Array();
         var _loc14_:Object = new Object();
         var _loc15_:String = param1.target;
         log("TARGET: " + _loc15_);
         if(_loc15_ == BattleLogicAttackStatement.TARGET_MY_NANOVOR)
         {
            _loc13_.push(param4.selectedNanovor);
            _loc11_ = false;
         }
         else if(_loc15_ == BattleLogicAttackStatement.TARGET_ENEMY_NANOVOR)
         {
            _loc13_.push(param5.selectedNanovor);
         }
         else if(_loc15_ == BattleLogicAttackStatement.TARGET_MY_TEAM)
         {
            _loc13_.push(param4.selectedNanovor);
            _loc11_ = false;
         }
         else if(_loc15_ == BattleLogicAttackStatement.TARGET_ENEMY_TEAM)
         {
            _loc13_.push(param5.selectedNanovor);
         }
         else if(_loc15_ == BattleLogicAttackStatement.TARGET_ALL_ACTIVE_NANOVOR)
         {
            _loc13_.push(param5.selectedNanovor);
            _loc13_.push(param4.selectedNanovor);
            _loc12_ = true;
         }
         else if(_loc15_ == BattleLogicAttackStatement.TARGET_ALL_SWARMS)
         {
            _loc13_.push(param4.selectedNanovor);
            _loc13_.push(param5.selectedNanovor);
            _loc12_ = true;
         }
         for each(_loc16_ in _loc13_)
         {
            if(param1.statementFormula != null)
            {
               _loc10_ = Math.round(param1.statementFormula.solve(param1,_loc16_));
            }
            _loc17_ = false;
            log("TARGETED NANOVOR: " + _loc16_);
            if(_loc6_ == Stat.HEALTH)
            {
               if(_loc10_ < 0)
               {
                  log("Damage was negative. Setting to 0");
                  _loc10_ = 0;
               }
               _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc16_.hitPoints,_loc7_,Number(_loc10_)));
               _loc16_.setHitPoints(_loc9_);
               _loc17_ = true;
               setPlayerStats(param4,_loc16_,_loc10_);
               if(_loc16_.owner.isDead() && !_loc16_.owner.hasQuitGame())
               {
                  log("SETTING PLAYER POSITION FOR OWNER OF DEAD NANOVOR");
                  setPlayerPosition(_loc16_.owner);
                  _loc16_.owner.setCompletedGame(true);
               }
            }
            else if(_loc6_ == Stat.STRENGTH)
            {
               if(param1.type == BattleLogicAttackStatement.TYPE_HACK || param1.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
               {
                  _loc9_ = _loc16_.getModdedStat(Stat.STRENGTH,param3);
               }
               else
               {
                  _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc16_.strength,_loc7_,_loc10_));
                  _loc16_.setStrength(_loc9_);
               }
               _loc17_ = true;
            }
            else if(_loc6_ == Stat.ARMOR)
            {
               if(param1.type == BattleLogicAttackStatement.TYPE_HACK || param1.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
               {
                  _loc9_ = _loc16_.getModdedStat(Stat.ARMOR,param3);
               }
               else
               {
                  _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc16_.armor,_loc7_,_loc10_));
                  _loc16_.setArmor(_loc9_);
               }
               _loc17_ = true;
            }
            else if(_loc6_ == Stat.SPEED)
            {
               if(param1.type == BattleLogicAttackStatement.TYPE_HACK || param1.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
               {
                  _loc9_ = _loc16_.getModdedStat(Stat.SPEED,param3);
               }
               else
               {
                  _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc16_.speed,_loc7_,_loc10_));
                  _loc16_.setSpeed(_loc9_);
               }
               _loc17_ = true;
            }
            else if(_loc6_ == Stat.SWAP_PERCENTAGE || _loc6_ == Stat.DODGE_FAIL_PERCENTAGE || _loc6_ == Stat.STUN_FAIL_PERCENTAGE)
            {
               if(param1.type == BattleLogicAttackStatement.TYPE_HACK || param1.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
               {
                  _loc9_ = 0;
               }
               _loc17_ = true;
            }
            _loc10_ = Math.round(_loc10_);
            if(_loc11_ && _loc17_)
            {
               log("Targeting the enemy");
               _loc14_ = setAttackResponseObject(_loc16_.owner,param1.attackStatementId,param1.type,_loc6_,_loc7_,_loc9_,_loc10_);
               _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
               param2.push(_loc14_);
            }
            else if(_loc17_)
            {
               log("Targeting attacker");
               _loc14_ = setAttackResponseObject(param4,param1.attackStatementId,param1.type,_loc6_,_loc7_,_loc9_,_loc10_);
               _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
               param2.push(_loc14_);
            }
            if(_loc6_ == Stat.ENERGY)
            {
               if(_loc12_)
               {
                  for each(_loc8_ in _players)
                  {
                     _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc8_.energyLevel,_loc7_,_loc10_));
                     _loc8_.setEnergyLevel(_loc9_);
                     _loc14_ = setAttackResponseObject(_loc8_,param1.attackStatementId,AttackActionTypes.MOD_ENERGY_LEVEL,_loc6_,_loc7_,_loc9_,_loc10_);
                     _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                     param2.push(_loc14_);
                  }
               }
               else if(_loc11_)
               {
                  _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(_loc16_.owner.energyLevel,_loc7_,_loc10_));
                  _loc16_.owner.setEnergyLevel(_loc9_);
                  _loc14_ = setAttackResponseObject(_loc16_.owner,param1.attackStatementId,AttackActionTypes.MOD_ENERGY_LEVEL,_loc6_,_loc7_,_loc9_,_loc10_);
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
               else
               {
                  _loc9_ = GameMath.checkNegativeNumbers(AttackStatementFormula.performOperation(param4.energyLevel,_loc7_,_loc10_));
                  param4.setEnergyLevel(_loc9_);
                  _loc14_ = setAttackResponseObject(param4,param1.attackStatementId,AttackActionTypes.MOD_ENERGY_LEVEL,_loc6_,_loc7_,_loc9_,_loc10_);
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
            }
            log("TARGET STAT: " + _loc6_);
            if(_loc6_ == Stat.OVERRIDE)
            {
               if(_loc12_)
               {
                  for each(_loc8_ in _players)
                  {
                     _loc8_.removeOverride();
                     _loc14_ = setActionResponseObject(_loc8_,AttackActionTypes.REMOVE_OVERRIDE);
                     _loc14_.attackStatementId = param1.attackStatementId.toString();
                     _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                     param2.push(_loc14_);
                  }
               }
               else if(_loc11_)
               {
                  log("Removing target\'s override");
                  _loc16_.owner.removeOverride();
                  _loc14_ = setActionResponseObject(_loc16_.owner,AttackActionTypes.REMOVE_OVERRIDE);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
               else
               {
                  log("Removing override");
                  param4.removeOverride();
                  _loc14_ = setActionResponseObject(param4,AttackActionTypes.REMOVE_OVERRIDE);
                  _loc14_.attackStatementId = param1.attackStatementId;
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
            }
            if(_loc6_ == Stat.RANDOM_HACK)
            {
               _loc18_ = _loc16_.removeRandomHack();
               if(_loc12_)
               {
                  for each(_loc8_ in _players)
                  {
                     _loc14_ = setActionResponseObject(_loc8_,AttackActionTypes.REMOVE_HACK,null,_loc18_);
                     _loc14_.attackStatementId = param1.attackStatementId.toString();
                     _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                     param2.push(_loc14_);
                  }
               }
               else if(_loc11_)
               {
                  _loc14_ = setActionResponseObject(_loc16_.owner,AttackActionTypes.REMOVE_HACK,null,_loc18_);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
               else
               {
                  _loc14_ = setActionResponseObject(param4,AttackActionTypes.REMOVE_HACK,null,_loc18_);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
            }
            if(_loc6_ == Stat.LAST_HACK)
            {
               log("Removing last hack");
               _loc16_.removeLastHack();
               if(_loc12_)
               {
                  for each(_loc8_ in _players)
                  {
                     _loc14_ = setActionResponseObject(_loc8_,AttackActionTypes.REMOVE_LAST_HACK);
                     _loc14_.attackStatementId = param1.attackStatementId.toString();
                     _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                     param2.push(_loc14_);
                  }
               }
               else if(_loc11_)
               {
                  _loc14_ = setActionResponseObject(_loc16_.owner,AttackActionTypes.REMOVE_LAST_HACK);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
               else
               {
                  _loc14_ = setActionResponseObject(param4,AttackActionTypes.REMOVE_LAST_HACK);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  _loc14_ = prepareClientDescription(_loc14_,param1,_loc10_);
                  param2.push(_loc14_);
               }
            }
            if(param1.type == BattleLogicAttackStatement.TYPE_OVERRIDE && !_loc17_)
            {
               if(_loc11_)
               {
                  _loc14_ = setActionResponseObject(_loc16_.owner,AttackActionTypes.ADD_OVERRIDE);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  param2.push(_loc14_);
               }
               else
               {
                  _loc14_ = setActionResponseObject(param4,AttackActionTypes.ADD_OVERRIDE);
                  _loc14_.attackStatementId = param1.attackStatementId.toString();
                  param2.push(_loc14_);
               }
            }
         }
         log("DAMAGE: " + _loc10_);
         return param2;
      }
      
      public function getGameOver() : Object
      {
         return generateGameResults();
      }
      
      public function calculateGameResults() : void
      {
         calculateNanovorResults();
      }
      
      private function setMasterNanovorList(param1:IMasterDataAssetRetriever) : void
      {
         var _loc2_:AssetDataLoader = new AssetDataLoader();
         _loc2_.setMasterNanovorDataURL(param1.getMasterDataURL(MasterDataAssetType.NANOVOR).url);
         _loc2_.loadMasterData();
      }
      
      private function addHack(param1:BattleLogicPlayer, param2:BattleLogicPlayer, param3:BattleLogicAttack, param4:BattleLogicAttackStatement) : Object
      {
         var _loc10_:BattleLogicAttackStatement = null;
         var _loc5_:Object = new Object();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         if(param4.type == BattleLogicAttackStatement.TYPE_HACK)
         {
            if(param4.target == BattleLogicAttackStatement.TARGET_ENEMY_NANOVOR || param4.target == BattleLogicAttackStatement.TARGET_ENEMY_TEAM)
            {
               param2.selectedNanovor.addHack(param4,true);
               _loc9_ = true;
            }
            else if(param4.target == BattleLogicAttackStatement.TARGET_MY_NANOVOR || param4.target == BattleLogicAttackStatement.TARGET_MY_TEAM)
            {
               param1.selectedNanovor.addHack(param4,false);
               _loc8_ = true;
            }
            else
            {
               param2.selectedNanovor.addHack(param4,true);
               _loc9_ = true;
               param1.selectedNanovor.addHack(param4,false);
               _loc8_ = true;
            }
            if(_loc8_)
            {
               for each(_loc10_ in param1.selectedNanovor.hacks)
               {
                  _loc6_.push(getHacksObject(param1.selectedNanovor));
               }
            }
            if(_loc9_)
            {
               for each(_loc10_ in param2.selectedNanovor.hacks)
               {
                  _loc7_.push(getHacksObject(param2.selectedNanovor));
               }
            }
            _loc5_.attackerHacks = _loc6_;
            _loc5_.enemyHacks = _loc7_;
         }
         return _loc5_;
      }
      
      public function receiveSwarm(param1:BattlePlayer, param2:Array) : void
      {
         var _loc5_:INanovor = null;
         var _loc6_:BattleLogicNanovor = null;
         var _loc7_:BattleLogicNanovor = null;
         log("receiveSwarm() - player: " + param1.playerName + " selectedNanovors.length=" + param2.length);
         var _loc3_:BattleLogicPlayer = getPlayerByBattlePlayer(param1);
         if(_loc3_ == null)
         {
            log("receiveSwarm() - Couldn\'t find player: " + param1.playerName);
            return;
         }
         var _loc4_:Array = new Array();
         for each(_loc5_ in param2)
         {
            for each(_loc6_ in MASTER_NANOVOR_LIST)
            {
               if(_loc6_.assetTypeId == _loc5_.assetTypeId)
               {
                  _loc7_ = _loc6_.clone();
                  _loc7_.setAssetId(_loc5_.assetId);
                  _loc7_.setArmor(_loc5_.armor);
                  _loc7_.setSpeed(_loc5_.speed);
                  _loc7_.setHitPoints(_loc5_.health);
                  _loc7_.setHitPointsTotal(_loc5_.health);
                  _loc7_.setStrength(_loc5_.strength);
                  _loc7_.setName(_loc5_.name);
                  _loc7_.setNickName(_loc5_.nickName);
                  _loc7_.setProductionNumber(_loc5_.productionNumber);
                  _loc4_.push(_loc7_);
               }
            }
         }
         _loc3_.setSwarm(_loc4_);
      }
      
      private function prepareClientDescription(param1:Object, param2:BattleLogicAttackStatement, param3:int) : Object
      {
         param2.prepareClientDescription(param3);
         param1.statementClientDescription = param2.getClientDescription();
         return param1;
      }
      
      private function setSwapResponseObject(param1:BattleLogicPlayer, param2:String = null) : Object
      {
         var _loc3_:Object = new Object();
         if(param1.nextNanovor != null)
         {
            _loc3_.newInstanceId = param1.nextNanovor.assetId;
            _loc3_.newAssetTypeId = param1.nextNanovor.assetTypeId;
         }
         if(param2 != null)
         {
            _loc3_.type = param2;
            _loc3_.userRefId = param1.userRefId;
            _loc3_.instanceId = param1.selectedNanovor.assetId;
            _loc3_.assetTypeId = param1.selectedNanovor.assetTypeId;
         }
         else
         {
            _loc3_ = setSwapResponseObject(param1,AttackActionTypes.SWAP);
         }
         return _loc3_;
      }
      
      private function getPlayerByBattlePlayer(param1:BattlePlayer) : BattleLogicPlayer
      {
         var _loc2_:BattleLogicPlayer = null;
         for each(_loc2_ in _players)
         {
            if(_loc2_.username.toLowerCase() == param1.playerName.toLowerCase() && _loc2_.userRefId == param1.playerId.toString())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function generateGameResults() : Object
      {
         var _loc2_:BattleLogicPlayer = null;
         var _loc5_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Boolean = false;
         var _loc1_:int = 0;
         var _loc3_:Object = new Object();
         var _loc4_:Array = new Array();
         for each(_loc2_ in _players)
         {
            _loc7_ = getActivePlayers();
            if((_loc2_.completedGame() || !_loc2_.hasQuitGame()) && _loc7_.length < 2)
            {
               if(_loc2_.position == 0)
               {
                  _loc2_.setPosition(1);
                  _loc3_.winnerId = _loc2_.userRefId;
               }
               _loc1_++;
            }
         }
         _loc5_ = 2;
         while(_loc5_ <= _loc1_)
         {
            _loc8_ = false;
            for each(_loc2_ in _players)
            {
               if(_loc2_.position == _loc5_)
               {
                  _loc8_ = true;
               }
            }
            if(!_loc8_)
            {
               for each(_loc2_ in _players)
               {
                  if(_loc2_.position > _loc5_)
                  {
                     _loc2_.setPosition(_loc2_.position - 1);
                  }
               }
            }
            _loc5_++;
         }
         for each(_loc2_ in _players)
         {
            if(_loc2_.completedGame() || !_loc2_.hasQuitGame())
            {
               if(_loc7_.length < 2)
               {
                  _loc4_.push(getPlayerStats(_loc2_));
               }
            }
         }
         calculateGameResults();
         if(_loc4_.length > 0)
         {
            _loc3_.results = _loc4_;
         }
         else
         {
            _loc3_ = null;
         }
         var _loc6_:int = 0;
         for each(_loc2_ in _players)
         {
            if(!_loc2_.hasQuitGame() || _loc2_.declinedToWatch())
            {
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public function increaseRoundCounter() : int
      {
         return ++_roundCounter;
      }
      
      public function getRound(param1:BattlePlayer) : Round
      {
         return new Round(_roundInfo,_attackResults,_roundResults);
      }
      
      private function setPlayerStats(param1:BattleLogicPlayer, param2:BattleLogicNanovor, param3:int) : void
      {
         param1.addDamageToTotal(param3);
         param1.setMaximumDamage(param3);
         param1.selectedNanovor.addDamageToTotal(param3);
         param1.selectedNanovor.setMaxDamageHit(param3);
         if(param2.hitPoints <= 0)
         {
            param2.diedInBattle();
            if(param2.owner.userRefId != param1.userRefId)
            {
               param1.incKillCount();
               param1.selectedNanovor.incKillCount();
               if(param2.faction == Faction.HEXITE)
               {
                  param1.incHexiteKillCount();
                  param1.selectedNanovor.incHexiteKillCount();
               }
               else if(param2.faction == Faction.MAGNAMOD)
               {
                  param1.incMagnamodKillCount();
                  param1.selectedNanovor.incMagnamodKillCount();
               }
               else if(param2.faction == Faction.VELOCITRON)
               {
                  param1.incVelocitronKillCount();
                  param1.selectedNanovor.incVelocitronKillCount();
               }
            }
         }
      }
      
      private function isOverrideAttack(param1:BattleLogicAttack) : Boolean
      {
         var _loc3_:BattleLogicAttackStatement = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1.attackStatements)
         {
            if(_loc3_.type == BattleLogicAttackStatement.TYPE_OVERRIDE)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
   }
}

