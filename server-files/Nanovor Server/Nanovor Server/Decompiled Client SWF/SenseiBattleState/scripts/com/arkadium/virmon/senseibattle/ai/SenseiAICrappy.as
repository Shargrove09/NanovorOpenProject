package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.senseibattle.IRound;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiAICrappy implements ISenseiAI
   {
      
      private var _senseiAIMoveGenerator:ISenseiAIMoveGenerator;
      
      private var _battleTracker:ISenseiAIBattleTracker;
      
      private var _enemyPlayer:IPlayer;
      
      private var _senseiPlayer:IPlayer;
      
      public function SenseiAICrappy(param1:IPlayer, param2:IPlayer, param3:ISenseiAIBattleTracker, param4:ISenseiAIMoveGenerator)
      {
         super();
         _senseiPlayer = param1;
         _enemyPlayer = param2;
         _battleTracker = param3;
         _senseiAIMoveGenerator = param4;
         _senseiAIMoveGenerator.setSenseiSwarm(_senseiPlayer.swarm,_enemyPlayer.username);
      }
      
      public function getPlayerName() : String
      {
         return _senseiPlayer.username;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiAICrappy>>\t" + param1);
      }
      
      public function setRound(param1:IRound) : void
      {
         _battleTracker.processRound(param1);
         log("setRound() - _enemyPlayer: " + _enemyPlayer.toString());
         log("setRound() - _senseiPlayer: " + _senseiPlayer.toString());
         _senseiAIMoveGenerator.updateEnemySwarm(new SenseiNanovor(_enemyPlayer.selectedNanovor));
         _senseiAIMoveGenerator.setRemoteNanovor(new SenseiNanovor(_enemyPlayer.hasNewNanovor ? _enemyPlayer.nextNanovor : _enemyPlayer.selectedNanovor));
      }
      
      public function getCombatTurnData() : ICombatTurnData
      {
         _senseiAIMoveGenerator.selectActiveNanovor(ISenseiNanovor(_senseiPlayer.selectedNanovor));
         var _loc1_:ICombatTurnData = _senseiAIMoveGenerator.getCombatTurnData();
         log("getCombatTurnData() - activeNanovor: " + _loc1_.MyActiveNanovorId);
         log("getCombatTurnData() - nextNanovor: " + _loc1_.MyNextNanovorId);
         return _loc1_;
      }
      
      public function getPlayerId() : int
      {
         return _senseiPlayer.userRefId;
      }
      
      public function setPlayerSwarmSize(param1:int) : void
      {
         _enemyPlayer.swarmSize = param1;
      }
      
      public function getSelectedNanovors() : Array
      {
         return _senseiPlayer.swarm;
      }
   }
}

