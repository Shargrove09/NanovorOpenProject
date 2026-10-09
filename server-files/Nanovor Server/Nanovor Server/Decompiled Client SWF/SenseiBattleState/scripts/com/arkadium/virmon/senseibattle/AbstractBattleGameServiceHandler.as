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
   
   public class AbstractBattleGameServiceHandler extends AbstractHandler implements IBattleGameServiceHandler
   {
      
      public function AbstractBattleGameServiceHandler()
      {
         super([IBattleCreatedHandler,IBattleCreationErrorHandler,IBattleInvitationErrorHandler,IJoinBattleErrorHandler,ISelectedNanovorErrorHandler,IBattleErrorHandler,IBattleInvitationRequestHandler,IBattleInvitationResponseHandler,IBattlePlayerKickedOutHandler,IPlayerJoinBattleHandler,IOtherPlayerJoinBattleHandler,IBattleStartedHandler,IGameSwarmValueSetHandler,IGameSwarmSelectedHandler,IReadyForTurnHandler,IEnemySelectedHandler,ISetRoundInfoHandler,IPerformAttackHandler,IRoundCompletedHandler,IPlayerQuitGameHandler,IGameOverHandler,IQuittingGameHandler,IRoomDestroyedHandler,IBattleInvitationAcceptHandler]);
      }
      
      public function addBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         addHandler(IBattleCreationErrorHandler,param1);
      }
      
      public function addBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         addHandler(IBattlePlayerKickedOutHandler,param1);
      }
      
      public function removeBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         removeHandler(IBattleInvitationResponseHandler,param1);
      }
      
      public function addSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         addHandler(ISetRoundInfoHandler,param1);
      }
      
      public function removeRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         removeHandler(IRoundCompletedHandler,param1);
      }
      
      public function addBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         addHandler(IBattleInvitationRequestHandler,param1);
      }
      
      public function removeReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         removeHandler(IReadyForTurnHandler,param1);
      }
      
      public function addBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         addHandler(IBattleInvitationErrorHandler,param1);
      }
      
      public function removeRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         removeHandler(IRoomDestroyedHandler,param1);
      }
      
      public function addOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         addHandler(IOtherPlayerJoinBattleHandler,param1);
      }
      
      public function addQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         addHandler(IQuittingGameHandler,param1);
      }
      
      public function addGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         addHandler(IGameSwarmValueSetHandler,param1);
      }
      
      public function removeBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         removeHandler(IBattleCreationErrorHandler,param1);
      }
      
      public function removeBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         removeHandler(IBattleErrorHandler,param1);
      }
      
      public function addBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         addHandler(IBattleStartedHandler,param1);
      }
      
      public function addGameOverHandler(param1:IGameOverHandler) : void
      {
         addHandler(IGameOverHandler,param1);
      }
      
      public function removeBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         removeHandler(IBattleStartedHandler,param1);
      }
      
      public function removeSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         removeHandler(ISelectedNanovorErrorHandler,param1);
      }
      
      public function removeEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         removeHandler(IEnemySelectedHandler,param1);
      }
      
      public function addPlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         addHandler(IPlayerJoinBattleHandler,param1);
      }
      
      public function addRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         addHandler(IRoundCompletedHandler,param1);
      }
      
      public function removeBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         removeHandler(IBattleInvitationRequestHandler,param1);
      }
      
      public function removeOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         removeHandler(IOtherPlayerJoinBattleHandler,param1);
      }
      
      public function addReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         addHandler(IReadyForTurnHandler,param1);
      }
      
      public function addBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         addHandler(IBattleInvitationResponseHandler,param1);
      }
      
      public function removeBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         removeHandler(IBattleInvitationAcceptHandler,param1);
      }
      
      public function removeSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         removeHandler(ISetRoundInfoHandler,param1);
      }
      
      public function removePerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         removeHandler(IPerformAttackHandler,param1);
      }
      
      public function removeBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         removeHandler(IBattleCreatedHandler,param1);
      }
      
      public function addBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         addHandler(IBattleErrorHandler,param1);
      }
      
      public function addPerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         addHandler(IPerformAttackHandler,param1);
      }
      
      public function addEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         addHandler(IEnemySelectedHandler,param1);
      }
      
      public function addJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         addHandler(IJoinBattleErrorHandler,param1);
      }
      
      public function removeGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         removeHandler(IGameSwarmSelectedHandler,param1);
      }
      
      public function addRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         addHandler(IRoomDestroyedHandler,param1);
      }
      
      public function addBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         addHandler(IBattleCreatedHandler,param1);
      }
      
      public function removeBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         removeHandler(IBattleInvitationErrorHandler,param1);
      }
      
      public function removeGameOverHandler(param1:IGameOverHandler) : void
      {
         removeHandler(IGameOverHandler,param1);
      }
      
      public function removePlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         removeHandler(IPlayerJoinBattleHandler,param1);
      }
      
      public function removePlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         removeHandler(IPlayerQuitGameHandler,param1);
      }
      
      public function removeBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         removeHandler(IBattlePlayerKickedOutHandler,param1);
      }
      
      public function removeQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         removeHandler(IQuittingGameHandler,param1);
      }
      
      public function addSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         addHandler(ISelectedNanovorErrorHandler,param1);
      }
      
      public function addPlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         addHandler(IPlayerQuitGameHandler,param1);
      }
      
      public function removeJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         removeHandler(IJoinBattleErrorHandler,param1);
      }
      
      public function addGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         addHandler(IGameSwarmSelectedHandler,param1);
      }
      
      public function removeGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         removeHandler(IGameSwarmValueSetHandler,param1);
      }
      
      public function addBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         addHandler(IBattleInvitationAcceptHandler,param1);
      }
   }
}

