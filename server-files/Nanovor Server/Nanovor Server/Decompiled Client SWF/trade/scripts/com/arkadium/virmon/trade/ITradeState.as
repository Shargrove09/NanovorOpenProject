package com.arkadium.virmon.trade
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IBuddyManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.data.IPermissionsManager;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   
   public interface ITradeState
   {
      
      function initialize(param1:IAnalyticsManager, param2:IUserProfile, param3:IDataManager, param4:IEMAssetRetriever, param5:ICharacterAssetRetriever, param6:IStateManager, param7:IWidgetManager, param8:IPermissionsManager, param9:ITradeGameService, param10:ISoundManager, param11:IBuddyManager, param12:IBuddyRPManager) : void;
   }
}

