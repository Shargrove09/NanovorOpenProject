package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.swarmchooser
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.handlers.battle.IGameSwarmSelectedHandler;
   import com.arkadium.communications.handlers.battle.IReadyForTurnHandler;
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.framework.VirmonData;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.NewUserSoloBattleSubStates;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class NewUserSoloBattleSubStateSwarmChooser extends AbstractSubState implements IReadyForTurnHandler, IGameSwarmSelectedHandler
   {
      
      private static const PRESELECT_ASSET_TYPE_IDS:Array = [1,24];
      
      private var _battleData:IBattleData;
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _selectedSwarmIds:Array;
      
      private var _battleGameService:IBattleGameService;
      
      public function NewUserSoloBattleSubStateSwarmChooser(param1:Array, param2:IBattleGameService, param3:IBattleData, param4:IBattleHeaderController)
      {
         super();
         log("NewUserSoloBattleSubStateSwarmChooser()");
         _battleGameService = param2;
         _battleData = param3;
         _battleHeaderController = param4;
         _battleGameService.addGameSwarmSelectedHandler(IGameSwarmSelectedHandler(this));
         preSelectedSwarmAssetIds(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NewUserSoloBattleSubStateSwarmChooser>>\t" + param1);
      }
      
      override public function setSubState() : void
      {
         log("setSubState()");
         _battleGameService.addReadyForTurnHandler(IReadyForTurnHandler(this));
         _battleGameService.setSwarm(_selectedSwarmIds);
      }
      
      private function getPlayerIndexById(param1:int) : int
      {
         var _loc3_:BattlePlayer = null;
         log("getPlayerIndexById()");
         var _loc2_:uint = 0;
         while(_loc2_ < _battleData.playersInBattle.length)
         {
            _loc3_ = _battleData.playersInBattle[_loc2_];
            if(_loc3_.playerId == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function preSelectedSwarmAssetIds(param1:Array) : void
      {
         var _loc2_:VirmonData = null;
         var _loc3_:int = 0;
         log("preSelectedSwarmAssetIds()");
         _selectedSwarmIds = new Array();
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.getAssetTypeID();
            if(-1 != PRESELECT_ASSET_TYPE_IDS.indexOf(_loc3_))
            {
               _selectedSwarmIds.push(_loc2_.getAssetID());
            }
         }
      }
      
      public function handleReadyForTurn(param1:String, param2:int, param3:Boolean) : void
      {
         log("handleReadyForTurn()");
         _battleGameService.removeReadyForTurnHandler(IReadyForTurnHandler(this));
         _subStateController.changeSubState(NewUserSoloBattleSubStates.SUB_STATE_SWARM_COMBAT,_selectedSwarmIds);
      }
      
      public function handleGameSwarmSelected(param1:String, param2:int, param3:String, param4:int) : void
      {
         log("handleGameSwarmSelected() - swarmCount: " + param2 + " userName: " + param3);
         var _loc5_:int = getPlayerIndexById(param4);
         if(_loc5_ == -1)
         {
            return;
         }
         var _loc6_:Boolean = false;
         if(_loc5_ > 1 && _loc5_ == _battleData.playersInBattle.length - 1)
         {
            _loc6_ = true;
         }
         _battleHeaderController.playerSwarmSelected(param4,param2,_loc6_);
      }
   }
}

