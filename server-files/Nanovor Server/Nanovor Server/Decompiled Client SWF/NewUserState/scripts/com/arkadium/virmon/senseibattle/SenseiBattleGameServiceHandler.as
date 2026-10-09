package com.arkadium.virmon.senseibattle
{
   import com.arkadium.communications.handlers.battle.*;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfo;
   
   public class SenseiBattleGameServiceHandler extends AbstractBattleGameServiceHandler implements IBattleGameServerConsumer
   {
      
      public function SenseiBattleGameServiceHandler()
      {
         super();
      }
      
      public function setRoundInfo(param1:Object) : void
      {
         var _loc3_:ISetRoundInfoHandler = null;
         var _loc2_:RoundInfo = new RoundInfo(param1);
         for each(_loc3_ in _handlers[ISetRoundInfoHandler])
         {
            _loc3_.handleSetRoundInfo(_loc2_);
         }
      }
      
      public function swarmSelected(param1:String, param2:uint, param3:String, param4:int) : void
      {
         var _loc5_:IGameSwarmSelectedHandler = null;
         for each(_loc5_ in _handlers[IGameSwarmSelectedHandler])
         {
            _loc5_.handleGameSwarmSelected(param1,param2,param3,param4);
         }
      }
      
      public function readyForTurn() : void
      {
         var _loc1_:IReadyForTurnHandler = null;
         for each(_loc1_ in _handlers[IReadyForTurnHandler])
         {
            _loc1_.handleReadyForTurn(null,-1,false);
         }
      }
      
      public function roundCompleted(param1:Object) : void
      {
         var _loc2_:IRoundCompletedHandler = null;
         for each(_loc2_ in _handlers[IRoundCompletedHandler])
         {
            _loc2_.handleRoundCompleted(param1);
         }
      }
      
      public function gameOver(param1:int, param2:Object) : void
      {
         var _loc3_:IGameOverHandler = null;
         for each(_loc3_ in _handlers[IGameOverHandler])
         {
            _loc3_.handleGameOver(param1,param2);
         }
      }
      
      public function performAttack(param1:Object) : void
      {
         var _loc2_:IPerformAttackHandler = null;
         for each(_loc2_ in _handlers[IPerformAttackHandler])
         {
            _loc2_.handlePerformAttack(param1);
         }
      }
   }
}

