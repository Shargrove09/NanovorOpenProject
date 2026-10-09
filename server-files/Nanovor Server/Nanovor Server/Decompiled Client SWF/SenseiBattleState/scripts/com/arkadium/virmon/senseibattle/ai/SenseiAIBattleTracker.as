package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.AttackActionTypes;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfo;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfoNanovor;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfoPlayer;
   import com.arkadium.virmon.senseibattle.IRound;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiAIBattleTracker implements ISenseiAIBattleTracker
   {
      
      private var _currentRound:int;
      
      private var _enemyPlayer:IPlayer;
      
      private var _senseiPlayer:IPlayer;
      
      public function SenseiAIBattleTracker()
      {
         super();
         _currentRound = 0;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiAIBattleTracker>>\t" + param1);
      }
      
      public function processRound(param1:IRound) : void
      {
         log("processRound()");
         processRoundInfo(param1.roundInfo);
         processAttackResults(param1.attackResults);
         processRoundResults(param1.roundResults);
      }
      
      private function getPlayerById(param1:int) : IPlayer
      {
         var _loc2_:IPlayer = null;
         for each(_loc2_ in [_enemyPlayer,_senseiPlayer])
         {
            if(_loc2_.userRefId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<SenseiAIBattleTracker>>\t" + param1);
      }
      
      private function processRoundInfo(param1:Object) : void
      {
         var _loc4_:RoundInfoPlayer = null;
         var _loc5_:int = 0;
         var _loc6_:IPlayer = null;
         var _loc7_:RoundInfoNanovor = null;
         var _loc8_:INanovor = null;
         ++_currentRound;
         var _loc2_:RoundInfo = new RoundInfo(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.roundInfoPlayers.length)
         {
            _loc4_ = _loc2_.roundInfoPlayers[_loc3_];
            _loc5_ = _loc4_.userRefId;
            _loc6_ = getPlayerById(_loc5_);
            if(null == _loc6_)
            {
               throw new Error("Player userRefId: " + _loc5_.toString() + " not found.");
            }
            _loc6_.roundPosition = _loc3_;
            _loc7_ = _loc4_.selectedNanovor;
            if(null != _loc7_)
            {
               _loc8_ = _loc6_.findNanovor(_loc7_.assetId);
               if(null == _loc8_)
               {
                  _loc8_ = _loc6_.makeAndAddNanovor(_loc7_.assetId,_loc7_.assetTypeId);
                  _loc8_.nickName = _loc7_.nickName;
                  _loc8_.baseSpeed = _loc7_.speed;
                  _loc8_.baseStrength = _loc7_.strength;
                  _loc8_.baseArmor = _loc7_.armor;
                  _loc8_.baseHealth = _loc7_.health;
               }
               _loc8_.speed = _loc7_.speed;
               _loc8_.strength = _loc7_.strength;
               _loc8_.armor = _loc7_.armor;
               _loc8_.health = _loc7_.health;
               _loc6_.selectedNanovor = _loc8_;
            }
            _loc3_++;
         }
      }
      
      private function processAttackResults(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:IPlayer = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.attackActions.length)
            {
               _loc5_ = _loc3_.attackActions[_loc4_];
               _loc6_ = _loc5_.targetUserRefId == null ? 0 : int(_loc5_.targetUserRefId);
               _loc7_ = getPlayerById(_loc6_);
               updateTarget(_loc7_,_loc5_.targetUpdates);
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      public function init(param1:IPlayer, param2:IPlayer) : void
      {
         _senseiPlayer = param1;
         _enemyPlayer = param2;
      }
      
      private function updateTarget(param1:IPlayer, param2:Object) : void
      {
         var wasAlive:Boolean = false;
         var nanovor:Object = null;
         var i:int = 0;
         var split:Array = null;
         var overrideId:* = undefined;
         var statement:IAttackStatement = null;
         var player:IPlayer = param1;
         var targetUpdates:Object = param2;
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
            player.currentOverrideArray = new Array();
            if(targetUpdates.overrideIds != null)
            {
               split = targetUpdates.overrideIds.split(",");
               for each(overrideId in split)
               {
                  player.currentOverrideArray.push(AttackStatement.createAttackStatementById(int(overrideId)));
               }
            }
            else if(targetUpdates.overrideId != null)
            {
               player.currentOverrideArray = [AttackStatement.createAttackStatementById(int(targetUpdates.overrideId))];
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
            logError(e.getStackTrace());
         }
      }
      
      private function processRoundResults(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:IPlayer = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:IPlayer = null;
         var _loc9_:int = 0;
         var _loc10_:IPlayer = null;
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:* = undefined;
         var _loc14_:Object = null;
         var _loc15_:INanovor = null;
         var _loc16_:Array = null;
         var _loc17_:* = undefined;
         var _loc18_:IAttackStatement = null;
         log("processRoundResults()");
         var _loc2_:Object = param1.swapActions;
         if(_loc2_ != null)
         {
            log("processRoundResults() - Have swap action");
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               _loc7_ = _loc2_[_loc6_];
               _loc8_ = getPlayerById(int(_loc7_.userRefId));
               _loc9_ = int(_loc7_.type);
               if(null != _loc8_)
               {
                  _loc8_.swapReason = _loc9_;
                  if(_loc9_ == AttackActionTypes.SWAP)
                  {
                     _loc8_.hasNewNanovor = true;
                  }
               }
               _loc6_++;
            }
         }
         var _loc3_:Object = param1.players;
         for each(_loc4_ in _loc3_)
         {
            _loc10_ = getPlayerById(int(_loc4_.userRefId));
            if(null != _loc10_)
            {
               _loc10_.energyLevel = int(_loc4_.energyLevel);
               _loc10_.energyGenerator = int(_loc4_.energyGenerator);
               _loc10_.moddedEnergyGenerator = int(_loc4_.moddedEnergyGenerator);
               _loc10_.swapPercentage = Number(_loc4_.swapPercentage);
               _loc10_.moddedSwapPercentage = Number(_loc4_.moddedSwapPercentage);
               _loc10_.currentOverrideArray = new Array();
               if(_loc4_.overrideIds != null)
               {
                  _loc16_ = _loc4_.overrideIds.split(",");
                  for each(_loc17_ in _loc16_)
                  {
                     _loc10_.currentOverrideArray.push(AttackStatement.createAttackStatementById(int(_loc17_)));
                  }
               }
               else if(_loc4_.overrideId != null)
               {
                  _loc10_.currentOverrideArray = [AttackStatement.createAttackStatementById(int(_loc4_.overrideId))];
               }
               _loc11_ = _loc4_.selectedNanovor;
               if(_loc4_.oldNanovor != null && Boolean(_loc4_.oldNanovor.instanceId))
               {
                  _loc11_ = _loc4_.oldNanovor;
               }
               _loc12_ = new Array();
               for each(_loc13_ in _loc11_.hacks)
               {
                  _loc18_ = AttackStatement.createAttackStatementById(int(_loc13_.statementId));
                  if(null != _loc18_)
                  {
                     _loc18_.currentDuration = int(_loc11_.currentDuration);
                     _loc12_.push(_loc18_);
                  }
               }
               _loc10_.selectedNanovor.hacks = _loc12_;
               _loc14_ = _loc4_.selectedNanovor;
               _loc15_ = _loc10_.findNanovor(_loc14_.instanceId);
               if(Boolean(_loc10_.hasNewNanovor) && _loc10_.swapReason == AttackActionTypes.SWAP)
               {
                  if(_loc15_ == null)
                  {
                     _loc15_ = _loc10_.makeAndAddNanovor(_loc14_.instanceId,int(_loc14_.assetTypeId));
                     _loc15_.nickName = _loc14_.nickname;
                     _loc15_.baseSpeed = int(_loc14_.speed);
                     _loc15_.baseStrength = int(_loc14_.strength);
                     _loc15_.baseArmor = int(_loc14_.armor);
                     _loc15_.baseHealth = int(_loc14_.health);
                  }
                  _loc10_.nextNanovor = _loc15_;
               }
               if(_loc15_ != null)
               {
                  _loc15_.speed = int(_loc14_.speed);
                  _loc15_.strength = int(_loc14_.strength);
                  _loc15_.armor = int(_loc14_.armor);
                  _loc15_.health = int(_loc14_.health);
               }
            }
         }
         for each(_loc5_ in [_enemyPlayer,_senseiPlayer])
         {
            if(_loc10_.nextNanovor != null)
            {
               _loc10_.selectedNanovor = _loc10_.nextNanovor;
               _loc10_.nextNanovor = null;
            }
            _loc10_.swapReason = AttackActionTypes.NO_SWAP;
            _loc10_.hasNewNanovor = false;
            _loc10_.resetStatHistory(true);
         }
      }
   }
}

