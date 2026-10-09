package com.arkadium.analytics
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.Click;
   import com.arkadium.analytics.enum.View;
   import flash.display.Sprite;
   
   public interface IAnalyticsManager
   {
      
      function trackView(param1:View) : void;
      
      function get enabled() : Boolean;
      
      function addAnalyticsConsumer(param1:IAnalyticsConsumer) : void;
      
      function get debug() : Boolean;
      
      function trackAction(param1:Action) : void;
      
      function get consumersDebugContainer() : Sprite;
      
      function trackClick(param1:Click) : void;
   }
}

