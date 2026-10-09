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
         this._filterChecker = param1;
         this._connectionName = param2;
         this._lcSender = param3;
         this._queue = [];
         this._timer = new Timer(SEND_INTERVAL);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick,false,0,true);
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(this._queue.length == 0)
         {
            return this.stopTimer();
         }
         this.sendNextLog();
      }
      
      public function log(param1:String, param2:Number, param3:int) : *
      {
         this._queue.push(new DeferredLogData(param1,param2,param3));
         this.startTimer();
      }
      
      private function sendNextLog() : void
      {
         var _loc1_:DeferredLogData = this._queue.shift();
         if(this._filterChecker.passesFilter(_loc1_.message))
         {
            this._lcSender.send(this._connectionName,"log",_loc1_.message,_loc1_.timeStamp,_loc1_.tieBreaker);
         }
      }
      
      private function startTimer() : void
      {
         if(this._timer.running)
         {
            return;
         }
         this._timer.start();
      }
      
      public function clearBuffer() : void
      {
         this._queue = [];
      }
      
      private function stopTimer() : void
      {
         if(!this._timer.running)
         {
            return;
         }
         this._timer.reset();
      }
   }
}

