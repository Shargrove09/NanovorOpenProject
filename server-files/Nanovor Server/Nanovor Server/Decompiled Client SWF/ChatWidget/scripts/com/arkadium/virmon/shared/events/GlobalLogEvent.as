package com.arkadium.virmon.shared.events
{
   import flash.events.Event;
   
   public class GlobalLogEvent extends Event
   {
      
      public static const LOG:String = "globalLogEvent::log";
      
      public static const ERROR:String = "globalLogEvent::error";
      
      private var _logTimeStamp:Number;
      
      private var _logMessage:String;
      
      private var _logSender:String;
      
      public function GlobalLogEvent(param1:String, param2:String, param3:String = null, param4:Number = -1, param5:Boolean = false, param6:Boolean = false)
      {
         this._logMessage = param2;
         this._logSender = param3;
         this._logTimeStamp = param4;
         super(param1,param5,param6);
      }
      
      public function get logSender() : String
      {
         return this._logSender;
      }
      
      public function get logMessage() : String
      {
         return this._logMessage;
      }
      
      override public function toString() : String
      {
         return formatToString("GlobalLogEvent","type","logMessage","logSender","logTimeStamp","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new GlobalLogEvent(type,this._logMessage,this._logSender,this._logTimeStamp,bubbles,cancelable);
      }
      
      public function get logTimeStamp() : Number
      {
         return this._logTimeStamp;
      }
   }
}

