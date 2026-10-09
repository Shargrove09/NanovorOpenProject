package com.arkadium.virmon.profilemanager
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.StateType;
   
   public class ProfileState extends AbstractState
   {
      
      public var mcMain:Main;
      
      public function ProfileState()
      {
         super();
         _quicktipsURL = Const.QUICKTIP_PROFILE;
         stateName = StateType.PROFILE.name;
      }
      
      override public function init(param1:Object = null) : void
      {
         log("PROFILE state is initialized");
         Managers.analyticsManager.trackView(View.PROFILEMANAGER_LANDING);
      }
      
      override public function destroy() : void
      {
         if(mcMain != null)
         {
            mcMain._smcGUIManager.panel.unRegisterPanel(mcMain._smcGUIManager.panel,mcMain._smcGUIManager.panel.PANEL_NAME);
         }
         super.destroy();
      }
      
      override public function onSetState() : void
      {
         if(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name).setMode(WidgetType.MODE_HOME);
         }
         if(null != Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name))
         {
            Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_HIDDEN);
         }
      }
   }
}

