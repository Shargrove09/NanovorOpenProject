package com.arkadium.virmon.trade
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.framework.IBuddyManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.data.IPermissionsManager;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.events.Event;
   
   public class TradeState extends AbstractState implements ITradeState
   {
      
      private var _permissionsManager:IPermissionsManager;
      
      private var _widgetManager:IWidgetManager;
      
      public var mcMain:Main;
      
      public function TradeState()
      {
         super();
         stateName = StateType.TRADEGAME.name;
      }
      
      override public function onSetState() : void
      {
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name).setMode(WidgetType.MODE_HIDDEN);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(_permissionsManager.canChat ? WidgetType.MODE_MINIMIZED : WidgetType.MODE_HIDDEN);
         }
      }
      
      public function initialize(param1:IAnalyticsManager, param2:IUserProfile, param3:IDataManager, param4:IEMAssetRetriever, param5:ICharacterAssetRetriever, param6:IStateManager, param7:IWidgetManager, param8:IPermissionsManager, param9:ITradeGameService, param10:ISoundManager, param11:IBuddyManager, param12:IBuddyRPManager) : void
      {
         log("initialize()");
         if(isInitialized)
         {
            return;
         }
         isInitialized = true;
         _widgetManager = param7;
         _permissionsManager = param8;
         EventManager.getInstance().dispatchEvent(new Event("START_ANIMATION"));
         param1.trackView(View.TRADE_LANDING);
         mcMain._smcGUIManager.mcTradePanel.initialize(param2,param1,param3,param4,param5,param6,param9,param10,param11,param12);
         log("TRADEGAME state is initialized");
      }
   }
}

