package com.smithandtinker.nanovor.debug
{
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.utils.Timer;
   
   public class DebugFilterSender
   {
      
      private static const ACTIVE_CHECK_TIMER_DELAY:int = 3000;
      
      private var _key:String;
      
      private var _activeCheckTimer:Timer;
      
      private var _debugLogWindow:IDebugLogWindow;
      
      private var _displayName:String;
      
      private var _currentFilter:String = "";
      
      private var _lcSender:LocalConnection;
      
      public function DebugFilterSender(param1:String, param2:String, param3:IDebugLogWindow, param4:String = "")
      {
         super();
         _key = param1;
         _displayName = param2;
         _debugLogWindow = param3;
         _currentFilter = param4;
         _lcSender = new LocalConnection();
         _lcSender.addEventListener(StatusEvent.STATUS,onLcSenderStatus,false,0,true);
         _lcSender.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleNothing,false,0,true);
         _lcSender.addEventListener(AsyncErrorEvent.ASYNC_ERROR,handleNothing,false,0,true);
         resetActiveCheckTimer();
      }
      
      public function set displayName(param1:String) : void
      {
         _displayName = param1;
      }
      
      private function handleNothing(param1:*) : void
      {
      }
      
      private function onActiveCheckTimerTick(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         try
         {
            _lcSender.send(_key,"ping");
         }
         catch(e:Error)
         {
            removeAndDestroy();
         }
      }
      
      private function removeAndDestroy() : void
      {
         if(_lcSender != null)
         {
            _lcSender.removeEventListener(StatusEvent.STATUS,onLcSenderStatus);
         }
         if(_activeCheckTimer != null)
         {
            _activeCheckTimer.removeEventListener(TimerEvent.TIMER,onActiveCheckTimerTick);
            _activeCheckTimer.stop();
         }
         if(_debugLogWindow != null)
         {
            _debugLogWindow.removeFilterSender(this);
         }
         _lcSender = null;
         _debugLogWindow = null;
         _activeCheckTimer = null;
      }
      
      private function resetActiveCheckTimer() : void
      {
         if(_activeCheckTimer == null)
         {
            _activeCheckTimer = new Timer(ACTIVE_CHECK_TIMER_DELAY);
            _activeCheckTimer.addEventListener(TimerEvent.TIMER,onActiveCheckTimerTick,false,0,true);
         }
         _activeCheckTimer.reset();
         _activeCheckTimer.start();
      }
      
      public function onClientRegistered() : *
      {
         _lcSender.send(_key,"registered");
      }
      
      public function get displayName() : String
      {
         return _displayName;
      }
      
      public function get currentFilter() : String
      {
         return _currentFilter;
      }
      
      public function sendFilter(param1:String) : void
      {
         var filter:String = param1;
         if(_currentFilter == filter)
         {
            return;
         }
         try
         {
            _lcSender.send(_key,"setFilter",filter);
            _currentFilter = filter;
            resetActiveCheckTimer();
            _debugLogWindow.handleFilterSenderLog("#### sent filter to client \'" + _displayName + "\': " + filter);
         }
         catch(e:Error)
         {
            _debugLogWindow.handleFilterSenderError("**** Error when trying to send filter to client \'" + _key + " (" + _displayName + ")\':\n" + e.message);
            removeAndDestroy();
         }
      }
      
      private function onLcSenderStatus(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            removeAndDestroy();
         }
      }
      
      public function get key() : String
      {
         return _key;
      }
   }
}

