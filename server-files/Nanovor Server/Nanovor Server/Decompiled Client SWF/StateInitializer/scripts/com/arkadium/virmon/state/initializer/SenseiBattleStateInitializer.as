package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.BuddyRPManager;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.senseibattle.ISenseiBattleState;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.state.IState;
   
   public class SenseiBattleStateInitializer
   {
      
      private var _state:ISenseiBattleState;
      
      public function SenseiBattleStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as ISenseiBattleState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as ISenseiBattleState");
         }
      }
      
      public function initialize(param1:Object) : void
      {
         var _loc2_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         this._state.initialize(param1,Managers.soundManager,_loc2_,new PlayerFactory(_loc2_,UserProfile.getInstance()),DataManager.getInstance().getEvoManager(),DataManager.getInstance().getBadgeManager(),DataManager.getInstance().getEMManager(),Managers.analyticsManager,Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) as IHeaderWidget,Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name),Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) as IAutoBattleWidget,UserProfile.getInstance(),Managers.stateManager,BuddyRPManager.getInstance(),Managers.assetRetrieverManager.masterDataAssetRetriever);
      }
   }
}

