package com.arkadium.analytics
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.Click;
   import com.arkadium.analytics.enum.View;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class AnalyticsManager implements IAnalyticsManager
   {
      
      private static var _instance:AnalyticsManager;
      
      private static const _DEBUG:Boolean = false;
      
      private var _enabled:Boolean;
      
      private var _consumersDebugContainer:Sprite;
      
      private var _consumers:Dictionary;
      
      public function AnalyticsManager(param1:Function)
      {
         super();
         if(param1 != getInstance)
         {
            throw new Error("Cannot instantiate AnalyticsManager outside of static getInstance()");
         }
         _consumers = new Dictionary();
         _consumersDebugContainer = new Sprite();
         _consumersDebugContainer.mouseEnabled = false;
         _consumersDebugContainer.mouseChildren = false;
      }
      
      public static function getInstance() : AnalyticsManager
      {
         if(_instance == null)
         {
            _instance = new AnalyticsManager(getInstance);
         }
         return _instance;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AnalyticsManager: " + param1);
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      public function trackView(param1:View) : void
      {
         var consumer:IAnalyticsConsumer = null;
         var view:View = param1;
         if(!_enabled)
         {
            return;
         }
         for each(consumer in _consumers)
         {
            try
            {
               consumer.handleTrackView(view);
            }
            catch(e:Error)
            {
               logError("trackView: " + e.message + "\n" + e.getStackTrace());
            }
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** AnalyticsManager: " + param1);
      }
      
      public function get consumersDebugContainer() : Sprite
      {
         return _consumersDebugContainer;
      }
      
      public function get debug() : Boolean
      {
         return _DEBUG;
      }
      
      public function trackAction(param1:Action) : void
      {
         var consumer:IAnalyticsConsumer = null;
         var action:Action = param1;
         if(!_enabled)
         {
            return;
         }
         for each(consumer in _consumers)
         {
            try
            {
               consumer.handleTrackAction(action);
            }
            catch(e:Error)
            {
               logError("trackView: " + e.message + "\n" + e.getStackTrace());
            }
         }
      }
      
      public function addAnalyticsConsumer(param1:IAnalyticsConsumer) : void
      {
         if(!_enabled)
         {
            return;
         }
         _consumers[param1] = param1;
         if(!param1.isInitialized)
         {
            param1.initialize(_consumersDebugContainer,_DEBUG);
         }
      }
      
      public function trackClick(param1:Click) : void
      {
         var consumer:IAnalyticsConsumer = null;
         var click:Click = param1;
         if(!_enabled)
         {
            return;
         }
         for each(consumer in _consumers)
         {
            try
            {
               consumer.handleTrackClick(click);
            }
            catch(e:Error)
            {
               logError("trackView: " + e.message + "\n" + e.getStackTrace());
            }
         }
      }
   }
}

