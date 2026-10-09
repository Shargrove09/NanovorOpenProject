package com.arkadium.virmon.newuserexperience.substates.solobattle.substates
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.INewUserSubStateSoloBattle;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.combat.NewUserSoloBattleSubStateCombat;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.NewUserSoloBattleSubStateGameOver;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.swarmchooser.NewUserSoloBattleSubStateSwarmChooser;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import flash.display.Sprite;
   
   public class NewUserSoloBattleSubStateFactory implements ISubStateFactory
   {
      
      private var _subStateSwarmChooser:NewUserSoloBattleSubStateSwarmChooser;
      
      private var _subStateCombat:NewUserSoloBattleSubStateCombat;
      
      private var _subStateGameOver:NewUserSoloBattleSubStateGameOver;
      
      private var _soloBattle:INewUserSubStateSoloBattle;
      
      public function NewUserSoloBattleSubStateFactory(param1:ISoundManager, param2:IPlayerFactory, param3:Sprite, param4:INewUserSubStateSoloBattle, param5:IBattleGameService, param6:IBattleData, param7:IBattleHeaderController, param8:IUserProfile, param9:ICharacterAssetTypeCache, param10:IOverlayAssetRetriever, param11:Array)
      {
         super();
         _soloBattle = param4;
         _subStateSwarmChooser = new NewUserSoloBattleSubStateSwarmChooser(param11,param5,param6,param7);
         _subStateCombat = new NewUserSoloBattleSubStateCombat(param1,param2,param3,param5,param6,param7,param8,null,param9,param10);
         _subStateGameOver = new NewUserSoloBattleSubStateGameOver(param3,param4);
      }
      
      public function destroy() : void
      {
         if(null != _subStateCombat)
         {
            _subStateCombat.destroy();
         }
         if(null != _subStateGameOver)
         {
            _subStateGameOver.destroy();
         }
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         var _loc3_:Array = null;
         var _loc4_:BattleSubStateGameOverData = null;
         switch(param1)
         {
            case NewUserSoloBattleSubStates.SUB_STATE_SWARM_CHOOSER:
               return _subStateSwarmChooser;
            case NewUserSoloBattleSubStates.SUB_STATE_SWARM_COMBAT:
               _loc3_ = param2 as Array;
               if(null == _loc3_)
               {
                  _soloBattle.handleSoloBattleError("Error pre-selecting swarm");
               }
               _subStateCombat.setSelectedSwarmIds(_loc3_);
               return _subStateCombat;
            case NewUserSoloBattleSubStates.SUB_STATE_SWARM_GAME_OVER:
               _loc4_ = param2 as BattleSubStateGameOverData;
               _subStateGameOver.setGameOverData(_loc4_);
               return _subStateGameOver;
            default:
               return null;
         }
      }
   }
}

