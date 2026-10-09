package com.arkadium.virmon.senseibattle
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   
   public interface ISenseiBattleState
   {
      
      function initialize(param1:Object, param2:ISoundManager, param3:INanovorFactory, param4:IPlayerFactory, param5:IEvoManager, param6:IBadgeManager, param7:IEMManager, param8:IAnalyticsManager, param9:IHeaderWidget, param10:IWidget, param11:IAutoBattleWidget, param12:IUserProfile, param13:IStateManager, param14:IBuddyRPManager, param15:IMasterDataAssetRetriever) : void;
   }
}

