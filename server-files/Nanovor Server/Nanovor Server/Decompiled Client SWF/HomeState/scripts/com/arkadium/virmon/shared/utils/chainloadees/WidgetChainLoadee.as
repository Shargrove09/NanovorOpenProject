package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WidgetChainLoadee implements IChainLoadee
   {
      
      private var _widgetManager:IWidgetManager;
      
      private var _target:DisplayObjectContainer;
      
      private var _chainLoader:IChainLoader;
      
      private var _widgetType:WidgetType;
      
      public function WidgetChainLoadee(param1:IWidgetManager, param2:WidgetType, param3:DisplayObjectContainer = null)
      {
         super();
         _widgetManager = param1;
         _widgetType = param2;
         _target = param3;
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         if(null == _widgetManager.getWidgetByName(_widgetType.name))
         {
            return;
         }
         IEventDispatcher(param1.currentTarget).removeEventListener(TimerEvent.TIMER,handleTimer);
         IEventDispatcher(param1.currentTarget).removeEventListener(TimerEvent.TIMER_COMPLETE,handleTimerComplete);
         Timer(param1.currentTarget).reset();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         if(_widgetManager.getWidgetByName(_widgetType.name) != null)
         {
            _chainLoader.handleChainLoadeeComplete();
            return;
         }
         _widgetManager.loadWidget(_widgetType);
         var _loc1_:Timer = new Timer(500,20);
         _loc1_.addEventListener(TimerEvent.TIMER,handleTimer);
         _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,handleTimerComplete);
         _loc1_.start();
      }
      
      public function get name() : String
      {
         return "WidgetChainLoadee" + "_" + _widgetType.name;
      }
      
      private function handleTimerComplete(param1:TimerEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(TimerEvent.TIMER,handleTimer);
         IEventDispatcher(param1.currentTarget).removeEventListener(TimerEvent.TIMER_COMPLETE,handleTimerComplete);
         Timer(param1.currentTarget).reset();
         if(null == _widgetManager.getWidgetByName(_widgetType.name))
         {
            logError("Failed to load widget due to timeout: " + _widgetType.name);
            _chainLoader.handleChainLoadeeError();
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** WidgetChainLoadee: " + param1);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<WidgetChainLoadee>> " + param1);
      }
   }
}

