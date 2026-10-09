package com.arkadium.communications
{
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
   
   public interface IBattleGameService
   {
      
      function addBattleErrorHandler(param1:IBattleErrorHandler) : void;
      
      function removeBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void;
      
      function removeBattleStartedHandler(param1:IBattleStartedHandler) : void;
      
      function kickPlayerOut(param1:String) : void;
      
      function removeRoundCompletedHandler(param1:IRoundCompletedHandler) : void;
      
      function addBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void;
      
      function addRoundCompletedHandler(param1:IRoundCompletedHandler) : void;
      
      function removeBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void;
      
      function createGame(param1:int = 1000, param2:Boolean = false) : void;
      
      function addBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void;
      
      function addBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void;
      
      function inviteUser(param1:String, param2:Boolean = false) : void;
      
      function removeRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void;
      
      function addOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void;
      
      function addQuittingGameHandler(param1:IQuittingGameHandler) : void;
      
      function addGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void;
      
      function removeBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void;
      
      function removeBattleErrorHandler(param1:IBattleErrorHandler) : void;
      
      function setAttackInfo(param1:ICombatTurnData) : void;
      
      function startGame() : void;
      
      function addBattleStartedHandler(param1:IBattleStartedHandler) : void;
      
      function addGameOverHandler(param1:IGameOverHandler) : void;
      
      function removePerformAttackHandler(param1:IPerformAttackHandler) : void;
      
      function addPlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void;
      
      function removeSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void;
      
      function get isCreator() : Boolean;
      
      function removeEnemySelectedHandler(param1:IEnemySelectedHandler) : void;
      
      function removeSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void;
      
      function addReadyForTurnHandler(param1:IReadyForTurnHandler) : void;
      
      function setNextSwap(param1:int) : void;
      
      function removeBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void;
      
      function getCreatorId() : String;
      
      function getBadgeList(param1:String, param2:String) : void;
      
      function addRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void;
      
      function replyGameInvitation(param1:String, param2:Boolean, param3:String) : void;
      
      function setSwarm(param1:Array) : void;
      
      function addBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void;
      
      function get players() : Array;
      
      function isGame() : Boolean;
      
      function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void;
      
      function removeBattleCreatedHandler(param1:IBattleCreatedHandler) : void;
      
      function addPerformAttackHandler(param1:IPerformAttackHandler) : void;
      
      function getCreatorName() : String;
      
      function addJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void;
      
      function setEnemy(param1:String) : void;
      
      function addEnemySelectedHandler(param1:IEnemySelectedHandler) : void;
      
      function setAttack(param1:int) : void;
      
      function get numPlayers() : int;
      
      function removeGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void;
      
      function setSelectedNanovor(param1:int) : void;
      
      function removeBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void;
      
      function addBattleCreatedHandler(param1:IBattleCreatedHandler) : void;
      
      function removeBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void;
      
      function removeGameOverHandler(param1:IGameOverHandler) : void;
      
      function quitGame() : void;
      
      function removeReadyForTurnHandler(param1:IReadyForTurnHandler) : void;
      
      function removePlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void;
      
      function playerDeclinedToWatch(param1:String) : void;
      
      function removeQuittingGameHandler(param1:IQuittingGameHandler) : void;
      
      function addPlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void;
      
      function removeJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void;
      
      function createQuickBattle(param1:int = 1000, param2:int = 2) : void;
      
      function removePlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void;
      
      function addSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void;
      
      function setGameSwarmValue(param1:int = 1000) : void;
      
      function addSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void;
      
      function addGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void;
      
      function get battleName() : String;
      
      function endRound() : void;
      
      function addBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void;
      
      function cancelMatchMaking() : void;
      
      function removeGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void;
      
      function addBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void;
      
      function removeOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void;
   }
}

