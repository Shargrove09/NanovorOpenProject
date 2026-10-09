package com.arkadium.virmon.senseibattle
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
   
   public interface IBattleGameServiceHandler
   {
      
      function removeBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void;
      
      function removeOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void;
      
      function addBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void;
      
      function addJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void;
      
      function removeGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void;
      
      function addEnemySelectedHandler(param1:IEnemySelectedHandler) : void;
      
      function addPerformAttackHandler(param1:IPerformAttackHandler) : void;
      
      function addBattleErrorHandler(param1:IBattleErrorHandler) : void;
      
      function removeBattleStartedHandler(param1:IBattleStartedHandler) : void;
      
      function addBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void;
      
      function addGameOverHandler(param1:IGameOverHandler) : void;
      
      function addRoundCompletedHandler(param1:IRoundCompletedHandler) : void;
      
      function removeGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void;
      
      function addBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void;
      
      function removeBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void;
      
      function addOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void;
      
      function addQuittingGameHandler(param1:IQuittingGameHandler) : void;
      
      function addBattleCreatedHandler(param1:IBattleCreatedHandler) : void;
      
      function removeReadyForTurnHandler(param1:IReadyForTurnHandler) : void;
      
      function removeBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void;
      
      function removeBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void;
      
      function removeRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void;
      
      function removeGameOverHandler(param1:IGameOverHandler) : void;
      
      function removeRoundCompletedHandler(param1:IRoundCompletedHandler) : void;
      
      function addBattleStartedHandler(param1:IBattleStartedHandler) : void;
      
      function removePlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void;
      
      function removePlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void;
      
      function removeBattleErrorHandler(param1:IBattleErrorHandler) : void;
      
      function addPlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void;
      
      function addPlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void;
      
      function removeJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void;
      
      function addGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void;
      
      function addSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void;
      
      function addGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void;
      
      function addReadyForTurnHandler(param1:IReadyForTurnHandler) : void;
      
      function removeSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void;
      
      function removeBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void;
      
      function removeEnemySelectedHandler(param1:IEnemySelectedHandler) : void;
      
      function removeSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void;
      
      function removeBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void;
      
      function addSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void;
      
      function addBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void;
      
      function removeQuittingGameHandler(param1:IQuittingGameHandler) : void;
      
      function addBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void;
      
      function addBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void;
      
      function addRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void;
      
      function removePerformAttackHandler(param1:IPerformAttackHandler) : void;
      
      function removeBattleCreatedHandler(param1:IBattleCreatedHandler) : void;
   }
}

