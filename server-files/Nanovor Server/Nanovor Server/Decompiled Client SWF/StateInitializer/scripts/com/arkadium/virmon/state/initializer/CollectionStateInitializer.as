package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.collection.ICollectionState;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.state.IState;
   
   public class CollectionStateInitializer
   {
      
      private var _state:ICollectionState;
      
      public function CollectionStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as ICollectionState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as ICollectionState");
         }
      }
      
      public function initialize(param1:Object) : void
      {
         var _loc2_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         this._state.initialize(param1,Managers.assetRetrieverManager.characterAssetRetriever,_loc2_,new PlayerFactory(_loc2_,UserProfile.getInstance()),Managers.soundManager,UserProfile.getInstance(),Managers.serviceRequestBrokerManager,Managers.analyticsManager,Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name),Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name),Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) as IAutoBattleWidget,Managers.stateManager,DataManager.getInstance().getEvoManager(),DataManager.getInstance().getVirmonManager());
      }
   }
}

