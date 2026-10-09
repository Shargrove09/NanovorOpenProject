package com.arkadium.virmon.battle
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   
   public interface IBattleState
   {
      
      function initialize(param1:ISoundManager, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile, param8:IStateManager, param9:IWidgetManager, param10:IAnalyticsManager, param11:IBattleGameService, param12:IUserGameService, param13:IBuddyRPManager, param14:IAvatarAssetRetriever) : void;
   }
}

