package com.arkadium.analytics
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.Click;
   import com.arkadium.analytics.enum.View;
   import com.google.analytics.AnalyticsTracker;
   import com.google.analytics.GATracker;
   import com.google.analytics.core.TrackerMode;
   import com.google.analytics.events.AnalyticsEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   
   public class GoogleAnalyticsConsumer implements IAnalyticsConsumer
   {
      
      private static const GA_ACCOUNT:String = "UA-10901378-1";
      
      private static const LOG_TRACKING_ACTIONS:Boolean = true;
      
      private static const LOGGING_ENABLED:Boolean = false;
      
      private var _isInitialized:Boolean = false;
      
      private var _debug:Boolean;
      
      private var _isReady:Boolean = false;
      
      private var _preInitBuffer:Array = new Array();
      
      private var _tracker:AnalyticsTracker;
      
      public function GoogleAnalyticsConsumer()
      {
         super();
         log("GoogleAnalyticsConsumer()");
      }
      
      private function log(param1:String) : void
      {
         if(LOGGING_ENABLED)
         {
            DebugLog.instance.log(">> GoogleAnalyticsConsumer: " + param1);
         }
      }
      
      public function handleTrackClick(param1:Click) : void
      {
         if(!_isReady)
         {
            _preInitBuffer.push(param1);
            return;
         }
         if(LOG_TRACKING_ACTIONS || _debug)
         {
            log("handleTrackClick(): " + param1.name);
         }
         _tracker.trackPageview(param1.name);
      }
      
      public function handleTrackAction(param1:Action) : void
      {
         if(!_isReady)
         {
            _preInitBuffer.push(param1);
            return;
         }
         if(LOG_TRACKING_ACTIONS || _debug)
         {
            log("handleTrackAction(): " + param1.name);
         }
         _tracker.trackPageview(param1.name);
      }
      
      private function onTrackerReady(param1:AnalyticsEvent) : void
      {
         var _loc2_:* = undefined;
         log("onTrackerReady()");
         _tracker.removeEventListener(AnalyticsEvent.READY,onTrackerReady);
         _isReady = true;
         for each(_loc2_ in _preInitBuffer)
         {
            if(Boolean(_loc2_ as View))
            {
               handleTrackView(_loc2_);
            }
            else if(Boolean(_loc2_ as Action))
            {
               handleTrackAction(_loc2_);
            }
            else if(Boolean(_loc2_ as Click))
            {
               handleTrackClick(_loc2_);
            }
         }
         _preInitBuffer = new Array();
      }
      
      public function handleTrackView(param1:View) : void
      {
         if(!_isReady)
         {
            _preInitBuffer.push(param1);
            return;
         }
         if(LOG_TRACKING_ACTIONS || _debug)
         {
            log("handleTrackView(): " + param1.name);
         }
         _tracker.trackPageview(param1.name);
      }
      
      public function initialize(param1:DisplayObjectContainer, param2:Boolean) : void
      {
         log("initialize()");
         _isInitialized = true;
         _debug = param2;
         GATracker.autobuild = false;
         _tracker = new GATracker(param1,GA_ACCOUNT,TrackerMode.AS3,_debug);
         if(_debug)
         {
            _tracker.debug.verbose = true;
         }
         _tracker.addEventListener(AnalyticsEvent.READY,onTrackerReady,false,0,true);
         GATracker(_tracker).build();
      }
      
      public function get isInitialized() : Boolean
      {
         return _isInitialized;
      }
      
      public function get isReady() : Boolean
      {
         return _isReady;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** GoogleAnalyticsConsumer: " + param1);
      }
   }
}

