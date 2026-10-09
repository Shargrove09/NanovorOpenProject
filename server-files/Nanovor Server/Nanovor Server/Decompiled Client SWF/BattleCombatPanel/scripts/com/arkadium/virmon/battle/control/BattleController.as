package com.arkadium.virmon.battle.control
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.handlers.battle.IPerformAttackHandler;
   import com.arkadium.communications.handlers.battle.IRoundCompletedHandler;
   import com.arkadium.communications.handlers.battle.ISetRoundInfoHandler;
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.CRef;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfo;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfoNanovor;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfoPlayer;
   import com.arkadium.virmon.battle.substates.combatgame.CombatUIController;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.AttackPreviewGenerator;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class BattleController implements ISetRoundInfoHandler, IPerformAttackHandler, IRoundCompletedHandler
   {
      
      private var _nanovorEndRoundHacks:Dictionary;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _playerAttacks:Array;
      
      private var _myPlayer:IPlayer;
      
      private var _battleGameService:IBattleGameService;
      
      private var _battleData:IBattleData;
      
      private var _playerEndRoundStats:Dictionary;
      
      private var _roundControl:RoundController;
      
      private var _players:Array;
      
      private var _currentRound:int;
      
      private var _combatUIControl:CombatUIController;
      
      public function BattleController(param1:IPlayerFactory, param2:CombatUIController, param3:IBattleGameService, param4:IBattleData, param5:ICharacterAssetTypeCache, param6:IOverlayAssetRetriever)
      {
         super();
         log("BattleController()");
         _playerFactory = param1;
         _combatUIControl = param2;
         _battleGameService = param3;
         _roundControl = new RoundController(this,param5,param6);
         _players = new Array();
         _playerAttacks = new Array();
         _currentRound = 0;
         CRef.battleController = this;
         _battleData = param4;
      }
      
      public function removePlayer(param1:IPlayer) : void
      {
         _players.splice(_players.indexOf(param1),1);
      }
      
      public function init(param1:int) : void
      {
         var _loc4_:BattlePlayer = null;
         log("BattleController::init()");
         _battleGameService.addSetRoundInfoHandler(ISetRoundInfoHandler(this));
         _battleGameService.addPerformAttackHandler(IPerformAttackHandler(this));
         _battleGameService.addRoundCompletedHandler(IRoundCompletedHandler(this));
         var _loc2_:Array = _battleData.playersInBattle;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_] as BattlePlayer;
            log("adding " + _loc4_.playerName + " (" + _loc4_.playerId + ")");
            addPlayer(_loc4_.playerName,_loc4_.playerId);
            _loc3_++;
         }
         _myPlayer = getPlayerById(param1);
      }
      
      public function getNextPlayerAttack() : PlayerAttack
      {
         var _loc1_:IPlayer = null;
         var _loc2_:IPlayerStats = null;
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:INanovor = null;
         var _loc6_:AttackStatement = null;
         if(_playerAttacks.length > 0)
         {
            log("NEXT ATTACK: " + _playerAttacks[0].toString());
            return _playerAttacks[0];
         }
         addStatHistory();
         for(_loc3_ in _playerEndRoundStats)
         {
            _loc2_ = _playerEndRoundStats[_loc3_];
            _loc1_ = _loc3_ as Player;
            log("getNextPlayerAttack() - player: " + _loc1_.username + " has " + _loc1_.swarm.length + " nanovors");
            for each(_loc5_ in _loc1_.swarm)
            {
               log("getNextPlayerAttack() - \t\tnansovor:" + _loc5_.assetId);
            }
            _loc1_.energyLevel = _loc2_.energyLevel;
            _loc1_.energyGenerator = _loc2_.energyGenerator;
            _loc1_.moddedEnergyGenerator = _loc2_.moddedEnergyGenerator;
            _loc1_.swapPercentage = _loc2_.swapPercentage;
            _loc1_.moddedSwapPercentage = _loc2_.moddedSwapPercentage;
            _loc1_.currentOverrideArray = new Array();
            for each(_loc6_ in _loc2_.currentOverrideArray)
            {
               _loc1_.currentOverrideArray.push(AttackStatement.copy(_loc6_));
            }
            log(" >>>> added stat history <<<< [" + _loc1_.username + "][" + _loc1_.statIndex + "] ==> " + _loc1_.getPlayerStats());
         }
         for(_loc3_ in _nanovorEndRoundHacks)
         {
            _loc4_ = _nanovorEndRoundHacks[_loc3_];
            _loc1_ = _loc3_ as Player;
            log("getNextPlayerAttack() - player == null? " + Boolean(null == _loc1_));
            log("getNextPlayerAttack() - player.selectedNanovor == null? " + Boolean(null == _loc1_.selectedNanovor));
            log("getNextPlayerAttack() - player.selectedNanovor.hacks == null? " + Boolean(null == _loc1_.selectedNanovor.hacks));
            log("getNextPlayerAttack() - aHacks == null? " + Boolean(null == _loc4_));
            _loc1_.selectedNanovor.hacks = _loc4_.slice();
         }
         log("=============================");
         log("END ROUND " + _currentRound);
         log("RoundCon(BC) SHOULD BE RETURNING NULL");
         return null;
      }
      
      public function get currentRound() : int
      {
         return _currentRound;
      }
      
      public function checkVictory() : int
      {
         var _loc1_:int = -1;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < _players.length)
         {
            if(!_players[_loc3_].isDead)
            {
               _loc2_.push(_players[_loc3_]);
            }
            _loc3_++;
         }
         if(_loc2_.length == 1)
         {
            _loc1_ = int(_loc2_[0].userRefId);
         }
         return _loc1_;
      }
      
      public function readyForAttackSelection() : void
      {
         var _loc1_:IPlayer = null;
         for each(_loc1_ in _players)
         {
            _loc1_.statIndex = _loc1_.statHistory.length - 1;
         }
         _combatUIControl.updateUIState(true);
         _combatUIControl.isAnimationPlaying = false;
         resetPlayerRoundVars();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<BattleController>>\t" + param1);
      }
      
      public function handleRoundCompleted(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:IPlayer = null;
         var _loc9_:int = 0;
         var _loc10_:PlayerStats = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:* = undefined;
         var _loc14_:Array = null;
         var _loc15_:* = undefined;
         var _loc16_:IAttackStatement = null;
         var _loc17_:Object = null;
         var _loc18_:INanovor = null;
         log("onRoundCompletedFromServer()");
         if(param1 != null)
         {
            log("got results");
            _loc2_ = param1.swapActions;
            if(_loc2_ != null)
            {
               log("got swapActions");
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc6_ = _loc2_[_loc5_];
                  _loc7_ = int(_loc6_.userRefId);
                  _loc8_ = getPlayerById(_loc7_);
                  _loc9_ = int(_loc6_.type);
                  log("SWAP REASON: " + _loc9_);
                  if(Boolean(_loc8_))
                  {
                     _loc8_.swapReason = _loc9_;
                     if(_loc9_ == AttackActionTypes.SWAP)
                     {
                        _loc8_.hasNewNanovor = true;
                     }
                  }
                  _loc5_++;
               }
            }
            _loc3_ = param1.players;
            for each(_loc4_ in _loc3_)
            {
               _loc8_ = getPlayerById(_loc4_.userRefId);
               if(Boolean(_loc8_))
               {
                  _loc10_ = new PlayerStats();
                  _loc10_.energyLevel = int(_loc4_.energyLevel);
                  _loc10_.energyGenerator = int(_loc4_.energyGenerator);
                  _loc10_.moddedEnergyGenerator = int(_loc4_.moddedEnergyGenerator);
                  _loc10_.swapPercentage = Number(_loc4_.swapPercentage);
                  _loc10_.moddedSwapPercentage = Number(_loc4_.moddedSwapPercentage);
                  log("onRoundCompletedFromServer() overrides: " + _loc4_.overrideIds);
                  if(_loc4_.overrideIds != null)
                  {
                     _loc14_ = _loc4_.overrideIds.split(",");
                     for each(_loc15_ in _loc14_)
                     {
                        _loc10_.currentOverrideArray.push(AttackStatement.createAttackStatementById(int(_loc15_)));
                     }
                  }
                  else if(_loc4_.overrideId != null)
                  {
                     _loc10_.currentOverrideArray = [AttackStatement.createAttackStatementById(int(_loc4_.overrideId))];
                  }
                  _playerEndRoundStats[_loc8_] = _loc10_;
                  _loc11_ = new Array();
                  if(_loc4_.oldNanovor != null && Boolean(_loc4_.oldNanovor.instanceId))
                  {
                     _loc12_ = _loc4_.oldNanovor;
                  }
                  else
                  {
                     _loc12_ = _loc4_.selectedNanovor;
                  }
                  for each(_loc13_ in _loc12_.hacks)
                  {
                     _loc16_ = AttackStatement.createAttackStatementById(int(_loc13_.statementId));
                     if(Boolean(_loc16_))
                     {
                        _loc16_.currentDuration = int(_loc13_.currentDuration);
                        _loc11_.push(_loc16_);
                     }
                  }
                  _nanovorEndRoundHacks[_loc8_] = _loc11_;
                  if(Boolean(_loc8_.hasNewNanovor) && _loc8_.swapReason == AttackActionTypes.SWAP)
                  {
                     _loc17_ = _loc4_.selectedNanovor;
                     _loc18_ = _loc8_.findNanovor(_loc17_.instanceId);
                     if(_loc18_ == null)
                     {
                        _loc18_ = _loc8_.makeAndAddNanovor(_loc17_.instanceId,int(_loc17_.assetTypeId));
                        _loc18_.nickName = _loc17_.nickname;
                        _loc18_.baseSpeed = int(_loc17_.speed);
                        _loc18_.baseStrength = int(_loc17_.strength);
                        _loc18_.baseArmor = int(_loc17_.armor);
                        _loc18_.baseHealth = int(_loc17_.health);
                     }
                     _loc18_.speed = int(_loc17_.speed);
                     _loc18_.strength = int(_loc17_.strength);
                     _loc18_.armor = int(_loc17_.armor);
                     _loc18_.health = int(_loc17_.health);
                     _loc8_.nextNanovor = _loc18_;
                  }
               }
            }
         }
         _roundControl.startRound();
         _combatUIControl.isAnimationPlaying = true;
         if(!_combatUIControl.oneRoundCompleted)
         {
            _combatUIControl.oneRoundCompleted = true;
         }
         log("analytics: state: " + Managers.stateManager.state);
         if(Managers.stateManager.state == StateType.SENSEI_BATTLE.name)
         {
            Managers.analyticsManager.trackView(View.SENSEI_ANIMATION_MODE);
         }
         else
         {
            Managers.analyticsManager.trackView(View.BATTLE_ANIMATION_MODE);
         }
      }
      
      private function resetPlayerRoundVars() : void
      {
         var _loc1_:IPlayer = null;
         for each(_loc1_ in _players)
         {
            if(_loc1_.nextNanovor != null)
            {
               _loc1_.selectedNanovor = _loc1_.nextNanovor;
               _loc1_.nextNanovor = null;
            }
            _loc1_.swapReason = AttackActionTypes.NO_SWAP;
            _loc1_.hasNewNanovor = false;
            _loc1_.resetStatHistory(true);
         }
         _playerEndRoundStats = new Dictionary(true);
         _nanovorEndRoundHacks = new Dictionary(true);
      }
      
      public function get myPlayer() : IPlayer
      {
         return _myPlayer;
      }
      
      public function get players() : Array
      {
         return _players;
      }
      
      private function updateTarget(param1:IPlayer, param2:Object, param3:int) : void
      {
         var wasAlive:Boolean = false;
         var nanovor:Object = null;
         var i:int = 0;
         var split:Array = null;
         var overrideId:* = undefined;
         var statement:IAttackStatement = null;
         var player:IPlayer = param1;
         var targetUpdates:Object = param2;
         var attackId:int = param3;
         log("updateTarget(): [" + player.username + "]\n" + Utils.ObjectToString(targetUpdates));
         try
         {
            if(targetUpdates.noTarget != null || targetUpdates.selectedNanovor == null)
            {
               return;
            }
            log("PLAYER BEFORE: " + player.toString());
            log("NANOVOR BEFORE: " + player.selectedNanovor.toString());
            player.energyLevel = int(targetUpdates.energyLevel);
            player.energyGenerator = int(targetUpdates.energyGenerator);
            player.swapPercentage = int(targetUpdates.swapChance);
            player.moddedEnergyGenerator = int(targetUpdates.moddedEnergyGenerator);
            player.moddedSwapPercentage = int(targetUpdates.moddedSwapChance);
            log("updateTarget() overrides: " + targetUpdates.overrideIds);
            player.currentOverrideArray = new Array();
            player.currentOverrideDescription = "";
            if(targetUpdates.overrideIds != null)
            {
               split = targetUpdates.overrideIds.split(",");
               for each(overrideId in split)
               {
                  player.currentOverrideArray.push(AttackStatement.createAttackStatementById(int(overrideId)));
               }
               if(split.length != 0)
               {
                  player.currentOverrideDescription = Attack.getOverrideDescription(attackId);
               }
            }
            else if(targetUpdates.overrideId != null)
            {
               player.currentOverrideArray = [AttackStatement.createAttackStatementById(int(targetUpdates.overrideId))];
               player.currentOverrideDescription = Attack.getOverrideDescription(attackId);
            }
            wasAlive = player.selectedNanovor.health > 0;
            nanovor = targetUpdates.selectedNanovor;
            player.selectedNanovor.health = int(nanovor.health);
            player.selectedNanovor.stunFailPercent = int(nanovor.stunFailChance);
            player.selectedNanovor.dodgeFailPercent = int(nanovor.dodgeChance);
            player.selectedNanovor.armor = int(nanovor.armor);
            player.selectedNanovor.speed = int(nanovor.speed);
            player.selectedNanovor.strength = int(nanovor.strength);
            player.selectedNanovor.moddedStunFailPercent = int(nanovor.moddedStunFailChance);
            player.selectedNanovor.moddedDodgeFailPercent = int(nanovor.moddedDodgeChance);
            player.yellowSpike = int(nanovor.yellowSpike);
            player.blueSpike = int(nanovor.blueSpike);
            player.redSpike = int(nanovor.redSpike);
            player.moddedYellowSpike = int(nanovor.moddedYellowSpike);
            player.moddedBlueSpike = int(nanovor.moddedBlueSpike);
            player.moddedRedSpike = int(nanovor.moddedRedSpike);
            if(player.selectedNanovor.health <= 0)
            {
               player.selectedNanovor.isDead = true;
               if(wasAlive)
               {
                  player.lastNanovorDiedInRoundNum = _currentRound;
               }
               player.checkSwarmDead();
            }
            player.selectedNanovor.removeAllHacks();
            i = 0;
            while(i < nanovor.hacks.length)
            {
               statement = AttackStatement.createAttackStatementById(int(nanovor.hacks[i].statementId));
               if(Boolean(statement))
               {
                  statement.currentDuration = int(nanovor.hacks[i].currentDuration);
                  player.selectedNanovor.addHack(statement);
               }
               i++;
            }
            log("PLAYER AFTER: " + player.toString());
            log("NANOVOR AFTER: " + player.selectedNanovor.toString());
         }
         catch(e:Error)
         {
            logError("updateTarget(): " + e.getStackTrace());
         }
      }
      
      private function addStatHistory() : void
      {
         var _loc1_:IPlayer = null;
         log("addStatHistory()");
         for each(_loc1_ in _players)
         {
            _loc1_.addStatHistory();
         }
      }
      
      public function handlePerformAttack(param1:Object) : void
      {
         var a:int = 0;
         var attackResult:Object = null;
         var attackerId:int = 0;
         var attackerNanovorId:String = null;
         var attackerNanovorAssetTypeId:int = 0;
         var attackId:int = 0;
         var p:int = 0;
         var attackAction:Object = null;
         var targetUserRefId:int = 0;
         var targetNanovorId:String = null;
         var targetNanovorAssetTypeId:int = 0;
         var statementId:int = 0;
         var reason:int = 0;
         var clientDescription:String = null;
         var totalDamage:* = undefined;
         var player:IPlayer = null;
         var playerAttack:PlayerAttack = null;
         var nanovor:INanovor = null;
         var attack:Attack = null;
         var attackResults:Object = param1;
         log("handlePerformAttack()");
         try
         {
            a = 0;
            while(a < attackResults.length)
            {
               attackResult = attackResults[a];
               attackerId = int(attackResult.attackerId);
               attackerNanovorId = attackResult.attackerNanovorId;
               attackerNanovorAssetTypeId = int(attackResult.attackerNanovorAssetId);
               attackId = attackResult.attackId == null ? 0 : int(attackResult.attackId);
               log("ATTACK RESULT: attackerId=" + attackerId + " attackerNanoId=" + attackerNanovorId + " attackerNanoTypeId=" + attackerNanovorAssetTypeId + " aid=" + attackId);
               p = 0;
               while(p < attackResult.attackActions.length)
               {
                  attackAction = attackResult.attackActions[p];
                  targetUserRefId = attackAction.targetUserRefId == null ? 0 : int(attackAction.targetUserRefId);
                  targetNanovorId = attackAction.targetNanovorId == null ? "0" : attackAction.targetNanovorId;
                  targetNanovorAssetTypeId = attackAction.targetNanovorAssetTypeId == null ? 0 : int(attackAction.targetNanovorAssetTypeId);
                  statementId = attackAction.attackStatementId == null ? 0 : int(attackAction.attackStatementId);
                  reason = attackAction.type == null ? 0 : int(attackAction.type);
                  clientDescription = attackAction.statementClientDescription == null ? "" : attackAction.statementClientDescription;
                  totalDamage = attackAction.totalDamage == null ? 0 : int(attackAction.totalDamage);
                  log("ATTACK ACTION: trgUserId=" + targetUserRefId + " trgNanoId=" + targetNanovorId + " trgNanoTypeId=" + targetNanovorAssetTypeId + " sid=" + statementId + " reason=" + reason + " desc=" + clientDescription + " dam=" + totalDamage);
                  player = getPlayerById(attackerId);
                  playerAttack = new PlayerAttack();
                  playerAttack.serverTargetUpdates = attackAction.targetUpdates;
                  playerAttack.player = player;
                  playerAttack.targetPlayer = targetUserRefId != 0 ? getPlayerById(targetUserRefId) : player;
                  playerAttack.attackId = attackId;
                  playerAttack.reason = reason;
                  playerAttack.attackStatement = statementId != 0 ? AttackStatement.createAttackStatementById(statementId) : null;
                  if(Boolean(playerAttack.attackStatement))
                  {
                     playerAttack.ignoresArmor = playerAttack.attackStatement.name.indexOf("AP") > -1;
                  }
                  if(attackAction.value != null)
                  {
                     playerAttack.newValueOfStat = attackAction.value;
                  }
                  playerAttack.clientDescription = clientDescription;
                  playerAttack.totalDamage = totalDamage;
                  log(playerAttack.player.username + " ==> " + playerAttack.targetPlayer.username);
                  log("handlePerformAttack() - player: " + player.username + " has " + player.swarm.length + " nanovors");
                  for each(nanovor in player.swarm)
                  {
                     log("handlePerformAttack() - \t\tnansovor:" + nanovor.assetId);
                  }
                  player.selectedNanovor = player.findNanovor(attackerNanovorId);
                  if(player.selectedNanovor == null)
                  {
                     throw new Error("attackerNanovorId (" + attackerNanovorId + ") not found in player (" + player.username + ")\'s swarm!");
                  }
                  if(targetNanovorId != "0" && targetNanovorAssetTypeId != 0)
                  {
                     playerAttack.targetPlayer.selectedNanovor = playerAttack.targetPlayer.findNanovor(targetNanovorId);
                     if(playerAttack.targetPlayer.selectedNanovor == null)
                     {
                        throw new Error("targetNanovorId not found in player (" + playerAttack.targetPlayer.username + ")\'s swarm!");
                     }
                  }
                  if(Boolean(player.selectedNanovor))
                  {
                     player.selectedNanovor.selectedAttack = null;
                     for each(attack in player.selectedNanovor.attacks)
                     {
                        if(attackId == attack.attackID)
                        {
                           player.selectedNanovor.selectedAttack = attack;
                           break;
                        }
                     }
                  }
                  player.enemy = playerAttack.targetPlayer;
                  if(playerAttack.attackStatement != null || playerAttack.attackId == 0 || reason == AttackActionTypes.FIZZLE || reason == AttackActionTypes.DODGED || reason == AttackActionTypes.TARGET_IS_DEAD)
                  {
                     log("ADDING ATTACK " + _playerAttacks.length + ": " + playerAttack.toString());
                     if(reason == AttackActionTypes.DODGED)
                     {
                        playerAttack.dodge = true;
                     }
                     _playerAttacks.push(playerAttack);
                     playerAttack.playerAttackIndex = _playerAttacks.length;
                  }
                  else
                  {
                     logError("ATTACK INFO INCOMPLETE, SID " + statementId + " NOT FOUND FOR PLAYER ATTACK: " + playerAttack.toString());
                  }
                  p++;
               }
               a++;
            }
         }
         catch(e:Error)
         {
            logError("handlePerformAttack(): " + e.getStackTrace());
         }
      }
      
      public function get combatUIController() : CombatUIController
      {
         return _combatUIControl;
      }
      
      public function updatePlayerUIDuringAnimation(param1:int) : void
      {
         var _loc2_:IPlayer = null;
         log("GAME STATE INDEX: " + param1);
         for each(_loc2_ in _players)
         {
            _loc2_.statIndex = param1;
         }
         _combatUIControl.updateUIState();
      }
      
      public function getPlayerById(param1:int) : IPlayer
      {
         var _loc2_:IPlayer = null;
         for each(_loc2_ in _players)
         {
            if(_loc2_.userRefId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get roundController() : RoundController
      {
         return _roundControl;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleController>>\t" + param1);
      }
      
      public function applyCurrentPlayerAttack() : Boolean
      {
         var _loc1_:PlayerAttack = null;
         log("APPLY PLAYER ATTACK");
         if(_playerAttacks.length > 0)
         {
            _loc1_ = _playerAttacks.shift();
            addStatHistory();
            if(_loc1_.serverTargetUpdates != null)
            {
               updateTarget(_loc1_.targetPlayer,_loc1_.serverTargetUpdates,_loc1_.attackId);
            }
            log(" >>>> added stat history <<<< [" + _loc1_.targetPlayer.username + "][" + _loc1_.targetPlayer.statIndex + "] ==> " + _loc1_.targetPlayer.getPlayerStats());
            return true;
         }
         log("NO MORE PLAYER ATTACKS");
         return false;
      }
      
      public function getPlayerByAnimationIndex(param1:int) : IPlayer
      {
         var _loc2_:IPlayer = null;
         for each(_loc2_ in _players)
         {
            if(_loc2_.animationIndex == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function addPlayer(param1:String, param2:int) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < _players.length)
         {
            if(_players[_loc3_].username == param1)
            {
               return;
            }
            _loc3_++;
         }
         log("addPlayer: " + param1 + " " + param2);
         var _loc4_:IPlayer = _playerFactory.createPlayer(param1,param2);
         _players.push(_loc4_);
      }
      
      public function handleSetRoundInfo(param1:RoundInfo) : void
      {
         var _loc3_:RoundInfoPlayer = null;
         var _loc4_:int = 0;
         var _loc5_:IPlayer = null;
         var _loc6_:RoundInfoNanovor = null;
         var _loc7_:INanovor = null;
         ++_currentRound;
         var _loc2_:int = 0;
         while(_loc2_ < param1.roundInfoPlayers.length)
         {
            _loc3_ = param1.roundInfoPlayers[_loc2_];
            _loc4_ = _loc3_.userRefId;
            _loc5_ = getPlayerById(_loc4_);
            _loc5_.roundPosition = _loc2_;
            _loc6_ = _loc3_.selectedNanovor;
            if(null != _loc6_)
            {
               _loc7_ = _loc5_.findNanovor(_loc6_.assetId);
               if(null == _loc7_)
               {
                  _loc7_ = _loc5_.makeAndAddNanovor(_loc6_.assetId,_loc6_.assetTypeId);
                  _loc7_.nickName = _loc6_.nickName;
                  _loc7_.baseSpeed = _loc6_.speed;
                  _loc7_.baseStrength = _loc6_.strength;
                  _loc7_.baseArmor = _loc6_.armor;
                  _loc7_.baseHealth = _loc6_.health;
               }
               _loc7_.speed = _loc6_.speed;
               _loc7_.strength = _loc6_.strength;
               _loc7_.armor = _loc6_.armor;
               _loc7_.health = _loc6_.health;
               _loc5_.selectedNanovor = _loc7_;
               combatUIController.updatePlayerSwarmometer(_loc5_);
            }
            _loc2_++;
         }
      }
      
      public function verifyBase() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:IPlayer = null;
         var _loc6_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in myPlayer.baseAttackPreviews)
         {
            _loc1_ += "nanovorID: " + _loc2_ + "\n";
            for(_loc3_ in myPlayer.baseAttackPreviews[_loc2_])
            {
               _loc1_ += "attackID: " + _loc3_ + "\n";
               for(_loc4_ in myPlayer.baseAttackPreviews[_loc2_][_loc3_].players)
               {
                  _loc5_ = getPlayerById(int(_loc4_));
                  _loc1_ += "\tvs player: " + _loc4_ + "\n";
                  for(_loc6_ in myPlayer.baseAttackPreviews[_loc2_][_loc3_].players[_loc4_])
                  {
                     _loc1_ += "\t\t" + _loc6_ + ": " + myPlayer.baseAttackPreviews[_loc2_][_loc3_].players[_loc4_][_loc6_] + "\n";
                  }
               }
            }
         }
      }
      
      public function generateAttackPreviews(param1:Boolean = false, param2:IPlayer = null) : void
      {
         if(param2 == null)
         {
            param2 = _myPlayer;
         }
         AttackPreviewGenerator.GenerateSelectedNanovorPreview(param1,param2,_players);
         if(param1)
         {
            verifyBase();
         }
         else
         {
            verify();
         }
      }
      
      public function generateSwarmAttackPreviews() : void
      {
         var _loc1_:INanovor = _myPlayer.selectedNanovor;
         var _loc2_:int = 0;
         while(_loc2_ < _myPlayer.swarm.length)
         {
            _myPlayer.selectedNanovor = _myPlayer.swarm[_loc2_];
            generateAttackPreviews(true);
            _loc2_++;
         }
         _myPlayer.selectedNanovor = _loc1_;
      }
      
      public function verify() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:IPlayer = null;
         var _loc5_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in myPlayer.attackPreviews)
         {
            _loc1_ += "attackID: " + _loc2_ + "\n";
            for(_loc3_ in myPlayer.attackPreviews[_loc2_].players)
            {
               _loc4_ = getPlayerById(int(_loc3_));
               _loc1_ += "\tvs player: " + _loc3_ + "\n";
               for(_loc5_ in myPlayer.attackPreviews[_loc2_].players[_loc3_])
               {
                  _loc1_ += "\t\t" + _loc5_ + ": " + myPlayer.attackPreviews[_loc2_].players[_loc3_][_loc5_] + "\n";
               }
            }
         }
      }
      
      public function destroy() : void
      {
         log("destroy()");
         _battleGameService.removeSetRoundInfoHandler(ISetRoundInfoHandler(this));
         _battleGameService.removePerformAttackHandler(IPerformAttackHandler(this));
         _battleGameService.removeRoundCompletedHandler(IRoundCompletedHandler(this));
         _roundControl.destroy();
         Managers.unsetManager(Managers.BATTLE_CONTROLLER);
      }
   }
}

