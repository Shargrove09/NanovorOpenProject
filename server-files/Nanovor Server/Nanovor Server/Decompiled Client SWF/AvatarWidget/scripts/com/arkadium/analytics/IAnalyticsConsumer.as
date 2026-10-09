package com.arkadium.analytics
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.Click;
   import com.arkadium.analytics.enum.View;
   import flash.display.DisplayObjectContainer;
   
   public interface IAnalyticsConsumer
   {
      
      function initialize(param1:DisplayObjectContainer, param2:Boolean) : void;
      
      function handleTrackClick(param1:Click) : void;
      
      function handleTrackAction(param1:Action) : void;
      
      function get isReady() : Boolean;
      
      function get isInitialized() : Boolean;
      
      function handleTrackView(param1:View) : void;
   }
}

