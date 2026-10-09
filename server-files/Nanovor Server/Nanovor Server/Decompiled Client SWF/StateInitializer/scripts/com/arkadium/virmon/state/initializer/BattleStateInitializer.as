package com.arkadium.virmon.state.initializer
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.virmon.battle.IBattleState;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.BuddyRPManager;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.state.IState;
   
   internal class BattleStateInitializer
   {
      
      private var _state:IBattleState;
      
      public function BattleStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as IBattleState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as IBattleState");
         }
      }
      
      public function initialize() : void
      {
         var _loc1_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         this._state.initialize(Managers.soundManager,_loc1_,new PlayerFactory(_loc1_,UserProfile.getInstance()),DataManager.getInstance().getEvoManager(),DataManager.getInstance().getBadgeManager(),DataManager.getInstance().getEMManager(),UserProfile.getInstance(),Managers.stateManager,Managers.widgetManager,Managers.analyticsManager,GameServiceProvider.getInstance().battleGameService,GameServiceProvider.getInstance().userGameService,BuddyRPManager.getInstance(),Managers.assetRetrieverManager.avatarAssetRetriever);
      }
   }
}

