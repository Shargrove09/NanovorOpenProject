package com.arkadium.virmon.senseibattle
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IGameServiceInvitationManager;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IBattleCreationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationAcceptHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationErrorHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationRequestHandler;
   import com.arkadium.communications.handlers.battle.IBattleInvitationResponseHandler;
   import com.arkadium.communications.handlers.battle.IBattlePlayerKickedOutHandler;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.battle.IEnemySelectedHandler;
   import com.arkadium.communications.handlers.battle.IGameOverHandler;
   import com.arkadium.communications.handlers.battle.IGameSwarmSelectedHandler;
   import com.arkadium.communications.handlers.battle.IGameSwarmValueSetHandler;
   import com.arkadium.communications.handlers.battle.IJoinBattleErrorHandler;
   import com.arkadium.communications.handlers.battle.IOtherPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPerformAttackHandler;
   import com.arkadium.communications.handlers.battle.IPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IPlayerQuitGameHandler;
   import com.arkadium.communications.handlers.battle.IQuittingGameHandler;
   import com.arkadium.communications.handlers.battle.IReadyForTurnHandler;
   import com.arkadium.communications.handlers.battle.IRoomDestroyedHandler;
   import com.arkadium.communications.handlers.battle.IRoundCompletedHandler;
   import com.arkadium.communications.handlers.battle.ISelectedNanovorErrorHandler;
   import com.arkadium.communications.handlers.battle.ISetRoundInfoHandler;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiBattleGameService implements IBattleGameService
   {
      
      private var _senseiBattleServerImitator:ISenseiBattleServerImitator;
      
      private var _battleGameServiceHandler:IBattleGameServiceHandler;
      
      public function SenseiBattleGameService(param1:ISenseiBattleServerImitator, param2:IBattleGameServiceHandler)
      {
         super();
         _senseiBattleServerImitator = param1;
         _battleGameServiceHandler = param2;
      }
      
      public function removeOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         _battleGameServiceHandler.removeOtherPlayerJoinBattleHandler(param1);
      }
      
      public function removeBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         _battleGameServiceHandler.removeBattleStartedHandler(param1);
      }
      
      public function kickPlayerOut(param1:String) : void
      {
      }
      
      public function removeRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         _battleGameServiceHandler.removeRoundCompletedHandler(param1);
      }
      
      public function removeBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         _battleGameServiceHandler.removeBattleInvitationAcceptHandler(param1);
      }
      
      public function addRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         _battleGameServiceHandler.addRoundCompletedHandler(param1);
      }
      
      public function addGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         _battleGameServiceHandler.addGameSwarmValueSetHandler(param1);
      }
      
      public function createGame(param1:int = 1000, param2:Boolean = false) : void
      {
      }
      
      public function addBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         _battleGameServiceHandler.addBattleInvitationAcceptHandler(param1);
      }
      
      public function setAttackInfo(param1:ICombatTurnData) : void
      {
         _senseiBattleServerImitator.receiveAttackInfo(param1);
      }
      
      public function removeBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         _battleGameServiceHandler.removeBattleCreationErrorHandler(param1);
      }
      
      public function getBadgeList(param1:String, param2:String) : void
      {
      }
      
      public function addRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         _battleGameServiceHandler.addRoomDestroyedHandler(param1);
      }
      
      public function removeBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         _battleGameServiceHandler.removeBattleInvitationRequestHandler(param1);
      }
      
      public function setSwarm(param1:Array) : void
      {
         _senseiBattleServerImitator.receiveSwarm(param1);
      }
      
      public function removeEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         _battleGameServiceHandler.removeEnemySelectedHandler(param1);
      }
      
      public function addBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         _battleGameServiceHandler.addBattleInvitationResponseHandler(param1);
      }
      
      public function addPerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         _battleGameServiceHandler.addPerformAttackHandler(param1);
      }
      
      public function isGame() : Boolean
      {
         return true;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<TempSenseiBattleGameService>>\t" + param1);
      }
      
      public function setEnemy(param1:String) : void
      {
      }
      
      public function setAttack(param1:int) : void
      {
      }
      
      public function get numPlayers() : int
      {
         return 2;
      }
      
      public function removeGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         _battleGameServiceHandler.removeGameSwarmSelectedHandler(param1);
      }
      
      public function addBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         _battleGameServiceHandler.addBattleCreatedHandler(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<TempSenseiBattleGameService>>\t" + param1);
      }
      
      public function removeGameOverHandler(param1:IGameOverHandler) : void
      {
         _battleGameServiceHandler.removeGameOverHandler(param1);
      }
      
      public function removePlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         _battleGameServiceHandler.removePlayerJoinBattleHandler(param1);
      }
      
      public function removeJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         _battleGameServiceHandler.removeJoinBattleErrorHandler(param1);
      }
      
      public function addSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         _battleGameServiceHandler.addSelectedNanovorErrorHandler(param1);
      }
      
      public function setGameSwarmValue(param1:int = 1000) : void
      {
      }
      
      public function createQuickBattle(param1:int = 1000, param2:int = 2) : void
      {
      }
      
      public function addGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         _battleGameServiceHandler.addGameSwarmSelectedHandler(param1);
      }
      
      public function get battleName() : String
      {
         return "";
      }
      
      public function cancelMatchMaking() : void
      {
      }
      
      public function addBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         _battleGameServiceHandler.addBattleErrorHandler(param1);
      }
      
      public function addSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         _battleGameServiceHandler.addSetRoundInfoHandler(param1);
      }
      
      public function addBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         _battleGameServiceHandler.addBattlePlayerKickedOutHandler(param1);
      }
      
      public function endRound() : void
      {
         _senseiBattleServerImitator.receiveEndRound();
      }
      
      public function addBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         _battleGameServiceHandler.addBattleInvitationErrorHandler(param1);
      }
      
      public function addBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         _battleGameServiceHandler.addBattleInvitationRequestHandler(param1);
      }
      
      public function removeRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         _battleGameServiceHandler.removeRoomDestroyedHandler(param1);
      }
      
      public function addQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         _battleGameServiceHandler.addQuittingGameHandler(param1);
      }
      
      public function addOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         _battleGameServiceHandler.addOtherPlayerJoinBattleHandler(param1);
      }
      
      public function getCreatorName() : String
      {
         return "";
      }
      
      public function get isCreator() : Boolean
      {
         return false;
      }
      
      public function addGameOverHandler(param1:IGameOverHandler) : void
      {
         _battleGameServiceHandler.addGameOverHandler(param1);
      }
      
      public function removeBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         _battleGameServiceHandler.removeBattleErrorHandler(param1);
      }
      
      public function addPlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         _battleGameServiceHandler.addPlayerJoinBattleHandler(param1);
      }
      
      public function setNextSwap(param1:int) : void
      {
      }
      
      public function removePerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         _battleGameServiceHandler.removePerformAttackHandler(param1);
      }
      
      public function getCreatorId() : String
      {
         return "";
      }
      
      public function get players() : Array
      {
         return [];
      }
      
      public function removeSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         _battleGameServiceHandler.removeSetRoundInfoHandler(param1);
      }
      
      public function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void
      {
      }
      
      public function removeSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         _battleGameServiceHandler.removeSelectedNanovorErrorHandler(param1);
      }
      
      public function addBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         _battleGameServiceHandler.addBattleStartedHandler(param1);
      }
      
      public function replyGameInvitation(param1:String, param2:Boolean, param3:String) : void
      {
      }
      
      public function removeBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         _battleGameServiceHandler.removeBattleCreatedHandler(param1);
      }
      
      public function setSelectedNanovor(param1:int) : void
      {
      }
      
      public function addJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         _battleGameServiceHandler.addJoinBattleErrorHandler(param1);
      }
      
      public function addReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         _battleGameServiceHandler.addReadyForTurnHandler(param1);
      }
      
      public function removeBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         _battleGameServiceHandler.removeBattleInvitationErrorHandler(param1);
      }
      
      public function removeBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         _battleGameServiceHandler.removeBattlePlayerKickedOutHandler(param1);
      }
      
      public function addEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         _battleGameServiceHandler.addEnemySelectedHandler(param1);
      }
      
      public function removeReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         _battleGameServiceHandler.removeReadyForTurnHandler(param1);
      }
      
      public function removePlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         _battleGameServiceHandler.removePlayerQuitGameHandler(param1);
      }
      
      public function inviteUser(param1:String, param2:Boolean = false) : void
      {
      }
      
      public function quitGame() : void
      {
      }
      
      public function playerDeclinedToWatch(param1:String) : void
      {
      }
      
      public function addPlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         _battleGameServiceHandler.addPlayerQuitGameHandler(param1);
      }
      
      public function removeQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         _battleGameServiceHandler.removeQuittingGameHandler(param1);
      }
      
      public function removeBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         _battleGameServiceHandler.removeBattleInvitationResponseHandler(param1);
      }
      
      public function removeGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         _battleGameServiceHandler.removeGameSwarmValueSetHandler(param1);
      }
      
      public function startGame() : void
      {
      }
      
      public function addBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         _battleGameServiceHandler.addBattleCreationErrorHandler(param1);
      }
   }
}

