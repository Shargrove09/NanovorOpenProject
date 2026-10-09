package com.smithandtinker.nanovor.debug
{
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.utils.Timer;
   
   internal class DeferredLogSender
   {
      
      private static const SEND_INTERVAL:Number = 25;
      
      private var _timer:Timer;
      
      private var _connectionName:String;
      
      private var _queue:Array;
      
      private var _lcSender:LocalConnection;
      
      private var _filterChecker:IFilterChecker;
      
      public function DeferredLogSender(param1:IFilterChecker, param2:String, param3:LocalConnection)
      {
         super();
         _filterChecker = param1;
         _connectionName = param2;
         _lcSender = param3;
         _queue = [];
         _timer = new Timer(SEND_INTERVAL);
         _timer.addEventListener(TimerEvent.TIMER,onTimerTick,false,0,true);
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(_queue.length == 0)
         {
            return stopTimer();
         }
         sendNextLog();
      }
      
      public function log(param1:String, param2:Number, param3:int) : *
      {
         _queue.push(new DeferredLogData(param1,param2,param3));
         startTimer();
      }
      
      private function sendNextLog() : void
      {
         var _loc1_:DeferredLogData = _queue.shift();
         if(_filterChecker.passesFilter(_loc1_.message))
         {
            _lcSender.send(_connectionName,"log",_loc1_.message,_loc1_.timeStamp,_loc1_.tieBreaker);
         }
      }
      
      private function startTimer() : void
      {
         if(_timer.running)
         {
            return;
         }
         _timer.start();
      }
      
      public function clearBuffer() : void
      {
         _queue = [];
      }
      
      private function stopTimer() : void
      {
         if(!_timer.running)
         {
            return;
         }
         _timer.reset();
      }
   }
}

