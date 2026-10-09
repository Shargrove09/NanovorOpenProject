package com.arkadium.virmon.home
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.shared.breadcrumb.IBreadcrumbProgressManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   
   public interface IHomeState
   {
      
      function initialize(param1:IUserProfile, param2:IBattleGameService, param3:IChatGameService, param4:IApplicationExiter, param5:IStateManager, param6:IHomeNewsBlocker, param7:IWidgetManager, param8:IBreadcrumbProgressManager, param9:IMDMManager, param10:IMasterDataAssetRetriever, param11:IAnalyticsManager, param12:WebClientManager, param13:INanovorFactory) : void;
   }
}

