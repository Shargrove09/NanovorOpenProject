package com.arkadium.virmon.collection
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   
   public interface ICollectionState
   {
      
      function initialize(param1:Object, param2:ICharacterAssetRetriever, param3:INanovorFactory, param4:IPlayerFactory, param5:ISoundManager, param6:IUserProfile, param7:IServiceRequestBrokerManager, param8:IAnalyticsManager, param9:IWidget, param10:IWidget, param11:IAutoBattleWidget, param12:IStateManager, param13:IEvoManager, param14:IVirmonManager) : void;
      
      function get pendingChanges() : Boolean;
   }
}

