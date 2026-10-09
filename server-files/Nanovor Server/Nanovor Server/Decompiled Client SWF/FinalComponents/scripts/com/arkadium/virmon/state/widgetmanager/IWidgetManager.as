package com.arkadium.virmon.state.widgetmanager
{
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.IWidgetLoadedHandler;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   
   public interface IWidgetManager
   {
      
      function addWidgetLoadedHandler(param1:WidgetType, param2:IWidgetLoadedHandler) : void;
      
      function addLoadedWidget(param1:WidgetType, param2:IWidget) : void;
      
      function setWidgetInitializer(param1:IWidgetInitializer) : void;
      
      function addWidget(param1:WidgetType) : void;
      
      function removeWidget(param1:WidgetType) : void;
      
      function loadWidget(param1:WidgetType) : void;
      
      function getWidgetByName(param1:String) : IWidget;
   }
}

