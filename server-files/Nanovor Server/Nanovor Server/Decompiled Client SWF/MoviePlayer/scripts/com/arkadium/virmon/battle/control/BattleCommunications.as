package com.arkadium.virmon.battle.control
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.handlers.battle.IBattleErrorHandler;
   import com.arkadium.communications.handlers.battle.IGameOverHandler;
   import com.arkadium.communications.handlers.battle.IPlayerQuitGameHandler;
   import com.arkadium.communications.handlers.battle.IReadyForTurnHandler;
   import com.arkadium.communications.handlers.battle.ISelectedNanovorErrorHandler;
   import com.arkadium.virmon.battle.substates.combatgame.CombatGamePanel;
   import com.arkadium.virmon.battle.substates.combatgame.CombatTurnData;
   import com.arkadium.virmon.battle.substates.combatgame.CombatUIController;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleCommunications implements IBattleErrorHandler, ISelectedNanovorErrorHandler, IPlayerQuitGameHandler, IReadyForTurnHandler, IGameOverHandler
   {
      
      private var _battleGameService:IBattleGameService;
      
      private var _combatGamePanel:CombatGamePanel;
      
      private var _combatUIController:CombatUIController;
      
      private var _myUserRefId:int;
      
      public function BattleCommunications(param1:CombatGamePanel, param2:CombatUIController, param3:IBattleGameService)
      {
         super();
         log("BattleCommunications()");
         _battleGameService = param3;
         _combatGamePanel = param1;
         _combatUIController = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("[BattleCommunications] " + param1);
      }
      
      public function handleReadyForTurn(param1:String, param2:int, param3:Boolean) : void
      {
         _combatUIController.readyForTurn();
      }
      
      public function sendSwarmToServer(param1:Array) : void
      {
         _battleGameService.setSwarm(param1);
      }
      
      public function init(param1:int) : void
      {
         log("init()");
         _myUserRefId = param1;
         _battleGameService.addPlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _battleGameService.addReadyForTurnHandler(IReadyForTurnHandler(this));
         _battleGameService.addGameOverHandler(IGameOverHandler(this));
         _battleGameService.addSelectedNanovorErrorHandler(ISelectedNanovorErrorHandler(this));
         _battleGameService.addBattleErrorHandler(IBattleErrorHandler(this));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("[BattleCommunications] " + param1);
      }
      
      public function sendTurn(param1:CombatTurnData) : void
      {
         _battleGameService.setAttackInfo(param1);
      }
      
      public function handleSelectedNanovorError() : void
      {
         _combatGamePanel.destroy();
      }
      
      public function handleBattleError() : void
      {
         _combatGamePanel.destroy();
      }
      
      public function handlePlayerQuitGame(param1:int, param2:String) : void
      {
         log("handlePlayerQuitGame()");
         _combatUIController.opponentLeaveGame(param1);
         _combatGamePanel.opponentLeaveGame(param1);
      }
      
      public function handleGameOver(param1:int, param2:Object) : void
      {
         log("handleGameOver(): game over.");
         _combatGamePanel.gameOver(param1,param2);
      }
      
      public function destroy() : void
      {
         log("destroy()");
         _battleGameService.removePlayerQuitGameHandler(IPlayerQuitGameHandler(this));
         _battleGameService.removeReadyForTurnHandler(IReadyForTurnHandler(this));
         _battleGameService.removeGameOverHandler(IGameOverHandler(this));
         _battleGameService.removeSelectedNanovorErrorHandler(ISelectedNanovorErrorHandler(this));
         _battleGameService.removeBattleErrorHandler(IBattleErrorHandler(this));
      }
      
      public function sendAnimationComplete() : void
      {
         _battleGameService.endRound();
      }
      
      public function sendPlayerDeclinedToWatch() : void
      {
         _battleGameService.playerDeclinedToWatch(String(_myUserRefId));
      }
   }
}

