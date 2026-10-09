package com.arkadium.virmon.nanomall
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.wrapper.IBuyNanocashUIManager;
   
   public interface INanomallState
   {
      
      function initialize(param1:IUserProfile, param2:IAnalyticsManager, param3:IBuyNanocashUIManager, param4:IStateManager, param5:IWidgetManager, param6:IServiceRequestBrokerManager, param7:IBoosterAssetRetriever, param8:IUserGameService, param9:IVirmonManager, param10:ICharacterAssetRetriever, param11:IEMManager, param12:IEMAssetRetriever) : void;
   }
}

