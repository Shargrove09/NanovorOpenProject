package com.arkadium.virmon.device
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   
   public interface IDeviceState
   {
      
      function initialize(param1:IDownloader, param2:IChatGameService, param3:IUserProfile, param4:INanovorFactory, param5:IPlayerFactory, param6:IStateManager, param7:IDataManager, param8:IFileOperator, param9:IServiceRequestBrokerManager, param10:IAnalyticsManager, param11:ICharacterAssetRetriever, param12:IWidgetManager, param13:IAssetManager, param14:ISoundManager) : void;
   }
}

