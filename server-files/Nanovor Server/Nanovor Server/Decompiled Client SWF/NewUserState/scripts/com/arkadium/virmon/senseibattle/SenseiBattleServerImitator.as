package com.arkadium.virmon.senseibattle
{
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAI;
   import com.arkadium.virmon.senseibattle.battlelogic.IBattleLogic;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiBattleServerImitator implements ISenseiBattleServerImitator
   {
      
      private var _battleData:IBattleData;
      
      private var _senseiAI:ISenseiAI;
      
      private var _battleLogic:IBattleLogic;
      
      private var _battleGameServerConsumer:IBattleGameServerConsumer;
      
      private var _senseiBattlePlayer:BattlePlayer;
      
      private var _playerBattlePlayer:BattlePlayer;
      
      private var _nanovorFactory:INanovorFactory;
      
      public function SenseiBattleServerImitator(param1:INanovorFactory, param2:ISenseiAI, param3:IBattleData, param4:IBattleLogic, param5:IBattleGameServerConsumer)
      {
         super();
         _nanovorFactory = param1;
         _senseiAI = param2;
         _battleData = param3;
         _battleLogic = param4;
         _battleGameServerConsumer = param5;
         if(BattlePlayer(param3.playersInBattle[0]).playerName.toLowerCase() == param2.getPlayerName().toLowerCase())
         {
            _playerBattlePlayer = param3.playersInBattle[1];
            _senseiBattlePlayer = param3.playersInBattle[0];
         }
         else
         {
            _playerBattlePlayer = param3.playersInBattle[0];
            _senseiBattlePlayer = param3.playersInBattle[1];
         }
      }
      
      public function receiveAttackInfo(param1:ICombatTurnData) : void
      {
         _battleLogic.receiveCombatTurnData(_senseiBattlePlayer,_senseiAI.getCombatTurnData());
         _battleLogic.receiveCombatTurnData(_playerBattlePlayer,param1);
         var _loc2_:Round = _battleLogic.getRound(_playerBattlePlayer);
         log("receiveAttackInfo() - roundInfo:\n" + Utils.ObjectToString(_loc2_.roundInfo));
         log("receiveAttackInfo() - attackResults:\n" + Utils.ObjectToString(_loc2_.attackResults));
         log("receiveAttackInfo() - roundResults:\n" + Utils.ObjectToString(_loc2_.roundResults));
         checkRoundInfoData(_loc2_.roundInfo);
         _battleGameServerConsumer.setRoundInfo(_loc2_.roundInfo);
         _battleGameServerConsumer.performAttack(_loc2_.attackResults);
         _battleGameServerConsumer.roundCompleted(_loc2_.roundResults);
         var _loc3_:Object = _battleLogic.getGameOver();
         if(null != _loc3_)
         {
            log("receiveAttackInfo() - gameOver:\n" + Utils.ObjectToString(_loc3_));
            _battleGameServerConsumer.gameOver(int(_loc3_.winnerId),_loc3_.results);
         }
         _senseiAI.setRound(_battleLogic.getRound(_senseiBattlePlayer));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiBattleServerImitator>>\t" + param1);
      }
      
      private function sendReadyForTurnResponse() : void
      {
         _battleGameServerConsumer.readyForTurn();
      }
      
      public function receiveSwarm(param1:Array) : void
      {
         var _loc4_:String = null;
         log("receiveSwarm(): selectedSwarmIds = " + param1.join(","));
         var _loc2_:Array = _senseiAI.getSelectedNanovors();
         _battleLogic.receiveSwarm(_senseiBattlePlayer,_loc2_);
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_nanovorFactory.createNanovorInstanceById(_loc4_));
         }
         _battleLogic.receiveSwarm(_playerBattlePlayer,_loc3_);
         _senseiAI.setPlayerSwarmSize(param1.length);
         _battleGameServerConsumer.swarmSelected(null,_loc2_.length,_senseiAI.getPlayerName(),_senseiAI.getPlayerId());
         _battleGameServerConsumer.swarmSelected(null,param1.length,_playerBattlePlayer.playerName,_playerBattlePlayer.playerId);
         sendReadyForTurnResponse();
      }
      
      public function receiveEndRound() : void
      {
         sendReadyForTurnResponse();
      }
      
      private function checkRoundInfoData(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(null == param1)
         {
            throw new Error("roundInfo is null");
         }
         if(null == param1.players)
         {
            throw new Error("roundInfo.players is null");
         }
         if(2 != param1.players.length)
         {
            throw new Error("roundInfo.players is not 2 players");
         }
         var _loc2_:int = 0;
         while(_loc2_ < 2)
         {
            _loc3_ = param1.players[_loc2_] as Object;
            if(null == _loc3_)
            {
               throw new Error("playerObject is null");
            }
            if(null == _loc3_.userRefId)
            {
               throw new Error("playerObject.userRefId is null");
            }
            _loc4_ = _loc3_.selectedNanovor as Object;
            if(null == _loc4_)
            {
               throw new Error("selectedNanovorObject is null");
            }
            if(null == _loc4_.instanceId)
            {
               throw new Error("selectedNanovorObject.instanceId is null");
            }
            if(null == _loc4_.assetTypeId)
            {
               throw new Error("selectedNanovorObject.assetTypeId is null");
            }
            if(null == _loc4_.nickname)
            {
               throw new Error("selectedNanovorObject.nickname is null");
            }
            if(null == _loc4_.speed)
            {
               throw new Error("selectedNanovorObject.speed is null");
            }
            if(null == _loc4_.strength)
            {
               throw new Error("selectedNanovorObject.strength is null");
            }
            if(null == _loc4_.armor)
            {
               throw new Error("selectedNanovorObject.armor is null");
            }
            if(null == _loc4_.health)
            {
               throw new Error("selectedNanovorObject.health is null");
            }
            _loc2_++;
         }
      }
   }
}

