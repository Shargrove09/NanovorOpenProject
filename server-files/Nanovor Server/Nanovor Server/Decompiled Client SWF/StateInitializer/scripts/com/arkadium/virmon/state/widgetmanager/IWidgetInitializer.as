package com.arkadium.virmon.state.widgetmanager
{
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   
   public interface IWidgetInitializer
   {
      
      function initializeWidget(param1:WidgetType, param2:IWidget) : void;
   }
}

